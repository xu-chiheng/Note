windows_launch_browser_in_background() {
	local command="$1"
	if [ -z "${command}" ]; then
		command=chrome
	fi

	# There should be no '&' character in URL

	# proxy
	local sites_0_0=(
		"https://www.youtube.com/?gl=US"
		"https://mail.google.com"
		"https://chat.openai.com"
		"https://claude.ai"
		"https://gemini.google.com"
		"https://copilot.microsoft.com"
		"https://meta.ai"
	)

	# no proxy
	local sites_0_1=(
		"https://www.bilibili.com"
		"https://outlook.live.com"
		"https://chat.deepseek.com"
		"https://www.doubao.com/chat"
		"https://kimi.moonshot.cn"
		"https://tongyi.aliyun.com/qianwen"
		"https://yiyan.baidu.com"
	)

	# NoCountryRedirect (NCR)
	# https://whatis.techtarget.com/definition/NCR-no-country-redirect
	# NCR (no country redirect)
	# Posted by: Margaret Rouse
	# WhatIs.com
	# Contributor(s): Ivy Wigmore
	# NCR (no country redirect) is a Google search parameter that tells the search engine to show results for the country specified in the URL rather than redirecting to the country from which the search is being conducted.
	# When you go to Google.com, Google automatically detects your location and then redirects their URL to the one for your country. If you live in the United Kingdom, for example, Google.com resolves to Google.co.uk. Google search engine results pages (SERP) for various countries can be quite different because they display pages from the user's country more prominently. That behavior might be useful for someone looking for a nearby location, business or product but is less helpful for other types of searches, such as research, for which relevance to the search query is often the most important criteria.
	# To ensure that Google returns results from the .com domain rather than one specific to a non-U.S. country, type a forward slash (/) and the letters ncr after the URL. Marketers and website owners can also use NCR to monitor page ranking in various countries. To do that, add /ncr to the Google URL for the country in question.
	# See a video demonstration of using NCR to stop Google from redirecting to the user's country:


	# Google GL Parameter: Supported Google Countries
	# https://serpapi.com/google-countries

	# Using Google’s GL Parameter to Beat Geo-Targeting
	# https://www.stayonsearch.com/using-googles-gl-parameter-to-beat-geo-targeting



	local sites_1=(
		"https://www.google.com/ncr"
		"https://www.youtube.com/?gl=US"
		"https://duckduckgo.com"
	)

	local sites_2=(
		"https://www.baidu.com"
		"https://www.bing.com"
	)

	local sites_3=(
		"https://www.2345.com"
		"https://hao.360.com"
		"https://hao.qq.com"
		"https://123.sogou.com"
		"https://www.hao123.com"
	)

	local sites_4=(
		"https://translate.google.com/?tl=zh-CN"
		"https://translate.google.com/?tl=en"
	)

	local sites_5=(
		"https://www.bing.com/translator"
	)

	local args=()
	local browser_path
	case "${command}" in
		tor_browser )
			browser_path='D:\Tor Browser\Browser\firefox.exe'
			args+=( )
			;;
		firefox* )
			browser_path='C:\Program Files\Mozilla Firefox\firefox.exe'
			case "${command}" in
				*private_mode* )
					args+=( -private )
					;;
			esac
			case "${command}" in
				firefox | firefox_private_mode )
					args+=( "${sites_1[@]}" "${sites_2[@]}" "${sites_3[@]}" )
					;;
				* )
					echo "Unknown command '${command}'!"
					return 1
					;;
			esac
			;;
		chrome* | edge* )
			# https://www.maketecheasier.com/useful-chrome-command-line-switches/
			args+=(
				--start-maximized
				--new-window
				# --disable-extensions
				# --disable-plugins
				# --disable-notifications
				# --disable-sync
				# --no-referrers
				# --dns-prefetch-disable
				# --disable-background-mode
				# --disable-translate
			)
			case "${command}" in
				*no_proxy_server* )
					# Edge command line options "--no-proxy-server" doesn't work
					# https://techcommunity.microsoft.com/t5/discussions/edge-command-line-options-quot-no-proxy-server-quot-doesn-t-work/m-p/3680836
					# How to use Microsoft Edge command-line options to configure proxy settings
					# https://learn.microsoft.com/en-us/deployedge/edge-learnmore-cmdline-options-proxy-settings

					# Settings -> System and performance
					# uncheck "Startup boost" and "Continue running background extensions and apps when Microsoft Edge is closed"

					args+=( --no-proxy-server )
					;;
			esac
			case "${command}" in
				chrome* )
					browser_path='C:\Program Files\Google\Chrome\Application\chrome.exe'
					case "${command}" in
						*incognito_mode* )
							args+=( --incognito )
							;;
					esac
					case "${command}" in
						chrome )
							args+=( "${sites_0_0[@]}" )
							;;
						chrome_incognito_mode )
							args+=( "${sites_1[@]}" "${sites_2[@]}" "${sites_4[@]}" )
							;;
						# https://www.chromium.org/developers/design-documents/network-settings/
						# --no-proxy-server
						# This tells Chrome not to use a Proxy. It overrides any other proxy settings provided.
						chrome_no_proxy_server )
							args+=( "${sites_0_1[@]}" )
							;;
						chrome_no_proxy_server_incognito_mode )
							args+=( "${sites_2[@]}" "${sites_3[@]}" "${sites_5[@]}" )
							;;
						* )
							echo "Unknown command '${command}'!"
							return 1
							;;
					esac
					;;
				edge* )
					browser_path='C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
					case "${command}" in
						*inprivate_mode* )
							args+=( --inprivate )
							;;
					esac
					case "${command}" in
						edge )
							args+=( "${sites_0_0[@]}" )
							;;
						edge_inprivate_mode )
							args+=( "${sites_1[@]}" "${sites_2[@]}" "${sites_4[@]}" )
							;;
						edge_no_proxy_server )
							args+=( "${sites_0_1[@]}" )
							;;
						edge_no_proxy_server_inprivate_mode )
							args+=( "${sites_2[@]}" "${sites_3[@]}" "${sites_5[@]}" )
							;;
						* )
							echo "Unknown command '${command}'!"
							return 1
							;;
					esac
					;;
			esac
			;;
		* )
			echo "Unknown command '${command}'!"
			return 1
			;;
	esac

	windows_launch_program_in_background "${browser_path}" "${args[@]}"
}
