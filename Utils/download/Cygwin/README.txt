
点击setup-x86_64.exe安装时，需要将窗口最大化，或者向右拖动下面的滑动条，才能在All右边的Default处看到下拉列表，才能将Default改为Install，这样才能完全安装。

不要添加 --include-source选项，否则需要下载3倍左右大小的文件。

下载之前，系统中应该没有安装Cygwin。如果有安装过Cygwin，需要将安装的痕迹删除(或者重命名)，如将安装目录D:\cygwin64，重命名为cygwin641，让Cygwin的安装程序找不到已经安装的Cygwin的位置。
因为如果Windows中安装过Cygwin，安装程序会在注册表中记录Cygwin的安装位置(D:\cygwin,D:\cygwin64)。使用命令行下载Cygwin时，会自动忽略掉在注册表中记录的Cygwin的安装位置中已经安装的包。

下载时，要关闭或暂停使用FreeGate，Shadowsocks, WireGuard, v2rayN等翻墙软件，否则速度很慢，因为网络流量可能会经过本地代理服务器(FreeGate，Shadowsocks, v2rayN)或者虚拟网卡(WireGuard)。

在凌晨或清早(00:00 - 07:00)，下载，网速最快.


https://cygwin.com/faq/faq.html#faq.setup.cli

Does Setup accept command-line arguments?

Yes, run setup-x86.exe --help or setup-x86_64.exe --help for a list.

Cygwin setup 2.909

Command Line Options:

 -t --allow-test-packages          Consider package versions marked test
    --allow-unsupported-windows    Allow old, unsupported Windows versions
 -a --arch                         Architecture to install (x86_64 or x86)
 -C --categories                   Specify entire categories to install
 -o --delete-orphans               Remove orphaned packages
 -A --disable-buggy-antivirus      Disable known or suspected buggy anti virus
                                   software packages during execution.
 -D --download                     Download packages from internet only
 -f --force-current                Select the current version for all packages
 -h --help                         Print help
 -I --include-source               Automatically install source for every
                                   package installed
 -i --ini-basename                 Use a different basename, e.g. "foo",
                                   instead of "setup"
 -U --keep-untrusted-keys          Use untrusted keys and retain all
 -L --local-install                Install packages from local directory only
 -l --local-package-dir            Local package directory
 -m --mirror-mode                  Skip package availability check when
                                   installing from local directory (requires
                                   local directory to be clean mirror!)
 -B --no-admin                     Do not check for and enforce running as
                                   Administrator
 -d --no-desktop                   Disable creation of desktop shortcut
 -r --no-replaceonreboot           Disable replacing in-use files on next
                                   reboot.
 -n --no-shortcuts                 Disable creation of desktop and start menu
                                   shortcuts
 -N --no-startmenu                 Disable creation of start menu shortcut
 -X --no-verify                    Don't verify setup.ini signatures
    --no-version-check             Suppress checking if a newer version of
                                   setup is available
    --enable-old-keys              Enable old cygwin.com keys
 -O --only-site                    Do not download mirror list.  Only use sites
                                   specified with -s.
 -M --package-manager              Semi-attended chooser-only mode
 -P --packages                     Specify packages to install
 -p --proxy                        HTTP/FTP proxy (host:port)
 -Y --prune-install                Prune the installation to only the requested
                                   packages
 -K --pubkey                       URL or absolute path of extra public key
                                   file (RFC4880 format)
 -q --quiet-mode                   Unattended setup mode
 -c --remove-categories            Specify categories to uninstall
 -x --remove-packages              Specify packages to uninstall
 -R --root                         Root installation directory
 -S --sexpr-pubkey                 Extra DSA public key in s-expr format
 -s --site                         Download site URL
 -u --untrusted-keys               Use untrusted saved extra keys
 -g --upgrade-also                 Also upgrade installed packages
    --user-agent                   User agent string for HTTP requests
 -v --verbose                      Verbose output
 -V --version                      Show version
 -W --wait                         When elevating, wait for elevated child
                                   process

The default is to both download and install packages, unless either --download or --local-install is specified.
