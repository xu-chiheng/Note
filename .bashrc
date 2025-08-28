# MIT License

# Copyright (c) 2023 徐持恒 Xu Chiheng

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------
source_etc_bashrc() {
	if [ -f /etc/bashrc ]; then
		. /etc/bashrc   # --> Read /etc/bashrc, if present.
	fi
}

source_.bashrc.d_scripts(){
	for file in ~/.bashrc.d/*.sh ; do
		. "${file}"
	done
}
# https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files

maybe_set_environment_variables_at_bash_startup() {
	if [ ! -v HOST_TRIPLE ]; then
		# uncomment the following line, to see the time consumed
		set_environment_variables_at_bash_startup
	fi
}

# time \
source_etc_bashrc
# time \
source_.bashrc.d_scripts
# time_command \
maybe_set_environment_variables_at_bash_startup
