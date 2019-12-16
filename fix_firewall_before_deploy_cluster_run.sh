#!/bin/bash
# run this on helper node so that nfs is available to persist during install runs
firewall-cmd --zone=public --permanent --add-service=nfs
firewall-cmd --reload
