
/* machine.js */


// Q4.4 : 
// 1 is 0b00010000
// Q8.8 :
// 1 is 0b0000000100000000

class Q11_4 {
    /**
     * @param {number} number
     */
    constructor( number ) {
        this.update( number );
    }
    /**
     * @param {number} number
     */
    update( number ) {
        while ( number < -2048 ) number += 2048;
        while ( number >= 2048 ) number -= 2048;
        this.value = Math.floor(number * 16);
    }

    /**
     * Q11_4 to signed INT16
     * @return {number} sint16
     */
    toSINT() {
        return this.value >> 4;
    }

    toNumber() { return this.value / 16; }
    toString() { return `${ this.toNumber() }`; }
}


 
/* ======== Methods ======== */

/**
 * @param {Q11_4} a
 * @param {Q11_4} b
 * @return {Q11_4} sum
 */
function Q11_4_add( a, b ) {
    return new Q11_4( a.toNumber() + b.toNumber() );
}

/**
 * @param {Q11_4} a
 * @param {Q11_4} b
 * @return {Q11_4} difference
 */
function Q11_4_sub( a, b ) {
    return new Q11_4( a.toNumber() - b.toNumber() );
}

/**
 * @param {Q11_4} a
 * @param {Q11_4} b
 * @return {Q11_4} product
 */
function Q11_4_mul( a, b ) {
    console.log(`signed ${a} ${b}`);
    let sign = ( a.toNumber() * b.toNumber() < 0);
    a.value = Math.abs(a.value);
    b.value = Math.abs(b.value);
    console.log(`abs    ${a} ${b}`);
    let out = new Q11_4( a.toNumber() * b.toNumber() )
    out.value *= 1 - (2*sign);
    console.log(`out:   ${out}`);
    return out;
}

/**
 * @param {Q11_4} a
 * @param {Q11_4} b
 * @return {Q11_4} quotient
 */
function Q11_4_div( a, b ) {
    return new Q11_4( a.toNumber() / b.toNumber() );
}

/**
 * @param {Q11_4} a
 * @param {Q11_4} b
 * @return {boolean} comparison
 */
function Q11_4_lt( a, b ) {
    return a.toNumber() < b.toNumber();
}


/**
 * @param {Q11_4} a
 * @param {Q11_4} b
 * @return {boolean} comparison
 */
function Q11_4_eq( a, b ) {
    return a.toNumber() == b.toNumber();
}
