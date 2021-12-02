
#include <vram.h>
#include <Q9_6.h>
#include <screen.h>
#include "person.h"

Q9_6 bounce(Q9_6 v) {
    v >>= 1;
    return Q9_6_neg(v);
}

void person_draw(const person_t * const p) {
    OBM[p->object].x = Q9_6_to_sint8( p->xp );
    OBM[p->object].y = Q9_6_to_sint8( p->yp )-8;
    OBM[p->object].pattern_config = p->pmfa;
    OBM[p->object].color = p->color;
}


void person_jump(person_t * const p) {
    bool to_jump = false;
    // left walljump
    if ( p->xp == 0 ) {
        p->xv += person_walljump_strength;
        to_jump = true;
    }
    // right walljump
    if (p->xp==(SINT_TO_Q9_6(GameWidth)-person_width) ) {
        p->xv -= person_walljump_strength;
        to_jump = true;
    }
    // vertical jump
    to_jump = to_jump || ((ground - p->yp) < 5);
    if (to_jump)
        p->yv = -person_jump_strength;
}

void person_advance(person_t * const p) {
    bool onwall = false;
    Q9_6 horizontal_deccel;

    // limit speed
    p->xv = Q9_6_clamp(SINT_TO_Q9_6(-5), p->xv, SINT_TO_Q9_6(5));
    p->yv = Q9_6_clamp(SINT_TO_Q9_6(-15), p->yv, SINT_TO_Q9_6(15));

    // update position
    p->xp += p->xv;
    p->yp += p->yv;

    // ground collision
    if (p->yp >= ground) {
        p->yp = ground;
        p->yv = bounce(p->yv);
    }

    // left wall collision
    if ( p->xp <= 0 ) {
        onwall = true;
        p->xp = 0;
    }

    // right wall collision
    if ( p->xp >= (SINT_TO_Q9_6(GameWidth)-person_width) ) {
        onwall = true;
        p->xp = (SINT_TO_Q9_6(GameWidth)-person_width);
    }

    // ceiling collision
    if ( p->yp < person_height ) {
        p->yp = person_height;
        p->yv = bounce(p->yv);
    }

    // horizontal deccel
    horizontal_deccel =
        (p->yp < ground) ? person_air_horizontal_deccel :
        person_gnd_horizontal_deccel;

    // if moving right
    if ( p->xv > 0 ) {
        p->xv -= horizontal_deccel;
        p->xv = (p->xv > 0) ? p->xv : 0;
    }
    // if moving left
    if ( p->xv < 0 ) {
        p->xv += horizontal_deccel;
        p->xv = (p->xv < 0) ? p->xv : 0;
    }

    // gravity
    if ( onwall && p->yv > 0 ) {
        p->yv += weakgravity;
    } else {
        p->yv += gravity;
    }
}
