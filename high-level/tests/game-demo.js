
/* game-demo.js */

var start_value = false;
var start_pedge = false;
var A_value = false;
var A_pedge = false;

const ground = 224;
const gravity = 2;

const clamp = ( min, T, max ) => Math.max( min, Math.min( T, max ) );

class Person {
    constructor( x, y ) { // cordinates relative to bottom left
        this.xp = x;
        this.yp = y;
        this.xv = 0;
        this.yv = 0;
        this.height = 8;
        this.width = 8;
        this.object = 0;
    }
    jump() {
        if ( ( Math.floor(ground-this.yp) < 5 ) || this.xp == 0 || this.xp == GameWidth-p.width ) {
            this.yv = 10;
            // walljump
            if ( this.xp == 0 ) {
                this.xv -= 15;
            }
            if ( this.xp == GameWidth-p.width ) {
                this.xv += 15
            }
        }

    }
    advance() {
        p.xv = clamp( -10, p.xv, 10 );
        p.yv = clamp( -30, p.yv, 30 );
        this.yp -= this.yv;
        this.xp -= this.xv;

        // ground collision
        if ( this.yp > ground ) {
            this.yp = ground;
            this.yv = Math.floor( this.yv * -.5 );
        }

        // left wall collision
        if ( this.xp < 0 ) {
            this.xp = 0;
        }

        // right wall collision
        if ( this.xp > GameWidth-p.width ) {
            this.xp = GameWidth-p.width;
        }

        // ceiling collision
        if ( this.yp < p.height ) {
            this.yp = p.height;
            this.yv = Math.floor( this.yv * -.5 );
        }

        // horizonal deccel
        this.xv = Math.round( this.xv/( 4*(this.yp==ground) + 1.2*(this.yp!=ground) ) );

        // gravity
        this.yv -= gravity;
    }
    draw() {
        // 
        if ( this.yv < 0 )
            OBM_setAddr(0,0);
        else
            OBM_setAddr(0,1);

        OBM_setX( this.object, Math.floor(this.xp) );
        // bob if on the ground
        OBM_setY( this.object, Math.floor(this.yp-this.height) + (this.yp==ground)*(frame&1) );
    }
}

var p = new Person( 128, ground );



function updatePPU() {
    getInput();

    if ( start_pedge ) {
        reset();
        return;
    }

    if ( A_pedge ) {
        console.log("jumping!");
        p.jump();
    }

    if ( CONTROLLER_LEFT() )
        p.xv += 3;
    if ( CONTROLLER_RIGHT() )
        p.xv -= 3;

    p.advance();

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
    p = new Person( 128, ground );
    p.draw();

    VRAM_RESET();

    // Person sprite
    p.object = 0;
    OBM_setColor(0,0b110);
    PMF[ 0] = 0b00001010; PMF[ 1] = 0b10100000;
    PMF[ 2] = 0b00101111; PMF[ 3] = 0b11111000;
    PMF[ 4] = 0b00101111; PMF[ 5] = 0b11111000;
    PMF[ 6] = 0b10110111; PMF[ 7] = 0b11011110;
    PMF[ 8] = 0b10110111; PMF[ 9] = 0b11011110;
    PMF[10] = 0b10111111; PMF[11] = 0b11111110;
    PMF[12] = 0b00101111; PMF[13] = 0b11111000;
    PMF[14] = 0b00001010; PMF[15] = 0b10100000;

    OBM_setColor(1,0b110);
    PMF[16] = 0b00001010; PMF[17] = 0b10100000;
    PMF[18] = 0b00101111; PMF[19] = 0b11111000;
    PMF[20] = 0b00101111; PMF[21] = 0b11111000;
    PMF[22] = 0b10111111; PMF[23] = 0b11111110;
    PMF[24] = 0b10110111; PMF[25] = 0b11011110;
    PMF[26] = 0b10110111; PMF[27] = 0b11011110;
    PMF[28] = 0b00101111; PMF[29] = 0b11111000;
    PMF[30] = 0b00001010; PMF[31] = 0b10100000;

    // tiles
    PMB[ 0] = 0b00000000; PMB[ 1] = 0b00000000;
    PMB[ 2] = 0b00000000; PMB[ 3] = 0b00000000;
    PMB[ 4] = 0b00000000; PMB[ 5] = 0b00000000;
    PMB[ 6] = 0b00000000; PMB[ 7] = 0b00000000;
    PMB[ 8] = 0b00000000; PMB[ 9] = 0b00000000;
    PMB[10] = 0b00000000; PMB[11] = 0b00000000;
    PMB[12] = 0b00000000; PMB[13] = 0b00000000;
    PMB[14] = 0b00000000; PMB[15] = 0b00000000;

    PMB[16] = 0b01010101; PMB[17] = 0b01010101;
    PMB[18] = 0b01010101; PMB[19] = 0b01010101;
    PMB[20] = 0b01010101; PMB[21] = 0b01010101;
    PMB[22] = 0b01010101; PMB[23] = 0b01010101;
    PMB[24] = 0b01010101; PMB[25] = 0b01010101;
    PMB[26] = 0b01010101; PMB[27] = 0b01010101;
    PMB[28] = 0b01010101; PMB[29] = 0b01010101;
    PMB[30] = 0b01010101; PMB[31] = 0b01010101;

    PMB[32] = 0b10101010; PMB[33] = 0b10101010;
    PMB[34] = 0b10101010; PMB[35] = 0b10101010;
    PMB[36] = 0b10101010; PMB[37] = 0b10101010;
    PMB[38] = 0b10101010; PMB[39] = 0b10101010;
    PMB[40] = 0b10101010; PMB[41] = 0b10101010;
    PMB[42] = 0b10101010; PMB[43] = 0b10101010;
    PMB[44] = 0b10101010; PMB[45] = 0b10101010;
    PMB[46] = 0b10101010; PMB[47] = 0b10101010;

    PMB[48] = 0b11111111; PMB[49] = 0b11111111;
    PMB[50] = 0b11111111; PMB[51] = 0b11111111;
    PMB[52] = 0b11111111; PMB[53] = 0b11111111;
    PMB[54] = 0b11111111; PMB[55] = 0b11111111;
    PMB[56] = 0b11111111; PMB[57] = 0b11111111;
    PMB[58] = 0b11111111; PMB[59] = 0b11111111;
    PMB[60] = 0b11111111; PMB[61] = 0b11111111;
    PMB[62] = 0b11111111; PMB[63] = 0b11111111;

    NTBL_Color1 = 0b011;
    NTBL_Color2 = 0b010;
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
