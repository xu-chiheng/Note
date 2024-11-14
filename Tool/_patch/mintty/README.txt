


3.6.2    a2cb0339efe2a9b4877c1a310ecbdbb80eca9c20    2022-11-27
patch_apply . ../_patch/mintty/openpty.patch





implement openpty feature

use openpty(), instead of forkpty(). do not create child process, instead, open a pty, and output the slave name of pty device.
used in gdb debugging.
utilize this gdb command line option:
--tty=TTY          Use TTY for input/output by the program being debugged.

$ ./mintty/bin/mintty.exe --openpty
/dev/pty1

echo hello >/dev/pty1

gdb --tty=/dev/pty1 emacs
run
