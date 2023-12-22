#pragma once
#include "socket.hpp"

class Server
{
    private:
        Socket socket;
        Socket* client;
        int port;

    public:
        Server();
        void close();
        void send_message(const std::string& message) const;
        std::string receive_message() const;
        void accept();
        int get_port() const;
};