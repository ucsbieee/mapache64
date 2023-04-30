
/* player.js */

var animationFrameRequest   = NaN;
var  timer_now, timer_then = Date.now(), timer_delta;
const timer_interval = 1000/FPS;

function _reset() {
    frame = -1;
    reset();
    _next_frame();
}

function _next_frame() {

    // FPS Control
    animationFrameRequest = requestAnimationFrame( _next_frame );
    timer_now = Date.now();
    timer_delta = timer_now - timer_then;
    if ( timer_delta < timer_interval )
        return;
    timer_then = timer_now - ( timer_delta % timer_interval );

    frame++;

    // recieve controller inputs
    CONTROLLER1_Q = CONTROLLER1_D;
    CONTROLLER2_Q = CONTROLLER2_D;

    /* Run CPU */
    disableInterrupts = true;
    drawScreen();
    do_logic();
    disableInterrupts = false;

    fill_vram();

    // if ( frame % FPS == 0 )
    //     console.log(`Second: ${frame/FPS}`);

}


_reset();
