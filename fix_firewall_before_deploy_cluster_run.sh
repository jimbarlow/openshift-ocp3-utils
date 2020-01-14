#!/bin/bash
# run this on helper node so that nfs is available to persist during install runs
firewall-cmd --zone=public --permanent --add-service=nfs
firewall-cmd --zone=public --permanent --add-service=dns
firewall-cmd --zone=public --permanent --add-service=dhcp
firewall-cmd --zone=public --permanent --add-port=6443/tcp
firewall-cmd --zone=public --permanent --add-port=22623/tcp
firewall-cmd --zone=public --permanent --add-port=2380/tcp
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
