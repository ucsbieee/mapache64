
#include <vram.h>
#include <Q9_6.h>

#define person_walljump_strength        (SINT_TO_Q9_6(10))
#define person_jump_strength            (SINT_TO_Q9_6(5))
#define person_air_horizontal_deccel    ((Q9_6)0x0009)  // 0.15
#define person_gnd_horizontal_deccel    ((Q9_6)0x0060)  // 1.5
#define person_horizontal_acc           ((Q9_6)0x70)    // 1.75

#define person_width    (SINT_TO_Q9_6(8))
#define person_height   (SINT_TO_Q9_6(8))
#define ground          (SINT_TO_Q9_6(224))

#define weakgravity     ((Q9_6)0x0004)  // 0.07
#define gravity         ((Q9_6)0x0014)  // 0.3125


typedef struct person_s {
    Q9_6 xp, yp, xv, yv;
    uint8_t object, pmfa, color;
} person_t;


void person_draw(const person_t * const p);

void person_jump(person_t * const p);
void person_advance(person_t * const p);
