#!/bin/sh

#move the gateway configs
cp gw_ipsec.conf lab/gw.u1834961-u1824952.cyber.test/etc/ipsec.conf
cp gw_ipsec.secrets lab/gw.u1834961-u1824952.cyber.test/etc/ipsec.secrets

#move client configs into mobusr1
cp client_ipsec.conf lab/mobusr1/etc/ipsec.conf
cp client_ipsec.secrets lab/mobusr1/etc/ipsec.secrets

#move client configs into mobusr2
cp client_ipsec.conf lab/mobusr2/etc/ipsec.conf
cp client_ipsec.secrets lab/mobusr2/etc/ipsec.secrets

#move client configs into mobusr3
cp client_ipsec.conf lab/mobusr3/etc/ipsec.conf
cp client_ipsec.secrets lab/mobusr3/etc/ipsec.secrets


#update the ipsec.conf files with the correct leftid parameters
sed 's/{DEVICENAME}/mobusr1/g' -i lab/mobusr1/etc/ipsec.conf
sed 's/{DEVICENAME}/mobusr2/g' -i lab/mobusr2/etc/ipsec.conf
sed 's/{DEVICENAME}/mobusr3/g' -i lab/mobusr3/etc/ipsec.conf