#!/bin/sh

#move the gateway configs
cp gw_ipsec.conf gw.u1834961-u1824952.cyber.test/etc/ipsec.conf
cp gw_ipsec.secrets gw.u1834961-u1824952.cyber.test/etc/ipsec.secrets

#move client configs into mobusr1
cp client_ipsec.conf mobusr1/etc/ipsec.conf
cp client_ipsec.secrets mobusr1/etc/ipsec.secrets

#move client configs into mobusr2
cp client_ipsec.conf mobusr2/etc/ipsec.conf
cp client_ipsec.secrets mobusr2/etc/ipsec.secrets

#move client configs into mobusr3
cp client_ipsec.conf mobusr3/etc/ipsec.conf
cp client_ipsec.secrets mobusr3/etc/ipsec.secrets


#update the ipsec.conf files with the correct leftid parameters
sed 's/{DEVICENAME}/mobusr1/g' -i mobusr1/etc/ipsec.conf
sed 's/{DEVICENAME}/mobusr2/g' -i mobusr2/etc/ipsec.conf
sed 's/{DEVICENAME}/mobusr3/g' -i mobusr3/etc/ipsec.conf