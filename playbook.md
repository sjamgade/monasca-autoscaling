Playbook
--------

## Create a Stack
 
There are empty yaml block, which need to be filled.
for exmaples: refer [heatintro.md](./heatintro.md)
Fill out resource block for each:
  - *OS::Heat::AutoScalingGroup*
  - *OS::Heat::ScalingPolicy*
  - *OS::Monasca::Notification*
  - *OS::Monasca::AlarmDefinition*
- Use this command to validate template structure
- openstack orchestration template validate
- openstack stack create
* openstack stack resource list

## Validate resources exists

Use these commands to actually go through the reources

There are examples of these cmd in [exmaples.md](./examples.md)
_ monasca notification-list
_ monasca alarm-definition-list
_ monasca metric-list
_ monasca measurement-list
_ monasca metric-statistics
_ monasca alarm-list

## Experiment with scale-up and scale-down
There are examples of these cmd in [exmaples.md](./examples.md)
- openstack server list

  To create load on the server ssh to server after assigning floating ip.
  openstack floating ip create public  --port=$(openstack port list --device-id=$(openstack server show -f value -c id SERVER_ID ) -f value -c id) -f value -c floating_ip_address

  ssh cirros@FLOATING_IP

- monasca metric-statistics
- monasca alarm-list
- monasca alarm-history


References
----------
* Heat autoscaling [template](https://github.com/openstack/heat-templates/blob/master/hot/monasca/autoscaling.yaml)
* Monasca [libvirt plugin documentation](https://github.com/openstack/monasca-agent/blob/master/docs/Libvirt.md)
* Monasca API [reference](https://github.com/openstack/monasca-api/blob/master/docs/monasca-api-spec.md)
