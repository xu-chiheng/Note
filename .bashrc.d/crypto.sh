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


gpg_export_private_and_public_keys() {
	# export private keys
	gpg --export-secret-keys -a;
	# export public keys
	gpg --export -a; 
}

gpg_generate_rsa_4096_bit_key_pair_for_git() {
	{ cat <<EOF
set timeout 10

spawn gpg --full-gen-key

expect "Your selection?"
send "1\r"

expect "What keysize do you want? (3072)"
send "4096\r"

expect "Key is valid for? (0)"
send "\r"

expect "Is this correct? (y/N)"
send "y\r"

expect "Real name:"
send "$(git config user.name)\r"

expect "Email address:"
send "$(git config user.email)\r"

expect "Comment:"
send "\r"

expect "Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit?"
send "O\r"

# Wait for the program to finish
expect eof
EOF
} | expect 

}

ssh_generate_key_pair_for_github() {
	{ cat <<EOF
set timeout 10

spawn ssh-keygen -t ed25519 -C "$(git config user.email)"

expect -re {Enter file in which to save the key (.*):}
send "$(echo ~)/.ssh/github\r"

expect "Enter passphrase (empty for no passphrase):"
send "\r"

expect "Enter same passphrase again:"
send "\r"

# Wait for the program to finish
expect eof
EOF
} | expect 

}


file_split_one() {
	local size="$1"
	local file="$2"
	if [ -z "${file}" ]; then
		echo "no file specified"
		return 1
	elif ! [ -f "${file}" ]; then
		echo "file ${file} does not exist"
		return 1
	fi
	local dir="${file}".chunks
	local base="$(basename "${file}")"

	echo "${file} started"
	if rm -rf "${dir}" \
		&& mkdir -p "${dir}" \
		&& { pushd "${dir}" &>/dev/null \
			&& split --bytes="${size}" --suffix-length=9 --additional-suffix=.chunk --numeric-suffixes "../${base}" \
			&& popd &>/dev/null ;}; then
		echo "${file} finished"
		rm -rf "${file}"
		return 0
	else
		echo "${file} failed"
		return 1
	fi
}

file_concatenate_one() {
	local dir="$1"
	if [ -z "${dir}" ]; then
		echo "no directory specified"
		return 1
	elif ! [[ "${dir}" == *.chunks ]]; then
		echo "${dir} is not a .chunks directory"
		return 1
	elif ! [ -d "${dir}" ]; then
		echo "directory ${dir} does not exist"
		return 1
	fi
	local file="$(dirname "${dir}")/$(basename "${dir}" .chunks)"
	echo "${dir} started"
	if rm -rf "${file}" \
		&& { find "${dir}" -type f -regextype posix-extended -regex '.*/x[0-9]+\.chunk$' -print0 | xargs -0 -n100 cat; } >"${file}"; then
		echo "${dir} finished"
		rm -rf "${dir}"
		return 0
	else
		echo "${dir} failed"
		return 1
	fi
}

gpg_encrypt_file() {
	local file="$1"
	if [ -z "${file}" ]; then
		echo "no file specified"
		return 1
	elif ! [ -f "${file}" ]; then
		echo "file ${file} does not exist"
		return 1
	fi
	echo "${file} started"
	# https://news.ycombinator.com/item?id=13382734
	# I like AES256 and SHA512
	if gpg --cipher-algo AES256 --digest-algo SHA512 --cert-digest-algo SHA512 --compress-algo none \
		--s2k-mode 3 --s2k-digest-algo SHA512 --s2k-count 1000000 \
		--encrypt --recipient "$(git config user.email)" --output "${file}".gpg "${file}"; then
		echo "${file} finished"
		rm -rf "${file}"
		return 0
	else
		echo "${file} failed"
		return 1
	fi
}

gpg_decrypt_file() {
	local gpg="$1"
	if [ -z "${gpg}" ]; then
		echo "no file specified"
		return 1
	elif ! [[ "${gpg}" == *.gpg ]]; then
		echo "${gpg} is not a .gpg file"
		return 1
	elif ! [ -f "${gpg}" ]; then
		echo "file ${gpg} does not exist"
		return 1
	fi
	local file="$(dirname "${gpg}")/$(basename "${gpg}" .gpg)"
	echo "${gpg} started"
	if gpg --decrypt --output "${file}" "${gpg}"; then
		echo "${gpg} finished"
		rm -rf "${gpg}"{,.sha512}
		return 0
	else
		echo "${gpg} failed"
		return 1
	fi
}

sha512_calculate_file() {
	local file="$1"
	if [ -z "${file}" ]; then
		echo "no file specified"
		return 1
	elif ! [ -f "${file}" ]; then
		echo "file ${file} does not exist"
		return 1
	fi
	if [ -f "${file}".sha512 ]; then
		return 0
	fi
	local dir="$(dirname "${file}")"
	local base="$(basename "${file}")"
	echo "${file} started"
	if { pushd "${dir}" &>/dev/null \
		&& sha512sum "${base}" >"${base}".sha512 \
		&& popd &>/dev/null ;}; then
		echo "${file} finished"
		return 0
	else
		echo "${file} failed"
		return 1
	fi
}
# https://man7.org/linux/man-pages/man1/xargs.1.html
# If any invocation of the command exits with a status of 255,
# xargs will stop immediately without reading any further input.
# An error message is issued on stderr when this happens.

# https://www.baeldung.com/linux/return-vs-exit
# return stops the execution of a Bash function.
# If we supply an integer argument to return, it returns that argument to the function caller as the exit status. Otherwise, it returns the exit status of the last command executed before return to the function caller.

# https://stackoverflow.com/questions/407184/how-to-check-the-extension-of-a-filename-in-a-bash-script
sha512_check_file() {
	local sum="$1"
	if [ -z "${sum}" ]; then
		echo "no file specified"
		return 1
	elif ! [[ "${sum}" == *.sha512 ]]; then
		echo "${sum} is not a .sha512 file"
		return 1
	elif ! [ -f "${sum}" ]; then
		echo "file ${sum} does not exist"
		return 1
	fi
	local dir="$(dirname "${sum}")"
	local base="$(basename "${sum}")"
	local file="${dir}/$(basename "${sum}" .sha512)"
	if [ -f "${file}" ]; then
		true
	elif [ -d "${file}".chunks ] || [ -f "${file}".gpg ]; then
		return 0
	else
		rm -rf "${sum}"
		return 0
	fi
	echo "${sum} started"
	if { pushd "${dir}" &>/dev/null \
		&& sha512sum --check --status "${base}" \
		&& popd &>/dev/null ;}; then
		echo "${sum} finished"
		return 0
	else
		echo "${sum} failed"
		return 1
	fi
}

find_binary_files_-print0() {
	local find_args=(
		-not
		'('
			-name '*.txt'
			-or -name '*.sha512'
			-or -name '*.cmd'
			-or -name '*.sh'
			-or -name '.*'
		')'
	)

	find . -type f "${find_args[@]}" -print0
}

find_sha512_files_-print0() {
	find . -type f -name '*.sha512' -print0
}

find_files_to_split_-print0() {
	local size="$1"
	find . -type f -regextype posix-extended -regex '.*\.(iso|tar|xz)' -a -size +"${size}" -print0
}

find_chunks_dirs_-print0() {
	find . -type d -name '*.chunks' -print0
}

find_files_to_encrypt_-print0() {
	find . -type f -regextype posix-extended -regex '.*\.(chunk|iso|tar|xz)' -print0
}

find_files_to_decrypt_-print0() {
	find . -type f -name '*.gpg' -print0
}

gpg_decrypt_in_parallel_ask_for_password_first_time() {
	echo "type the master password of secret key(private key) for the first time" \
	&& echo "password correct" | gpg --encrypt --recipient "$(git config user.email)" | gpg --decrypt \
	&& echo "waiting for 1 seconds ..." \
	&& sleep 1 \
	&& echo "decrypting in parallel ..."
}

# https://stackoverflow.com/questions/11003418/calling-shell-functions-with-xargs
# https://unix.stackexchange.com/questions/158564/how-to-use-defined-function-with-xargs

# bash -c can't get arguments from command line without the last arg "-"
# bash -c ' echo hello "$@" ' world
# bash -c ' echo hello "$@" ' - world

# https://www.man7.org/linux/man-pages/man1/bash.1.html
# --     A -- signals the end of options and disables further
# 		option processing.  Any arguments after the -- are treated
# 		as filenames and arguments.  An argument of - is
# 		equivalent to --.
handle_file_operation() {
	local operation="$1"
	case "${operation}" in
		file_split_common )
			local size="$2"
			find_files_to_split_-print0 "${size}" \
			| xargs -0 -n1 \
			bash -c "$(declare -f file_split_one); file_split_one '${size}'"' "$@" ;' -
			;;
		file_concatenate )
			find_chunks_dirs_-print0 \
			| xargs -0 -n1 \
			bash -c "$(declare -f file_concatenate_one); file_concatenate_one"' "$@" ;' -
			;;
		gpg_encrypt_in_parallel )
			find_files_to_encrypt_-print0 \
			| xargs -0 -n1 -P0 \
			bash -c "$(declare -f gpg_encrypt_file); gpg_encrypt_file"' "$@" ;' -
			;;
		gpg_decrypt_in_parallel )
			gpg_decrypt_in_parallel_ask_for_password_first_time

			find_files_to_decrypt_-print0 \
			| xargs -0 -n1 -P0 \
			bash -c "$(declare -f gpg_decrypt_file); gpg_decrypt_file"' "$@" ;' -
			;;
		sha512_calculate_in_parallel )
			find_binary_files_-print0 \
			| xargs -0 -n1 -P0 \
			bash -c "$(declare -f sha512_calculate_file); sha512_calculate_file"' "$@" ;' -
			;;
		sha512_check_in_parallel )
			find_sha512_files_-print0 \
			| xargs -0 -n1 -P0 \
			bash -c "$(declare -f sha512_check_file); sha512_check_file"' "$@" ;' -
			;;
		gpg_encrypt_in_series )
			find_files_to_encrypt_-print0 \
			| xargs -0 -n1 \
			bash -c "$(declare -f gpg_encrypt_file); gpg_encrypt_file"' "$@" ;' -
			;;
		gpg_decrypt_in_series )
			find_files_to_decrypt_-print0 \
			| xargs -0 -n1 \
			bash -c "$(declare -f gpg_decrypt_file); gpg_decrypt_file"' "$@" ;' -
			;;
		sha512_calculate_in_series )
			find_binary_files_-print0 \
			| xargs -0 -n1 \
			bash -c "$(declare -f sha512_calculate_file); sha512_calculate_file"' "$@" ;' -
			;;
		sha512_check_in_series )
			find_sha512_files_-print0 \
			| xargs -0 -n1 \
			bash -c "$(declare -f sha512_check_file); sha512_check_file"' "$@" ;' -
			;;
	esac
}

file_operation_common() {
	local handle_operation_command="$1"
	local operation="$2"
	shift 2
	local current_datetime="$(print_current_datetime)"
	local output_file="~${current_datetime}-${operation}-output.txt"
	local failure_output_file="~${current_datetime}-${operation}-failure-output.txt"
	time_command "${handle_operation_command}" "${operation}" "$@" 2>&1 | tee "${output_file}"
	cat "${output_file}" | grep -E '^\./.+ failed$' | sed -E -e 's/ failed$//' >"${failure_output_file}"
	printf "\n\n"
	if [ -s "${failure_output_file}" ]; then
		echo "failed :"
		cat "${failure_output_file}"
	else
		echo "all succeeded"
		rm -rf "${failure_output_file}"
	fi
	printf "\n\n"
	time_command sync .
}

do_file_operation() {
	time_command file_operation_common handle_file_operation "$@"
}

file_split_common() {
	local size="$1"
	if [ -z "${size}" ]; then
		echo "no size specified"
		return 1
	elif ! [[ "${size}}" =~ [1-9][0-9]*G ]]; then
		echo "invalid size : ${size}"
		return 1
	fi
	do_file_operation file_split_common "${size}"
}

file_split_1G() {
	file_split_common 1G
}

file_split_4G() {
	file_split_common 4G
}

file_split_16G() {
	file_split_common 16G
}

file_concatenate() {
	do_file_operation file_concatenate
}

gpg_encrypt_in_parallel() {
	do_file_operation gpg_encrypt_in_parallel
}

gpg_decrypt_in_parallel() {
	do_file_operation gpg_decrypt_in_parallel
}

sha512_calculate_in_parallel() {
	do_file_operation sha512_calculate_in_parallel
}

sha512_check_in_parallel() {
	do_file_operation sha512_check_in_parallel
}

gpg_encrypt_in_series() {
	do_file_operation gpg_encrypt_in_series
}

gpg_decrypt_in_series() {
	do_file_operation gpg_decrypt_in_series
}

sha512_calculate_in_series() {
	do_file_operation sha512_calculate_in_series
}

sha512_check_in_series() {
	do_file_operation sha512_check_in_series
}
