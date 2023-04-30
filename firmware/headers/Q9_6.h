// Defines a new type for fixed-point number math. Q9_6 means 9 digits before
// and 6 digits after the decimal
#ifndef __Q9_6_H
#define __Q9_6_H
#include "int.h"

typedef sint16_t Q9_6;

#define SINT_TO_Q9_6(NUM) ((Q9_6)(NUM<<6))

Q9_6 sint8_to_Q9_6(sint8_t);
Q9_6 sint16_to_Q9_6(sint16_t);
sint8_t Q9_6_to_sint8(Q9_6);
sint16_t Q9_6_to_sint16(Q9_6);

Q9_6 Q9_6_mul(Q9_6 n1, Q9_6 n2);
Q9_6 Q9_6_div(Q9_6 n1, Q9_6 n2);

Q9_6 Q9_6_clamp(const Q9_6 min, const Q9_6 T, const Q9_6 max);

Q9_6 Q9_6_neg(const Q9_6 num);

#endif
