#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=financeirows.grupomateus.com.br"

kubectl -n java-pro create secret tls traefik-ui-tls-cert --key=tls.key --cert=tls.crt