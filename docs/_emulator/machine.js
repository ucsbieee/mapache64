
/* machine.js */
/* Need to be imported with keyword "defer" */

// Get Game element
const Game = document.getElementById( "Game" );
if ( Game == null ) {
    alert( "\"#Game\" element not recognized." );
    throw new Error();
}

// Set Game styling
Game.style.textAlign= "center";
const GameWidth     = 256;
const GameHeight    = 240;
const CanvasScalar  = 3;
const CanvasWidth   = GameWidth * CanvasScalar;
const CanvasHeight  = GameHeight * CanvasScalar;

// Add Canvas to Game
var Canvas;
Canvas = document.createElement( "canvas" );

Canvas.setAttribute( "width", CanvasWidth );
Canvas.setAttribute( "height", CanvasHeight );
Canvas.setAttribute( "id", "Game__Canvas" );
Game.appendChild( Canvas );
const ctx = Canvas.getContext("2d", { alpha: false });
ctx.imageSmoothingEnabled = false;



/* ====== Full Screen ====== */

// if in inGameView, add box shadow and disable scroll. otherwise reset.
var inGameView = false;
function toggleGameView() {
    if (inGameView === false) {
        Canvas.style.boxShadow = "0 0 0 100vmax black";
        Game.style.top = "50%"; Game.style.left = "50%";
        Game.style.transform = "translate(-50%,-50%)";
        Game.style.position = "fixed";
        inGameView = true;
    }
    else {
        Canvas.style.boxShadow = "";
        Game.style.position =  "";
        Game.style.top = ""; Game.style.left = "";
        Game.style.transform = "";
        inGameView = false;

    }
}


/* ====== Game Data ====== */

var frame = 0;
const FPS = 60;



/* ====== Flags ====== */

var disableInterrupts = false;



/* ====== VRAM ====== */

// Pattern Memory Foreground
const NumSprites         = 32;
const BytesPerSprite     = 16;
var PMF                  = new Uint8Array( NumSprites * BytesPerSprite );

// Pattern Memory Background
const NumTiles          = 32;
const BytesPerTile      = 16;
var PMB                 = new Uint8Array( NumTiles * BytesPerTile );

// Nametable
const NTBL_Size         = 1024;
var NTBL                = new Uint8Array( NTBL_Size );

// Object Memory
const NumObjects        = 64;
const BytesPerObject    = 4;
var OBM                 = new Uint8Array( NumObjects * BytesPerObject );

// Text Table
const TXBL_Size         = NTBL_Size;
var TXBL                = new Uint8Array( NTBL_Size );

// Pattern Memory Character
const BytesPerCharacter = 8;

// Nametable Methods
const NTBL_CRToIndex = (c,r) => ((r&0b11111)<<5) | ((c&0b11111));
const NTBL_getColor = (index) => NTBL[index] >>> 7;
const NTBL_getHFlip = (index) => (NTBL[index] >>> 6) & 0b1;
const NTBL_getVFlip = (index) => (NTBL[index] >>> 5) & 0b1;
const NTBL_getAddr  = (index) => NTBL[index] & 0b11111;
function NTBL_setColor(index,Color) { NTBL[index] &= ~0b10000000; NTBL[index] |= (Color & 0b1) << 7; }
function NTBL_setHFlip(index,HFlip) { NTBL[index] &= ~0b01000000; NTBL[index] |= (HFlip & 0b1) << 6; }
function NTBL_setVFlip(index,VFlip) { NTBL[index] &= ~0b01000000; NTBL[index] |= (VFlip & 0b1) << 5; }
function NTBL_setAddr(index,Addr) { NTBL[index] &= ~0b00011111; NTBL[index] |= (Addr & 0x1f); }
const NTBL_getPalette0 = () => NTBL[960] & 0x7;
const NTBL_getPalette1 = () => (NTBL[960] >>> 3) & 0x7;
function NTBL_setPalette0(Palette) { NTBL[960] &= ~0x7; NTBL[960] |= (Palette & 0x7); }
function NTBL_setPalette1(Palette) { NTBL[960] &= ~0x38; NTBL[960] |= (Palette & 0x7) << 3; }

// Object Memory Methods
const OBM_getX = (index) => (OBM[4*index]);
const OBM_getY = (index) => (OBM[4*index+1]);
const OBM_getHFlip = (index) => (OBM[4*index+2] >>> 6) & 0b1;
const OBM_getVFlip = (index) => (OBM[4*index+2] >>> 5) & 0b1;
const OBM_getAddr = (index) => (OBM[4*index+2]) & 0x1f;
const OBM_getColor = (index) => (OBM[4*index+3]) & 0x7;
const OBM_getScanline = (index, scanline) => {
    let line_address = OBM_getAddr(index) << 4;
    line_address += 2*( OBM_getVFlip(index) ? (7-scanline) : scanline );
    let out = (PMF[ line_address ] << 8) | (PMF[ line_address + 1 ]);
    return OBM_getHFlip(index) ? flip(out) : out;
};
function OBM_setX(index,X) { OBM[4*index] = (X & 0xff); }
function OBM_setY(index,Y) { OBM[4*index+1] = (Y & 0xff); }
function OBM_setHFlip(index,HFlip) { OBM[4*index+2] &= ~0x80; OBM[4*index+2] |= (HFlip & 0b1) << 7; }
function OBM_setVFlip(index,VFlip) { OBM[4*index+2] &= ~0x40; OBM[4*index+2] |= (VFlip & 0b1) << 6; }
function OBM_setAddr(index,Addr) { OBM[4*index+2] &= ~0x1f; OBM[4*index+2] |= (Addr & 0x1f); }
function OBM_setColor(index,Color) { OBM[4*index+3] &= ~0x07; OBM[4*index+3] |= (Color & 0x7); }

// Text Table Methods
const TXBL_CRToIndex = (c,r) => NTBL_CRToIndex(c,r);
const TXBL_getColor = (index) => TXBL[index] >>> 7;
const TXBL_getAddr = (index) => TXBL[index] & 0x7f;
function TXBL_setColor(index,Color) { TXBL[index] &= ~0b10000000; TXBL[index] |= (Color & 0b1) << 7; }
function TXBL_setAddr(index,Addr) { TXBL[index] &= ~0x7f; TXBL[index] |= (Addr & 0x7f); }

// For Debug Only
function VRAM_RESET() {
    for ( let i = 0; i < PMF.length; i++ )
        PMF[i] = 0;
    for ( let i = 0; i < PMB.length; i++ )
        PMB[i] = 0;
    for ( let i = 0; i < NTBL.length; i++ )
        NTBL[i] = 0;
    for ( let i = 0; i < OBM.length; i++ ) {
        OBM[i] = 0;
        OBM_setY( i, 0xff );
    }
    for ( let i = 0; i < TXBL.length; i++ )
        TXBL[i] = 0;
}



/* ============= GPU ============= */

var PixelBuffer = new Uint8ClampedArray( 4 * GameWidth * GameHeight );


// 24 bits - rgb
function drawScreen() {
    drawBackground();
    drawForeground();
    drawText();
    const screenImage = new ImageData( PixelBuffer, GameWidth, GameHeight );
    createImageBitmap(screenImage).then(function(screenBitmap) {
        ctx.drawImage( screenBitmap, 0, 0, CanvasWidth, CanvasHeight );
    });
}

function drawBackground() {
    let current_tile_data;
    let current_tile_color;
    for ( let y = 0; y < GameHeight; y++ ) {
        for ( let x = 0; x < GameWidth; x++ ) {
            if ( x % 8 == 0 ) { // if at new tile
                current_tile_data = get_tile_data(x,y);
                current_tile_color = get_tile_color(x,y);
            }
            let pattern_pixel = (current_tile_data >>> (14-2*(x%8))) & 0b11;
            let buffer_pixel =
                (pattern_pixel == 0b11) ? 0xff :
                (pattern_pixel == 0b10) ? 0x7f :
                (pattern_pixel == 0b01) ? 0x3f :
                0x00;
            const draw_r = (current_tile_color>>>2) & 1;
            const draw_g = (current_tile_color>>>1) & 1;
            const draw_b = (current_tile_color>>>0) & 1;
            const pixelLocation = 4*(GameWidth*y + x);
            PixelBuffer[ pixelLocation + 0 ] = draw_r ? buffer_pixel : 0x00;
            PixelBuffer[ pixelLocation + 1 ] = draw_g ? buffer_pixel : 0x00;
            PixelBuffer[ pixelLocation + 2 ] = draw_b ? buffer_pixel : 0x00;
            PixelBuffer[ pixelLocation + 3 ] = 0xff;
        }
    }
}

function drawForeground() {
    for ( let i = 0; i < NumObjects; i++ )
        if ( OBM_getY(i) < GameHeight )
            drawObject( i );
}

function drawObject( obma ) {
    let object_x = OBM_getX(obma);
    let object_y = OBM_getY(obma);
    let end_x = Math.min( object_x+8, GameWidth );
    let end_y = Math.min( object_y+8, GameHeight );
    const draw_r = (OBM_getColor(obma)>>>2) & 1;
    const draw_g = (OBM_getColor(obma)>>>1) & 1;
    const draw_b = (OBM_getColor(obma)>>>0) & 1;
    for ( let pattern_y = 0; pattern_y < (end_y-object_y); pattern_y++ ) {
        let address = (OBM_getAddr(obma) << 4) + 2*( OBM_getVFlip(obma) ? (7-pattern_y) : pattern_y); // obma to PMF address
        let data = (PMF[ address ] << 8) | (PMF[ address + 1 ]); // load scanline
        data = OBM_getHFlip(obma) ? flip(data) : data; // flip scanline if needed
        for ( let pattern_x = 0; pattern_x < (end_x-object_x); pattern_x++ ) { // draw each pixel in scanline
            let pattern_pixel = (data >>> (14-2*pattern_x)) & 0b11;
            if ( pattern_pixel == 0b00 ) continue;
            let buffer_pixel =
                (pattern_pixel == 0b11) ? 0xff :
                (pattern_pixel == 0b10) ? 0x7f :
                0x3f;
            const pixelLocation = 4*(GameWidth*(pattern_y+object_y) + pattern_x+object_x);

            PixelBuffer[ pixelLocation + 0 ] = draw_r ? buffer_pixel : 0x00;
            PixelBuffer[ pixelLocation + 1 ] = draw_g ? buffer_pixel : 0x00;
            PixelBuffer[ pixelLocation + 2 ] = draw_b ? buffer_pixel : 0x00;
        }
    }
}

function get_tile_data( x, y ) {
    let index = ((y&0b11111000)<<2) | ((x&0b11111000)>>>3);
    x &= 0b111;
    y &= 0b111;
    let address = NTBL_getAddr(index) << 4;
    address += 2*( NTBL_getVFlip(index) ? (7-y) : y );
    let data = (PMB[ address ] << 8) | (PMB[ address + 1 ]);
    return NTBL_getHFlip(index) ? flip(data) : data;
}

function get_tile_color( x, y ) {
    let index = ((y&0b11111000)<<2) | ((x&0b11111000)>>>3);
    return NTBL_getColor(index) ? NTBL_getPalette1() : NTBL_getPalette0();
}

function flip( pattern_scanline ) {
    let out = 0;
    for ( let i = 0; i < 8; i++ ) {
        out |= (pattern_scanline&0b11) << (14-2*i);
        pattern_scanline >>>= 2;
    }
    return out;
}

function drawText() {
    for ( let y = 0; y < GameWidth; y++ ) {
        for ( let x = 0; x < GameWidth; x++ ) {
            let c = x/8;
            let r = y/8;
            let txbl_index = TXBL_CRToIndex(c,r);
            let pmca = TXBL_getAddr(txbl_index);
            let pmc_index = pmca * BytesPerCharacter + (y%8);
            let valid = (PMC[pmc_index] >>> (7-(x%8)))&1;
            if (valid) {
                const pixelLocation = 4*(GameWidth*y + x);
                PixelBuffer[ pixelLocation + 0 ] = TXBL_getColor(txbl_index) ? 0xff : 0x00;
                PixelBuffer[ pixelLocation + 1 ] = TXBL_getColor(txbl_index) ? 0xff : 0x00;
                PixelBuffer[ pixelLocation + 2 ] = TXBL_getColor(txbl_index) ? 0xff : 0x00;
            }
        }
    }
}

/* ====== Controller ====== */

var twoControllers = false;

function setNumControllers( num ) {
    twoControllers = ( num === 2 );
    if ( num !== 1 && num !== 2 )
        console.error("Bad controller number!");
}


// Controller 2 will use WASD, Q, E, N, M as opposed to Up Down Left Right, A Button, B Button, Enter, Shift
var CONTROLLER1_D = 0;
var CONTROLLER1_Q = 0;
var CONTROLLER2_D = 0;
var CONTROLLER2_Q = 0;
const CONTROLLER1_A      = () => (CONTROLLER1_Q & 0b00000001) >>> 0;
const CONTROLLER1_B      = () => (CONTROLLER1_Q & 0b00000010) >>> 1;
const CONTROLLER1_UP     = () => (CONTROLLER1_Q & 0b00000100) >>> 2;
const CONTROLLER1_DOWN   = () => (CONTROLLER1_Q & 0b00001000) >>> 3;
const CONTROLLER1_LEFT   = () => (CONTROLLER1_Q & 0b00010000) >>> 4;
const CONTROLLER1_RIGHT  = () => (CONTROLLER1_Q & 0b00100000) >>> 5;
const CONTROLLER1_START  = () => (CONTROLLER1_Q & 0b01000000) >>> 6;
const CONTROLLER1_SELECT = () => (CONTROLLER1_Q & 0b10000000) >>> 7;

const CONTROLLER2_A      = () => (CONTROLLER2_Q & 0b00000001) >>> 0;
const CONTROLLER2_B      = () => (CONTROLLER2_Q & 0b00000010) >>> 1;
const CONTROLLER2_UP     = () => (CONTROLLER2_Q & 0b00000100) >>> 2;
const CONTROLLER2_DOWN   = () => (CONTROLLER2_Q & 0b00001000) >>> 3;
const CONTROLLER2_LEFT   = () => (CONTROLLER2_Q & 0b00010000) >>> 4;
const CONTROLLER2_RIGHT  = () => (CONTROLLER2_Q & 0b00100000) >>> 5;
const CONTROLLER2_START  = () => (CONTROLLER2_Q & 0b01000000) >>> 6;
const CONTROLLER2_SELECT = () => (CONTROLLER2_Q & 0b10000000) >>> 7;

document.addEventListener('keyup', handle_keyup);
document.addEventListener('keydown', handle_keydown);
// document.classList.add("stop_scrolling");

// extra switch case + if statement for multiple controllers
function handle_keyup(e) {
    if (!twoControllers) {
        switch ( e.code ) {
            case "KeyZ"       : CONTROLLER1_D &= ~0b00000001; break;
            case "KeyX"       : CONTROLLER1_D &= ~0b00000010; break;
            case "ArrowUp"    : CONTROLLER1_D &= ~0b00000100; break;
            case "ArrowDown"  : CONTROLLER1_D &= ~0b00001000; break;
            case "ArrowLeft"  : CONTROLLER1_D &= ~0b00010000; break;
            case "ArrowRight" : CONTROLLER1_D &= ~0b00100000; break;
            case "Enter"      : CONTROLLER1_D &= ~0b01000000; break;
            case "ShiftRight" : CONTROLLER1_D &= ~0b10000000; break;
            case "Space"      : toggleGameView();             break;
            default: break;
        }
    }
    else {
        switch ( e.code ) {
            case "KeyN"       : CONTROLLER1_D &= ~0b00000001; break;
            case "KeyM"       : CONTROLLER1_D &= ~0b00000010; break;
            case "ArrowUp"    : CONTROLLER1_D &= ~0b00000100; break;
            case "ArrowDown"  : CONTROLLER1_D &= ~0b00001000; break;
            case "ArrowLeft"  : CONTROLLER1_D &= ~0b00010000; break;
            case "ArrowRight" : CONTROLLER1_D &= ~0b00100000; break;
            case "Enter"      : CONTROLLER1_D &= ~0b01000000; break;
            case "ShiftRight" : CONTROLLER1_D &= ~0b10000000; break;

            case "KeyQ"       : CONTROLLER2_D &= ~0b00000001; break;
            case "KeyE"       : CONTROLLER2_D &= ~0b00000010; break;
            case "KeyW"       : CONTROLLER2_D &= ~0b00000100; break;
            case "KeyS"       : CONTROLLER2_D &= ~0b00001000; break;
            case "KeyA"       : CONTROLLER2_D &= ~0b00010000; break;
            case "KeyD"       : CONTROLLER2_D &= ~0b00100000; break;
            case "KeyZ"       : CONTROLLER2_D &= ~0b01000000; break;
            case "KeyX"       : CONTROLLER2_D &= ~0b10000000; break;
            case "Space"      : toggleGameView();             break;
            default: break;
        }

    }
}

function handle_keydown(e) {
    if (!twoControllers) {
        switch ( e.code ) {
            case "KeyZ"       : CONTROLLER1_D |= 0b00000001; break;
            case "KeyX"       : CONTROLLER1_D |= 0b00000010; break;
            case "ArrowUp"    : CONTROLLER1_D |= 0b00000100; break;
            case "ArrowDown"  : CONTROLLER1_D |= 0b00001000; break;
            case "ArrowLeft"  : CONTROLLER1_D |= 0b00010000; break;
            case "ArrowRight" : CONTROLLER1_D |= 0b00100000; break;
            case "Enter"      : CONTROLLER1_D |= 0b01000000; break;
            case "ShiftRight" : CONTROLLER1_D |= 0b10000000; break;
            default: break;
        }
    }
    else {
        switch ( e.code ) {
            case "KeyN"       : CONTROLLER1_D |= 0b00000001; break;
            case "KeyM"       : CONTROLLER1_D |= 0b00000010; break;
            case "ArrowUp"    : CONTROLLER1_D |= 0b00000100; break;
            case "ArrowDown"  : CONTROLLER1_D |= 0b00001000; break;
            case "ArrowLeft"  : CONTROLLER1_D |= 0b00010000; break;
            case "ArrowRight" : CONTROLLER1_D |= 0b00100000; break;
            case "Enter"      : CONTROLLER1_D |= 0b01000000; break;
            case "ShiftRight" : CONTROLLER1_D |= 0b10000000; break;

            case "KeyQ"       : CONTROLLER2_D |= 0b00000001; break;
            case "KeyE"       : CONTROLLER2_D |= 0b00000010; break;
            case "KeyW"       : CONTROLLER2_D |= 0b00000100; break;
            case "KeyS"       : CONTROLLER2_D |= 0b00001000; break;
            case "KeyA"       : CONTROLLER2_D |= 0b00010000; break;
            case "KeyD"       : CONTROLLER2_D |= 0b00100000; break;
            case "KeyZ"       : CONTROLLER2_D |= 0b01000000; break;
            case "KeyX"       : CONTROLLER2_D |= 0b10000000; break;
            default: break;
        }
    }
}
