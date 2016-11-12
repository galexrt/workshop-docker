#!/bin/bash

echoOut

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

KUBERNETES_VERSION="1.4.6"
ETCD_VERSION="3.0.14"
FLANNEL_VERSION="0.6.2"

cd "$DIR" || exit 1

echo "-> Checking for kubernetes tar (version: v$KUBERNETES_VERSION)"
if [ ! -f "$DIR/kubernetes-v$KUBERNETES_VERSION.tar.gz" ]; then
    echo "-> Downloading Kubernetes tar, version: v$KUBERNETES_VERSION ..."
    # Download and extract kubernetes release tar.gz
    wget "https://github.com/kubernetes/kubernetes/releases/download/v$KUBERNETES_VERSION/kubernetes.tar.gz" -O "$DIR/kubernetes-v$KUBERNETES_VERSION.tar.gz"
    rm -rf "$DIR/kubernetes"
    echo "=> Download of Kubernetes tar, version v$KUBERNETES_VERSION completed."
else
    echo "=> Kubernetes tar version: v$KUBERNETES_VERSION found."
fi
echo "-> Extracting Kubernetes tar ..."
tar xfz "$DIR/kubernetes-v$KUBERNETES_VERSION.tar.gz"
echo "=> Kubernetes tar extracted."

# Download etcd and flanneld
echo "-> Downloading etcd (version v$ETCD_VERSION) ..."
if [ ! -f "$DIR/kubernetes/etcd-v$ETCD_VERSION-linux-amd64.tar.gz" ]; then
    wget "https://github.com/coreos/etcd/releases/download/v$ETCD_VERSION/etcd-v$ETCD_VERSION-linux-amd64.tar.gz" -O "$DIR/kubernetes/etcd-v$ETCD_VERSION-linux-amd64.tar.gz"
fi
echo "=> Download of etcd complete."
echo "-> Downloading flannel  (version v$FLANNEL_VERSION) ..."
if [ ! -f "$DIR/kubernetes/flannel-v$FLANNEL_VERSION-linux-amd64.tar.gz" ]; then
    wget "https://github.com/coreos/flannel/releases/download/v$FLANNEL_VERSION/flannel-v$FLANNEL_VERSION-linux-amd64.tar.gz" -O "$DIR/kubernetes/flannel-v$FLANNEL_VERSION-linux-amd64.tar.gz"
fi
echo "=> Download of flannel complete."

# Remove "empty" original kubernetes contrib folder and replace with official repository
echo "-> Replacing original contrib folder with \"kubernetes/contrib\" repo ..."
rm -rf "$DIR/kubernetes/contrib"
git clone https://github.com/kubernetes/contrib.git "$DIR/kubernetes/contrib/"
echo "=> Replacement complete."

cd "$DIR/kubernetes/server" || exit 1

echo "-> Extracting kubernetes binaries, salt( and pepper) ..."
# Extract kubernetes tar and co.
tar xfz "$DIR/kubernetes/server/kubernetes-server-linux-amd64.tar.gz"
tar xfz "$DIR/kubernetes/server/kubernetes-salt.tar.gz"
cp -r "$DIR/kubernetes/server/kubernetes/saltbase" "$DIR/kubernetes/cluster"

echo "-> The kubernetes files are right where you left them.. (W10)"
# Create kubernetes binary folder
mkdir -p "$DIR/kubernetes/_output/local/go"
cp -r "$DIR/kubernetes/server/kubernetes/server/bin" "$DIR/kubernetes/_output/local/go"
echo "=> Extraction and placement of kubernetes binaries is completed."

# Add source_type (and other misc) vars to the all group variables
cat <<EOF >> "$DIR/kubernetes/contrib/ansible/inventory/group_vars/all.yml"
etcd_version: $ETCD_VERSION
flannel_version: $FLANNEL_VERSION

source_type: localBuild
kube_source_type: localBuild
etcd_source_type: localBuild
flannel_source_type: localBuild

# Special options to fix some "common" problems
flannel_opts: "-ip-masq=true"
kube_master_api_port: 8443
EOF

echo "-> Patching kubernetes files with some \e[104mMAGIC\e[49m ..."
# Overwrite "official" files with some "patched"/updated files
cp -rf "$DIR/patched_files/"* "$DIR/kubernetes/"
echo "=> Patched kubernetes files."

echo "++++++++++++++++++++++++++++++++++"
echo "=> Please go into the 'kubernetes/contrib/ansible' directory."
echo "=> Create your inventory at 'kubernetes/contrib/ansible/inventory/inventory'."
echo "=> Modify the 'inventory/group_vars/all.yml' according to your needs."
echo "=> After that go into the 'scripts/' folder run one of the scripts, details see below:"
echo " * './deploy-cluster.sh' deploys everything"
echo " * './deploy-master.sh;./deploy-node.sh' deploys \"only\" the master and node binaries (perfect for updating kubernetes)"
echo "=> Add '-vv' as an argument for verbose output (the more \"v\" the more)."
echo -e "\e[5m\e[41m==>> DON'T FORGET TO CONFIGURE THE VARIABLES IN 'inventory/group_vars/all.yml' <<==\e[25m"
echo ""
