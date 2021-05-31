#!/bin/bash

export SECRET_KEY_BASE=$(rails secret)

redis-server --daemonize yes

rails s -b 0.0.0.0
