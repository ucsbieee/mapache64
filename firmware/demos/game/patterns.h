
#ifndef __PATTERNS_H
#define __PATTERNS_H


#include <vram.h>

extern const pattern_t person_normal;
extern const uint8_t person_normal_pmfa;

extern const pattern_t black;
extern const uint8_t black_pmba;

extern const pattern_t dark_gray;
extern const uint8_t dark_gray_pmba;

extern const pattern_t light_gray;
extern const uint8_t light_gray_pmba;

extern const pattern_t white;
extern const uint8_t white_pmba;


void load_background_pattern(const pattern_t pattern, const uint8_t pmba);
void load_foreground_pattern(const pattern_t pattern, const uint8_t pmfa);


#endif
