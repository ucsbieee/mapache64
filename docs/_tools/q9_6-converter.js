
/* q9_6-converter.js */


// HTML Elements
const Num_In    = document.getElementById("Num-In");
const Bin_In    = document.getElementById("Bin-In");
const Bin_Out   = document.getElementById("Bin-Out");
const Num_Out   = document.getElementById("Num-Out");



// to be called by "Num to Bin" button
function display_bin() {
    let input = new Q9_6( parseFloat( Num_In.value ) );
    Bin_Out.innerHTML = num_to_bin( input );
}

// to be called by "Bin to Num" button
function display_num() {
    let input = Bin_In.value;
    Num_Out.innerHTML = bin_to_num( input );
}



// Helpers

/**
 * @param {Q9_6} num
 * @return {string} bin
 */
function num_to_bin( num ) {
    let out = "";
    for ( let i = 0; i < 16; i++ ) {
        out = (( num.value >>> i ) & 1) + out;
    }
    return out;
}

/**
 * @param {string} bin
 * @return {string} num
 */
function bin_to_num( bin ) {
    if ( bin.length != 16 ) {
        return `[Error]: Gave string of length ${bin.length}.`;
    }
    let out = new Q9_6(0);
    let negative = parseInt(bin.charAt(0));
    out.value = negative*0xffff8000;
    for ( let i = 0; i < 15; i++ ) {
        out.value |= parseInt(bin.charAt(15-i)) << i;
    }
    return out.toString();
}
