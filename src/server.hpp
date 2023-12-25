#pragma once
#include "socket.hpp"

class Server
{
    private:
        Socket socket;
        Socket* client;

    public:
        Server();
        void close();
        void send_message(const std::string& message) const;
        std::string receive_message() const;
        void accept();
};

static pthread_mutex_t socket_creation_mutex = PTHREAD_MUTEX_INITIALIZER;
static set<int> used_sockets_fds;
static set<int> used_sockets_ports;