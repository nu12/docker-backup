#!/bin/bash

redis-server --daemonize yes

export SECRET_KEY_BASE=$(bin/rake secret)

rails s -b 0.0.0.0