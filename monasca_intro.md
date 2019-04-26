# Monasca
## Monitoring-as-a-Service

* multi-tenant
* RESTful API
  * measurements
  * statistics
  * alerting
  * alarm history
  * logs
  * events (in dev)
* high-performant, scalable and fault-tolerant
* Amazon CloudWatch equivalent in OpenStack

## Metrics

`POST, GET /v2.0/metrics`

* `name` (string(255), required)  
  The name of the metric.  
  e.g. cpu.user_perc, kafka.consumer_lag

* `dimensions` ({string(255): string(255)}, optional)  
A dictionary consisting of (key, value) pairs used to uniquely identify a metric and slice and dice on.

* `timestamp` (string, required)  
The timestamp in milliseconds from the Epoch.

* `value` (float, required)  
Value of the metric.

* `value_meta` ({string(255): string(2048)}, optional)  
A dictionary consisting of (key, value) pairs used to describe the metric.  
e.g.: status_code, error message

* `tenant_id`: (string, optional, restricted)  
Tenant ID to create metrics on behalf of.
  * This parameter can be used to submit metrics from one tenant, to another.
  * Requires the delegate role.

## Dimensions

* A dictionary of (key, value) pairs that are used to uniquely identify a metric.

* Used to filter, group and aggregate metrics when querying.

* Dimensions can be anything you want, but naming conventions should be adopted
for consistency.

* Examples of dimension keys are the following: `hostname`, `region`, `zone`,
`service`, `component`, `process` .

## Metrics Agent

* Push model
* Agent is installed on the systems that we want to monitor
* Detection plugins for setup automation

## Agent Metrics and Plugins

* System metrics (cpu, memory, network, filesystem, …)
* libvirt, OvS multi-tenant plugins
* Application metrics
  * Prometheus
  * StatsD
* RabbitMQ, MySQL, Kafka, and many others
* Kubernetes metrics
* Extensible/Pluggable: Additional services can be easily added

## Notification Methods

Specify the name, type and address to send a notification to.

`GET, POST, PUT, DELETE, PATCH /v2.0/notification-methods`

Notification methods are associated with actions in alarms and are invoked when
alarm state transitions occur.

Supported notification methods (plugins) are:

*        Email
* PagerDuty
*        Webhook
*        Jira
*        HipChat
*        Slack

## Alarm Definitions

Operations for creating, reading updating and deleting alarm definitions.

```
GET, POST /v2.0/alarm-definitions
GET, PUT, PATCH, DELETE /v2.0/alarm-definitions/{alarm-definition-id}
```

Alarm definitions are templates that are used to automatically create alarms
based on matching metric names and dimensions

The `match-by` paramater is used to match/group metrics together by dimension
e.g. `--match-by hostname` will create an alarm per unique hostname.

One alarm definition can result in many alarms.

Simple grammar for creating compound alarm expressions:

```
avg(cpu.user_perc{}) > 85 or avg(disk.read_ops{device=vda}, 120) > 1000
```

Alarm state (ALARM, OK and UNDETERMINED)

Actions (notification methods) associated with alarms for state transitions

User assigned severity (LOW, MEDIUM, HIGH, CRITICAL)

## Alarms

Alarms are created when incoming metrics match alarm definitions

```
GET /v2.0/alarms
GET, PUT, PATCH, DELETE /v2.0/alarms/{alarm-id}
```

Query Parameters

*        `alarm_definition_id` (string, optional)  
Alarm definition ID to filter by.

*        `metric_name` (string(255), optional)  
Name of metric to filter by.

*        `metric_dimensions` ({string(255): string(255)}, optional)  
Dimensions of metrics to filter by specified as a comma separated array of (key, value) pairs as key1:value1,key1:value1, ...

*        `state` (string, optional)  
State of alarm to filter by, either OK, ALARM or UNDETERMINED.

*        `state_updated_start_time` (string, optional)  
The start time in ISO 8601 combined date and time format in UTC.

*        `sort-by`  
Fields to sort by

*        `offset`  
Offset for paging
* `limit`  
Limit the size of result set
