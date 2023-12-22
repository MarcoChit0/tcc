#include "./general.hpp"

std::default_random_engine rng;

Object::Id Object::last_used_id = NONE;

static double timer = get_time_limit();
static bool timer_is_set = false;
static int policy_type = 0;

static std::chrono::system_clock::time_point start_time = std::chrono::system_clock::now();

double get_ellapsed_time()
{
    return double(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - start_time).count()) / double(1000) / double(1000) / double(1000);
}

double get_memory_usage()
{
    FILE *file = fopen("/proc/self/statm", "r");
    if (not file)
    {
        std::cout << "Failed to open memory file." << std::endl;
        exit(1);
    }
    unsigned long vm = 0;
    assert(fscanf(file, "%lu", &vm) != EOF);
    fclose(file);
    size_t size = (size_t)vm * getpagesize();
    return double(size) / double(1000) / double(1000) / double(1000);
}

#include <sys/resource.h>

double get_time_limit()
{
    struct rlimit lim;
    getrlimit(RLIMIT_RTTIME, &lim);                              // microseconds
    return (double)(double(lim.rlim_max) / double(1000 * 1000)); // seconds
}

double get_memory_limit()
{
    struct rlimit lim;
    getrlimit(RLIMIT_AS, &lim);
    return double(lim.rlim_max) / double(1000) / double(1000) / double(1000);
}

#include <future>

str get_output(const str &label, const str &command, const str &input, const opt<double> &opt_time_limit)
{
    boost::process::ipstream std_out_pstream;
    boost::process::ipstream std_err_pstream;
    boost::process::opstream std_in_pstream;

    double start_time = get_ellapsed_time();
    boost::process::child cp(
        command,
        boost::process::std_out > std_out_pstream,
        boost::process::std_err > std_err_pstream,
        boost::process::std_in < std_in_pstream);

    std::stringstream std_out_sstream;
    std::stringstream std_err_sstream;
    std::stringstream std_in_sstream;

    std_in_sstream << input;
    bool is_std_in_pstream_closed = false;

    auto write_in = [&std_in_pstream, &std_in_sstream, &is_std_in_pstream_closed]()
    {
        if (not is_std_in_pstream_closed)
        {
            str buffer;
            while (not std_in_sstream.eof())
            {
                std::getline(std_in_sstream, buffer);
                std_in_pstream << buffer << std::endl;
            }
            if (std_in_sstream.eof())
            {
                std_in_pstream.pipe().close();
                is_std_in_pstream_closed = true;
            }
        }
    };
    auto read_out = [&std_out_pstream, &std_out_sstream]()
    {
        str buffer;
        while (not std_out_pstream.eof())
        {
            std::getline(std_out_pstream, buffer);
            std_out_sstream << buffer << std::endl;
        }
    };
    auto read_err = [&std_err_pstream, &std_err_sstream]()
    {
        str buffer;
        while (not std_err_pstream.eof())
        {
            std::getline(std_err_pstream, buffer);
            std_err_sstream << buffer << std::endl;
        }
    };

    std::future<void> in_writer = std::async(write_in);
    std::future<void> out_reader = std::async(read_out);
    std::future<void> err_reader = std::async(read_err);
    do
    {
        if (opt_time_limit.has_value() and get_ellapsed_time() - start_time > *opt_time_limit)
        {
            cp.terminate();
            throw std::runtime_error("Timeout: " + label + " exceeded time limit.");
        }
        if (in_writer.wait_for(std::chrono::duration<double>(0.01)) == std::future_status::ready)
        {
            in_writer = std::async(write_in);
        }
        if (out_reader.wait_for(std::chrono::duration<double>(0.01)) == std::future_status::ready)
        {
            out_reader = std::async(read_out);
        }
        if (err_reader.wait_for(std::chrono::duration<double>(0.01)) == std::future_status::ready)
        {
            err_reader = std::async(read_err);
        }
    } while (cp.running());
    out_reader.wait();
    err_reader.wait();

    if (not std_err_sstream.str().empty())
    {
        std::cerr << std_err_sstream.str();
    }
    return std_out_sstream.str();
}

FunctionsCache functions_cache;
FunctionsCache functions_storage;

bool enough_time(int alarm_type = ALARM_TYPE_SAMPLE_GENERATION)
{
    double time_limit = get_time_limit();
    double ellapsed_time = get_ellapsed_time();
    if (alarm_type == ALARM_TYPE_SAMPLE_GENERATION)
    {
        time_limit *= sample_generation_alarm;
    }
    if (ellapsed_time < time_limit)
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool enough_memory()
{
    double memory_limit = get_memory_limit();
    double memory_usage = get_memory_usage();
    if (memory_usage < percentage_memory_limit * memory_limit)
    {
        return true;
    }
    else
    {
        return false;
    }
}

void set_timer()
{
    timer_is_set = true;
    timer = get_ellapsed_time() + step;
}

bool timer_expired()
{
    return timer_is_set and get_ellapsed_time() > timer;
}

void unset_timer()
{
    timer_is_set = false;
}

int get_policy_type()
{
    return policy_type;
}

void set_policy_type(int new_policy_type)
{
    policy_type = new_policy_type;
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

void signal_handler(int signal)
{
    if (signal == SIGUSR1 or signal == SIGTERM)
    {
        std::cout << "Interrupt signal received. Terminating main thread." << std::endl;
        std::cout << "LOG::get_ellapsed_time():" << get_ellapsed_time() << std::endl;
        std::cout << "LOG::get_memory_usage():" << get_memory_usage() << std::endl;
        child_process.terminate();
        exit(0);
    }
}

void timer_function(int duration)
{
    std::this_thread::sleep_for(std::chrono::seconds(duration));
    kill(getpid(), SIGUSR1);
}