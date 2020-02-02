#!/bin/sh

mkdir -p tmp-keys
cd tmp-keys

###############################################################################################################
###############################################################################################################
#Root certificate creation

# generate root CA key
ipsec pki --gen --type rsa --size 4096 --outform pem > CA.key.pem

# generate root certificate
ipsec pki --self --ca --lifetime 3650 --in CA.key.pem --type rsa --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU=ISS CW2, CN=Certificate Authority" --outform pem > CA.crt.pem

###############################################################################################################
###############################################################################################################
#www certificate creation

# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > www.key.pem

# generate csr
ipsec pki --pub --in www.key.pem --type rsa --outform pem > www.csr.pem

# sign certificate with root certificate
ipsec pki --issue --in www.csr.pem --lifetime 365 --cacert CA.crt.pem --cakey CA.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU=ISS CW2, CN=www.u1834961-u1824952.cyber.test" --san 213.1.133.3 --san @213.1.133.3 --flag serverAuth --flag ikeIntermediate --outform pem > www.crt.pem

###############################################################################################################
###############################################################################################################
#vpn gw certificate creation

# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > gw.key.pem

# generate csr
ipsec pki --pub --in gw.key.pem --type rsa --outform pem > gw.csr.pem

# sign certificate with root certificate
ipsec pki --issue --in gw.csr.pem --lifetime 365 --cacert CA.crt.pem --cakey CA.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU=ISS CW2, CN=gw.u1834961-u1824952.cyber.test" --san 213.1.133.2 --san @213.1.133.2 --san 192.168.65.1 --san @192.168.65.1 --flag serverAuth --flag ikeIntermediate --outform pem > gw.crt.pem

###############################################################################################################
###############################################################################################################
# ICA
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > ica.key.pem

#generate csr
ipsec pki --pub --in ica.key.pem --type rsa --outform pem > ica.csr.pem

# sign certificate with root certificate
ipsec pki --issue --in ica.csr.pem --lifetime 365 --cacert CA.crt.pem --cakey CA.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU=ISS CW2, CN=i_ca.cyber.test" --san 192.168.65.5 --san @192.168.65.5 --flag serverAuth --flag ikeIntermediate --outform pem > ica.crt.pem

###############################################################################################################
###############################################################################################################

#mobUsr1
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > mobusr1.key.pem

#generate csr
ipsec pki --pub --in mobusr1.key.pem --type rsa --outform pem > mobusr1.csr.pem

#sign certificate with Intermediate Certificate authority -- no san due to mobile users having multiple IPs
ipsec pki --issue --in mobusr1.csr.pem --lifetime 365 --cacert ica.crt.pem --cakey ica.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU =ISS CW2, CN=mobusr1" --flag serverAuth --flag ikeIntermediate --outform pem > mobusr1.crt.pem

###############################################################################################################
###############################################################################################################

#mobUsr2
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > mobusr2.key.pem

#generate csr
ipsec pki --pub --in mobusr2.key.pem --type rsa --outform pem > mobusr2.csr.pem

#sign certificate with Intermediate Certificate authority -- no san due to mobile users having multiple IPs
ipsec pki --issue --in mobusr2.csr.pem --lifetime 365 --cacert ica.crt.pem --cakey ica.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU =ISS CW2, CN=mobusr2" --flag serverAuth --flag ikeIntermediate --outform pem > mobusr2.crt.pem

###############################################################################################################
###############################################################################################################

#mobUsr3
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > mobusr3.key.pem

#generate csr
ipsec pki --pub --in mobusr3.key.pem --type rsa --outform pem > mobusr3.csr.pem

#sign certificate with Intermediate Certificate authority -- no san due to mobile users having multiple IPs
ipsec pki --issue --in mobusr3.csr.pem --lifetime 365 --cacert ica.crt.pem --cakey ica.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU =ISS CW2, CN=mobusr3" --flag serverAuth --flag ikeIntermediate --outform pem > mobusr3.crt.pem

###############################################################################################################
###############################################################################################################
# move keys/certificates to right place


# move CA keys
mv CA.key.pem ../CA/etc/ipsec.d/private/
mv CA.crt.pem ../CA/etc/ipsec.d/cacerts/

# move gw keys
mv gw.key.pem ../gw.u1834961-u1824952.cyber.test/etc/ipsec.d/private/
mv gw.crt.pem ../gw.u1834961-u1824952.cyber.test/etc/ipsec.d/cacerts/

# move www keys
mv www.key.pem ../www.u1834961-u1824952.cyber.test/etc/ipsec.d/private/
mv www.crt.pem ../www.u1834961-u1824952.cyber.test/etc/ipsec.d/cacerts/

#move icakeys
mv ica.key.pem ../i_ca.cyber.test/etc/ipsec.d/private
mv ica.crt.pem ../i_ca.cyber.test/etc/ipsec.d/cacerts

#move mobusr1 keys
mv mobusr1.key.pem ../mobusr1/etc/ipsec.d/private
mv mobusr1.crt.pem ../mobusr1/etc/ipsec.d/cacerts


#move mobusr2 keys
mv mobusr2.key.pem ../mobusr2/etc/ipsec.d/private
mv mobusr2.crt.pem ../mobusr2/etc/ipsec.d/cacerts


#move mobusr1 keys
mv mobusr3.key.pem ../mobusr3/etc/ipsec.d/private
mv mobusr3.crt.pem ../mobusr3/etc/ipsec.d/cacerts


cd ..

rm -r tmp-keys
