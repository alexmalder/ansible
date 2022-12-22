iptables.flush:
  cmd.run:
    - names:
      - iptables -F
      - iptables -F -t nat
      - iptables -F -t mangle
      - iptables -X
      - iptables -t nat -X
      - iptables -t mangle -X
      - iptables -P INPUT ACCEPT
      - iptables -P OUTPUT ACCEPT
      - iptables -P FORWARD ACCEPT
      - iptables -P FORWARD DROP
      - iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
