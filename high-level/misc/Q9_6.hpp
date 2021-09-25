
#pragma once


#include <iostream>


struct Q9_6 {
    uint16_t data;

    Q9_6() { }
    Q9_6( int in ) { data = (in*64); }
    Q9_6( double in ) { data = (uint16_t)(in*64.0); }
    operator int() const { return data / 64; }
    operator double() const { return (double)(data) / 64.0; }

    friend std::ostream& operator<<(std::ostream& os, const Q9_6& num);
};
std::ostream& operator<<(std::ostream& os, const Q9_6& num) {
    os << (double)(num);
    return os;
}
