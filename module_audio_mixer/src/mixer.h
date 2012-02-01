
#include "mixerparams.h"

#define MIXER_MAX_VOL            0x20000000

/* Supported mixer commands */
#define MIXER_CMD_MIX_MULT       10
#define MIXER_CMD_KILL           11

/* Mixer thread */
int Mixer(chanend c_in, chanend c_out, chanend c_ctrl);

/* Update a mixer node's weight */
void Mixer_UpdateWeight(chanend c_ctrl, unsigned mix, unsigned channel, unsigned weight);


