#!/bin/bash
# NetBox Data Rehydration Script (Disaster Recovery)
# This script restores the Laboratory structure and devices directly into the database.

echo "⏳ Starting NetBox rehydration process..."

docker exec netbox-docker-netbox-1 /opt/netbox/netbox/manage.py shell -c "
from dcim.models import Site, Device, DeviceType, Manufacturer, DeviceRole, Interface
from ipam.models import IPAddress
from django.contrib.contenttypes.models import ContentType

print('  -> Creating Site, Manufacturer and Device Type...')
site, _ = Site.objects.get_or_create(name='Laboratory', slug='laboratory')
mfr, _ = Manufacturer.objects.get_or_create(name='Cisco', slug='cisco')
dt, _ = DeviceType.objects.get_or_create(manufacturer=mfr, model='Generic IOS', slug='generic-ios')

print('  -> Creating Roles...')
role_router, _ = DeviceRole.objects.get_or_create(name='Router', slug='router', color='ff0000')
role_switch, _ = DeviceRole.objects.get_or_create(name='Switch', slug='switch', color='0000ff')

# List of devices to restore
devices = [
    ('R1', '10.0.31.1', role_router),
    ('R2', '10.0.22.2', role_router),
    ('SW1', '10.0.11.10', role_switch),
    ('SW2', '10.0.12.2', role_switch),
    ('SW3', '10.0.31.10', role_switch),
]

for name, ip, role in devices:
    print(f'  -> Restoring Device: {name} ({ip})...')
    dev, _ = Device.objects.get_or_create(
        name=name,
        device_type=dt,
        role=role,
        site=site,
        status='active'
    )
    # Restore Management Interface
    mgmt_int, _ = Interface.objects.get_or_create(device=dev, name='Management', type='other')
    
    # Restore IP Address
    ip_obj, _ = IPAddress.objects.get_or_create(address=f'{ip}/24', status='active')
    ip_obj.assigned_object_id = mgmt_int.id
    ip_obj.assigned_object_type = ContentType.objects.get_for_model(Interface)
    ip_obj.save()
    
    # Set as Primary IP
    dev.primary_ip4 = ip_obj
    dev.save()

print('✅ Rehydration completed successfully!')
"
