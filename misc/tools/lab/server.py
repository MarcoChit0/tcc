from neural_network import *

import socket
import threading
import sys
import traceback
import tap
import argcomplete
import logging

class ArgParsingNamespace(tap.Tap):
    host: str
    port: int
    num_connections: int
    timeout: int

    def configure(self) -> None:
        self.add_argument('--host', help='host to listen', default="localhost")
        self.add_argument('--port', help='port to listen', default=1024)
        self.add_argument('--num_connections', help='number of connections to listen', default=1)
        self.add_argument('--timeout', help='timeout for each connection', default=1)

BUFFER_SIZE = 1024
event = threading.Event()

logging.basicConfig(
    filename='server.log', 
    filemode='w',
    format='%(asctime)s %(levelname)s: %(message)s',
    level=logging.INFO)

# Client thread function
def client_thread(conn, addr):
    try:
        model = None
        loop = True
        while not event.is_set() and loop:
            data = conn.recv(BUFFER_SIZE)
            if not data:
                break

            message = data.decode('utf-8')
            if message.startswith('<BEGIN>') and message.endswith('<END>'):
                message_type, message_content = parse_message(message)
                response = ''

                logging.info(f"LOG::handle_client::client: {conn}")
                logging.info(f"LOG::handle_client::request: [{message_type}:{message_content}]")

                if message_type == 'build':
                    message_type, response, model = handle_build(message_type, message_content)
                elif message_type == 'consult':
                    response = handle_consult(message_content, model)
                elif message_type == 'close':
                    response = handle_close()
                    loop = False
                else:
                    response = f'Invalid message type'
                    message_type = 'error'
                # elif message_type == 'timeout':
                #     response = handle_timeout(message_content)

                conn.sendall(f'<BEGIN>{message_type}:{response}<END>'.encode('utf-8'))
            else:
                conn.sendall('<BEGIN>error:Invalid message format<END>'.encode('utf-8'))
        logging.info(f"LOG::handle_client::event.is_set(): {event.is_set()}")
    except Exception as e:
        # Handle exceptions
        logging.error("Exception occurred", exc_info=True)
        conn.sendall(f'<BEGIN>error:{str(e)}<END>'.encode('utf-8'))
    finally:
        logging.info("LOG::handle_client::Closing connection")
        conn.close()

# Message parsing function
def parse_message(message):
    content = message[7:-5]  # Remove <BEGIN> and <END>
    message_type, message_content = content.split(':', 1)
    return message_type, message_content

# Handlers for different message types
def handle_build(message_type, message_content):
    logging.info("LOG::handle_client::handle_build")
    try:
        model = build_and_train_model(message_content)
        return message_type, 'ok', model
    except Exception as e:
        logging.error("Model building exception", exc_info=True)
        return "error", str(e), None

def handle_consult(message_content, model):
    logging.info("LOG::handle_client::handle_consult")
    states = np.array([[int(char) for char in state] for state in message_content.split(',')])
    response = ','.join([str(value_array[0]) for value_array in model.predict(states, verbose=0)])
    logging.info(f"LOG::handle_client::response: {response}")
    return response

def handle_close():
    logging.info("LOG::handle_client::handle_close")
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
    threads = []
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((host, port))
        s.listen(num_connections)
        s.settimeout(1)
        try:
            while True:
                try:
                    conn, addr = s.accept()
                    thread = threading.Thread(target=client_thread, args=(conn, addr))
                    thread.start()
                    threads.append(thread)
                except socket.timeout:
                    logging.info("LOG::server::main::Socket timeout occurred")
                    if event.is_set():
                        logging.info(f"LOG::server::main::event.is_set(): {event.is_set()}")
                        break
                except socket.error as e:
                    logging.error("LOG::server::main::Socket exception occurred", exc_info=True)
        except Exception as e:
            logging.error("Main loop exception", exc_info=True)
        finally:
            logging.info("LOG::server::main::Closing server")
            for thread in threads:
                thread.join(); logging.info("LOG::server::main::thread joined")
            s.close()

if __name__ == '__main__':
    args = ArgParsingNamespace()
    argcomplete.autocomplete(args)
    main(args.host, args.port, args.num_connections)
