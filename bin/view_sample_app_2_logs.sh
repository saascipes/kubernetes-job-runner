#!/bin/bash

set -e

POD_NAME=( $(kubectl get pod | grep sample-app-2-job) )

printf "%s\n" "${POD_NAME[0]}"

kubectl logs -f pod/${POD_NAME[0]}
