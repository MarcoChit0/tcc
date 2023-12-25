#include "server.hpp"

Server::Server()
{
    // pthread_mutex_lock(&socket_creation_mutex);
    // std::cerr << "LOG::Server::Server::begin:" << get_ellapsed_time() << std::endl;
    // int port;
    // do
    // {
    //     // Get the process ID
    //     auto process_id = getpid();
    //     std::cerr << "LOG::Server::Server::pid:" << getpid() << std::endl;

    //     // Get a hashed value of the thread ID
    //     auto thread_id_hash = std::hash<std::thread::id>{}(std::this_thread::get_id());
    //     std::cerr << "LOG::Server::Server::thread_id_hash:" << thread_id_hash << std::endl;

    //     // Combine process ID and thread ID hash to get a unique number
    //     auto unique_id = process_id + thread_id_hash;
    //     std::cerr << "LOG::Server::Server::unique_id:" << unique_id << std::endl;

    //     port = ((rand() % 100000 + 1024) + unique_id) % 65536;
    //     port < 1024 ? port += 1024 : port;
    //     std::cerr << "LOG::Server::Server::port:" << port << std::endl;
    // } while (used_sockets_ports.find(port) != used_sockets_ports.end());
    
    // std::cerr << "LOG::Server::Server::used_sockets_ports:" << std::endl;
    // for(auto p : used_sockets_ports)
    // {
    //     std::cerr <<"\t" << p << std::endl;
    // }

    // do
    // {
    //     this->socket.create_server(port);
    //     std::cerr << "LOG::Server::Server::sockfd:"<< this->socket.get_sockfd() << std::endl;
    // } while (used_sockets_fds.find(this->socket.get_sockfd()) != used_sockets_fds.end());

    // std::cerr << "LOG::Server::Server::used_sockets_fds:" << std::endl;
    // for(auto fd : used_sockets_fds)
    // {
    //     std::cerr << "\t" << fd << std::endl;
    // }

    // used_sockets_ports.insert(port);
    // used_sockets_fds.insert(this->socket.get_sockfd());
    
    std::cerr << "LOG::Server::Server::port:" << port << std::endl;
    this->socket.create_server(port);
    std::cerr << "LOG::Server::Server::sockfd:"<< this->socket.get_sockfd() << std::endl;
    this->socket.bind();
    std::cerr << "LOG::Server::Server::binded:"<< get_ellapsed_time() << std::endl;
    pthread_mutex_unlock(&socket_creation_mutex);
    this->socket.listen();
    std::cerr << "LOG::Server::Server::listened" << std::endl;
    std::cerr << "LOG::Server::Server::end" << std::endl;
}

void Server::close()
{
    std::cerr << "LOG::Server::close::begin" << std::endl;
    str message = "close";
    build_message(message);
    this->send_message(message);
    this->client->close();
    delete this->client;
    this->socket.close();
    child_process.terminate();
    std::cerr << "LOG::Server::close::end" << std::endl;
}

void Server::send_message(const std::string &message) const
{
    std::cerr << "LOG::Server::send_message::begin" << std::endl;
    std::cerr << "LOG::Server::send_message::message:" << message << std::endl;
    this->client->write(message);
    std::cerr << "LOG::Server::send_message::write" << std::endl;
}

std::string Server::receive_message() const
{
    std::cerr << "LOG::Server::receive_message::begin" << std::endl;
    str message = this->client->read();
    std::cerr << "LOG::Server::receive_message::message:" << message << std::endl;
    std::cerr << "LOG::Server::receive_message::end" << std::endl;
    return message;
}

void Server::accept()
{
    std::cerr << "LOG::Server::accept::begin" << std::endl;
    this->client = this->socket.accept();
    std::cerr << "LOG::Server::accept::end" << std::endl;
}