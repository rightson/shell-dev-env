#!/usr/bin/env python3

import subprocess
import re

CMD_IPSET_LIST = ['sudo', 'ipset', 'list']
CMD_IPSET_ADD = ['sudo', 'ipset', 'add']
IP_MEMBERS_INDEX = 8
LOG_AUTH = '/var/log/auth.log'

stdout = subprocess.check_output(CMD_IPSET_LIST).decode('utf-8')

ip_list = [line for line in stdout.splitlines()][IP_MEMBERS_INDEX:]

auth_log = open(LOG_AUTH).read().split('\n')

for line in auth_log:
    if 'Invalid' in line:
        ip = line.split(' ')[-1]
        if ip and not ip in ip_list:
            cmd = CMD_IPSET_ADD + ['blacklist', ip]
            print(' '.join(cmd))
            result = subprocess.check_output(cmd).decode('utf-8')
            if (result):
                print(result)
            continue
