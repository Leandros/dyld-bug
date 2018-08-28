#!/bin/bash

gcc -shared -all_load -ObjC -framework Foundation -o lib.dylib lib.m

