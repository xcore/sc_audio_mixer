
#include <xs1.h>
#include <print.h>

#include "mixer.h"

#pragma xta command "add exclusion exit_"
#pragma xta command "analyse path sample_input sample_output"
#pragma xta command "set required - 5200 ns" /* 192kHz */

void Mixer_UpdateWeight(chanend c_ctrl, unsigned mix, unsigned channel, unsigned weight)
{
    c_ctrl <: MIXER_CMD_MIX_MULT;
    c_ctrl <: (unsigned) mix;
    c_ctrl <: (unsigned) channel;
    c_ctrl <: (unsigned) weight;  
}

void Mixer_Kill(chanend c_ctrl)
{
    c_ctrl <: MIXER_CMD_KILL;
}

/* Performs the actual mix */
#pragma unsafe arrays
static inline int doMix(int samples[], int mult[])
{
    int h=0; 
    int l=0; 

#pragma loop unroll
    for (int i=0; i<MIXER_NUM_CHAN_IN; i++) 
    {
        {h,l} = macs(samples[i], mult[i], h, l);
    }
    
    /* Perform saturation check and limit */
    l = sext(h, 25);

    if(l != h)
    {
        if(h>>32)  
            h = (0x80000000>>7);
        else
            h = (0x7fffff00>>7);
    }
    return h<<7;
}

/* Main mixer thread */
#pragma unsafe arrays
void Mixer(streaming chanend c_in, streaming chanend c_out, chanend c_ctrl)
{
    int samplesIn[MIXER_NUM_CHAN_IN];
    unsigned samplesOut[MIXER_NUM_CHAN_IN];

    /* Mix weight table */
    int mult_Mix[MIXER_NUM_CHAN_OUT][MIXER_NUM_CHAN_IN];
    
    for (int i = 0; i < MIXER_NUM_CHAN_IN; i++)
    {
        samplesIn[i] = 0;
    }
    
    /* Init mix wight table */
    for (int i=0; i < MIXER_NUM_CHAN_OUT; i++)
    {
        for (int j=0;j<MIXER_NUM_CHAN_IN;j++) 
        {
            if(i==j)
            {
                mult_Mix[i][j] = MIXER_MAX_VOL>>4;
            }
            else
            {
                mult_Mix[i][j] = 0;
            }
        }
    }

    while(1)
    {
        unsigned cmd, ct;
        int mixed;

        /* Look for any control or sample data */
        select
        {
            case c_ctrl :> cmd:

                switch (cmd)
                {

                    case MIXER_CMD_MIX_MULT:
                        {
                            /* Update a particular mixer node */
                            int weight, channel, mix;
                            c_ctrl :> mix;
                            c_ctrl :> channel;
                            c_ctrl :> weight;

                            mult_Mix[mix][channel] = weight;
                        }
                        break;

                     case MIXER_CMD_KILL:
#pragma xta endpoint "exit_"
                        /* Kill command, kill thread */
                        return;

                }
                break;

#pragma xta endpoint "sample_input"
            case c_in :> samplesIn[0]:


                /* Receive samples into local buffer */
#pragma loop unroll
                for(int i = 1; i < MIXER_NUM_CHAN_IN; i++)
                {
                    c_in :> samplesIn[i];
                } 

                /* Lets do some mixing baby */
#pragma loop unroll
                for(int i = 0; i < MIXER_NUM_CHAN_OUT; i++)
                {
                    samplesOut[i] = doMix(samplesIn, mult_Mix[i]);
                }

#pragma xta endpoint "sample_output"
                /* Output samples from buffer */
#pragma loop unroll
                for(int i = 0; i < MIXER_NUM_CHAN_OUT; i++)
                {
                    c_out <: samplesOut[i];
                }
                break;           
        }
    }
}

