Commands and Sample Outputs
---------------------------

These command can help you view your deployment in detail

* openstack orchestration template validate

```bash
ubuntu@monasca-heat:~$ openstack orchestration template validate -t autoscaling.yaml
Environment:
  event_sinks: []
  parameter_defaults: {}
  parameters: {}
  resource_registry:
    resources: {}
Description: 'Example of using monasca resources for auto-scale testing. In this template,
  sample scale-group is created with given nova instance to auto-scale when cpu utilization
  varies between 15 to 50 percent for 3 times consequently.

  '
Parameters:
  flavor:
    Default: m1.nano
    Description: Flavor for the instances to be created
    Label: flavor
    NoEcho: 'false'
    Type: String
  image:
    Description: Name or ID of the image to use for the instances.
    Label: image
    NoEcho: 'false'
    Type: String
```

* Check flavor, image, and security_group IDs
* openstack stack create

```bash
ubuntu@monasca-heat:~$ openstack stack create --wait -t autoscaling.yaml --parameter image=3250d6a6-e372-4e37-8b7f-1b854ecaaa9b --parameter flavor=m1.tiny test
....
2019-04-11 11:35:44Z [test.scale_down_policy]: CREATE_COMPLETE  state changed
2019-04-11 11:35:44Z [test.down_notification]: CREATE_IN_PROGRESS  state changed
2019-04-11 11:35:44Z [test.up_notification]: CREATE_IN_PROGRESS  state changed
2019-04-11 11:35:44Z [test.down_notification]: CREATE_COMPLETE  state changed
2019-04-11 11:35:45Z [test.up_notification]: CREATE_COMPLETE  state changed
2019-04-11 11:35:45Z [test.cpu_alarm_low]: CREATE_IN_PROGRESS  state changed
2019-04-11 11:35:45Z [test.cpu_alarm_high]: CREATE_IN_PROGRESS  state changed
2019-04-11 11:35:45Z [test.cpu_alarm_low]: CREATE_COMPLETE  state changed
2019-04-11 11:35:45Z [test.cpu_alarm_high]: CREATE_COMPLETE  state changed
2019-04-11 11:35:45Z [test]: CREATE_COMPLETE  Stack CREATE completed successfully
....
```

* openstack stack resource list 

```bash
ubuntu@monasca-heat:~$ openstack stack resource list -n 7 test --max-width 120
+-------------------+----------------------+-------------------+-----------------+-------------------+--------------------+
| resource_name     | physical_resource_id | resource_type     | resource_status | updated_time      | stack_name         |
+-------------------+----------------------+-------------------+-----------------+-------------------+--------------------+
| up_notification   | 141ba277-30a3-441b-  | OS::Monasca::Noti | CREATE_COMPLETE | 2019-04-11T13:46: | test               |
|                   | 8ee9-d7491fbcb755    | fication          |                 | 45Z               |                    |
| cpu_alarm_low     | 95440854-3110-4061   | OS::Monasca::Alar | CREATE_COMPLETE | 2019-04-11T13:46: | test               |
|                   | -affa-0d59e1f636b8   | mDefinition       |                 | 45Z               |                    |
| group             | c6bbee22-b053-424d-  | OS::Heat::AutoSca | CREATE_COMPLETE | 2019-04-11T13:46: | test               |
|                   | af8b-bbd58313a8cd    | lingGroup         |                 | 45Z               |                    |
| cpu_alarm_high    | bb133bc4-50c9-4faa-  | OS::Monasca::Alar | CREATE_COMPLETE | 2019-04-11T13:46: | test               |
|                   | bac4-011202a04b73    | mDefinition       |                 | 45Z               |                    |
| down_notification | 647946a4-168f-4b7b-  | OS::Monasca::Noti | CREATE_COMPLETE | 2019-04-11T13:46: | test               |
|                   | adb8-a5b5796192c4    | fication          |                 | 45Z               |                    |
| scale_down_policy | 9b0fab911f664368b0f9 | OS::Heat::Scaling | CREATE_COMPLETE | 2019-04-11T13:46: | test               |
|                   | 4a0d1979bae2         | Policy            |                 | 45Z               |                    |
| scale_up_policy   | 12bc95dbe1104bf19674 | OS::Heat::Scaling | CREATE_COMPLETE | 2019-04-11T13:46: | test               |
|                   | 63a6c02d67df         | Policy            |                 | 45Z               |                    |
| fexdqohubmck      | 1ba11cac-9b54-458c-  | OS::Nova::Server  | CREATE_COMPLETE | 2019-04-11T14:20: | test-group-        |
|                   | aecf-b64e00941018    |                   |                 | 50Z               | tnwfedco5iyy       |
+-------------------+----------------------+-------------------+-----------------+-------------------+--------------------+
```

* Note the `physical_resource_id` from `group` row, as this will be the
  `scale_group` dimension used to group measurements
* Note the `physical_resource_id` from resources of `resource_type`
  "OS::Nova::Server" is the server id from Nova

* [monasca notification-list](./notification.list)
* monasca alarm-definition-list

```bash
ubuntu@monasca-heat:~$ monasca alarm-definition-list

+--------------------------------------+--------------------------------------+------------------------------------------------------------------------------------------+----------+-----------------+
| name                                 | id                                   | expression                                                                               | match_by | actions_enabled |
+--------------------------------------+--------------------------------------+------------------------------------------------------------------------------------------+----------+-----------------+
| CPU utilization less than 15 percent | 95440854-3110-4061-affa-0d59e1f636b8 | avg(cpu.utilization_perc{scale_group=fbdd8830-ba09-4b82-8afd-5307e67aefd1}) < 15 times 3 |          | True            |
| CPU utilization beyond 50 percent    | bb133bc4-50c9-4faa-bac4-011202a04b73 | avg(cpu.utilization_perc{scale_group=fbdd8830-ba09-4b82-8afd-5307e67aefd1}) > 50 times 3 |          | True            |
+--------------------------------------+--------------------------------------+------------------------------------------------------------------------------------------+----------+-----------------+
```

* [monasca metric-list](./metric.list)
* monasca measurement-list

```bash
ubuntu@monasca-heat:~$ monasca measurement-list --group_by hostname --dimension scale_group=fbdd8830-ba09-4b82-8afd-5307e67aefd1 cpu.utilization_perc -3
+----------------------+-------------------------------------------------------------+--------------------------+--------------+------------+
| name                 | dimensions                                                  | timestamp                | value        | value_meta |
+----------------------+-------------------------------------------------------------+--------------------------+--------------+------------+
| cpu.utilization_perc | hostname: test-group-tnwfedco5iyy-fexdqohubmck-fkryddl4a6qp | 2019-04-19T17:10:26.395Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:10:41.409Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:10:56.467Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:11:11.442Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:11:26.457Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:11:41.503Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:11:56.458Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:12:11.554Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:12:26.515Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:12:41.567Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:12:56.519Z |        0.000 |            |
|                      |                                                             | 2019-04-19T17:13:11.558Z |        0.000 |            |
+----------------------+-------------------------------------------------------------+--------------------------+--------------+------------+
```
* monasca metric-statistics

```bash
ubuntu@monasca-heat:~$ monasca metric-statistics --dimensions scale_group=fbdd8830-ba09-4b82-8afd-5307e67aefd1 --merge_metrics --period 60 cpu.utilization_perc avg -3
+----------------------+---------------------------------------------------+----------------------+--------------+
| name                 | dimensions                                        | timestamp            | avg          |
+----------------------+---------------------------------------------------+----------------------+--------------+
| cpu.utilization_perc | scale_group: fbdd8830-ba09-4b82-8afd-5307e67aefd1 | 2019-04-19T17:10:00Z |        0.000 |
|                      |                                                   | 2019-04-19T17:11:00Z |        0.000 |
|                      |                                                   | 2019-04-19T17:12:00Z |        0.000 |
|                      |                                                   | 2019-04-19T17:13:00Z |        0.000 |
+----------------------+---------------------------------------------------+----------------------+--------------+
```

* [monasca alarm-list](./alarm.list)
* log in to the instance and generate load
  - `dd if=/dev/zero of=/dev/null`
* openstack server list
* monasca metric-statistics
* monasca alarm-list
* monasca alarm-history


References
----------
* Heat autoscaling [template](https://github.com/openstack/heat-templates/blob/master/hot/monasca/autoscaling.yaml)
* Monasca [libvirt plugin documentation](https://github.com/openstack/monasca-agent/blob/master/docs/Libvirt.md)
* Monasca API [reference](https://github.com/openstack/monasca-api/blob/master/docs/monasca-api-spec.md)
