#!/usr/bin/env python3

import subprocess
import re

IP_V4_PATTERN = re.compile(r'(([01]?[0-9]?[0-9]|2[0-4][0-9]|2[5][0-5])\.){3}([01]?[0-9]?[0-9]|2[0-4][0-9]|2[5][0-5])')

def exec(cmd):
    print('run> ', ' '.join(cmd))
    stdout = subprocess.check_output(cmd).decode('utf-8')
    return [line for line in stdout.splitlines()]

def get_ipset_blacklist():
    CMD_IPSET_LIST = ['sudo', 'ipset', 'list']
    IP_MEMBERS_INDEX = 8
    return exec(CMD_IPSET_LIST)[IP_MEMBERS_INDEX:]

def get_invalid_auth():
    LOG_AUTH = '/var/log/auth.log'
    auth_log = open(LOG_AUTH).read().splitlines()
    ip_list = []
    for line in auth_log:
        if 'Invalid' in line:
            ip_list.append(line.split(' ')[-1])
    return ip_list

def get_ufw_whitelist():
    CMD_UFW_STATUS = ['sudo', 'ufw', 'status']
    status = exec(CMD_UFW_STATUS)
    allow_list = []
    for line in status:
        tokens = re.split(r'\s+', line)
        if len(tokens) >= 3 and IP_V4_PATTERN.match(tokens[2]) and tokens[1] == 'ALLOW':
            allow_list.append(tokens[2])
    return allow_list

def get_new_illegal_ip():
    blacklist = get_ipset_blacklist()
    whitelist = get_ufw_whitelist()
    invalid_ip_list = get_invalid_auth()
    illegal_list = []
    for ip in invalid_ip_list:
        if ip not in whitelist and ip not in blacklist:
            illegal_list.append(ip)
    return [x for x in set(illegal_list)]

def block_new_illegal_ip(illegal_list):
    CMD_IPSET_ADD = ['sudo', 'ipset', 'add']
    for ip in illegal_list:
        cmd = CMD_IPSET_ADD + ['blacklist', ip]
        try:
            exec(cmd)
        finally:
            pass

illegal_list = get_new_illegal_ip()
block_new_illegal_ip(illegal_list)

