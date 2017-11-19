#!/bin/bash

fswatch -o ./src/ | while read; do ./build.sh; done
