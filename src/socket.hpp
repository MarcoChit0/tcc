#pragma once
#include "general.hpp"

// message format: <BEGIN>messagecontent<END>
#define MESSAGE_BEGIN "<BEGIN>"
#define MESSAGE_BEGIN_LENGTH 7
#define MESSAGE_END "<END>"
#define MESSAGE_END_LENGTH 5
#define MINIMUM_MESSAGE_LENGTH (MESSAGE_BEGIN_LENGTH + MESSAGE_END_LENGTH)
#define NUMBER_OF_CONNECTIONS 1
#define MESSAGE_LENGTH 1024


class Socket
{
private:
    int sockfd;
    struct sockaddr_in serv_addr, cli_addr;
    socklen_t clilen;

public:
    Socket();
    Socket(int socket);
    bool create_server(int port);
    void bind();
    void listen();
    Socket *accept();
    std::string read();
    void write(const std::string &message);
    int close();
    friend std::ostream& operator<<(std::ostream& os, const Socket& socket);
    friend bool operator==(const Socket& l, const Socket& r);
};

void get_message_content(str& message);
void build_message(str& message);
bool is_message_complete(str& message);