#!/bin/sh

find . -name '*.pem' -delete

mkdir -p tmp-keys
cd tmp-keys

###############################################################################################################
###############################################################################################################
#Root certificate creation

# generate root CA key
ipsec pki --gen --type rsa --size 4096 --outform pem > CA.key.pem

# generate root certificate
ipsec pki --self --ca --lifetime 3650 --in CA.key.pem --type rsa --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU=ISS CW2, CN=CA" --outform pem > CA.crt.pem

echo "Created Root CA Certificate"

###############################################################################################################
###############################################################################################################
#www certificate creation

# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > www.key.pem

# generate csr
ipsec pki --pub --in www.key.pem --type rsa --outform pem > www.csr.pem

# sign certificate with root key
ipsec pki --issue --in www.csr.pem --lifetime 365 --cacert CA.crt.pem --cakey CA.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU=ISS CW2, CN=www.u1834961-u1824952.cyber.test" --san 213.1.133.3 --san @213.1.133.3 --flag serverAuth --flag ikeIntermediate --outform pem > www.crt.pem

echo "Created WWW Certificate"

###############################################################################################################
###############################################################################################################
#vpn gw certificate creation

# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > gw.key.pem

# generate csr
ipsec pki --pub --in gw.key.pem --type rsa --outform pem > gw.csr.pem

# sign certificate with root key
ipsec pki --issue --in gw.csr.pem --lifetime 365 --cacert CA.crt.pem --cakey CA.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU=ISS CW2, CN=gw.u1834961-u1824952.cyber.test" --san 213.1.133.2 --san @213.1.133.2 --san 192.168.65.1 --san @192.168.65.1 --flag serverAuth --flag ikeIntermediate --outform pem > gw.crt.pem

echo "Created GW Certificate"

###############################################################################################################
###############################################################################################################
# ICA
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > ica.key.pem

#generate csr
ipsec pki --pub --in ica.key.pem --type rsa --outform pem > ica.csr.pem

# sign certificate with root key
ipsec pki --issue --ca --in ica.csr.pem --lifetime 365 --cacert CA.crt.pem --cakey CA.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU=ISS CW2, CN=i_ca.cyber.test" --san 192.168.65.5 --san @192.168.65.5 --flag serverAuth --flag ikeIntermediate --outform pem > ica.crt.pem

#Create Revocation list 
ipsec pki --signcrl --carcert ica.crt.pem --cakey ica.key.pem --reason superseeded --cert rogueOne.crt.pem > ica.crl.pem

echo "Created Intermediate CA Certificate"

###############################################################################################################
###############################################################################################################

#mobUsr1
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > mobusr1.key.pem

#generate csr
ipsec pki --pub --in mobusr1.key.pem --type rsa --outform pem > mobusr1.csr.pem

#sign certificate with Intermediate Certificate authority key -- no san due to mobile users having multiple IPs
ipsec pki --issue --in mobusr1.csr.pem --lifetime 365 --cacert ica.crt.pem --cakey ica.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU =ISS CW2, CN=mobusr1" --flag serverAuth --flag ikeIntermediate --outform pem > mobusr1.crt.pem

echo "Created mobusr1 Certificate"

###############################################################################################################
###############################################################################################################

#mobUsr2
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > mobusr2.key.pem

#generate csr
ipsec pki --pub --in mobusr2.key.pem --type rsa --outform pem > mobusr2.csr.pem

#sign certificate with Intermediate Certificate authority key -- no san due to mobile users having multiple IPs
ipsec pki --issue --in mobusr2.csr.pem --lifetime 365 --cacert ica.crt.pem --cakey ica.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU =ISS CW2, CN=mobusr2" --flag serverAuth --flag ikeIntermediate --outform pem > mobusr2.crt.pem

echo "Created mobusr2 Certificate"

###############################################################################################################
###############################################################################################################

#mobUsr3
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > mobusr3.key.pem

#generate csr
ipsec pki --pub --in mobusr3.key.pem --type rsa --outform pem > mobusr3.csr.pem

#sign certificate with Intermediate Certificate authority key -- no san due to mobile users having multiple IPs
ipsec pki --issue --in mobusr3.csr.pem --lifetime 365 --cacert ica.crt.pem --cakey ica.key.pem --dn "C=UK, O=University of Warwick - Cyber Security Centre, OU =ISS CW2, CN=mobusr3" --flag serverAuth --flag ikeIntermediate --outform pem > mobusr3.crt.pem

echo "Created mobusr3 Certificate"

###############################################################################################################
###############################################################################################################
# move keys/certificates to right place


#rogueOne
# generate key
ipsec pki --gen --type rsa --size 4096 --outform pem > rogueOne.key.pem

# generate csr
ipsec pki --pub --in rogueOne.key.pem --type --rsa --outform pem > rogueOne.csr.pem

#sign certificate with intermediate certificate authority key
ipsec pki --issue --in rogueOne.csr.pem --lifetime 365 --cacert ica.crt.pem --cakey ica.key.pem --
dn "C=UK, O=University of Warwick - Cyber Security Centre, OU =ISS CW2, CN=mobusr3" --flag serverAuth --flag ikeIntermediate --outform pem > rogueOne.crt.pem


# copy CA keys
cp CA.key.pem ../CA/etc/ipsec.d/private/
cp CA.crt.pem ../CA/etc/ipsec.d/cacerts/

# We share the root certificate with all company computers so it can be used to verify all the different certificates/identities for the organisation

# copy gw keys
cp gw.key.pem ../gw.u1834961-u1824952.cyber.test/etc/ipsec.d/private/
cp gw.crt.pem ../gw.u1834961-u1824952.cyber.test/etc/ipsec.d/certs/

cp CA.crt.pem ../gw.u1834961-u1824952.cyber.test/etc/ipsec.d/cacerts/
cp ica.crt.pem ../gw.u1834961-u1824952.cyber.test/etc/ipsec.d/cacerts/


# copy www keys
cp www.key.pem ../www.u1834961-u1824952.cyber.test/etc/ipsec.d/private/
cp www.crt.pem ../www.u1834961-u1824952.cyber.test/etc/ipsec.d/cacerts/

cp CA.crt.pem ../www.u1834961-u1824952.cyber.test/etc/ipsec.d/cacerts/



# copy icakeys
cp ica.key.pem ../i_ca.cyber.test/etc/ipsec.d/private/
cp ica.crt.pem ../i_ca.cyber.test/etc/ipsec.d/cacerts/

cp CA.crt.pem ../i_ca.cyber.test/etc/ipsec.d/cacerts/



# copy mobusr1 keys
cp mobusr1.key.pem ../mobusr1/etc/ipsec.d/private/client.key.pem
cp mobusr1.crt.pem ../mobusr1/etc/ipsec.d/certs/client.crt.pem

cp CA.crt.pem ../mobusr1/etc/ipsec.d/cacerts/



# copy mobusr2 keys
cp mobusr2.key.pem ../mobusr2/etc/ipsec.d/private/client.key.pem
cp mobusr2.crt.pem ../mobusr2/etc/ipsec.d/certs/client.crt.pem

cp CA.crt.pem ../mobusr2/etc/ipsec.d/cacerts/



# copy mobusr3 keys
cp mobusr3.key.pem ../mobusr3/etc/ipsec.d/private/client.key.pem
cp mobusr3.crt.pem ../mobusr3/etc/ipsec.d/certs/client.crt.pem

cp CA.crt.pem ../mobusr3/etc/ipsec.d/cacerts/

# copy rogueOne keys
cp rogueOne.key.pem ../rogueOne/etc/ipsec.d/private/client.key.pem
cp rogueOne.crt.pem ../mobusr3/etc/ipsec.d/certs/client.crt.pem

cp CA.crt.pem ../mobusr3/etc/ipsec.d/cacerts/

cd ..

rm -r tmp-keys
