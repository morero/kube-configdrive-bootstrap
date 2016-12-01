#!/bin/bash
#ca
openssl genrsa -out ssl/ca-key.pem 2048
openssl req -x509 -new -nodes -key ssl/ca-key.pem -days 10000 -out ssl/ca.pem -subj "/CN=kube-ca"

#apiserver
openssl genrsa -out ssl/apiserver-key.pem 2048
openssl req -new -key ssl/apiserver-key.pem -out ssl/apiserver.csr -subj "/CN=kube-apiserver" -config openssl.conf
openssl x509 -req -in ssl/apiserver.csr -CA ssl/ca.pem -CAkey ssl/ca-key.pem -CAcreateserial -out ssl/apiserver.pem -days 365 -extensions v3_req -extfile openssl.conf

#worker keypairs for: 37.120.166.211
openssl genrsa -out ssl/kube-node-1-worker-key.pem 2048
WORKER_IP=37.120.166.211 openssl req -new -key ssl/kube-node-1-worker-key.pem -out ssl/kube-node-1-worker.csr -subj "/CN=kube-node-1" -config worker-openssl.cnf
WORKER_IP=37.120.166.211 openssl x509 -req -in ssl/kube-node-1-worker.csr -CA ssl/ca.pem -CAkey ssl/ca-key.pem -CAcreateserial -out ssl/kube-node-1-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf

openssl genrsa -out ssl/admin-key.pem 2048
openssl req -new -key ssl/admin-key.pem -out ssl/admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in ssl/admin.csr -CA ssl/ca.pem -CAkey ssl/ca-key.pem -CAcreateserial -out ssl/admin.pem -days 365


