#!/usr/bin/env bash
# Made and written by Alexander Trost (c)2016

echo "=== ip link show"
ip link show
echo "=== ip addr show"
ip addr show
echo "==="
iptables-save || (iptables -L; iptables -t nat -L)
