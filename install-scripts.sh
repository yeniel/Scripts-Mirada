#!/bin/sh

chmod +x *

./install_gcalcli.sh

path=$(pwd)

ln -sf "$path"/annotate-line.sh /usr/local/bin/annotate-line
ln -sf "$path"/connect-vpn.sh /usr/local/bin/connect-vpn
ln -sf "$path"/disconnect-vpn.sh /usr/local/bin/disconnect-vpn
ln -sf "$path"/unit4.sh /usr/local/bin/unit4
ln -sf "$path"/description-for-commit.sh /usr/local/bin/description-for-commit
