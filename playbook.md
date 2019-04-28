Playbook
--------

## 1. Create a Stack and AlarmsDefition

**DO**:

Fill out resource block for **cpu_alarm_high**, **cpu_alarm_low**, **group**:
  - **OS::Heat::AutoScalingGroup**
  - **OS::Monasca::AlarmDefinition**  
  Add properties as defined in [heatintro.md](./heatintro.md)

Create a stack  
`openstack stack create --wait -t autoscaling.yaml test`

**CHECK**:

Refer to [examples.md](./examples.md) for detailed commands

Check metadata attribute of server.   
It should have `scale_group=(id of stack named test)`
`openstack server show SERVER_ID`

There should be two alarm definitions created.  
`monasca alarm-definition-list`

Check if the metric used in alarm expression is available in the TSDB. Use
`--help` to look up available options.   
`monasca metric-list`

What are the actual values of the relevant metrics? You can use `--group_by`
argument.  
`monasca measurement-list`

Try to aggregate the measurements and check what are the actual values used for
alarm evaluation. We filter on `scale_group` and calculate average on three
consecutive 60s periods. Please use `--merge_metrics` argument.   
`monasca metric-statistics`

After some time there should some metrics for the VMs from stack.
To get values other than 0 (zero), create some load on the VMs

```
# Make sure to type in SERVER_IP on next line

ip netns exec qdhcp-13f0b5d1-bf1d-4edc-a40d-7c569997ca3e ssh cirros@$SERVER_IP "dd if=/dev/zero of=/dev/null &"
```

## 2. Add Notifications for alarms

**DO**:

Delete previous stack  
`openstack stack delete --wait --yes test`

Fill out  *up_notification* and *down_notification*:
  - **OS::Monasca::Notification**  
   Add properties as defined in [heatintro.md](./heatintro.md)

Create a stack  
`openstack stack create --wait -t autoscaling.yaml test`


**CHECK**:

Create some load on vm and watch for notifications
```
# Make sure to type in SERVER_IP on next line

ip netns exec qdhcp-13f0b5d1-bf1d-4edc-a40d-7c569997ca3e ssh cirros@$SERVER_IP "dd if=/dev/zero of=/dev/null &"
```

Refer to [examples.md](./examples.md) for detailed commands


This is the list of webhook notfications which Monasca will call whenever
corresponding alarms have been fired  
`monasca notification-list`

These notification methods should be assigned to alarm definitions.  
`monasca alarm-definition-list`

You can use the commands from the previous part to observe the increased CPU
utilization.

Initially no notifications as the alarm have not yet been in **ALARM** state.  
But after ~3 mins the alarm should transition into ALARM state.  

Check the state of the alarms generated from alarm definitions and collected
metrics.   
`monasca alarm-list`

Triggered notifications have no effect in Heat until now because we haven't
configured scaling policies.

## 3. Add scaling policies

**DO**:

Delete previous stack  
`openstack stack delete --wait --yes test`

- Fill out  *scale_up_policy* and *scale_down_policy*:
  - **OS::Heat::ScalingPolicy**  
  Add properties as defined in [heatintro.md](./heatintro.md)

Create a stack  
`openstack stack create --wait -t autoscaling.yaml test`

**CHECK**

Create some load on vm and watch for notifications
```
# Make sure to type in SERVER_IP on next line

ip netns exec qdhcp-13f0b5d1-bf1d-4edc-a40d-7c569997ca3e ssh cirros@$SERVER_IP "dd if=/dev/zero of=/dev/null &"
```

Observe increased load using the commands from the first part.

As soon as the threshold is exceeded alarm transitions to ALARM state and
notification is triggered. Check the state of the alarm.  
`monasca alarm-list`  
`monasca alarm-show`

A new vm should be created  
`openstack server list`

## 4. Experiment with scale-up and scale-down

**DO**:

ssh to different machines toggle load generating process:  

To stop:   `pidof dd | xargs kill -9`

To start:  `dd if=/dev/zero of=/dev/null &`

**CHECK**:

Observe the changing alarm states with the commands from the previous section.

Check how the *cpu_alarm_high* and *cpu_alarm_low* alarm states changed in time.  
`monasca alarm-history`

Corresponding scale up and scale down in number of VMs  
`openstack server list`

References
----------
* Heat autoscaling [template](https://github.com/openstack/heat-templates/blob/master/hot/monasca/autoscaling.yaml)
* Monasca [libvirt plugin documentation](https://github.com/openstack/monasca-agent/blob/master/docs/Libvirt.md)
* Monasca API [reference](https://github.com/openstack/monasca-api/blob/master/docs/monasca-api-spec.md)
* Monasca CLI [code reference](https://github.com/openstack/python-monascaclient/tree/master/doc/source/cli)
  and [docs](https://docs.openstack.org/python-monascaclient/latest/)