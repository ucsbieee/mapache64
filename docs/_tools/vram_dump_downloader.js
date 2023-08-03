
/* vram_dump_downloader.js */

var DumpVramButton = document.getElementById("Dump-VRAM-Button");
DumpVramButton.addEventListener("click", ()=>{downloadVramDump()} );

function downloadVramDump() {

    // Concat the VRAM into 1 array
    let VRAM = new Uint8Array(0x1000);
    VRAM.set(PMF, 0x000);
    VRAM.set(PMB, 0x200);
    VRAM.set(NTBL, 0x400);
    VRAM.set(OBM, 0x800);
    VRAM.set(TXBL, 0x900);

    const blob = new Blob([VRAM.buffer], { type: 'application/octet-stream' });
    const url = URL.createObjectURL(blob);

    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = 'vram.bin';
    anchor.style.display = 'none';

    document.body.appendChild(anchor);
    anchor.click();

    document.body.removeChild(anchor);
    URL.revokeObjectURL(url);
}
