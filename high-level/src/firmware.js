
/* machine.js */


// Q4.4 : 
// 1 is 0b00010000
// Q8.8 :
// 1 is 0b0000000100000000

class UQ4_4 {
    /**
     * @param {number} number
     */
    constructor( number ) {
        while ( number < 0 ) number += 16;
        while ( number >= 16 ) number -= 16;
        this.value = Math.floor(number * 16);
    }

    /**
     * Q4_4 to unsigned INT8
     * @return {number} uint8
     */
    toUINT() {
        return this.value >>> 4;
    }

    toNumber() { return this.value / 16; }
    toString() { return `${ this.toNumber() }`; }
}

class SQ4_4 {
    /**
     * @param {number} number
     */
    constructor( number ) {
        while ( number < -8 ) number += 16;
        while ( number >= 8 ) number -= 16;
        this.value = Math.floor(number * 16);
    }

    /**
     * Q4_4 to signed INT8
     * @return {number} sint8
     */
    toSINT() {
        return this.value >> 4;
    }

    toNumber() { return this.value / 16; }
    toString() { return `${ this.toNumber() }`; }
}

class UQ8_8 {
    /**
     * @param {number} number
     */
    constructor( number ) {
        while ( number < 0 ) number += 256;
        while ( number >= 256 ) number -= 256;
        this.value = Math.floor(number * 256);
    }

    /**
     * Q8_8 to unsigned INT8
     * @return {INT8} uint8
     */
    toUINT() {
        return this.value >>> 8;
    }

    toNumber() { return this.value / 256; }
    toString() { return `${ this.toNumber() }`; }
}

class SQ8_8 {
    /**
     * @param {number} number
     */
    constructor( number ) {
        while ( number < -128 ) number += 256;
        while ( number >= 127 ) number -= 256;
        this.value = Math.floor(number * 256);
    }

    /**
     * Q8_8 to signed INT8
     * @return {INT8} sint8
     */
    toSINT() {
        return this.value >> 8;
    }

    toNumber() { return this.value / 256; }
    toString() { return `${ this.toNumber() }`; }
}



 
/* ======== Methods ======== */

/**
 * @param {UQ4_4} a
 * @param {UQ4_4} b
 * @return {UQ4_4} sum
 */
function UQ4_4_add( a, b ) {
    return new Q4_4( a.toNumber() + b.toNumber() );
}

/**
 * @param {UQ4_4} a
 * @param {UQ4_4} b
 * @return {UQ4_4} difference
 */
function UQ4_4_sub( a, b ) {
    return new Q4_4( a.toNumber() - b.toNumber() );
}

/**
 * @param {UQ4_4} a
 * @param {UQ4_4} b
 * @return {UQ8_8} product
 */
function UQ4_4_mul( a, b ) {
    return new Q8_8( a.toNumber() * b.toNumber() );
}

/**
 * @param {UQ4_4} a
 * @param {UQ4_4} b
 * @return {UQ4_4} quotient
 */
function UQ4_4_div( a, b ) {
    return new Q4_4( a.toNumber() / b.toNumber() );
}

/**
 * @param {UQ4_4} a
 * @param {UQ4_4} b
 * @return {boolean} comparison
 */
function UQ4_4_lt( a, b ) {
    return a.toNumber < b.toNumber;
}


/**
 * @param {UQ4_4} a
 * @param {UQ4_4} b
 * @return {boolean} comparison
 */
function UQ4_4_eq( a, b ) {
    return a.toNumber == b.toNumber;
}

/**
 * @param {SQ4_4} a
 * @param {SQ4_4} b
 * @return {SQ4_4} sum
 */
function SQ4_4_add( a, b ) {
    return new Q4_4( a.toNumber() + b.toNumber() );
}

/**
 * @param {SQ4_4} a
 * @param {SQ4_4} b
 * @return {SQ4_4} difference
 */
function SQ4_4_sub( a, b ) {
    return new Q4_4( a.toNumber() - b.toNumber() );
}

/**
 * @param {SQ4_4} a
 * @param {SQ4_4} b
 * @return {UQ8_8} product
 */
function SQ4_4_mul( a, b ) {
    return new Q4_4( a.toNumber() * b.toNumber() );
}

/**
 * @param {SQ4_4} a
 * @param {SQ4_4} b
 * @return {SQ4_4} quotient
 */
function SQ4_4_div( a, b ) {
    return new Q4_4( a.toNumber() / b.toNumber() );
}

/**
 * @param {SQ4_4} a
 * @param {SQ4_4} b
 * @return {boolean} comparison
 */
function SQ4_4_lt( a, b ) {
    return a.toNumber < b.toNumber;
}


/**
 * @param {SQ4_4} a
 * @param {SQ4_4} b
 * @return {boolean} comparison
 */
function SQ4_4_eq( a, b ) {
    return a.toNumber == b.toNumber;
}

/**
 * @param {UQ8_8} a
 * @param {UQ8_8} b
 * @return {UQ8_8} sum
 */
 function UQ8_8_add( a, b ) {
    return new Q8_8( a.toNumber() + b.toNumber() );
}

/**
 * @param {UQ8_8} a
 * @param {UQ8_8} b
 * @return {UQ8_8} difference
 */
function UQ8_8_sub( a, b ) {
    return new Q8_8( a.toNumber() - b.toNumber() );
}

/**
 * @param {UQ8_8} a
 * @param {UQ8_8} b
 * @return {UQ8_8} product
 */
function UQ8_8_mul( a, b ) {
    return new Q8_8( a.toNumber() * b.toNumber() );
}

/**
 * @param {UQ8_8} a
 * @param {UQ8_8} b
 * @return {UQ8_8} quotient
 */
function UQ8_8_div( a, b ) {
    return new Q8_8( a.toNumber() / b.toNumber() );
}

/**
 * @param {UQ8_8} a
 * @param {UQ8_8} b
 * @return {boolean} comparison
 */
function UQ8_8_lt( a, b ) {
    return a.toNumber < b.toNumber;
}


/**
 * @param {UQ8_8} a
 * @param {UQ8_8} b
 * @return {boolean} comparison
 */
function UQ8_8_eq( a, b ) {
    return a.toNumber == b.toNumber;
}

/**
 * @param {SQ8_8} a
 * @param {SQ8_8} b
 * @return {SQ8_8} sum
 */
function SQ8_8_add( a, b ) {
    return new Q8_8( a.toNumber() + b.toNumber() );
}

/**
 * @param {SQ8_8} a
 * @param {SQ8_8} b
 * @return {SQ8_8} difference
 */
function SQ8_8_sub( a, b ) {
    return new Q8_8( a.toNumber() - b.toNumber() );
}

/**
 * @param {SQ8_8} a
 * @param {SQ8_8} b
 * @return {UQ8_8} product
 */
function SQ8_8_mul( a, b ) {
    return new Q8_8( a.toNumber() * b.toNumber() );
}

/**
 * @param {SQ8_8} a
 * @param {SQ8_8} b
 * @return {SQ8_8} quotient
 */
function SQ8_8_div( a, b ) {
    return new Q8_8( a.toNumber() - b.toNumber() );
}

/**
 * @param {SQ8_8} a
 * @param {SQ8_8} b
 * @return {boolean} comparison
 */
function SQ8_8_lt( a, b ) {
    return a.toNumber < b.toNumber;
}

/**
 * @param {SQ8_8} a
 * @param {SQ8_8} b
 * @return {boolean} comparison
 */
function SQ8_8_eq( a, b ) {
    return a.toNumber == b.toNumber;
}
