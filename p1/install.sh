#!/bin/sh

# install k3s on alpine
sudo apk add curl
curl -sfL https://get.k3s.io | sh -

sudo cat<<EOF>/etc/init.d/k3s
#!/sbin/openrc-run

name="K3S"
command="/usr/local/bin/k3s"
command_args="server"
command_background="yes"
command_user="root"
pidfile="/run/k3s/k3s.pid"
start_stop_daemon_args="--make-pidfile -2 /var/log/k3s/server.log"

depend() {
    need net
}

start_pre() {
    checkpath --directory --owner root:root --mode 0775 /run/k3s /var/log/k3s
}
EOF

sudo rc-service k3s start

# curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl