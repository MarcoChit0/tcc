from neural_network import *

import socket
import threading
import sys
import os
import signal
from io import StringIO
import traceback
import tap
import argcomplete

class ArgParsingNamespace(tap.Tap):
    host: str
    port: int
    num_connections: int

    def configure(self) -> None:
        self.add_argument('--host', help='host to listen', default="localhost")
        self.add_argument('--port', help='port to listen', default=1024)
        self.add_argument('--num_connections', help='number of connections to listen', default=1)

BUFFER_SIZE = 1024

# Client thread function
def client_thread(conn, addr):
    try:
        model = None
        while True:
            data = conn.recv(BUFFER_SIZE)
            if not data:
                break

            message = data.decode('utf-8')
            if message.startswith('<BEGIN>') and message.endswith('<END>'):
                message_type, message_content = parse_message(message)
                response = ''

                print(f"LOG::handle_client::client: {conn}")
                print(f"LOG::handle_client::request: [{message_type}:{message_content}]")

                if message_type == 'build':
                    response, model = handle_build(message_content)
                elif message_type == 'consult':
                    response = handle_consult(message_content, model)
                elif message_type == 'close':
                    response = handle_close()
                    conn.sendall(f'<BEGIN>{message_type}:{response}<END>'.encode('utf-8'))
                    break
                # elif message_type == 'timeout':
                #     response = handle_timeout(message_content)

                conn.sendall(f'<BEGIN>{message_type}:{response}<END>'.encode('utf-8'))
            else:
                conn.sendall('<BEGIN>error:Invalid message format<END>'.encode('utf-8'))

    except Exception as e:
        # Handle exceptions
        traceback.print_exc()
        conn.sendall(f'<BEGIN>error:{str(e)}<END>'.encode('utf-8'))
    finally:
        conn.close()

# Message parsing function
def parse_message(message):
    content = message[7:-5]  # Remove <BEGIN> and <END>
    message_type, message_content = content.split(':', 1)
    return message_type, message_content

# Handlers for different message types
def handle_build(message_content):
    print("LOG::handle_client::handle_build")
    try:
        model = build_and_train_model(message_content)
        return 'ok', model
    except Exception as e:
        return f'error:{str(e)}'

def handle_consult(message_content, model):
    print("LOG::handle_client::handle_consult")
    states = np.array([[int(char) for char in state] for state in message_content.split(',')])
    response = ','.join([str(value_array[0]) for value_array in model.predict(states, verbose=0)])
    return response

def handle_close():
    print("LOG::handle_client::handle_close")
    return 'ok'

# def handle_timeout(message_content):
#     try:
#         time_limit = float(message_content)
#         signal.alarm(int(time_limit))
#         return 'ok'
#     except ValueError:
#         return 'error:Invalid time limit'

# Main function to start the server
def main(host, port, num_connections=1):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((host, port))
        s.listen(num_connections)

        while True:
            conn, addr = s.accept()
            threading.Thread(target=client_thread, args=(conn, addr)).start()

if __name__ == '__main__':
    args = ArgParsingNamespace()
    argcomplete.autocomplete(args)
    main(args.host, args.port, args.num_connections)
