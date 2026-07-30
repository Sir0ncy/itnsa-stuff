#!/usr/bin/openssl
# CA
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout ca.key -out ca.pem \
  -addext "basicConstraints=critical,CA:TRUE" \
  -addext "keyUsage=critical,keyCertSign,cRLSign"

# Generate WEB Key and CSR
openssl req -newkey rsa:2048 -nodes -keyout web.key -out web.csr \
  -addext "subjectAltName=DNS:web.itnsa.id,DNS:int.itnsa.id" -addext "keyUsage=digitalSignature"

# Sign WEB with Root CA
openssl x509 -req -in web.csr -CA ca.pem -CAkey ca.key -CAcreateserial \
  -out web.pem -days 365 -sha256 \
  -copy_extensions copy

# Generate MAIL Key and CSR
openssl req -newkey rsa:2048 -nodes -keyout mail.key -out mail.csr -addext "keyUsage=digitalSignature"

# Sign MAIL with Root CA
openssl x509 -req -in mail.csr -CA ca.pem -CAkey ca.key -CAcreateserial \
  -out mail.pem -days 365 -sha256

# Generate VPN Key and CSR
openssl req -newkey rsa:2048 -nodes -keyout vpn.key -out vpn.csr \
  -addext "extendedKeyUsage=serverAuth" -addext "keyUsage=digitalSignature,keyEncipherment"

# Sign VPN with Root CA
openssl x509 -req -in vpn.csr -CA ca.pem -CAkey ca.key -CAcreateserial \
  -out vpn.pem -days 365 -sha256 \
  -copy_extensions copy