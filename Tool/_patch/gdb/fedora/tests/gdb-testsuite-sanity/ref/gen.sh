#!/bin/bash

BIN=`which gdb` &&
PACKAGE=`rpm -qf --qf='%{name}\n' ${BIN}` &&
SYSTEM=`uname -r | grep -o -E 'el[0-9]+a?|fc[0-9]+'` &&
ARCH=`arch` &&
echo "./ref/${PACKAGE}/${SYSTEM}.${ARCH}" &&
exit 0

echo "ERROR" >&2
exit 1
