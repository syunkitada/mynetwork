#!/bin/sh

brctl addbr tier11-br
ip link set tier11-br up

ip link add tier11-br-veth0 type veth peer name tier110-veth
brctl addif tier11-br tier11-br-veth0
ip link set tier11-br-veth0 up

ip link add tier11-br-veth1 type veth peer name tier111-veth
brctl addif tier11-br tier11-br-veth1
ip link set tier11-br-veth1 up

ip link add tier11-br-veth2 type veth peer name tier112-veth
brctl addif tier11-br tier11-br-veth2
ip link set tier11-br-veth2 up


ip link set tier110-veth netns tier11
ip netns exec tier11 ip addr add dev tier110-veth 10.110.0.10/24
ip netns exec tier11 ip link set tier110-veth up

ip netns add tier111
ip link set tier111-veth netns tier111
ip netns exec tier111 ip addr add dev tier111-veth 10.110.0.11/24
ip netns exec tier111 ip link set lo up
ip netns exec tier111 ip link set tier111-veth up
ip netns exec tier111 route add default gw 10.110.0.1

ip netns add tier112
ip link set tier112-veth netns tier112
ip netns exec tier112 ip addr add dev tier112-veth 10.110.0.12/24
ip netns exec tier112 ip link set lo up
ip netns exec tier112 ip link set tier112-veth up
ip netns exec tier112 route add default gw 10.110.0.1
