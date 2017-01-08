#!/bin/sh

yum install -y epel-release
yum install -y bridge-utils bird vim tcpdump traceroute


brctl addbr tier1-br
ip link set tier1-br up

ip link add tier1-br-veth1 type veth peer name tier11-veth
brctl addif tier1-br tier1-br-veth1
ip link set tier1-br-veth1 up

ip link add tier1-br-veth2 type veth peer name tier12-veth
brctl addif tier1-br tier1-br-veth2
ip link set tier1-br-veth2 up

ip link add tier1-br-veth3 type veth peer name tier13-veth
brctl addif tier1-br tier1-br-veth3
ip link set tier1-br-veth3 up


ip netns add tier11
ip link set tier11-veth netns tier11
ip netns exec tier11 sysctl net.ipv4.ip_forward=1
ip netns exec tier11 ip addr add dev tier11-veth 10.1.0.11/24
ip netns exec tier11 ip link set lo up
ip netns exec tier11 ip link set tier11-veth up
ip netns exec tier11 route add default gw 10.1.0.1

ip netns add tier12
ip link set tier12-veth netns tier12
ip netns exec tier12 sysctl net.ipv4.ip_forward=1
ip netns exec tier12 ip addr add dev tier12-veth 10.1.0.12/24
ip netns exec tier12 ip link set lo up
ip netns exec tier12 ip link set tier12-veth up
ip netns exec tier12 route add default gw 10.1.0.1

ip netns add tier13
ip link set tier13-veth netns tier13
ip netns exec tier13 sysctl net.ipv4.ip_forward=1
ip netns exec tier13 ip addr add dev tier13-veth 10.1.0.13/24
ip netns exec tier13 ip link set lo up
ip netns exec tier13 ip link set tier13-veth up
ip netns exec tier13 route add default gw 10.1.0.1


mkdir -p /etc/bird/
