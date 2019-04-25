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
* Restart Monasca services

    ```
    cd scripts
    ./stop_services.sh
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

## Running the playbook on your own

---

You will require:

* Ubuntu Linux 18.04

* and follow the [setup procedure](/environment/setup_steps)
