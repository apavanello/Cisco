#### ADM ####
####### CONFIG object-group ##########

object-group network RFC1918
10.0.0.0 255.0.0.0
172.16.0.0 255.240.0.0
192.168.0.0 255.255.0.0
exit


######### CONFIG ACLs ###############


ip access-list extended ACL-VPN-LOJA1
 permit ip 10.10.0.0 0.0.0.255 10.10.10.0 0.0.0.255
 exit

ip access-list extended ACL-VPN-LOJA2
 permit ip 10.10.0.0 0.0.0.255 10.10.20.0 0.0.0.255
 exit

ip access-list extended ACL-VPN-LOJA3
 permit ip 10.10.0.0 0.0.0.255 10.10.30.0 0.0.0.255
 exit

ip access-list extended NAT
 deny   ip any object-group RFC1918
 permit ip any any
 exit

 
######## CONFIG NAT ###################

ip nat inside source list NAT interface G 0/1 overload

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



#############################################################
################################################################
##############################################################


#### LOJA 1 #####
####### CONFIG object-group ##########

object-group network RFC1918
10.0.0.0 255.0.0.0
172.16.0.0 255.240.0.0
192.168.0.0 255.255.0.0
exit



######### CONFIG ACLs ###############


ip access-list extended ACL-VPN
 permit ip 10.10.0.0 0.0.0.255 10.10.0.0 0.0.0.255
 exit

ip access-list extended NAT
 deny   ip any object-group RFC1918
 permit ip any any
 exit



######## CONFIG NAT ###################

#ip nat pool POOL-NAT 177.200.0.4 177.200.0.4 prefix-length 24


ip nat inside source list NAT interface G 0/1 overload


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
 match address 2001
 exit


#### ADD NAT INSIDE E NAO OUTSIDE NAS INTERFACES e CRYPTO #####

interface GigabitEthernet0/1
ip nat outside
crypto map LOJA-MAP

interface GigabitEthernet0/0
ip nat inside


###############################################################
###################################LOJA 2 ####################
##############################################################


#### LOJA 1 #####
####### CONFIG object-group ##########

object-group network RFC1918
10.0.0.0 255.0.0.0
172.16.0.0 255.240.0.0
192.168.0.0 255.255.0.0
exit



######### CONFIG ACLs ###############


ip access-list extended ACL-VPN
 permit ip 10.10.20.0 0.0.0.255 10.10.0.0 0.0.0.255
 exit

ip access-list extended NAT
 deny   ip any object-group RFC1918
 permit ip any any
 exit



######## CONFIG NAT ###################

#ip nat pool POOL-NAT 177.200.0.4 177.200.0.4 prefix-length 24


ip nat inside source list NAT interface G 0/1 overload


########## CONFIG PHASE 1 #############

crypto isakmp policy 2
 encr aes 256
 hash sha256
 authentication pre-share
 group 16
 lifetime 18000
 exit


######## CONFIG PSK PHASE 1 #############


crypto isakmp key VPN-LOJA2 address 200.215.0.2


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







###############################################################
###################################LOJA 3 ####################
##############################################################


#### LOJA 1 #####
####### CONFIG object-group ##########

object-group network RFC1918
10.0.0.0 255.0.0.0
172.16.0.0 255.240.0.0
192.168.0.0 255.255.0.0
exit



######### CONFIG ACLs ###############


ip access-list extended ACL-VPN
 permit ip 10.10.30.0 0.0.0.255 10.10.0.0 0.0.0.255
 exit

ip access-list extended NAT
 deny   ip any object-group RFC1918
 permit ip any any
 exit



######## CONFIG NAT ###################

#ip nat pool POOL-NAT 177.200.0.4 177.200.0.4 prefix-length 24


ip nat inside source list NAT interface G 0/1 overload


########## CONFIG PHASE 1 #############

crypto isakmp policy 2
 encr aes 256
 hash sha256
 authentication pre-share
 group 16
 lifetime 18000
 exit


######## CONFIG PSK PHASE 1 #############


crypto isakmp key VPN-LOJA3 address 200.215.0.2


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


