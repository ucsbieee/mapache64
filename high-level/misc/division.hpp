
#pragma once


#include "Q9_6.hpp"




uint16_t div8( uint8_t dividend, uint8_t divisor ) {
    uint8_t quotient;
    uint16_t divisor_slider = ((uint16_t) divisor) << 8;
    // Compare divisor_slider to dividend
    for ( uint8_t i = 0; i <= 8; i++ ) {
        if ( divisor_slider <= dividend ) {
            dividend -= divisor_slider;
            quotient = (quotient << 1) | 1;
        } else { // divisor_slider > dividend
            quotient = quotient << 1;
        }
        divisor_slider = divisor_slider >> 1;
    }
    return quotient;
}




uint16_t div16( uint16_t dividend, uint16_t divisor ) {
    uint16_t quotient;
    uint32_t divisor_slider = ((uint32_t) divisor) << 16;
    // Compare divisor_slider to dividend
    for ( uint8_t i = 0; i <= 16; i++ ) {
        if ( divisor_slider <= dividend ) {
            dividend -= divisor_slider;
            quotient = (quotient << 1) | 1;
        } else { // divisor_slider > dividend
            quotient <<= 1;
        }
        divisor_slider = divisor_slider >> 1;
    }
    return quotient;
}




// Q9_6 is exact same thing
Q9_6 divQ9_6( Q9_6 dividend, Q9_6 divisor ) {
    Q9_6 out;
    out.data = div16(dividend.data, divisor.data >> 6);
    return out;
}
