#!/usr/bin/env python3

import docker
import os
import pickle
import argparse

CACHE_FILE = "/var/cache/known_containers.pickle"

parser = argparse.ArgumentParser()
parser.add_argument('-R', dest='reload', action='store_const',
                    const=True, default=False)

args = parser.parse_args()

known_containers = set()

if os.path.exists(CACHE_FILE):
    with open(CACHE_FILE, "rb") as f:
        known_containers = pickle.load(f)

client = docker.from_env()

status = 0
status_message = "OK"
first_line = "All healthy"
result = []
found_containers = set()
unknown_containers = set()


for container in client.containers.list():
    state = container.attrs.get("State", {})
    health = state.get("Health", {})
    name = container.attrs["Name"].lstrip("/")
    if health == {}:
        continue
    if name not in known_containers and status < 1:
        status = 1
        status_message = "WARN"
        unknown_containers.add(name)
        first_line = "Unknown container(s): {}".format(", ".join(unknown_containers))
    found_containers.add(name)
    if health["Status"] == "unhealthy" and status < 2:
        status = 2
        status_message = "CRIT"
        first_line = "{} {}".format(container.attrs["Name"].lstrip("/"), health["Status"])
    result.append("{} {}".format(container.attrs["Name"].lstrip("/"), health["Status"]))

missing_containers = known_containers - found_containers
if missing_containers:
    status = 2
    status_message = "CRIT"
    first_line = "Container(s) are missing: {}".format(", ".join(missing_containers))

result = sorted(result)
    
result.insert(0, first_line)
if args.reload:
    with open(CACHE_FILE, "wb") as f:
        pickle.dump(found_containers, f)
        print("Reloaded containers")
        exit()

print('{} docker_health - {} - {}'.format(status, status_message, "\\\\n".join(result)))
