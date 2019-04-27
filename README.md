# Auto-Scaling with Heat and Monasca
## OpenStack Summit Denver 2019

---

* Download your private SSH key (heat_monasca_2019.pem) from
  [here](https://drive.google.com/open?id=1ZDFWllrw5nuvUqAy7FktCOGnhrVOih3t).

* Change permissions

    ```bash
    chmod 600 heat_monasca_2019.pem
    ```

* SSH to your instance and pull the latest changes

    ```bash
    ssh -i heat_monasca_2019.pem ubuntu@<your_instance_ip>
    cd monasca-autoscaling
    git pull
    ```
* Start Monasca services

    ```
    cd scripts
    ./start_services.sh
    ```

### For Windows users

* You can use your favorite SSH client.

* We recommend Git BASH, BASH emulator with SSH client.

* Another good alternative is [cmder](http://cmder.net/).

#### For PuTTY users

* Set the private key for authentication in `Connection -> SSH -> Auth`.
  Choose [heat_monasca_2019.ppk](https://drive.google.com/open?id=1uMT6Eg6JBraMwmp95TyIUouPMjxsr7W_) as your private key.

* Remember to save the session settings.

## Agenda

* [Monasca Introduction](monasca_intro.md)
* [Heat Introduction](heat_intro.md)
* [Assignments Playbook](playbook.md)

## Running the playbook on your own

You will require:

* Ubuntu Linux 18.04

* and follow the [setup procedure](/environment/setup_steps)


## Troubleshooting 

### Check if all services are running fine

`systemctl list-units | grep devstack`
OR
`systemctl list-units | grep failed`

All services should be in 'running' state, if not restart them

LOGS: `journalctl -u devstack@n-cpu.service`

### In case services reporting AMQP errors

CHECK: `sudo rabbitmqctl list_users`

if there is NO `stackrabbit` user then:

```
sudo rabbitmqctl add_user stackrabbit secretrabbit
sudo rabbitmqctl set_permissions stackrabbit '.*' '.*' '.*'
sudo rabbitmqctl list_vhosts
sudo rabbitmqctl add_vhost nova_cell1
sudo rabbitmqctl set_permissions -p nova_cell1 stackrabbit '.*' '.*' '.*'
sudo systemctl restart devstack@*
```


### Monasca Services not running

CHECK: `~/monasca-autoscaling/scripts/list_services.sh`

`
~/monasca-autoscaling/scripts/stop_services.sh
~/monasca-autoscaling/scripts/start_services.sh
`



### Check server can be launched

CHECK: `openstack server create --debug --image cirros-0.4.0-x86_64-disk --network private --flavor m1.nano --security-group testvm --wait vm1`

FAILURE: "message": "Host 'YOUR-HOSTNAME' is not mapped to any cell", "code": 400

`
nova-manage cell_v2 delete_host --cell_uuid b603d831-06d9-4a00-ba5d-0b2a55da6920 --host rocky-16
/home/ubuntu/devstack/tools/discover_hosts.sh
sudo sed -i "s/rocky-16/$HOSTNAME/g"  /etc/monasca/agent/agent.yaml /etc/monasca/agent/conf.d/host_alive.yaml
~/monasca-autoscaling/scripts/stop_services.sh
~/monasca-autoscaling/scripts/start_services.sh
`


### Network connectivity issues within the host:


CHECK: `ip netns list`

there should be two qdhcp namespaces, if you have atleast one instnace
