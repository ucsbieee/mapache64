
/* gpu-showcase.js */


var handled = true;
var read = new FileReader();
const ExpectedFileSize = PMF.length + PMB.length + NTBL.length + OBM.length * 4;

const FileInput = document.getElementById("FileInput");
FileInput.addEventListener( "change", handleImageUpload, false );

function reset() { }
function do_logic() { }

function fill_vram() {
    if ( handled ) return;

    // load image here
    let offset = 0;
    PMF = new Uint8Array(read.result, offset, PMF.length);
    offset += PMF.length;
    PMB = new Uint8Array(read.result, offset, PMB.length);
    offset += PMB.length;
    NTBL = new Uint8Array(read.result, offset, NTBL.length);
    offset += NTBL.length;
    OBM = new Uint32Array(read.result, offset, OBM.length);

    NTBL_Color0 = ( NTBL[960] >> 0 ) && 0x7;
    NTBL_Color1 = ( NTBL[960] >> 3 ) && 0x7;

    handled = true;
}

function handleImageUpload() {
    let file = this.files[0];

    // console.log( file.size );

    if ( file.size !=ExpectedFileSize ){
        alert("error: bad file size");
    }
    else {
        read.readAsArrayBuffer( file );
    }
}

read.onloadend = function() {
    handled = false;
    console.log("file read")
    // console.log( read.result );
}