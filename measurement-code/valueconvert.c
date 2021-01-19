// averaging past 32k samples
// by fetching every 8k samples
// for processing `csdr fmdemod_atan_cf` output
// usage:
//    cc -O3 -o valueconvert valueconvert.c

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <math.h>

#define SAMPLES (8000)

int main(int argc, char* argv[]) {

  union {
    unsigned char byte[4];
    float f;
  } v;
  size_t n;
  double d, ds[4], av;
  float s[SAMPLES];
  unsigned int p, q;
  uint64_t count;

  // Initialize float/double work area

  for (q = 0; q < SAMPLES; q++) {
    s[q] = 0.0;
  }

  for (q = 0; q < 4; q++) {
    ds[q] = 0.0;
  }

  p = 0;
  count = 0;

  while ((n = fread(&s, sizeof(float), SAMPLES, stdin)) > 0) {

      d = 0.0;
      for (size_t i = 0; i < n; i++) {
	  d += (double)s[i];
      }

      ds[p] = d / (double)n;
      p++;
      if (p > 3) {
	 p = 0;
      }

      av = (ds[0] + ds[1] + ds[2] + ds[3]) / 4.0;

      // Why this multiplication factor is 4000 = fs/2 [Hz]?
      // That's explained at the end of this source code
      fprintf(stdout, "%" PRIu64 "%10.3f\n", count, (av * 4000.0));

      count++;

  }
  exit(0);
}  

/*

Here's the shell/csdr script to explain why the multiplication factor
for csdr fmdemod_atan_cf is fs/2 (4000 Hz).

sox -t wav dec202012041552.wav -t raw --rate 8000 --bits 32 --channels 1 \
  --encoding floating-point --endian little - | \
csdr shift_addition_fc -0.125 | \
  csdr bandpass_fir_fft_cc -0.001 +0.001 0.0002 | \
  csdr shift_addition_cc +0.125 | \
  csdr fmdemod_atan_cf | csdr floatdump_f | \
  awk 'BEGIN{RS=" ";}{print $0 * 4000.0;}' | \
  less

See also fmdemod_atan_cf() in
https://github.com/ha7ilm/csdr/blob/master/libcsdr.c
The function fmdemod_atan_cf() outputs the phase difference
divided by PI, which stands for Fs/2, since Fs stands for 2*PI.

*/
