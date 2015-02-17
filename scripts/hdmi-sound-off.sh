#!/bin/bash
cp asoundrc.hdmi-off ~/.asoundrc
alsactl restore
