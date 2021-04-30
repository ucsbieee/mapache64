
/* gpu-showcase.js */


function reset() {

}

function do_logic() {
    console.log(`A      : ${CONTROLLER_A()}`);
    console.log(`B      : ${CONTROLLER_B()}`);
    console.log(`UP     : ${CONTROLLER_UP()}`);
    console.log(`DOWN   : ${CONTROLLER_DOWN()}`);
    console.log(`LEFT   : ${CONTROLLER_LEFT()}`);
    console.log(`RIGHT  : ${CONTROLLER_RIGHT()}`);
    console.log(`START  : ${CONTROLLER_START()}`);
    console.log(`SELECT : ${CONTROLLER_SELECT()}`);
}

function fill_vram() {
    for ( let i = 0; i < PMF.length; i++ )
        PMF[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < PMB.length; i++ )
        PMB[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < NTBL.length; i++ )
        NTBL[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < OBM.length; i++ )
        OBM[i] = Math.floor(Math.random() * (1 << 16)) | Math.floor(Math.random() * (1 << 16)) << 16;
}
