app_example_mixer
.................

This appliction gives an example of how to use the mixer component.  It passes sin-waves of 
various frequencies into the mixer and modifies the mixes.  Outputs and inputs are printed
such that they can be plotted and the output observed.

The example also includes a gnuplot script for plotting this data.

Requirements
============
For dataplotting gnuplot is required.

Building
========
make all

Running
=======
make run

This will call the built binary from in the simulator, the output piped to log.txt.  
The make file will then call a gnuplot script file which will generare plotes based
on log.txt

see example_output.pdf for typical output.



