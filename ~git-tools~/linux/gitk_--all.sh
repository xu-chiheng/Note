#!/usr/bin/env -S bash -i

cd "$(dirname "$0")"

cd ../..

nohup gitk --all &
