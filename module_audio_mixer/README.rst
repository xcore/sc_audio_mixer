module_audio_mixer
..................

This module includes the Mixer thread and API for controlling it's configuration.

The Mixer thread takes in audio samples from one channel and outputs mixes to another channel.
A third channel is use to control the mixer, setting node weights etc.

Seperate channels are used for audio input and output such that audio can be "streamed" through
it in a typical application.

The mixer includes a "saturation" check and limiting to avoid wrap-around issues.  Mixes are 
clipped at +/- full range.

The mixer expects samples left aligned in a word, so if you have 24bit samples shift them up 8
bits.  16 bits for 16bit samples etc.



