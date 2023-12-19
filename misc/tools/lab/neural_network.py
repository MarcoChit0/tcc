from math import ceil, floor
import os
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

def plot_history(history):
    acc = history.history["mean_absolute_error"]
    val_acc = history.history["val_mean_absolute_error"]
    loss = history.history["loss"]
    val_loss = history.history["val_loss"]
    epochs = range(1, len(acc) + 1)
    plt.plot(epochs, acc, "bo", label="Training MAE")
    plt.plot(epochs, val_acc, "b", label="Validation MAE")
    plt.title("Training and validation Mean Absolute Error (MAE)")
    plt.legend()
    plt.figure()
    plt.plot(epochs, loss, "bo", label="Training MSE")
    plt.plot(epochs, val_loss, "b", label="Validation MSE")
    plt.title("Training and validation Mean Squared Error (MSE)")
    plt.legend()
    plt.show()


class ArgParsingNamespace(tap.Tap):
    states: str
    samples_file: str
    operation: str
    plot: bool
    path: str

    def configure(self) -> None:
        self.add_argument('--states', help='states file', default='')
        self.add_argument('--samples_file', help='samples file', default='')
        self.add_argument('--operation', help='train, predict', default=False)
        self.add_argument('--plot', help='plot history', default=False)
        self.add_argument('--path', help='path to save model', default='')


if __name__ == '__main__':
    parser = ArgParsingNamespace()
    argcomplete.autocomplete(parser)
    parser.parse_args()
    model_name = "model.keras"
    model_path = os.path.join(parser.path, model_name)
    if parser.operation == 'train':
        if parser.samples_file == '' or os.path.isfile(parser.samples_file) == False:
            print("You must specify --samples_file to train the model", file=sys.stderr)
        else:
            model, history = build_and_train_model(parser.samples_file)
            model.save(model_path)
            if parser.plot:
                plot_history(history)

    elif parser.operation == 'predict':
        if parser.states == '':
            print("You must specify --states to predict the model", file=sys.stderr)
        else:
            model = keras.models.load_model(model_path)
            states = parser.states.split(',')
            input_states = []
            for state in states:
                input_states.append([int(char) for char in state])
            input_states = np.array(input_states)
            print(input_states, file=sys.stderr)
            values_str = ""
            for value_array in model.predict(input_states, verbose=0):
                values_str += f"{str(value_array[0]) + ','}"
                
            print(values_str[:-1])

    else:
        print("You must specify --operation to train or predict the model", file=sys.stderr)
        exit()
