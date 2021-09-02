
var map = {
    "a":0, "A":0,
    "b":1, "B":1
};
let initaliazed = false;

function reset() { }
function do_logic() { }

function fill_vram() {
    if ( initaliazed ) return;
    NTBL_Color0 = 0b000;
    NTBL_Color1 = 0b111;
    fill_ntbl( "aaaaabAaaaaa" );
    fill_pmb();
    clear_OBM()
    initaliazed = true;
}

function fill_ntbl( message ) {
    for ( let i = 0; i < 240; i++ ) {
        if ( (i < message.length) && (message[i] in map) ) {
            NTBL_setAddr(i, map[message[i]] );
            NTBL_setColor(i,1);
        } else {
            NTBL_setColor(i,0);
        }
    }
}

function clear_OBM() {
    for ( let i = 0; i < 64; i++ ) {
        OBM_setY(i,255);
    }
}

function fill_pmb() {
    // A
    PMB[ 0] = 0b00001111; PMB[ 1] = 0b11000000;
    PMB[ 2] = 0b00111100; PMB[ 3] = 0b11110000;
    PMB[ 4] = 0b11110000; PMB[ 5] = 0b00111100;
    PMB[ 6] = 0b11110000; PMB[ 7] = 0b00111100;
    PMB[ 8] = 0b11111111; PMB[ 9] = 0b11111100;
    PMB[10] = 0b11110000; PMB[11] = 0b00111100;
    PMB[12] = 0b11110000; PMB[13] = 0b00111100;
    PMB[14] = 0b00000000; PMB[15] = 0b00000000;

    // B
    PMB[16] = 0b11111111; PMB[17] = 0b11110000;
    PMB[18] = 0b11110000; PMB[19] = 0b00111100;
    PMB[20] = 0b11110000; PMB[21] = 0b00111100;
    PMB[22] = 0b11111111; PMB[23] = 0b11110000;
    PMB[24] = 0b11110000; PMB[25] = 0b00111100;
    PMB[26] = 0b11110000; PMB[27] = 0b00111100;
    PMB[28] = 0b11111111; PMB[29] = 0b11110000;
    PMB[30] = 0b00000000; PMB[31] = 0b00000000;
}
