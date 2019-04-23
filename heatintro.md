
HEAT
----
[heatarch.png](heatarch.png)

Some examples of resource:

      resource:
        type: OS::Nova::Server
        properties:
          flavor: { get_param: flavor }
          image: { get_param: image }
          metadata: {"scale_group": {get_param: "OS::stack_id"}}
          networks:
          - network: private
          security_groups:
          - testvm



## Some of the resouce groups relevant today for us is:
- *OS::Heat::AutoScalingGroup*
- *OS::Heat::ScalingPolicy*
- *OS::Monasca::Notification*
- *OS::Monasca::AlarmDefinition*



## OS::Heat::AutoScalingGroup
Properties:
  - name: Convenient name.
  - max_size: Maximum size of the group.
  - min_size: Minimum size of the group.
  - cooldown: minimum time before *any* autoscaling related operation.
  - resources: set of resource that should be scaled up or down.

- Heat provdes this group a box of resources that can be scaled.
- Scaling up and down is based on Scaling Policy for the group.
- Should be under a group, because the policy has to back refer to it



## OS::Heat::ScalingPolicy
Properties:
  - **change**: a number that has an effect based on change_type.
  - **change_type:** (meaning of "change")
  	- "change_in_capacity"
    - "percentage_change_in_capacity", 
    - "exact_capacity" 
  - **cooldown:** minimum amount of time (in seconds) between allowable executions of this policy.
  - **group_id:** ID of the group that this policy will affect
  - **name:** Convenient name

Attributes: (outputs)
  - **alarm_url**: the url which triggers the policy



## OS::Monasca::Notification
Properties:
  - **address**: Address of the notification. 
        - email address
        - url
        - service key based on notification type.
  - **type**: Type of the notification.
        - email
        - webhook
        - pagerduty
     
Example:

	up_notification:
    	type: OS::Monasca::Notification
    	properties:
      		type: webhook
      		address: {get_attr: [scale_up_policy, alarm_url]}



## **OS::Monasca::AlarmDefinition**
Properties:
- **expression**: Expression of the alarm to evaluate.
  eg: `avg(cpu.utilization_perc{scale_group=scale_group_id}) > 50 times 3`
    
Optional Properties
- **alarm_actions**
- **ok_actions**:
- **undetermined_actions**:
- **actions_enabled**
- **match_by**:  
- **severity**
- description
- name
    
## Big Picture:
- OS::Monasca::AlarmDefinition >>> which has
- OS::Monasca::Notification   >>> triggers
- OS::Heat::ScalingPolicy     >>> scales up/down
- OS::Heat::AutoScalingGroup  >>> resources to scale
