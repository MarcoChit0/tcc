#include "client.hpp"
#include <iostream>
#include <chrono>

static std::chrono::system_clock::time_point st = std::chrono::system_clock::now();

// Function to get the endpoint as a string
std::string endpoint_to_string(const boost::asio::ip::tcp::endpoint &endpoint)
{
    return endpoint.address().to_string() + ":" + std::to_string(endpoint.port());
}

Client::Client(const std::string id) : socket(std::make_unique<boost::asio::ip::tcp::socket>(io_context)), id(id)
{
    this->connected = false;
    std::cerr << "LOG::" << *this << "::Client::creating client at "
              << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
              << std::endl;
}

Client::~Client()
{
}

void Client::connect(int port, const std::string &host)
{
    if(port != -1)
    {
        this->port = port;
        this->host = host;
        std::cerr << "LOG::" << *this << "::connect::creating client at "
                << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
                << std::endl;

        boost::asio::ip::tcp::resolver resolver(io_context);
        boost::asio::ip::tcp::resolver::results_type endpoints = resolver.resolve(host, std::to_string(port));
        boost::asio::connect(*socket, endpoints);

        auto local_endpoint = socket->local_endpoint();
        auto remote_endpoint = socket->remote_endpoint();

        std::cerr << "LOG::" << *this << "::connect::local endpoint: " << endpoint_to_string(local_endpoint) << std::endl;
        std::cerr << "LOG::" << *this << "::connect::remote endpoint: " << endpoint_to_string(remote_endpoint) << std::endl;

        std::cerr << "LOG::" << *this << "::connect::client connected to server" << std::endl;
        std::cerr << "LOG::" << *this << "::connect::client connected at "
                << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
                << std::endl;
        
        this->connected = true;
    }
}

void Client::write(const std::string &message_type, const std::string &message_content) const
{
    std::cerr << "LOG::" << *this << "::write::writing message at "
              << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
              << std::endl;

    std::cerr << "LOG::" << *this << "::write::message type: " << message_type << std::endl;
    std::cerr << "LOG::" << *this << "::write::message content: " << message_content << std::endl;

    // Assuming build_message function exists and combines message_type and message_content
    std::string message = build_message(message_type, message_content);
    boost::asio::write(*socket, boost::asio::buffer(message));

    std::cerr << "LOG::" << *this << "::write::message written at "
              << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
              << std::endl;
}

std::pair<std::string, std::string> Client::read() const
{
    std::cerr << "LOG::" << *this << "::read::reading message at "
              << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
              << std::endl;
    
    std::string buffer;
    boost::system::error_code error; // Use boost::system::error_code
    while (!is_message_complete(buffer))
    {
        char buf[1024];
        size_t len = socket->read_some(boost::asio::buffer(buf), error);
        if (error && error != boost::asio::error::eof) // Corrected error comparison
        {
            throw boost::system::system_error(error); // Or handle it in some other way
        }
        buffer.append(buf, len);
    }

    std::cerr << "LOG::" << *this << "::read::message: " << buffer << std::endl;

    std::cerr << "LOG::" << *this << "::read::message read at "
              << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
              << std::endl;

    return get_message(buffer); // Assuming get_message function exists
}

void Client::close()
{
    if (not this->is_connected())
    {
        std::cerr << "LOG::" << *this << "::close::client not connected" << std::endl;
        return;
    }

    std::cerr << "LOG::" << *this << "::close::closing client at "
              << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
              << std::endl;
    write("close", "");
    auto response = this->read();
    if(response.first != "close" and response.second != "ok")
    {
        std::cerr << "LOG::" << *this << "::close::error when closing the socket." << std::endl;
    }
    socket->close();
    std::cerr << "LOG::" << *this << "::close::client closed at "
              << double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - st).count()) / 1e9
              << std::endl;
}

std::pair<std::string, std::string> get_message(const std::string &buffer)
{
    if (is_message_complete(buffer))
    {
        int begin_index = buffer.find(MESSAGE_BEGIN);
        int end_index = buffer.find(MESSAGE_END);
        std::vector<std::string> splited_buffer = split(buffer.substr(begin_index + MESSAGE_BEGIN_LENGTH, end_index - begin_index - MESSAGE_BEGIN_LENGTH), ':');
        return std::make_pair(splited_buffer[0], splited_buffer[1]);
    }
    else
    {
        return std::make_pair("error", "");
    }
}

std::string build_message(const std::string &message_type, const std::string &message_content)
{
    return MESSAGE_BEGIN + message_type + ":" + message_content + MESSAGE_END;
}

bool is_message_complete(const std::string &message)
{
    if (message == "" or message.length() <= MINIMUM_MESSAGE_LENGTH)
    {
        return false;
    }
    return message.find(MESSAGE_BEGIN) != std::string::npos and message.find(MESSAGE_END) != std::string::npos;
}

std::vector<std::string> split(const std::string &s, char delimiter)
{
    std::vector<std::string> tokens;
    std::istringstream ss(s);
    std::string token;

    while (std::getline(ss, token, delimiter))
    {
        tokens.push_back(token);
    }

    return tokens;
}

bool Client::is_connected() const
{
    return this->connected;
}

std::ostream& operator<<(std::ostream &out, const Client &self)
{
    if(self.is_connected())
    {
        out << "Client(" << self.id << ", " << self.host << ":" << self.port << ")";
    }
    else
    {
        out << "Client(" << self.id << ")";
    }
    return out;
}