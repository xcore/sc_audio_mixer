app_example_mixer
.................

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

