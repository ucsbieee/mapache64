
/* controller.js */

function reset() {
    setNumControllers(2);
}

function  do_logic() {
    console.log(frame);
    // console.log(`CONTROLLER1_D: ${CONTROLLER1_D}`);
    // console.log(`CONTROLLER1_Q: ${CONTROLLER1_Q}`);
    // console.log(`CONTROLLER2_D: ${CONTROLLER2_D}`);
    // console.log(`CONTROLLER2_Q: ${CONTROLLER2_Q}`);

    console.log(`A      : ${CONTROLLER1_A()}`);
    console.log(`B      : ${CONTROLLER1_B()}`);
    console.log(`UP     : ${CONTROLLER1_UP()}`);
    console.log(`DOWN   : ${CONTROLLER1_DOWN()}`);
    console.log(`LEFT   : ${CONTROLLER1_LEFT()}`);
    console.log(`RIGHT  : ${CONTROLLER1_RIGHT()}`);
    console.log(`START  : ${CONTROLLER1_START()}`);
    console.log(`SELECT : ${CONTROLLER1_SELECT()}`);

    console.log(`A      : ${CONTROLLER2_A()}`);
    console.log(`B      : ${CONTROLLER2_B()}`);
    console.log(`UP     : ${CONTROLLER2_UP()}`);
    console.log(`DOWN   : ${CONTROLLER2_DOWN()}`);
    console.log(`LEFT   : ${CONTROLLER2_LEFT()}`);
    console.log(`RIGHT  : ${CONTROLLER2_RIGHT()}`);
    console.log(`START  : ${CONTROLLER2_START()}`);
    console.log(`SELECT : ${CONTROLLER2_SELECT()}`);
}

function fill_vram() {

}
