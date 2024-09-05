#!/usr/bin/env python

import subprocess
import json
import sys

COMMAND = "heroku apps --json --all"

p = subprocess.Popen(
    [
        "fuzzel",
        "-d",
        "--prompt",
        "Select app > ",
    ],
    stdout=subprocess.PIPE,
    stdin=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True
)

result = subprocess.check_output(COMMAND, shell=True).decode("utf-8")
s = ""
for app in json.loads(result):
    s += f"{app['name']}\0icon\x1f/home/azelphur/.bin/assets/heroku.png\n"

stdout, stderr = p.communicate(input=s)
app = stdout.strip()
if not app:
    sys.exit(0)

url = "https://dashboard.heroku.com/apps/" + app
subprocess.Popen(
    f"xdg-open {url}",
    shell=True,
    start_new_session=True,
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL,
)
sys.exit(0)

