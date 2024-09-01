#!/usr/bin/env python

import subprocess
import random
import requests

r = requests.get("https://raw.githubusercontent.com/seantomburke/shipit.gifs/master/gifs.json")
gifs = r.json()
gif = random.choice(gifs["gifs"])
process = subprocess.Popen(["wl-copy", f"![{gif['description']}]({gif['url']})"])
process.communicate()
