#!/bin/sh

brctl addbr tier111-br
ip link set tier111-br up

ip link add tier111br-veth0 type veth peer name as1110-veth
brctl addif tier111-br tier111br-veth0
ip link set tier111br-veth0 up

ip link add tier111br-veth1 type veth peer name as1111-veth
brctl addif tier111-br tier111br-veth1
ip link set tier111br-veth1 up

ip link add tier111br-veth2 type veth peer name as1112-veth
brctl addif tier111-br tier111br-veth2
ip link set tier111br-veth2 up

# as111
ip link set as1110-veth netns tier111
ip netns exec tier111 ip addr add dev as1110-veth 10.111.0.10/24
ip netns exec tier111 ip link set as1110-veth up

# as1111
ip netns add as1111
ip link set as1111-veth netns as1111
ip netns exec as1111 sysctl net.ipv4.ip_forward=1
ip netns exec as1111 ip addr add dev as1111-veth 10.111.0.11/24
ip netns exec as1111 ip link set lo up
ip netns exec as1111 ip link set as1111-veth up
ip netns exec as1111 route add default gw 10.111.0.1

# as1112
ip netns add as1112
ip link set as1112-veth netns as1112
ip netns exec as1112 sysctl net.ipv4.ip_forward=1
ip netns exec as1112 ip addr add dev as1112-veth 10.111.0.12/24
ip netns exec as1112 ip link set lo up
ip netns exec as1112 ip link set as1112-veth up
ip netns exec as1112 route add default gw 10.111.0.1
