from math import ceil, floor
import os
from sqlite3 import Time
import sys
from tabnanny import verbose
# run script only on CPU
os.environ["CUDA_VISIBLE_DEVICES"] = ""
# limit comments
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3' 
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import tap
import argcomplete
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import socket
import time
import signal


# run script only on CPU
tf.config.set_visible_devices(tf.config.list_physical_devices('CPU'))
# limit paralelism
tf.config.threading.set_intra_op_parallelism_threads(1)
tf.config.threading.set_inter_op_parallelism_threads(1)
# only see fatal errors
tf.get_logger().setLevel(tf._logging.FATAL)



def build_model(input_shape, num_units=250):
    # Define the model
    model_input = keras.Input(shape=input_shape)
    
    # First hidden layer
    x = layers.Dense(num_units, activation='relu', kernel_initializer='he_normal')(model_input)

    # Second hidden layer
    x = layers.Dense(num_units, activation='relu', kernel_initializer='he_normal')(x)

    # Residual block
    residual = layers.Dense(num_units, activation='relu', kernel_initializer='he_normal')(x)
    residual = layers.Dense(num_units, activation='relu', kernel_initializer='he_normal')(residual)

    # Add the residual block to the output of the second hidden layer
    x = layers.Add()([x, residual])
    x = layers.Activation('relu')(x)

    # Output layer
    output = layers.Dense(1, activation='linear')(x)

    # Compile the model
    optimizer = keras.optimizers.Adam(learning_rate=1e-4)
    loss_function = keras.losses.MeanSquaredError()
    metrics = tf.keras.metrics.MeanAbsoluteError()
    model = keras.Model(inputs=model_input, outputs=output)
    model.compile(optimizer=optimizer, loss=loss_function, metrics=metrics)

    return model

def train_model(model, train_data, train_labels, validation_data, validation_labels, epochs=20, batch_size=32):
    print_training_process = 0 # change to 1 to see training progress
    history = model.fit(
        train_data,
        train_labels,
        epochs=epochs,
        batch_size=batch_size,
        validation_data=(validation_data, validation_labels),
        verbose=print_training_process
    )
    return history

def get_samples_data(samples_file):
    ptrain = 0.9
    df = pd.read_csv(samples_file)
    
    train_data = [[int(char) for char in word] for word in df["state"]]
    train_data = np.array(train_data)
    train_labels = df[["h_nd"]].to_numpy()
    assert len(train_data) == len(train_labels)

    maximum_character_length = len(df["state"].iloc[0])
    
    validation_data = train_data[ceil(len(train_data) * ptrain):]
    validation_labels = train_labels[ceil(len(train_labels) * ptrain):]
    train_data = train_data[:ceil(len(train_data) * ptrain)]
    train_labels = train_labels[:ceil(len(train_labels) * ptrain)]
    
    input_shape = (maximum_character_length, )
    return {
        'input_shape': input_shape,
        'train_data': train_data,
        'train_labels': train_labels,
        'validation_data': validation_data,
        'validation_labels': validation_labels
    }


            
def build_and_train_model(samples_file):
    print("LOG::build_and_train_model::begin", file=sys.stderr)
    print("LOG::build_and_train_model::Samples file:", samples_file, file=sys.stderr)
    samples_data = get_samples_data(samples_file)
    print("LOG::build_and_train_model::Building model", file=sys.stderr)
    model = build_model(samples_data['input_shape'])
    print("LOG::build_and_train_model::Training model", file=sys.stderr)
    history = train_model(model, samples_data['train_data'], samples_data['train_labels'], samples_data['validation_data'], samples_data['validation_labels'])
    print("LOG::build_and_train_model::end", file=sys.stderr)
    return model, history

def plot_history(history, path):
    acc = history.history["mean_absolute_error"]
    val_acc = history.history["val_mean_absolute_error"]
    loss = history.history["loss"]
    val_loss = history.history["val_loss"]
    epochs = range(1, len(acc) + 1)

    # Create a figure and a set of subplots
    fig, axs = plt.subplots(2, 1, figsize=(10, 8))  # 2 rows, 1 column

    # Plot MAE
    axs[0].plot(epochs, acc, "bo", label="Training MAE")
    axs[0].plot(epochs, val_acc, "b", label="Validation MAE")
    axs[0].set_title("Training and validation Mean Absolute Error (MAE)")
    axs[0].legend()
    axs[0].set_xlabel("Epochs")
    axs[0].set_ylabel("MAE")

    # Plot MSE
    axs[1].plot(epochs, loss, "ro", label="Training MSE")
    axs[1].plot(epochs, val_loss, "r", label="Validation MSE")
    axs[1].set_title("Training and validation Mean Squared Error (MSE)")
    axs[1].legend()
    axs[1].set_xlabel("Epochs")
    axs[1].set_ylabel("MSE")

    # Adjust layout for better readability
    plt.tight_layout()

    # Save the figure
    plt.savefig(os.path.join(path, "history.png"))



class ArgParsingNamespace(tap.Tap):
    samples_file: str
    path: str
    port: int
    timeout: int

    def configure(self) -> None:
        self.add_argument('--samples_file', help='samples file', default='')
        self.add_argument('--path', help='path to save model', default='')
        self.add_argument('--port', help='port to listen')
        self.add_argument('--timeout', help='timeout to listen', default=None)

def create_client_socket(host, port):
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect((host, port))
    return client_socket

def send(client_socket, message):
    client_socket.sendall(message.encode())

def receive_message(client_socket, buffer_size=1024):
    message = client_socket.recv(buffer_size)
    return message.decode()

def is_messge_complete(message): return '<BEGIN>' in message and '<END>' in message
def get_message_content(message): return message.replace("<BEGIN>", "").replace("<END>", "")
def build_message(content): return f"<BEGIN>{content}<END>"

def receive(client_socket, buffer_size=1024):
    buffer = ''
    while True:
        buffer += receive_message(client_socket, buffer_size)
        if is_messge_complete(buffer):
            break
    return buffer

def handle_timeout(signum, frame):
    raise TimeoutError("Timeout!")

def main(model, client_socket):
    while True:
        print("LOG::main::waiting for cpp messages!", file=sys.stderr)
        line = receive(client_socket)
        print(f"LOG::main::message [{line}] received!", file=sys.stderr)
        line = get_message_content(line)
        if line == 'close':
            client_socket.close()
            break
        states = line.split(',')
        input_states = []
        for state in states:
            input_states.append([int(char) for char in state])
        input_states = np.array(input_states)
        print(input_states, file=sys.stderr)

        output_message = ''
        for value_array in model.predict(input_states, verbose=0):
            output_message += f"{str(value_array[0]) + ','}"
        output_message = build_message(output_message[:-1])
        print(output_message, file=sys.stderr)
        send(client_socket, output_message)
        print(f"LOG::main::message [{output_message}] sent!", file=sys.stderr)

def init(samples_file, dir_path, model_name="model.keras"):
    if samples_file == '' or os.path.isfile(samples_file) == False:
        print("You must specify --samples_file to train the model", file=sys.stderr)
    else:
        model, history = build_and_train_model(samples_file)
        model.save(os.path.join(dir_path, model_name))
        plot_history(history, dir_path)
        return model


if __name__ == '__main__':
    parser = ArgParsingNamespace()
    argcomplete.autocomplete(parser)
    parser.parse_args()

    if parser.timeout != None:
        signal.signal(signal.SIGALRM, handle_timeout)
        signal.alarm(parser.timeout)

    try:
        model = init(parser.samples_file, parser.path)
        print("LOG::main::Model ready", file=sys.stderr)

        host = 'localhost'
        port = parser.port
        client_socket = create_client_socket(host, port)
        print("LOG::main::Client socket ready", file=sys.stderr)

        main(model, client_socket)

    except Exception as e:
        print(f"LOG::main::Exception {e}", file=sys.stderr)
