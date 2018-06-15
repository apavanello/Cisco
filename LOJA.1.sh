#### LOJA 1 #####
####### CONFIG object-group ##########

object-group network RFC1918
10.0.0.0 255.0.0.0
172.16.0.0 255.240.0.0
192.168.0.0 255.255.0.0
exit

object-group network SRC-LAN
 #MUDAR PARA O IP DA REDE LAN DE ORIGEM
 10.10.10.0 /24
 exit

object-group network DEST-LAN
 #MUDAR PARA O IP DA REDE LAN de DESTINO
 10.10.0.0 /24
 exit


######### CONFIG ACLs ###############


ip access-list extended ACL-VPN
 permit ip object-group SRC-LAN  object-group DEST-LAN
 exit


ip access-list extended NAT
 deny   ip any object-group RFC1918
 permit ip any any
 exit


######## CONFIG NAT ###################

ip nat pool POOL-NAT 177.200.0.4 177.200.0.4 prefix-length 24
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


crypto isakmp key VPN-LOJA1 address 200.215.0.2


######## CONFIG PHASE 2 #################

crypto ipsec transform-set LOJA-PHASE2 esp-aes 256 esp-sha-hmac
 mode tunnel
 exit


######## CONFIG CRYPTOMAP ################

crypto map LOJA-MAP 10 ipsec-isakmp
 set peer 200.215.0.2
 set transform-set LOJA-PHASE2
 match address ACL-VPN
 exit


#### ADD NAT INSIDE E NAO OUTSIDE NAS INTERFACES e CRYPTO #####

interface GigabitEthernet0/1
ip nat outside
crypto map LOJA-MAP

interface GigabitEthernet0/0
ip nat inside


exit
