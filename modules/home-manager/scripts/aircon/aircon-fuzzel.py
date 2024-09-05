#!/usr/bin/env python

import requests
import subprocess
import os
import json

with open(os.path.expanduser("~/.ha_credentials.json"), "r") as f:
    config = json.load(f)

API_URL = config["url"].strip()
HEADERS = {
    "Authorization": f"Bearer {config['token']}",
}
ENTITY_ID = config["entity_id"]


class MenuItem:
    def __init__(self, name, icon=None):
        self.name = name
        self.icon = icon

    def get_icon(self):
        return os.path.expanduser(f"~/.bin/assets/aircon/{self.icon}")

    def render(self):
        return f"{self.name}\0icon\x1f{self.get_icon()}"

modes = [
    MenuItem("Off", "power.svg"),
    MenuItem("Set Temperature", "thermostat.svg"),
    MenuItem("Heat", "fire.svg"),
    MenuItem("Dry", "humidity-percentage.svg"),
    MenuItem("Cool", "snowflake.svg"),
    MenuItem("Fan", "mode-fan.svg"),
    MenuItem("Heat/Cool", "mode-heat-cool.svg"),
]

def get_current_state():
    r = requests.get(API_URL + f"/api/states/{ENTITY_ID}", headers=HEADERS)
    return r.json()

state = get_current_state()
if state['state'] == "off":
    prompt = "Off"
else:
    prompt = f"{state['state'].capitalize()}ing {state['attributes']['temperature']}°C"

p = subprocess.Popen(
    [
        "fuzzel",
        "-d",
        "--prompt",
        f"Aircon {prompt} > "
    ],
    stdout=subprocess.PIPE,
    stdin=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True
)

s = ""
for mode in modes:
    s += mode.render() + "\n"

stdout, stderr = p.communicate(input=s)
if stdout == "Set Temperature\n":
    p = subprocess.Popen(
        [
            "fuzzel",
            "-d",
            "--prompt",
            "Set Temperature > ",
        ],
        stdout=subprocess.PIPE,
        stdin=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    stdout, stderr = p.communicate()
    data = {
        "entity_id": ENTITY_ID,
        "temperature": stdout.strip(),
    }
    r = requests.post(
        API_URL + "/api/services/climate/set_temperature",
        headers=HEADERS,
        json=data
    )

else:
    data = {
        "entity_id": ENTITY_ID,
        "hvac_mode": stdout.lower().strip()
    }
    r = requests.post(
        API_URL + "/api/services/climate/set_hvac_mode",
        headers=HEADERS,
        json=data
    )
