#!/bin/bash
# Tăng heapsize lên 100GB
export NODE_OPTIONS=--max-old-space-size=102400


MASTER_URL=https://metal-kings-cheer.loca.lt node botok.js
