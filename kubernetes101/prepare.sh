#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

KUBERNETES_VERSION="1.2.0"

cd "$DIR" || exit 1

wget "https://github.com/kubernetes/kubernetes/releases/download/v$KUBERNETES_VERSION/kubernetes.tar.gz" -O "$DIR/kubernetes.tar.gz"
tar xfz "$DIR/kubernetes.tar.gz"
rm -rf "$DIR/kubernetes/contrib/*"
git clone https://github.com/kubernetes/contrib.git "$DIR/kubernetes/contrib/"
rm -rf "$DIR/kubernetes/contrib/ansible"

cd "$DIR/kubernetes/server" || exit 1

tar xfz "$DIR/kubernetes/server/kubernetes-server-linux-amd64.tar.gz"
tar xfz "$DIR/kubernetes/server/kubernetes-salt.tar.gz"
cp -r "$DIR/kubernetes/server/kubernetes/saltbase" "$DIR/kubernetes/cluster"
cp -r "$DIR/kubernetes/server/kubernetes/saltbase" "$DIR/kubernetes/contrib"

mkdir -p "$DIR/kubernetes/_output/local/go"
cp -r "$DIR/kubernetes/server/kubernetes/server/bin" "$DIR/kubernetes/_output/local/go"
cp -r "$DIR/ansible" "$DIR/kubernetes/contrib"

echo ""
echo "=> Files prepared. Done."
