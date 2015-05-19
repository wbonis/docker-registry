#!/bin/sh

openssl genrsa -out devdockerCA.key 2048

openssl req -x509 -new -nodes -key devdockerCA.key -days 10000 -out devdockerCA.crt

openssl genrsa -out dev-docker-registry.com.key 2048

openssl req -new -key dev-docker-registry.com.key -out dev-docker-registry.com.csr

openssl x509 -req -in dev-docker-registry.com.csr -CA devdockerCA.crt -CAkey devdockerCA.key -CAcreateserial -out dev-docker-registry.com.crt -days 10000


#openssl genrsa -aes256 -out ca-key.pem 2048
#openssl req -new -x509 -days 10000 -key ca-key.pem -sha256 -out ca.pem
#openssl genrsa -out server-key.pem 2048
#openssl req -subj "/CN=***REMOVED***" -new -key server-key.pem -out server.csr
#echo subjectAltName = IP:10.10.10.20,IP:127.0.0.1 > extfile.cnf
#openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem \
  #-CAcreateserial -out server-cert.pem -extfile extfile.cnf
#openssl genrsa -out key.pem 2048
#openssl req -subj '/CN=client' -new -key key.pem -out client.csr
#echo extendedKeyUsage = clientAuth > extfile.cnf
#openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem \
  #-CAcreateserial -out cert.pem -extfile extfile.cnf
#rm -v client.csr server.csr
