#!/bin/bash -x

# Ref:

echo ">>>> You need to use root / admin account to do the following"
echo " "
echo " "

> /var/log/syslog
journalctl --disk-usage
journalctl --rotate
journalctl --vacuum-time=2days
journalctl --vacuum-size=100M
journalctl --vacuum-files=5
echo " >>> you need to manually: "
echo " vi /etc/systemd/journald.conf"
echo " then, modify entry as below:"
echo "e.g. (remove comment and add, say, 100M, as limit"
echo "SystemMaxUse=100M"

systemctl daemon-reload

