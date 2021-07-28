#!/bin/bash

export SECRET_KEY_BASE=$(rails secret)

redis-server --daemonize yes

if [[ -z "${PASSWORD}" ]]; then
    rails s -b 0.0.0.0
else
  PASSWORD=$(echo $PASSWORD) rails s -b 0.0.0.0
fi