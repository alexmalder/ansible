iptables.postfix:
  cmd.run:
    - names:
      - service iptables save
      - iptables -S
      - iptables -t nat -d 192.168.0.0/24 -A POSTROUTING -j MASQUERADE
      - iptables -A FORWARD -p icmp --icmp-type echo-request -j ACCEPT
