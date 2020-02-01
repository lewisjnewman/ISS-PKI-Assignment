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

cd ..

rm -r tmp-keys