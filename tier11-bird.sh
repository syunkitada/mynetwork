#!/bin/sh

cat << EOT > /etc/bird/tier111-bird.conf
router id 10.110.0.11;

log syslog { debug, trace, info, remote, warning, error, auth, fatal, bug };
log stderr all;
log "tmp" all;

protocol device {
  scan time 10; # Scan interfaces every 10 seconds
}

protocol direct {
  interface "*veth*", "*"; # Restrict network interfaces it works with
}

template bgp bgp_template {
  local as 65110;
  multihop;

  hold time 240;
  startup hold time 240;
  connect retry time 120;
  keepalive time 80;       # defaults to hold time / 3
  start delay time 5;      # How long do we wait before initial connect
  error wait time 60, 300; # Minimum and maximum time we wait after an error (when consecutive
                           # errors occur, we increase the delay exponentially ...
  error forget time 300;   # ... until this timeout expires)
  disable after error;     # Disable the protocol automatically when an error occurs
  next hop self;           # Disable next hop processing and always advertise our local address as nexthop
}

protocol bgp Mesh_10_110_0_10 from bgp_template {
  neighbor 10.110.0.10 as 65100;
}
EOT

cat << EOT > /etc/bird/tier112-bird.conf
router id 10.110.0.12;

log syslog { debug, trace, info, remote, warning, error, auth, fatal, bug };
log stderr all;
log "tmp" all;

protocol device {
  scan time 10; # Scan interfaces every 10 seconds
}

protocol direct {
  interface "*veth*", "*"; # Restrict network interfaces it works with
}

template bgp bgp_template {
  local as 65120;
  multihop;

  hold time 240;
  startup hold time 240;
  connect retry time 120;
  keepalive time 80;       # defaults to hold time / 3
  start delay time 5;      # How long do we wait before initial connect
  error wait time 60, 300; # Minimum and maximum time we wait after an error (when consecutive
                           # errors occur, we increase the delay exponentially ...
  error forget time 300;   # ... until this timeout expires)
  disable after error;     # Disable the protocol automatically when an error occurs
  next hop self;           # Disable next hop processing and always advertise our local address as nexthop
}

protocol bgp Mesh_10_110_0_10 from bgp_template {
  neighbor 10.110.0.10 as 65100;
}
EOT

ip netns exec tier111 bird -c /etc/bird/tier111-bird.conf -P /var/run/tier111-bird.pid -s /var/run/tier111-bird.ctl
ip netns exec tier112 bird -c /etc/bird/tier112-bird.conf -P /var/run/tier112-bird.pid -s /var/run/tier112-bird.ctl

ip netns exec tier111 netstat -an
ip netns exec tier112 netstat -an
