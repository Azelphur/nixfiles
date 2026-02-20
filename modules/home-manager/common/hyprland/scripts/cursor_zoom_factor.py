#!/usr/bin/env python

import subprocess
import json
import sys
import math

#key = "misc:cursor_zoom_factor"
key = "cursor:zoom_factor"
result = subprocess.check_output(f"hyprctl -j getoption {key}", shell=True)
print(result)
if sys.argv[1] == "get":
    sys.exit(0)
result = json.loads(result)
result = max(result["float"], 1.0)
try:
    modifier = result / 10
except OverflowError:
    modifier = 1000
print(f"{modifier=}")
if sys.argv[1] == "in":
    new_zoom = result + modifier
elif sys.argv[1] == "out":
    new_zoom = result - modifier
if new_zoom < 1.0:
    print("Limited")
    new_zoom = 1.0
print(f"{new_zoom=}")
cmd = f"hyprctl keyword {key} {new_zoom}"
subprocess.check_output(cmd, shell=True)
