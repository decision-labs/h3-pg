#!/usr/bin/env bash

cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
sudo cmake --install build --component h3-pg
ctest --test-dir build --output-on-failure --build-config Debug
