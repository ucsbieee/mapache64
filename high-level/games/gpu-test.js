
/* testgame.js */

function updatePPU() {
    for ( let i = 0; i < PMF.length; i++ )
        PMF[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < PMB.length; i++ )
        PMB[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < NTBL.length; i++ )
        NTBL[i] = Math.floor(Math.random() * (1 << 8));
    for ( let i = 0; i < OBM.length; i++ )
        OBM[i] = Math.floor(Math.random() * (1 << 16)) | Math.floor(Math.random() * (1 << 16)) << 16;
}

function testOBM() {
    for ( let i = 0; i < PMB.length; i++ )
        PMB[i] = Math.floor(Math.random() * (1 << 8));

    for ( let i = 0; i < PMF.length; i++ )
        PMF[i] = Math.floor(Math.random() * (1 << 8));
        // PMF[i] = 0xff;

    for ( let i = 0; i < NumObjects; i++ ) {
        OBM_setX( i, i*8 );
        OBM_setY( i, Math.min(i*8,0xff) );
        OBM_setAddr( i, 0 );
        OBM_setColor( i, 0b110 );
    }
}
