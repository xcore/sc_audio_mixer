sc_audio_mixer
...........

:Stable release:  unreleased

:Status:  first port to github

:Maintainer: xross

:Description:  Audio mixer component


Key Features
============

* Build-time configurable input/output count
* Runs in a thread and takes samples in via a channel, and outputs mixes via another channel
* Control commands come in from a third control channel
* Includes saturation 

To Do
=====

* Add routing
* Add db

Firmware Overview
=================

This repo contains audio mixer and example application.

There is an example application included in this module.

app_multi_uart_demo - This is a self contained test application for testing the mixer.  It passes sin waves into the mixer.

The primary module is module_audio_mixer. This contains the audio mixer module and provides mixing functionality along with an API for using it.

Issues
============

* None

Required Repositories
================

* xcommon git\@github.com:xcore/xcommon.git

Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the maintainer for this line.
