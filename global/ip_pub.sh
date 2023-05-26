#!/bin/bash

ip=$(curl -s httpbin.org/ip|jq -r '.origin')
cat<<EOF
{"ip":"$ip"}
EOF
