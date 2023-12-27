#pragma once

#include <string>
#include <utility>
#include <cassert>
#include <chrono>
#include <random>
#include <map>
#include <typeindex>
#include <bitset>
#include <csignal>
#include <sys/time.h>
#include <unistd.h>
#include <memory>

#include <iostream>
#include <fstream>
#include <sstream>

#include <vector>
#include <tuple>
#include <optional>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <tuple>
#include <stack>

#include <boost/asio.hpp>
#include <boost/heap/pairing_heap.hpp>
#include <boost/bimap.hpp>
#include <boost/process.hpp>

#include <thread>
#include <mutex>
#include <atomic>
#include <condition_variable>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <sys/ioctl.h>

// message format: <BEGIN>messagecontent<END>
#define MESSAGE_BEGIN "<BEGIN>"
#define MESSAGE_BEGIN_LENGTH 7
#define MESSAGE_END "<END>"
#define MESSAGE_END_LENGTH 5
#define MINIMUM_MESSAGE_LENGTH (MESSAGE_BEGIN_LENGTH + MESSAGE_END_LENGTH)
#define NUMBER_OF_CONNECTIONS 1
#define MESSAGE_LENGTH 1024


class Client
{
private:
    boost::asio::io_context io_context;
    std::unique_ptr<boost::asio::ip::tcp::socket> socket;

public:
    Client();
    ~Client();
    void connect(int port, const std::string& host = "localhost");
    void write(const std::string& message_type, const std::string& message_content) const;
    std::pair<std::string, std::string> read() const;
    int close();
};


std::pair<std::string, std::string> get_message(const std::string &buffer);
std::string build_message(const std::string &message_type, const std::string &message_content);
bool is_message_complete(const std::string &message);
std::vector<std::string> split(const std::string &s, char delimiter);