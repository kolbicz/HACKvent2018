#include <string.h>
#include <stdio.h>

#include <switch.h>

#define SWAP(i, j) (t) = (i); (i) = (j); (j) = (t);
#define LOBYTE(b) ((uint8_t)((b) & 0x0F))
#define HIBYTE(b) ((uint8_t)((b) >> 4))
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define S(a) s[(uint8_t)(a)]
#define N 256

uint8_t a, i, j, k, t, w, z, s[N];

static void update() {
    i += w;
    j = k + S(j + S(i));
    k = i + k + S(j);
    SWAP(S(i), S(j));
}

static void crush() {
    uint8_t v;
    for (v = 0; v < (N / 2); v++) {
        if (S(v) > S(N - 1 - v)) {
            SWAP(S(v), S(N - 1 - v));
        }
    }
}

static void whip() {
    uint32_t v;
    for (v = 0; v < (N * 2); v++) {
        update();
    }
    w += 2;
}

static uint8_t output() {
    z = S(j + S(i + S((z + k))));
    return z;
}

static void shuffle() {
    whip();
    crush();
    whip();
    crush();
    whip();
    a = 0;
}

static uint8_t drip() {
    if (a > 0) {
        shuffle();
    }
    update();
    return output();
}

static void squeeze(uint8_t *r, size_t rs) {
    size_t v;
    if (a > 0) {
        shuffle();
    }
    for (v = 0; v < MIN(rs, N); v++) {
        r[v] = drip();
    }
}

static void absorb_nibble(uint8_t x) {
    if (a == (N / 2)) {
        shuffle();
    }
    SWAP(S(a), S((N / 2) + x));
    a++;
}

static void absorb_stop() {
    if (a == (N / 2)) {
        shuffle();
    }
    a++;    
}

static void absorb_byte(uint8_t b) {
    absorb_nibble(LOBYTE(b));
    absorb_nibble(HIBYTE(b));    
}

static void absorb(const uint8_t *b, size_t bs) {
    size_t v;
    for (v = 0; v < bs; v++) {
        absorb_byte(b[v]);
    }    
}

static void initialize_state() {
    uint32_t v;
    a = i = j = k = z = 0; w = 1;
    for (v = 0; v < N; v++) {
        S(v) = (uint8_t)v;
    }    
}

static void key_setup(const uint8_t *k, size_t ks) {
    initialize_state();
    absorb(k, ks);
}

extern void spritz_encrypt(const uint8_t *k, size_t ks, uint8_t *m, size_t ms) {
    size_t v;
    key_setup(k, ks);
    for (v = 0; v < ms; v++) {
        m[v] += drip();
    }
}

extern void spritz_decrypt(const uint8_t *k, size_t ks, uint8_t *m, size_t ms) {
    size_t v;
    key_setup(k, ks);
    for (v = 0; v < ms; v++) {
        m[v] -= drip();
    }
}

extern void spritz_crypt(const uint8_t *k, size_t ks, uint8_t *m, size_t ms) {
    size_t v;
    key_setup(k, ks);
    for (v = 0; v < ms; v++) {
        m[v] ^= drip();
    }
}

extern void spritz_hash(const uint8_t *m, size_t ms, uint8_t *r, size_t rs) {
    initialize_state();
    absorb(m, ms);
    absorb_stop();
    absorb((uint8_t *)&rs, 1);
    squeeze(r, rs);
}

int main(int argc, char **argv)
{
    //Initialize console. Using NULL as the second argument tells the console library to use the internal console structure as current one.
    consoleInit(NULL);

    //Move the cursor to row 16 and column 20 and then prints "Hello World!"
    //To move the cursor you have to print "\x1b[r;cH", where r and c are respectively
    //the row and column where you want your cursor to move
    
    uint8_t key[] = "shuffle*whip$crush%squeeze";		
		uint8_t flag[] = "\xa8\x91\x99\x7b\x60\xd8\xc6\xdd\x7e\xf4\x33\x4f\x20\xf7\x7f\x4a\x8c\x5c\xff\xb7\x44\x3e\x34\x98\xef\xd9\x3d\x76\x1c\xb2\xd2\x88\xcf\x3f\x97\x23\x43\x55\xd0\xb8\xca\xaa\xcf\xa5\x4f\x0b\xa6\x9d\xe1\x74\x08\x0b\x7a\xcb\x07\x33\x83\x98\xa3\xa4\xd8\xa7\xa2\xa3\xec\x7f\xd9\x35\xbb\xfc\xeb\x39\x2b\x71\x41\xef\xd2\x47\x16\x33\x98\x26\x4a\xbf\x8b\x53\x15\xd3\xf2\xb9\x34\xc2\x27\x88\xa5\xb5\x05\x6c\x47\xdb\xa2\x5b\x5d\xad\x4f\x95\xbf\x84\x73\x20\xa8\x4e\x00\x53\xfe\xff\xb4\x70\x94\x86\xf0\x4f\xbd\x24\xc3\x5f\xcf\x2b\x78\x96\x0f\x91\xc2\x62\xed\xc1\x2e\x44\x80\xc5\x5c\xd4\x55\x82\xf3\x0f\x33\x1c\x91\xa9\x05";
    
    spritz_decrypt(key, strlen((const char *) key), flag, sizeof(flag));
    printf("\x1b[16;10H%s",flag);

    while(appletMainLoop())
    {
        //Scan all the inputs. This should be done once for each frame
        hidScanInput();

        //hidKeysDown returns information about which buttons have been just pressed (and they weren't in the previous frame)
        u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);

        if (kDown & KEY_PLUS) break; // break in order to return to hbmenu

        consoleUpdate(NULL);
    }

    consoleExit(NULL);
    return 0;
}
