#!/bin/env python
import fileinput
import sys
import os
import shutil

wall_dir = "/home/eric/.wall"

def wall_path(i):
    return os.path.join(wall_dir, "wall_" + str(i) + ".jpg")

if len(sys.argv) > 1:
    wall_num = int(sys.argv[1]) 
    image = input()
    shutil.move(image, wall_path(wall_num))
else:
    for i,line in enumerate(fileinput.input()):
        shutil.copyfile(line.rstrip(), wall_path(i))
