#!/bin/bash
# Used by: security_group.tf
# Capture Username and User Public IP.

my_ip=$(curl -s ifconfig.co/)
whoami=$(whoami)
echo '{ "my_public_ip": "'"$my_ip/32"'", "username": "'"$whoami"'" }'