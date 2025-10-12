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


____how_to_use_mailvelope_browser_extension____() {
	# https://mailvelope.com/en
	# https://github.com/mailvelope/mailvelope

	# Encrypting Your E-Mails Using PGP Mailvelope For Confidentiality - YouTube
	# https://www.youtube.com/watch?v=0l1a_cwnhDU

	# Installing, configuring, and using Mailvelope - YouTube
	# https://www.youtube.com/watch?v=Q5k8l1Bp8Xo

	# Options --> Security --> Remember passwords for this browser session. : Yes, keep in memory for 600 minutes.
	# Options --> Security --> Where are decrypted messages displayed?      : On the email provider's page.
	# Options --> Gmail API --> Gmail API Integration : ON

	# GnuPG export keys
	gpg_export_all_public_keys_with_ascii_armored_output_and_to_text_file
	gpg_export_all_private_keys_with_ascii_armored_output_and_to_text_file

	# https://keys.mailvelope.com
	# https://keys.mailvelope.com/manage.html
	# Using Mailvelope browser extension to import GnuPG exported public and private keys, 
	# it will upload the public key to the key server and the key server will send you an email to verify the email address of the public key.
	# Email address chiheng.xu@gmail.com successfully verified
	# Your public OpenPGP key is now available at the following link: https://keys.mailvelope.com/pks/lookup?op=get&search=chiheng.xu@gmail.com

	# If using the following command, the email address will not be verified.
	# gpg --keyserver hkps://keys.mailvelope.com --send-keys "$(gpg_print_key_id_of_email "$(git config user.email)")"
}
unset -f ____how_to_use_mailvelope_browser_extension____

gpg_upload_public_key_of_email_to_hkps://keys.mailvelope.com() {
	local email="$1"
	if ! email_is_valid "${email}"; then
		echo "no valid email provided"
		return 1
	fi
	# https://github.com/mailvelope/keyserver
	# REST API   Upload new key
	public_key=$(gpg --armor --export-options export-minimal --export "${email}")
	json_data=$(jq -n --arg pk "${public_key}" '{ publicKeyArmored: $pk }')
	curl -X POST "https://keys.mailvelope.com/api/v1/key" -H "Content-Type: application/json" -d "${json_data}"
}

gpg_upload_public_key_of_email_to_hkps://keys.openpgp.org() {
	local email="$1"
	if ! email_is_valid "${email}"; then
		echo "no valid email provided"
		return 1
	fi
	# https://keys.openpgp.org/about/usage
	# https://keys.openpgp.org/about/faq
	# You can upload keys using GnuPG’s --send-keys command, but identity information can’t be verified that way to make the key searchable by email address.
	# Alternatively, try this shortcut for uploading your key:
	gpg --export "${email}" | curl -T - https://keys.openpgp.org
	# Remember to verify your email address to ensure others can find your key when searching by email address
	# https://keys.openpgp.org
	# We found an entry for chiheng.xu@gmail.com.
	# https://keys.openpgp.org/vks/v1/by-fingerprint/4E928EB96C7929323551C3ACD53FA5A3E656A74C
}

gpg_upload_public_key_of_email_to_keyservers() {
	local email="$1"
	if ! email_is_valid "${email}"; then
		echo "no valid email provided"
		return 1
	fi
	local keyserver
	for keyserver in $(gpg_print_verifying_keyservers); do
		echo_command gpg_upload_public_key_of_email_to_${keyserver} "${email}"
		echo
	done
}

gpg_upload_default_public_key_to_keyservers() {
	gpg_upload_public_key_of_email_to_keyservers "$(git config user.email)"
}

gpg_search_public_key_of_email_on_keyservers() {
	local email="$1"
	if ! email_is_valid "${email}"; then
		echo "no valid email provided"
		return 1
	fi

	local keyserver
	for keyserver in $(gpg_print_verifying_keyservers); do
		expect -c "
			# Set timeout for Expect commands (in seconds)
			set timeout 10

			# Start gpg --search with the given keyserver and email
			spawn gpg --keyserver \"${keyserver}\" --search \"${email}\"

			expect {
				# Match the prompt asking for a selection
				\"Enter number(s), N)ext, or Q)uit >\" {
					send \"\r\"
					exp_continue
				}
				# Wait for the program to finish
				eof
			}
		"
		echo
	done
}

gpg_search_default_public_key_on_keyservers() {
	gpg_search_public_key_of_email_on_keyservers "$(git config user.email)"
}

gpg_print_verifying_keyservers() {
	local keyservers=(
		# Hagrid
		# Hagrid is a verifying OpenPGP key server.
		# You can find general instructions and an API documentation at the running instance at https://keys.openpgp.org.
		# https://keys.openpgp.org
		# https://gitlab.com/keys.openpgp.org/hagrid
		hkps://keys.openpgp.org

		# Mailvelope Keyserver
		# A simple OpenPGP public key server that validates email address ownership of uploaded keys.
		# https://keys.mailvelope.com
		# https://github.com/mailvelope/keyserver
		hkps://keys.mailvelope.com

		# The following key servers does not verify email address of public key.
		# So, can only be used to search public key by id
		# https://keyserver.ubuntu.com
	)
	local keyserver
	for keyserver in "${keyservers[@]}"; do
		echo "${keyserver}"
	done
}

gpg_refresh_all_public_keys_from_keyservers() {
	local keyserver
	for keyserver in $(gpg_print_verifying_keyservers); do
		echo_command gpg --keyserver "${keyserver}" --refresh-keys
		echo
	done
}

gpg_download_public_key_of_email_from_keyservers() {
	local email="$1"
	if ! email_is_valid "${email}"; then
		echo "no valid email provided"
		return 1
	fi
	local keyserver
	for keyserver in $(gpg_print_verifying_keyservers); do
		echo_command gpg --keyserver "${keyserver}" --locate-keys "${email}"
		echo
	done
}

gpg_list_all_public_keys() {
	gpg --list-keys
	# gpg -k
}

gpg_list_all_private_keys() {
	gpg --list-secret-keys
	# gpg -K
}

gpg_print_key_id_of_email() {
	local email="$1"
	if ! email_is_valid "${email}"; then
		echo "no valid email provided"
		return 1
	fi
	gpg --list-keys --with-colons "${email}" 2>/dev/null | awk -F: '/^pub/ {print $5}'
}

gpg_print_key_fingerprint_of_email() {
	local email="$1"
	if ! email_is_valid "${email}"; then
		echo "no valid email provided"
		return 1
	fi
	gpg --list-keys --with-colons "${email}" 2>/dev/null | awk -F: '/^fpr:/ {print $10}'
}

# https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages
# https://www.howtogeek.com/427982/how-to-encrypt-and-decrypt-files-with-gpg-on-linux/

# https://stackoverflow.com/questions/50332885/how-do-i-install-and-use-gpg-agent-on-windows
# gpg_agent_start_in_background() {
# 	gpgconf --launch gpg-agent
# }

gpg_export_default_public_key_with_ascii_armored_output_and_to_text_file() {
	gpg --export -a "$(git config user.email)" | tee gpg_default_public_key.asc
}

gpg_export_default_private_key_with_ascii_armored_output_and_to_text_file() {
	gpg --export-secret-keys -a "$(git config user.email)" | tee gpg_default_private_key.asc
}

gpg_export_all_public_keys_with_ascii_armored_output_and_to_text_file() {
	gpg --export -a | tee gpg_all_public_keys.asc
}

gpg_export_all_private_keys_with_ascii_armored_output_and_to_text_file() {
	gpg --export-secret-keys -a | tee gpg_all_private_keys.asc
}

# | Command   | Displays                   | Purpose                                                                                   |
# | --------- | -------------------------- | ----------------------------------------------------------------------------------------- |
# | `gpg -k`  | Public keys                | Used by others to encrypt messages to you or verify your signature                        |
# | `gpg -K`  | Private keys               | Used by you to sign or decrypt messages sent to you                                       |
# | pub / sec | Primary key (Sign/Certify) | Your core identity key                                                                    |
# | sub / ssb | Subkey (Encrypt/Decrypt)   | Used for actual encryption/decryption; primary key is usually only for signing/certifying |

# Basic Concepts
# Primary Key (Master Key):
# 	Generated when creating a GPG key pair
# 	Used for signing and certifying (S/C)
# 	Serves as the core identity of the entire key system
# Subkey (Secondary Key):
# 	Can be used for encryption/decryption (E) or signing
# 	Generated by and bound to the primary key
# 	Can be added or revoked at any time without affecting the primary key

# https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
gpg_generate_rsa_4096_bit_no_expiration_encryption_and_signing_key_pairs_for_git() {
	expect -c "
		# Set timeout for Expect commands (in seconds)
		set timeout 10

		spawn gpg --full-generate-key

		expect \"Your selection?\"
		send \"1\r\"

		expect \"What keysize do you want? (3072)\"
		send \"4096\r\"

		expect \"Key is valid for? (0)\"
		send \"\r\"

		expect \"Is this correct? (y/N)\"
		send \"y\r\"

		expect \"Real name:\"
		send \"$(git config user.name)\r\"

		expect \"Email address:\"
		send \"$(git config user.email)\r\"

		expect \"Comment:\"
		send \"\r\"

		expect \"Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit?\"
		send \"O\r\"

		# Hand over remaining interaction (input of passphrase or password of private key) to the user
		interact
	"
}

gpg_generate_ecc_256_bit_no_expiration_encryption_and_signing_key_pairs_for_git() {
	expect -c "
		# Set timeout for Expect commands (in seconds)
		set timeout 10

		spawn gpg --expert --full-generate-key

		# Select ECC and ECC
		expect \"Your selection?\"
		send \"9\r\"

		# Choose Curve25519 (256-bit, recommended)
		expect \"Please select which elliptic curve you want:\"
		send \"1\r\"

		# No expiration
		expect \"Key is valid for? (0)\"
		send \"\r\"

		# Confirm
		expect \"Is this correct? (y/N)\"
		send \"y\r\"

		expect \"Real name:\"
		send \"$(git config user.name)\r\"

		expect \"Email address:\"
		send \"$(git config user.email)\r\"

		expect \"Comment:\"
		send \"\r\"

		# Confirm key creation
		expect \"Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit?\"
		send \"O\r\"

		# Hand over remaining interaction (input of passphrase or password of private key) to the user
		interact
	"
}

# Setting Up SSH Keys for GitHub
# https://www.youtube.com/watch?v=8X4u9sca3Io
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
ssh_generate_ed25519_authentication_key_pair_for_github() {
	# Define the path for the SSH key file
	local key_file=~/.ssh/id_github
	# Remove any existing key pair with the same name
	rm -rf "${key_file}"{,.pub}
	# Use expect to automate the ssh-keygen prompt for the file path,
	# then let the user manually enter the passphrase
	expect -c "
		# Set the timeout for expect commands (in seconds)
		set timeout 10

		# Start the ssh-keygen command with the user's Git email as a comment
		spawn ssh-keygen -t ed25519 -C \"$(git config user.email)\"

		# Match the prompt asking where to save the key
		expect -re {Enter file in which to save the key.*:}
		send \"${key_file}\r\"

		# Hand over remaining interaction (input of passphrase or password of private key) to the user
		interact
	"
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
	local recipient="$2"
	if [ -z "${file}" ]; then
		echo "no file specified"
		return 1
	elif ! [ -f "${file}" ]; then
		echo "file ${file} does not exist"
		return 1
	fi
	if [ -z "${recipient}" ]; then
		recipient="$(git config user.email)"
	fi
	echo "${file} started"
	# https://news.ycombinator.com/item?id=13382734
	# I like AES256 and SHA512
	if gpg --cipher-algo AES256 --digest-algo SHA512 --cert-digest-algo SHA512 --compress-algo none \
		--s2k-mode 3 --s2k-digest-algo SHA512 --s2k-count 1000000 \
		--encrypt --recipient "${recipient}" --output "${file}".gpg "${file}"; then
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
