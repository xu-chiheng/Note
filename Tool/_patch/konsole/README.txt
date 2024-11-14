
4.9.4    be821ffd456b5809948ad41654ee334ff93f2571    2012-11-17
patch_apply . ../_patch/konsole/openpty.patch


implement openpty feature

do not create child process, instead, open a pty, and output the slave name of pty device.
used in gdb debugging.
utilize this gdb command line option:
--tty=TTY          Use TTY for input/output by the program being debugged.

$ OPENPTY= konsole
/dev/pty1

echo hello >/dev/pty1

gdb --tty=/dev/pty1 emacs
run
