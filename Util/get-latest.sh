# VPS SSH login as root
cd ~
rm -rf .git Note .bashrc.d Util
git clone https://github.com/xu-chiheng/Note -b main
mv Note/.git ./
rm -rf Note
git reset --hard HEAD
