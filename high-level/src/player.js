
/* player.js */

var animationFrameRequest   = NaN;
var  timer_now, timer_then = Date.now(), timer_delta;
const timer_interval = 1000/FPS;


advanceFrame();
function advanceFrame() {

    // FPS Control
    animationFrameRequest = requestAnimationFrame( advanceFrame );
    timer_now = Date.now();
    timer_delta = timer_now - timer_then;
    if ( timer_delta < timer_interval )
        return;
    timer_then = timer_now - ( timer_delta % timer_interval );

    // recieve controller inputs
    CONTROLLER_Q = CONTROLLER_D;

    /* Run CPU */
    drawingPPU = true;
    updatePPU();
    drawingPPU = false;

    /* Draw */
    updatingPPU = true;
    drawScreen();
    updatingPPU = false;

    // console.log(`Second: ${frame/FPS}`);

    frame++;

    // debugger;
}
