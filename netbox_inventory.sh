#!/bin/bash
docker exec netbox-docker-netbox-1 /opt/netbox/netbox/manage.py shell -c "
import json
from dcim.models import Device
import sys

inventory = {
    '_meta': {'hostvars': {}},
    'all': {'children': ['router', 'switch', 'ungrouped']},
    'router': {'hosts': []},
    'switch': {'hosts': []},
    'ungrouped': {'hosts': []}
}

for d in Device.objects.all():
    name = d.name
    ip = str(d.primary_ip4.address.ip) if d.primary_ip4 else None
    role = d.role.slug if d.role else 'ungrouped'
    
    if role not in inventory:
        inventory[role] = {'hosts': []}
        inventory['all']['children'].append(role)
    
    inventory[role]['hosts'].append(name)
    inventory['_meta']['hostvars'][name] = {
        'ansible_host': ip,
        'netbox_role': role
    }

json.dump(inventory, sys.stdout)
" 2>/dev/null | grep -v "imported automatically" | grep -v "loaded config" | grep -v "objects imported"
