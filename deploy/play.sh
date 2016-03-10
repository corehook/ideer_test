#!/bin/bash
# play restart.yml master
ansible-playbook $1 --extra-vars="branch=$2"
