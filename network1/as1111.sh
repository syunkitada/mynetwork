#!/bin/sh

brctl addbr as1111-16-br
ip link set as1111-16-br up

ip link add as111116-veth0 type veth peer name as111116-veth00
brctl addif as1111-16-br as111116-veth0
ip link set as111116-veth0 up

ip link add as111116-veth1 type veth peer name as111116-veth11
brctl addif as1111-16-br as111116-veth1
ip link set as111116-veth1 up


ip link set as111116-veth00 netns as1111
ip netns exec as1111 ip addr add dev as111116-veth00 10.111.1.17/28
ip netns exec as1111 ip link set as111116-veth00 up

ip netns add as1111-16-server1
ip link set as111116-veth11 netns as1111-16-server1
ip netns exec as1111-16-server1 ip addr add dev as111116-veth11 10.111.1.21/28
ip netns exec as1111-16-server1 ip link set lo up
ip netns exec as1111-16-server1 ip link set as111116-veth11 up
ip netns exec as1111-16-server1 route add default gw 10.111.1.17
