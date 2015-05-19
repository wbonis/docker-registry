#!/bin/bash

pushd certs

openssl genrsa -out devCA.key 2048

openssl req -x509 -new -nodes -key devCA.key -days 10000 -out devCA.crt  -subj "/OU=Development/CN=devCA"

openssl genrsa -out dev-reg.key 2048

openssl req -new -key dev-reg.key -out dev-reg.csr -subj "/OU=Development/CN=reg.your.domain"

openssl x509 -req -in dev-reg.csr -CA devCA.crt -CAkey devCA.key -CAcreateserial -out dev-reg.crt -days 10000

rm dev-reg.csr

popd
