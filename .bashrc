for file in ~/.bashrc.d/*.sh ; do
	. "${file}"
done
# https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files