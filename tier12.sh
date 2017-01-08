#!/bin/sh

brctl addbr tier12-br
ip link set tier12-br up

ip link add tier12-br-veth0 type veth peer name tier120-veth
brctl addif tier12-br tier12-br-veth0
ip link set tier12-br-veth0 up

ip link add tier12-br-veth1 type veth peer name tier121-veth
brctl addif tier12-br tier12-br-veth1
ip link set tier12-br-veth1 up

ip link add tier12-br-veth2 type veth peer name tier122-veth
brctl addif tier12-br tier12-br-veth2
ip link set tier12-br-veth2 up


ip link set tier120-veth netns tier12
ip netns exec tier12 ip addr add dev tier120-veth 10.120.0.10/24
ip netns exec tier12 ip link set tier120-veth up

ip netns add tier121
ip link set tier121-veth netns tier121
ip netns exec tier121 ip addr add dev tier121-veth 10.120.0.11/24
ip netns exec tier121 ip link set lo up
ip netns exec tier121 ip link set tier121-veth up
ip netns exec tier121 route add default gw 10.120.0.1

ip netns add tier122
ip link set tier122-veth netns tier122
ip netns exec tier122 ip addr add dev tier122-veth 10.120.0.12/24
ip netns exec tier122 ip link set lo up
ip netns exec tier122 ip link set tier122-veth up
ip netns exec tier122 route add default gw 10.120.0.1
