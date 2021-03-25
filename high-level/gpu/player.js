
/* player.js */

var animationFrameRequest   = NaN;
var  timer_now, timer_then = Date.now(), timer_delta;
var frame = 0;
const FPS = 60;
const timer_interval = 1000/FPS;

// testOBM();
advanceFrame();
function advanceFrame() {

    // FPS Control
    animationFrameRequest = requestAnimationFrame( advanceFrame );
    timer_now = Date.now();
    timer_delta = timer_now - timer_then;
    if ( timer_delta < timer_interval )
        return;
    timer_then = timer_now - ( timer_delta % timer_interval );

    /* Run CPU */
    updatePPU();

    /* Draw */
    drawScreen();

    console.log(`Second: ${frame/FPS}`);

    frame++;

    debugger;
}
