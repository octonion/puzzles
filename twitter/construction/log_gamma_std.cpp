#include <cmath>
#include <cstdint>
#include <unordered_map>
#include <set>
#include <queue>
#include <iostream>

// Compiled and tested with the following command
// g++ -std=c++20 -O3 log_gamma_std.cpp -o log_gamma_std && time ./log_gamma_std

using float128_t = long double;
static_assert(sizeof(float128_t) == 16, "Compiler does not support 128 bit floats");

using Map = std::unordered_map<uint64_t, uint64_t>;
using Set = std::set<uint64_t>;

constexpr uint64_t isqrt(uint64_t n) {
    return uint64_t(std::sqrt(float128_t(n)));
}


void print_path(const Map &paths, const Map &sqrts, const uint64_t &val) {
    uint64_t v = val;
    while (v > 3) {
        auto w = paths.at(v);
        std::cout << v << " <- " << w << "! + " << sqrts.at(v) << " sqrt\n";
        v = w;
    }
    std::cout << "\n\n";
}


int main(int argc, char **args) {

    uint64_t bound = 1000000000;
    float128_t log_bound = std::log(float128_t(bound));

    std::queue<float128_t> queue;
    queue.push(3);

    Set found = {3};
    Map paths = {{3, 3}};
    Map sqrts = {{3, 0}};

    while (!queue.empty()) {
        auto m = queue.front();

        queue.pop();

        auto x = std::lgammal(float128_t(m) + float128_t(1));

        uint64_t i = 0;
        auto p = std::ceil(std::log2l(x / log_bound));
        auto q = uint64_t(std::max(p, float128_t(0.0)));

        i += q;

        uint64_t n = std::round(std::exp(x / std::exp2l(q)));

        while (n > 3) {
            if (!found.contains(n)) {
                found.insert(n);
                queue.push(n);
                paths[n] = m;
                sqrts[n] = i;
            }

            n = isqrt(n);
            i += 1;
        }
    }

    for (uint64_t ii = 3; ii < bound; ii++) {
        if (!found.contains(ii)) {
            std::cout << ii << " \n";
            break;
        }
    }
    std::cout << "\n\n";

    print_path(paths, sqrts, 9);
    print_path(paths, sqrts, 522);
    print_path(paths, sqrts, 1074);
    print_path(paths, sqrts, 1337);
    return 0;
}
