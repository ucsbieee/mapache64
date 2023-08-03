
#include <lodepng.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


// The expected pixels
uint8_t gpugold[240][256];
// The difference between the expected and received pixels
uint8_t gpugold_difference[240][256];



// Convert 24-bit RGB color to Mapache64 6-bit color
uint8_t hex24_to_pixel(const uint8_t * const h) {
    uint8_t pixel = 0;
    for (int i = 0; i < 3; i++) { // b, g, r
        if (h[2-i]==0xff) pixel |= 0b11<<(2*i);
        else if (h[2-i]>=0x7f) pixel |= 0b10<<(2*i);
        else if (h[2-i]>=0x3f) pixel |= 0b01<<(2*i);
    }
    return pixel;
}



// Convert Mapache64 8-bit color to 32-bit RGBA color
void pixel_to_hex32(const uint8_t pixel, uint8_t * const h) {
    // alpha
    if ((pixel>>6)==0b11)
        h[3] = 0xff;
    else
        h[3] = 0x00;
    // b, g, r
    for (int i = 0; i < 3; i++) {
        uint8_t color = (pixel>>(2*i))&0b11;
        if (color==0b11) h[2-i] = 0xff;
        else if (color==0b10) h[2-i] = 0x7f;
        else if (color==0b01) h[2-i] = 0x3f;
        else h[2-i] = 0x00;
    }
}



// DPI Functions
extern "C" {



// Generate a gold model from a PNG
int gpugold_load_png(const char * const filename) {

    int lodepng_error;
    uint8_t * image;
    unsigned int width, height;

    lodepng_error = lodepng_decode24_file(&image, &width, &height, filename);

    if (lodepng_error) {
        printf("Error %u: %s\n", lodepng_error, lodepng_error_text(lodepng_error));
        free(image);
        return 1;
    } else if (width!=256 || height!=240) {
        printf("Error: Incorrect resolution\n");
        free(image);
        return 1;
    }

    // initialize arrays
    int i = 0;
    for (int y = 0; y < 240; y++) {
        for (int x = 0; x < 256; x++) {
            gpugold[y][x] = hex24_to_pixel(image + i);
            gpugold_difference[y][x] = 0;
            i += 3;
        }
    }

    free(image);
    return 0;
}



// Generate a gold model from a VRAM dump
int gpugold_load_vram(const char * const filename) {
    printf("Error: Loading from VRAM is not yet supported.\n");
    return 1;
}



// Return the pixel value from the currently loaded image
uint8_t gpugold_pixel(const uint8_t x, const uint8_t y) {
    if (y>=240) return 0;
    return gpugold[y][x];
}



// Add pixel to difference array
void gpugold_add_difference(const uint8_t x, const uint8_t y, const uint8_t pixel) {
    const uint8_t valid = 0xc0;
    if (y>=240) return;
    gpugold_difference[y][x] = pixel | valid;
}



// Save difference array to PNG file
int gpugold_save_difference(const char * const filename) {
    uint8_t image[240 * 256 * 4];
    int i = 0;
    int num_differences = 0;
    for (int y = 0; y < 240; y++) {
        for (int x = 0; x < 256; x++) {
            pixel_to_hex32(gpugold_difference[y][x], image + i);
            if (image[i+3]==0xff) {
                // printf("Saved (%d,%d) %02x%02x%02x\n", x, y, image[i], image[i+1], image[i+2]);
                num_differences++;
            }
            i += 4;
        }
    }
    if (num_differences)
        lodepng_encode32_file(filename, image, 256, 240);
    return num_differences;
}


}
