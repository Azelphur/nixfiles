#!/usr/bin/env python

import requests
import subprocess
import os
import json


class MenuItem:
    def __init__(self, name, icon=None):
        self.name = name
        self.icon = icon

    def get_icon(self):
        return os.path.expanduser(f"~/.bin/assets/aircon/{self.icon}")

    def render(self):
        return f"{self.name}\0icon\x1f{self.get_icon()}"

def main(entity_id=None):
    with open(os.path.expanduser("~/.ha_credentials.json"), "r") as f:
        config = json.load(f)

    if entity_id is None:
        entity_id = config["default_entity_id"]
    aircon_name = config["entity_ids"][entity_id]

    api_url = config["url"].strip()
    headers = {
        "Authorization": f"Bearer {config['token']}",
    }
    modes = [
        MenuItem("Off", "power.svg"),
        MenuItem("Set Temperature", "thermostat.svg"),
        MenuItem("Heat", "fire.svg"),
        MenuItem("Dry", "humidity-percentage.svg"),
        MenuItem("Cool", "snowflake.svg"),
        MenuItem("Fan", "mode-fan.svg"),
        MenuItem("Heat/Cool", "mode-heat-cool.svg"),
        MenuItem("Switch Unit", "heat-pump.svg"),
    ]

    def get_current_state():
        r = requests.get(api_url + f"/api/states/{entity_id}", headers=headers)
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
            f"{aircon_name} {prompt} > "
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
    print("STDOUT IS", stdout)
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
            text=True,
        )
        stdout, stderr = p.communicate()
        data = {
            "entity_id": entity_id,
            "temperature": stdout.strip(),
        }
        r = requests.post(
            api_url + "/api/services/climate/set_temperature",
            headers=headers,
            json=data
        )
    elif stdout == "Switch Unit\n":
        p = subprocess.Popen(
            [
                "fuzzel",
                "-d",
                "--prompt",
                "Select Unit > ",
            ],
            stdout=subprocess.PIPE,
            stdin=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        menu = [MenuItem(v, "heat-pump.svg") for v in config["entity_ids"].values()]
        s = ""
        for item in menu:
            s += item.render() + "\n"
        stdout, stderr = p.communicate(input=s)
        reverse_dict = {v: k for k, v in config["entity_ids"].items()}
        main(reverse_dict[stdout.strip()])
    else:
        data = {
            "entity_id": entity_id,
            "hvac_mode": stdout.lower().strip()
        }
        r = requests.post(
            api_url + "/api/services/climate/set_hvac_mode",
            headers=headers,
            json=data
        )

if __name__ == "__main__":
    main()
