
/* game-demo.js */


// start button value
var start_value = false;
// start button positive edge
var start_pedge = false;
// A button value
var A_value = false;
// A button positive edge
var A_pedge = false;

const ground = new Q11_4(224);
const gravity = new Q11_4(.3125);
const weakgravity = new Q11_4(.07);
const jump_strength = 5;
const walljump_strength = 10;
const gnd_horizonal_deccel = 1.5;
const air_horizonal_deccel = .15;
const horizonal_speed = 1.75;

const clamp = ( min, T, max ) => Math.max( min, Math.min( T, max ) );

class Person {
    constructor() { // cordinates relative to bottom left
        this.xp = new Q11_4(128);
        this.yp = new Q11_4(ground.toNumber());
        this.xv = new Q11_4(0);
        this.yv = new Q11_4(0);
        this.height = 8;
        this.width = 8;
        this.object = 0;
        OBM_setColor( this.object, 0b110 );
    }
    jump() {
        // if on ground or against a wall
        if ( ( Math.floor(ground-this.yp.toNumber()) < 5 ) || this.xp.toNumber() == 0 || this.xp.toNumber() == GameWidth-p.width ) {

            this.yv.update(jump_strength);

            // left walljump
            if ( this.xp.toNumber() == 0 ) this.xv = Q11_4_sub( this.xv, new Q11_4(walljump_strength) );
            // right walljump
            if ( this.xp.toNumber() == GameWidth-p.width ) this.xv = Q11_4_add( this.xv, new Q11_4(walljump_strength) );
        }

    }
    advance() {
        let onwall = false;

        // limit speed
        this.xv.update( clamp(  -5, this.xv.toNumber(),  5 ) );
        this.yv.update( clamp( -15, this.yv.toNumber(), 15 ) );

        // update position
        this.xp = Q11_4_sub( this.xp, this.xv );
        this.yp = Q11_4_sub( this.yp, this.yv );

        // ground collision
        if ( this.yp.toNumber() >= ground.toNumber() ) {
            this.yp.update( ground.toNumber() );
            this.yv = Q11_4_mul( this.yv, new Q11_4(-.5) );
        }

        // left wall collision
        if ( this.xp.toNumber() < 0 ) {
            onwall = true;
            this.xp.update(0);
        }

        // right wall collision
        if ( this.xp.toNumber() > GameWidth-this.width ) {
            onwall = true;
            this.xp.update( GameWidth-this.width );
        }

        // ceiling collision
        if ( this.yp.toNumber() < this.height ) {
            this.yp.update( this.height );
            this.yv = Q11_4_mul( this.yv, new Q11_4(-.5) );
        }

        // horizonal deccel
        let horizonal_deccel =
            ( this.yp.toNumber() >= ground.toNumber() )*gnd_horizonal_deccel
            + ( this.yp.toNumber() < ground.toNumber() )*air_horizonal_deccel;
        // if moving left
        if ( this.xv.toNumber() > 0 ) {
            this.xv.update(Math.max(
                0, Q11_4_sub( this.xv, new Q11_4(horizonal_deccel) ).toNumber()
            ));
        } // if moving right
        else if ( this.xv.toNumber() < 0 ) {
            this.xv.update(Math.min(
                0, Q11_4_add( this.xv, new Q11_4(horizonal_deccel) ).toNumber()
            ));
        }

        // gravity (fall slower if against a wall)
        if ( onwall && this.yv < 0 ) {
            this.yv = Q11_4_sub( this.yv, weakgravity );
        } else {
            this.yv = Q11_4_sub( this.yv, gravity );
        }
    }
    draw() {
        // if falling, use look up sprite
        if ( this.yv.toNumber() <= 0 )
            OBM_setAddr( this.object, 0 );
        else
            OBM_setAddr( this.object, 1 );

        // set x
        OBM_setX( this.object, this.xp.toSINT() );
        // set y
        OBM_setY( this.object, this.yp.toSINT()-this.height + ( this.yp.toNumber() >= ground.toNumber() )*((frame&0b1000)!=0) );
    }
}

var p = new Person();



function updatePPU() {
    getInput();

    // if start was pressed, reset
    if ( start_pedge ) {
        reset();
        return;
    }

    // if A was pressed, jump
    if ( A_pedge ) {
        console.log("jumping!");
        p.jump();
    }

    // move in a direction if a direction is held
    if ( CONTROLLER_LEFT() )
        p.xv = Q11_4_add( p.xv, new Q11_4(horizonal_speed) );
    if ( CONTROLLER_RIGHT() )
        p.xv = Q11_4_sub( p.xv, new Q11_4(horizonal_speed) );

    // move person
    p.advance();

    // load person to VRAM
    p.draw();
}

function getInput() {
    start_pedge = ( !start_value && CONTROLLER_START() );
    start_value = CONTROLLER_START();
    A_pedge = ( !A_value && CONTROLLER_A() );
    A_value = CONTROLLER_A();
}

function reset() {
    console.log("reseting!");

    // update VRAM
    VRAM_RESET();

    // Reinitialize person
    p = new Person();
    p.draw();

    /* === Person sprite === */
    // normal
    PMF[ 0] = 0b00001010; PMF[ 1] = 0b10100000;
    PMF[ 2] = 0b00101111; PMF[ 3] = 0b11111000;
    PMF[ 4] = 0b00101111; PMF[ 5] = 0b11111000;
    PMF[ 6] = 0b10110111; PMF[ 7] = 0b11011110;
    PMF[ 8] = 0b10110111; PMF[ 9] = 0b11011110;
    PMF[10] = 0b10111111; PMF[11] = 0b11111110;
    PMF[12] = 0b00101111; PMF[13] = 0b11111000;
    PMF[14] = 0b00001010; PMF[15] = 0b10100000;

    // looking up
    PMF[16] = 0b00001010; PMF[17] = 0b10100000;
    PMF[18] = 0b00101111; PMF[19] = 0b11111000;
    PMF[20] = 0b00101111; PMF[21] = 0b11111000;
    PMF[22] = 0b10111111; PMF[23] = 0b11111110;
    PMF[24] = 0b10110111; PMF[25] = 0b11011110;
    PMF[26] = 0b10110111; PMF[27] = 0b11011110;
    PMF[28] = 0b00101111; PMF[29] = 0b11111000;
    PMF[30] = 0b00001010; PMF[31] = 0b10100000;

    /* === tiles === */
    // black
    PMB[ 0] = 0b00000000; PMB[ 1] = 0b00000000;
    PMB[ 2] = 0b00000000; PMB[ 3] = 0b00000000;
    PMB[ 4] = 0b00000000; PMB[ 5] = 0b00000000;
    PMB[ 6] = 0b00000000; PMB[ 7] = 0b00000000;
    PMB[ 8] = 0b00000000; PMB[ 9] = 0b00000000;
    PMB[10] = 0b00000000; PMB[11] = 0b00000000;
    PMB[12] = 0b00000000; PMB[13] = 0b00000000;
    PMB[14] = 0b00000000; PMB[15] = 0b00000000;

    // dark gray
    PMB[16] = 0b01010101; PMB[17] = 0b01010101;
    PMB[18] = 0b01010101; PMB[19] = 0b01010101;
    PMB[20] = 0b01010101; PMB[21] = 0b01010101;
    PMB[22] = 0b01010101; PMB[23] = 0b01010101;
    PMB[24] = 0b01010101; PMB[25] = 0b01010101;
    PMB[26] = 0b01010101; PMB[27] = 0b01010101;
    PMB[28] = 0b01010101; PMB[29] = 0b01010101;
    PMB[30] = 0b01010101; PMB[31] = 0b01010101;

    // light gray
    PMB[32] = 0b10101010; PMB[33] = 0b10101010;
    PMB[34] = 0b10101010; PMB[35] = 0b10101010;
    PMB[36] = 0b10101010; PMB[37] = 0b10101010;
    PMB[38] = 0b10101010; PMB[39] = 0b10101010;
    PMB[40] = 0b10101010; PMB[41] = 0b10101010;
    PMB[42] = 0b10101010; PMB[43] = 0b10101010;
    PMB[44] = 0b10101010; PMB[45] = 0b10101010;
    PMB[46] = 0b10101010; PMB[47] = 0b10101010;

    // white
    PMB[48] = 0b11111111; PMB[49] = 0b11111111;
    PMB[50] = 0b11111111; PMB[51] = 0b11111111;
    PMB[52] = 0b11111111; PMB[53] = 0b11111111;
    PMB[54] = 0b11111111; PMB[55] = 0b11111111;
    PMB[56] = 0b11111111; PMB[57] = 0b11111111;
    PMB[58] = 0b11111111; PMB[59] = 0b11111111;
    PMB[60] = 0b11111111; PMB[61] = 0b11111111;
    PMB[62] = 0b11111111; PMB[63] = 0b11111111;

    // sky-blue
    NTBL_Color1 = 0b011;
    // green
    NTBL_Color2 = 0b010;
    // sky is blue, ground is green
    for ( let i = 0; i < NTBL_Size; i++ ) {
        if ( i < 896 ) {
            NTBL_setAddr(i,3);
            NTBL_setColor(i,0);
        } else {
            NTBL_setAddr(i,2);
            NTBL_setColor(i,1);
        }
    }
}
