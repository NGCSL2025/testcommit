#!/bin/bash
# Tăng heapsize lên 100GB
export NODE_OPTIONS=--max-old-space-size=102400


MASTER_URL=https://bright-donuts-laugh.loca.lt node botok.js

