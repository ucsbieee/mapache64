// Defines convenient integer types of different sizes. Analogous to those
// of the C++ `cstdint` header: https://en.cppreference.com/w/cpp/types/integer
#ifndef __INT_H
#define __INT_H

typedef unsigned long int uint32_t;
typedef unsigned short int uint16_t;
typedef unsigned char uint8_t;

typedef signed long int sint32_t;
typedef signed short int sint16_t;
typedef signed char sint8_t;

typedef sint32_t int32_t;
typedef sint16_t int16_t;
typedef sint8_t int8_t;

typedef sint8_t bool;
#define true ((bool)1)
#define false ((bool)0)

#define nullptr ((void*)0)

#endif
