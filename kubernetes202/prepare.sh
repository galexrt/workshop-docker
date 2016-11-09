#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

KUBERNETES_VERSION="v1.4.5"
ETCD_VERSION="3.0.14"
FLANNEL_VERSION="0.6.2"


cd "$DIR" || exit 1

wget "https://github.com/kubernetes/kubernetes/releases/download/$KUBERNETES_VERSION/kubernetes.tar.gz" -O "$DIR/kubernetes.tar.gz"
tar xfz "$DIR/kubernetes.tar.gz"
rm -rf "$DIR/kubernetes/contrib"
git clone https://github.com/kubernetes/contrib.git "$DIR/kubernetes/contrib/"

cd "$DIR/kubernetes/server" || exit 1

tar xfz "$DIR/kubernetes/server/kubernetes-server-linux-amd64.tar.gz"
tar xfz "$DIR/kubernetes/server/kubernetes-salt.tar.gz"
cp -r "$DIR/kubernetes/server/kubernetes/saltbase" "$DIR/kubernetes/cluster"
cp -r "$DIR/kubernetes/server/kubernetes/saltbase" "$DIR/kubernetes/contrib"

mkdir -p "$DIR/kubernetes/_output/local/go"
cp -r "$DIR/kubernetes/server/kubernetes/server/bin" "$DIR/kubernetes/_output/local/go"
wget "https://github.com/coreos/etcd/releases/download/v3.0.14/etcd-v$ETCD_VERSION-linux-amd64.tar.gz" -O "$DIR/kubernetes/etcd-v$ETCD_VERSION.tar.gz"
wget "https://github.com/coreos/flannel/releases/download/v0.6.2/flannel-v$FLANNEL_VERSION-linux-amd64.tar.gz" -O "$DIR/kubernetes/flannel-v$FLANNEL_VERSION-linux-amd64.tar.gz"

echo "etcd_version: $FLANNEL_VERSION" >> "$DIR/kubernetes/contrib/ansible/inventory/group_vars/all.yml"
echo "localBuildOutput: \"../../../etcd-v{{ etcd_version }}-linux-amd64.tar.gz\"" >> "$DIR/kubernetes/contrib/ansible/roles/etcd/defaults/main.yaml"
echo "flannel_version: $FLANNEL_VERSION" >> "$DIR/kubernetes/contrib/ansible/inventory/group_vars/all.yml"
echo "localBuildOutput: \"../../../flannel-{{ flannel_version }}-linux-amd64.tar.gz\"" >> "$DIR/kubernetes/contrib/ansible/roles/flannel/defaults/main.yaml"

cat <<EOF >> "$DIR/kubernetes/contrib/ansible/inventory/group_vars/all.yml"
source_type: localBuild

kube_source_type: localBuild
etcd_source_type: localBuild
flannel_source_type: localBuild
EOF

cp -rf "$DIR/patched_files/"* "$DIR/kubernetes/"

echo "++++++++++++++++++++++++++++++++++"
echo "=> Files prepared. Done."
echo "=> Please go into the 'kubernetes/contrib/ansible' directory and"
echo "=> Create your inventory and modify the 'inventory/group_vars/all.yml'"
echo "=> according to your setup."
echo "=> After that go into the 'scripts/' folder run the './deploy-cluster.sh'"
echo "=> with '-vv' as an argument."
