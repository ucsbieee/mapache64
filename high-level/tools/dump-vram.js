
/* gpu-showcase.js */


var drawn_file = true;
var read = new FileReader();
const ExpectedFileSize = PMF.length + PMB.length + NTBL.length + OBM.length;

const FileInput = document.getElementById("FileInput");
FileInput.addEventListener( "change", handleImageUpload, false );

// Interrupts

function reset() { }
function do_logic() { }

function fill_vram() {
    if ( drawn_file ) return;

    // load image here
    let offset = 0;
    PMF = new Uint8Array(read.result, offset, PMF.length);
    offset += PMF.length;
    PMB = new Uint8Array(read.result, offset, PMB.length);
    offset += PMB.length;
    NTBL = new Uint8Array(read.result, offset, NTBL.length);
    offset += NTBL.length;
    OBM = new Uint8Array(read.result, offset, OBM.length);

    NTBL_Color0 = ( NTBL[960] >> 0 ) && 0x7;
    NTBL_Color1 = ( NTBL[960] >> 3 ) && 0x7;

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
