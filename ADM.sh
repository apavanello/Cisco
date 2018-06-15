#### ADM ####
####### CONFIG object-group ##########

object-group network RFC1918
10.0.0.0 255.0.0.0
172.16.0.0 255.240.0.0
192.168.0.0 255.255.0.0
exit

 object-group network LAN-ADM
 10.10.0.0 /24
 exit

object-group network LAN-LOJA1
 10.10.10.0 /24
 exit

object-group network LAN-LOJA2
 10.10.20.0 /24
 exit

 object-group network LAN-LOJA3
 10.10.30.0 /24
 exit



######### CONFIG ACLs ###############


ip access-list extended ACL-VPN-LOJA1
 permit ip object-group LAN-ADM object-group LAN-LOJA1
 exit

ip access-list extended ACL-VPN-LOJA2
 permit ip object-group LAN-ADM object-group LAN-LOJA2
 exit

ip access-list extended ACL-VPN-LOJA3
 permit ip object-group LAN-ADM object-group LAN-LOJA3
 exit

ip access-list extended NAT
 deny   ip any object-group RFC1918
 permit ip any any
 exit

 
######## CONFIG NAT ###################

ip nat pool POOL-NAT 200.215.0.2 200.215.0.2 prefix-length 24
ip nat inside source list NAT pool POOL-NAT overload


########## CONFIG PHASE 1 #############

crypto isakmp policy 2
 encr aes 256
 hash sha256
 authentication pre-share
 group 16
 lifetime 18000
 exit


######## CONFIG PSK PHASE 1 #############

crypto isakmp key VPN-LOJA1 address 177.200.0.4
crypto isakmp key VPN-LOJA2 address 178.111.2.3
crypto isakmp key VPN-LOJA3 address 200.1.4.12


######## CONFIG PHASE 2 #################

crypto ipsec transform-set LOJA-1-PHASE2 esp-aes 256 esp-sha-hmac
 mode tunnel
 exit
crypto ipsec transform-set LOJA-2-PHASE2 esp-aes 256 esp-sha-hmac
 mode tunnel
 exit
crypto ipsec transform-set LOJA-3-PHASE2 esp-aes 256 esp-sha-hmac
 mode tunnel
 exit



######## CONFIG CRYPTOMAP ################

crypto map LOJA-MAP 1 ipsec-isakmp
 set peer 177.200.0.4
 set transform-set LOJA-1-PHASE2
 match address ACL-VPN-LOJA1
 exit

crypto map LOJA-MAP 2 ipsec-isakmp
 set peer 178.111.2.3
 set transform-set LOJA-2-PHASE2
 match address ACL-VPN-LOJA2
 exit
 
crypto map LOJA-MAP 3 ipsec-isakmp
 set peer 200.1.4.12
 set transform-set LOJA-3-PHASE2
 match address ACL-VPN-LOJA3
 exit

#### ADD NAT INSIDE E NAO OUTSIDE NAS INTERFACES e CRYPTO #####

interface GigabitEthernet0/1
ip nat outside
crypto map LOJA-MAP

interface GigabitEthernet0/0
ip nat inside


exit
