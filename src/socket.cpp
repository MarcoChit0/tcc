#include "socket.hpp"

Socket::Socket() {}

Socket::Socket(int socket)
{
    this->sockfd = socket;
}

/**
 * Creates a server socket and initializes the server address structure.
 * Throws a runtime_error if socket creation fails.
 */
bool Socket::create_server(int port)
{
    std::cerr << "LOG::Socket::create_server::begin"<< std::endl;
    this->sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (this->sockfd < 0)
    {
        std::cerr << "LOG::Socket::create_server::Could not open socket\n";
        return false;
    }
    this->serv_addr.sin_family = AF_INET;
    this->serv_addr.sin_addr.s_addr = INADDR_ANY;
    this->serv_addr.sin_port = htons(port);
    bzero((char *)&(this->serv_addr.sin_zero), 8);
    std::cerr << "LOG::Socket::create_server::sockfd:" << this->sockfd << std::endl;
    std::cerr << "LOG::Socket::create_server::end"<< std::endl;
    return true;
}


/**
 * Binds the socket to the specified address and port.
 * Throws a runtime_error if the binding fails.
 */
void Socket::bind()
{
    std::cerr << "LOG::Socket::bind::begin"<< std::endl;
    if (::bind(this->sockfd, (struct sockaddr *)&this->serv_addr, sizeof(this->serv_addr)) < 0)
    {
        throw std::runtime_error("Socket::bind::Error on binding\n");
    }
    std::cerr << "LOG::Socket::bind::end"<< std::endl;
}

/**
 * Listens for incoming connections on the socket.
 */
void Socket::listen()
{
    std::cerr << "LOG::Socket::listen::begin"<< std::endl;
    ::listen(this->sockfd, NUMBER_OF_CONNECTIONS);
    std::cerr << "LOG::Socket::listen::end"<< std::endl;
}

/**
 * Accepts an incoming connection, creates a new socket for the connection,
 * and returns the new socket.
 * Throws a runtime_error if accepting the connection fails.
 */
Socket *Socket::accept()
{
    std::cerr << "LOG::Socket::accept::begin"<< std::endl;
    this->clilen = sizeof(this->cli_addr);
    int newsockfd = ::accept(this->sockfd, (struct sockaddr *)&this->cli_addr, &this->clilen);
    if (newsockfd < 0)
    {
        std::cerr << "LOG::Socket::accept::Could not accept the connection\n";
        kill(getpid(), SIGTERM);
    }
    std::cerr << "LOG::Socket::accept::end"<< std::endl;
    return new Socket(newsockfd);
}

/**
 * Reads data from the socket and returns it as a string.
 * Throws a runtime_error if reading fails.
 */
std::string Socket::read()
{
    std::cerr << "LOG::Socket::read::begin"<< std::endl;
    std::string buffer;
    while (true)
    {
        char message[MESSAGE_LENGTH];
        bzero(message, MESSAGE_LENGTH);
        int n = ::read(this->sockfd, &message, MESSAGE_LENGTH);
        std::cerr << "LOG::Socket::read::message:" << message << std::endl;
        std::cerr << "LOG::Socket::read::n:" << n << std::endl;
        if (n < 0)
        {
            std::cerr << "LOG::Socket::read::Could not read from socket\n";
            kill(getpid(), SIGTERM);
        }

        buffer += message;
        std::cerr << "LOG::Socket::read::buffer:" << buffer << std::endl;
        if (is_message_complete(buffer))
        {
            break;
        }
    }
    std::cerr << "LOG::Socket::read::end"<< std::endl;

    return str(buffer);
}

/**
 * Writes the given message to the socket.
 * Throws a runtime_error if writing fails.
 */
void Socket::write(const std::string &message)
{
    std::cerr << "LOG::Socket::write::begin"<< std::endl;
    std::cerr << "LOG::Socket::write::message:" << message << std::endl;
    int n = ::write(this->sockfd, message.c_str(), message.length());
    std::cerr << "LOG::Socket::write::n:" << n << std::endl;
    if (n < 0)
    {
        std::cerr << "LOG::Socket::write::Could not write the message\n";
        kill(getpid(), SIGTERM);
    }
    std::cerr << "LOG::Socket::write::end"<< std::endl;
}

/**
 * Closes the socket.
 * Returns 0 on success, -1 on failure.
 */
int Socket::close()
{
    std::cerr << "LOG::Socket::close"<< std::endl;
    return ::close(this->sockfd);
}

/**
 * Overloads the << operator to print the socket's address and port.
 */
std::ostream &operator<<(std::ostream &os, const Socket &socket)
{
    os << inet_ntoa(socket.serv_addr.sin_addr) << ":" << ntohs(socket.serv_addr.sin_port) << std::endl;
    return os;
}

/**
 * Overloads the == operator to compare two sockets' ID.
 */
bool operator==(const Socket &l, const Socket &r)
{
    return (l.sockfd == r.sockfd);
}

void get_message_content(str &message)
{
    if (is_message_complete(message))
    {
        int begin_index = message.find(MESSAGE_BEGIN);
        int end_index = message.find(MESSAGE_END);
        message = message.substr(begin_index + MESSAGE_BEGIN_LENGTH, end_index - begin_index - MESSAGE_BEGIN_LENGTH);
    }
}

void build_message(str &message_content)
{
    message_content = MESSAGE_BEGIN + message_content + MESSAGE_END;
}

bool is_message_complete(str &message)
{
    if (message == "" or message.length() <= MINIMUM_MESSAGE_LENGTH)
    {
        return false;
    }
    return message.find(MESSAGE_BEGIN) != std::string::npos and message.find(MESSAGE_END) != std::string::npos;
}