
/* vram-dump-viewer.js */


var drawn_file = true;
var read = new FileReader();
const ExpectedFileSize = 0x1000;

const FileInput = document.getElementById("FileInput");
FileInput.addEventListener( "change", handleImageUpload, false );

// Interrupts

function reset() { }
function do_logic() { }

function fill_vram() {
    if ( drawn_file ) return;

    // load image here
    PMF     = new Uint8Array(read.result, 0x000, PMF.length);
    PMB     = new Uint8Array(read.result, 0x200, PMB.length);
    NTBL    = new Uint8Array(read.result, 0x400, NTBL.length);
    OBM     = new Uint8Array(read.result, 0x800, OBM.length);
    TXBL    = new Uint8Array(read.result, 0x900, TXBL.length);

    drawn_file = true;
    console.log("Screen updated.");
}

function handleImageUpload() {
    let file = this.files[0];

    if ( !(file instanceof File) )
        return;

    if ( file.size != ExpectedFileSize ){
        alert("[ERROR]: Bad file size.");
        return;
    }

    read.readAsArrayBuffer( file );
}

read.onloadend = function() {
    drawn_file = false;
    console.log("File read.");
    // console.log( read.result );
}
