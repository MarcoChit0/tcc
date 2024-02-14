#include "test.hpp"

int test_pytorch()
{
    torch::Tensor tensor = torch::rand({2, 3});
    std::cout << tensor << std::endl;
    return 0;
}