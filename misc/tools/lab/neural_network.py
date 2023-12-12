from math import ceil
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import tap
import argcomplete
import pandas as pd

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
    model = keras.Model(inputs=model_input, outputs=output)
    model.compile(optimizer=optimizer, loss=loss_function)

    return model

def train_model(model, x_train, y_train, x_val, y_val, epochs=10, batch_size=32):
    # Train the model
    history = model.fit(
        x_train,
        y_train,
        epochs=epochs,
        batch_size=batch_size,
        validation_data=(x_val, y_val),
        verbose=0
    )
    return history

def get_samples_data(samples_file):
    ptrain = 0.8
    df = pd.read_csv(samples_file)
    x_train = df[["state"]].to_numpy()
    x_val = df[["h_nd"]].to_numpy()
    assert len(x_train) == len(x_val)
    samples_to_train = ceil(len(x_train) * ptrain)
    y_train = x_train[samples_to_train + 1: len(x_train)]
    x_train = x_train[0:samples_to_train]
    y_val = x_val[samples_to_train + 1: len(x_train)]
    x_val = x_val[0:samples_to_train]
    return {
        'x_train': x_train,
        'y_train': y_train,
        'x_val': x_val,
        'y_val': y_val,
        'input_shape': x_train.shape[1:],
    }
            
def build_and_train_model(samples_file):
    samples_data = get_samples_data(samples_file)
    model = build_model(samples_data['input_shape'])
    history = train_model(model, samples_data['x_train'], samples_data['y_train'], samples_data['x_val'], samples_data['y_val'])
    return model, history

class ArgParsingNamespace(tap.Tap):
    states: str
    samples_file: str
    operation: str

    def configure(self) -> None:
        self.add_argument('--states', help='states file', default='')
        self.add_argument('--samples_file', help='samples file', default='')
        self.add_argument('--operation', help='train, predict', default=False)

parser = ArgParsingNamespace()
argcomplete.autocomplete(parser)
parser.parse_args()
print(parser)
if parser.operation == 'train':
    if parser.samples_file == '':
        print("You must specify --samples_file to train the model")
    else:
        model, history = build_and_train_model(parser.samples_file)
        model.save('model.h5')
        print(history.history)

elif parser.predict == 'predict':
    if parser.states == '':
        print("You must specify --states to predict the model")
    else:
        model = keras.models.load_model('model.h5')
        states = parser.states.split(',')
        values = []
        for state in states:
            values.append(model.predict([[float(state)]]))
        values_str = [str(value[0][0]) + "," for value in values]
        print(values_str[:-1])

else:
    print("You must specify --operation to train or predict the model")
    exit()
