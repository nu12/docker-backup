#!/bin/bash

export SECRET_KEY_BASE=$(rails secret)

rails s -b 0.0.0.0