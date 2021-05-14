
/* gpu-showcase.js */


function reset() {

}

function do_logic() {

}

function fill_vram() {
    NTBL_Color0 = 0b001;
    NTBL_Color1 = 0b111;
    for ( let i = 0; i < PMF.length; i++ )
        PMF[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < PMB.length; i++ )
        PMB[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < NTBL.length; i++ )
        NTBL[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < OBM.length; i++ )
        OBM[i] = Math.floor(Math.random() * (1 << 16)) | Math.floor(Math.random() * (1 << 16)) << 16;
}
