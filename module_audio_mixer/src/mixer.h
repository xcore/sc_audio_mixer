
#include "params.h"

#define MIXER_MAX_VOL            0x20000000

/* Supported mixer commands */
#define MIXER_CMD_MIX_MULT       10
#define MIXER_CMD_KILL           11

/* Mixer thread */
int mixer(chanend c_in, chanend c_out, chanend c_ctrl);
