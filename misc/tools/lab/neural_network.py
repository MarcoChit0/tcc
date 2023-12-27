from email.policy import default
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
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt



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
    print("LOG::build_and_train_model::Saving model", file=sys.stderr)
    model.save(os.path.join(os.path.dirname(samples_file), "model.keras"))
    print("LOG::build_and_train_model::Plotting history", file=sys.stderr)    
    plot_history(history, os.path.dirname(samples_file))
    print("LOG::build_and_train_model::end", file=sys.stderr)
    return model

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



# class ArgParsingNamespace(tap.Tap):
#     host: str
#     port: int
#     num_connections: int

#     def configure(self) -> None:
#         self.add_argument('--host', help='host to listen', default='0.0.0.0')
#         self.add_argument('--port', help='port to listen', default=1024)
#         self.add_argument('--num_connections', help='number of connections to listen', default=1)

# def receive_message(client_socket, buffer_size=1024): return client_socket.recv(buffer_size).decode("utf-8")
# def is_messge_complete(buffer): return '<BEGIN>' in buffer and '<END>' in buffer
# def build_message(type, content): return f"<BEGIN>{type}:{content}<END>"
# def get_message(buffer): 
#     msg = buffer.replace("<BEGIN>", "").replace("<END>", "")
#     msg_type, msg_content = msg.split(':')
#     return msg_type, msg_content

# def receive(client_socket, buffer_size=1024):
#     buffer = ''
#     while True:
#         buffer += receive_message(client_socket, buffer_size)
#         if is_messge_complete(buffer):
#             break
#     return get_message(buffer)

# def send(client_socket, message_type, message_content):
#     message = build_message(message_type, message_content)
#     client_socket.send(message.encode())

# def consult(model, message_content):
#         states = message_content.split(',')
#         input_states = []
#         for state in states:
#             input_states.append([int(char) for char in state])
#         input_states = np.array(input_states)
#         print(input_states, file=sys.stderr)

#         output_message = ''
#         for value_array in model.predict(input_states, verbose=0):
#             output_message += f"{str(value_array[0]) + ','}"
#         return output_message[:-1]

# def handle_timeout(signum, frame):
#     raise Exception("Timeout!")

# def handle_client(client_socket, client_address):
#     print(f"LOG::start_server::Connection from {client_address[0]}:{client_address[1]} has been established!", file=sys.stderr)
#     try:
#         model = None
#         while True:
#             print(f"LOG::handle_client::waiting for message from client {client_socket}", file=sys.stderr)
#             msg_type, msg_content = receive(client_socket)
#             print(f"LOG::handle_client::message [{msg_type}:{msg_content}] received!", file=sys.stderr)
            
#             if msg_type == 'build':
#                 if msg_content == '' or os.path.isfile(msg_content) == False:
#                     print("You must specify --samples_file to train the model", file=sys.stderr)
#                     break
#                 model = build_and_train_model(msg_content)
#                 send(client_socket, 'build', 'ok')
#                 print(f"LOG::main::message [build:ok] sent!", file=sys.stderr)
           
#             elif msg_type == 'consult':
#                 response = consult(model, msg_content)
#                 send(client_socket, 'consult', response)

#             elif msg_type == 'timelimit':
#                 signal.signal(signal.SIGALRM, handle_timeout)
#                 timelimit = ceil(float(msg_content))
#                 signal.alarm(timelimit)
#                 print("LOG::handle_client::timelimit set to ", timelimit, file=sys.stderr)
#                 send(client_socket, 'timelimit', timelimit)

            
#             elif msg_type == 'exit':
#                 print(f"LOG::handle_client::message [exit] received!", file=sys.stderr)
#                 break

#     finally:
#         client_socket.close()

# def start_server(host, port, num_connections):
#     server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     if host == '0.0.0.0':
#         server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
#     server.bind((host, port))
#     server.listen(num_connections)

#     print(f"LOG::start_server::Server listening on port {host}:{port}", file=sys.stderr)

#     # TODO: add timeout to each thread
#     try:
#         while True:
#             client_socket, address = server.accept()

#             client_handler = threading.Thread(
#                 target=handle_client, 
#                 args=(client_socket, address,)
#             )
#             client_handler.start()
#             print("LOG::start_server::Number of threads:", threading.active_count(), file=sys.stderr)
#     except:
#         print("LOG::start_server::Closing server", file=sys.stderr)
#         server.close()
#         print("LOG::start_server::Server closed", file=sys.stderr)
#         exit(0)


# if __name__ == '__main__':
#     parser = ArgParsingNamespace()
#     argcomplete.autocomplete(parser)
#     parser.parse_args()

#     start_server(parser.host, parser.port, parser.num_connections)
