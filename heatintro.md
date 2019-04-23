HEAT
----

Heat Architecture Diagram

A template is an input to heat to state what the stack is supposed to look like.
It consists of resources which are components which make up the stack.
Heat is already aware of these resoruces are knows about their properties that 
are relenvant from heat perspective and how to create and destroy them by talking
to corresponding service.

Some examples of resource:

Some of the resouce groups relevant today for us is:
- *OS::Heat::AutoScalingGroup*
- *OS::Heat::ScalingPolicy*
- *OS::Monasca::Notification*
- *OS::Monasca::AlarmDefinition*


- *OS::Heat::AutoScalingGroup*
  Properties:
  - name: Convenient name.
  - max_size: Maximum size of the group.
  - min_size: Minimum size of the group.
  - cooldown: minimum time before *any* autoscaling related operation.
  - resources: set of resource that should be scaled up or down.

- Heat provdes this group a box of resources that can be scaled.
- Scaling up and down is based on Scaling Policy for the group.
- Should be under a group, because the policy has to back refer to it


*OS::Heat::ScalingPolicy*
    Properties:
    - change: a number that has an effect based on change_type.
    - change_type: (meaning of "change")
        - "change_in_capacity"
        - "percentage_change_in_capacity", 
        - "exact_capacity" 
    - cooldown: minimum amount of time (in seconds) between allowable executions of this policy.
    - group_id: ID of the group that this policy will affect
    - name: Convenient name

    Attributes: (outputs)
    - alarm_url: the url which triggers the policy


*OS::Monasca::Notification*
    Properties:
    - address: Address of the notification. 
        - email address
        - url
        - service key based on notification type.
    - type: Type of the notification.
        - email
        - webhook
        - pagerduty
exameple:
  up_notification:
    type: OS::Monasca::Notification
    properties:
      type: webhook
      address: {get_attr: [scale_up_policy, alarm_url]}


*OS::Monasca::AlarmDefinition*
    Properties:
    - expression
    Expression of the alarm to evaluate.
    String value expected.
    Updates cause replacement.

    Optional Properties

    - actions_enabled
    - alarm_actions
        - List of Monasca notification.
    - description
    - name
    - match_by: The metric dimensions to match to the alarm dimensions
    - ok_actions
    - severity
    - undetermined_actions: The notification methods to use when an alarm state is UNDETERMINED.
        - List of Monasca notification.
