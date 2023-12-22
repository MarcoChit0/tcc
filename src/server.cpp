#include "server.hpp"

Server::Server()
{
    std::cerr << "LOG::Server::Server::begin"<< std::endl;
    int port;
    do
    {
        port = rand() % 10000 + 10000;
        this->socket.create_server(this->port);
        std::cerr << "LOG::Server::Server::port:" << port << std::endl;
    } while (!this->socket.create_server(port));
    std::cerr << "LOG::Server::Server::server created"<< std::endl;
    this->port = port;
    this->socket.bind(); std::cerr << "LOG::Server::Server::binded"<< std::endl;
    this->socket.listen(); std::cerr << "LOG::Server::Server::listened"<< std::endl;
    std::cerr << "LOG::Server::Server::end"<< std::endl;
}

void Server::close()
{
    std::cerr << "LOG::Server::close::begin"<< std::endl;
    str message = "close"; build_message(message);
    this->send_message(message);
    this->client->close();
    delete this->client;
    this->socket.close();
    child_process.terminate();
    std::cerr << "LOG::Server::close::end"<< std::endl;
}

void Server::send_message(const std::string& message) const
{
    std::cerr << "LOG::Server::send_message::begin"<< std::endl;
    std::cerr << "LOG::Server::send_message::message:" << message << std::endl;
    this->client->write(message);
    std::cerr << "LOG::Server::send_message::write"<< std::endl;
}

std::string Server::receive_message() const
{
    std::cerr << "LOG::Server::receive_message::begin"<< std::endl;
    str message = this->client->read();
    std::cerr << "LOG::Server::receive_message::message:" << message << std::endl;
    std::cerr << "LOG::Server::receive_message::end"<< std::endl;
    return message;
}

void Server::accept()
{
    std::cerr << "LOG::Server::accept::begin"<< std::endl;
    this->client = this->socket.accept();
    std::cerr << "LOG::Server::accept::end"<< std::endl;
}

int Server::get_port() const
{
    return this->port;
}