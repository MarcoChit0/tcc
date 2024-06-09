#include "./general.hpp"

std::default_random_engine rng;

Object::Id Object::last_used_id = EMPTY_OBJECT;

// static double time_limit = 0.0f;

static bool timer_is_set = false;
static int policy_type = 0;

static std::chrono::system_clock::time_point start_time = std::chrono::system_clock::now();

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

bool directory_created_successfully(const str &directory)
{
    str full_path = default_directory + directory;
    struct stat info;
    if (stat(full_path.c_str(), &info) != 0)
    {
        str command = "mkdir -p " + full_path;
        int status = system(command.c_str());
        if (status != 0)
        {
            std::cout << "Failed to create directory: " << full_path << std::endl;
            return false;
        }
    }
    return true;
}

double get_elapsed_time()
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
    return time_limit;
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

    double start_time = get_elapsed_time();
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
        if (opt_time_limit.has_value() and get_elapsed_time() - start_time > *opt_time_limit)
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
    try
    {
        double t_lim = get_time_limit();
        double ellapsed_time = get_elapsed_time();
        std::cout << "LOG::General::enough_time::t_lim::" << t_lim << std::endl;
        std::cout << "LOG::General::enough_time::ellapsed_time::" << ellapsed_time << std::endl;
        if (t_lim < 0)
        {
            return true;
        }

        if (alarm_type == ALARM_TYPE_SAMPLE_GENERATION)
        {
            t_lim *= sample_generation_alarm;
        }
        
        return ellapsed_time < t_lim;
    }
    catch(const std::exception& e)
    {
        std::cerr << "LOG::enough_time::Error on try-catch block::" << e.what() << std::endl;
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
    timer = get_elapsed_time() + step;
}

bool timer_expired()
{
    return timer_is_set and get_elapsed_time() > timer;
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