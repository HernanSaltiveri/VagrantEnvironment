
## Requirement 
Solution must contain a valid Vagrantfile to test solution. All logic must be implemented via Ansible Playbooks/Roles. You can use public Ansible roles, Ansible Galaxy is preferred source. Solution must contain basic README.

<b>1. Redis Cluster.</b> Implement Ansible playbook to deploy Redis cluster in docker containers.After first playbook run, Redis cluster must be properly initialized. Redis data should be persistent on host.

<b>2. RabbitMQ cluster.</b> Implement Ansible Playbook to deploy RabbitMQ cluster in docker containers. After first playbook run, RabbitMQ cluster must be properly initialized. Management interface must be present, admin username and password must be configurable via Ansible 

<b>3. MySQL replication.</b>Implement Ansible Playbook which deploys MySQL master and slave in Docker containers. First playbook run must result in replication process running with now errors. MySQL data directories must be persisted on host’s disk.

 
## Solution
The solution was implemented using 3 specific roles, one for redis, one for rabbitmq and one for mysql
There were also use a docker role to install docker on the vagrant VM taken from ansible galaxy code 
Another role was added to adjust docker.
 

> <b>VAGRANT FILE</b>
> 
>       Vagrant.configure("2") do |config|
>         config.vm.box = "ubuntu/trusty64"
>         config.vm.synced_folder "roles", "/conf"
>         config.vm.provision "ansible" do |ansible|
>           ansible.verbose = "v"
>           ansible.playbook = "playbook.yml"
>          end
>       end
>
>
> <b>PLAYBOOK.yml</b>
>
>
>       ---
>       - hosts: all
>         become: true
>         roles: 
>             - docker
>             - adjustDocker
>             - redis
>             - rabbitmq
>             - mysql


## Redis Cluster

> 
> Role folder
> - Docker : to install docker
> - Redis : to set up redis cluster
> 
> Bash folder
> - this folder contains a way to implement the redis replication taking from
>
> REFERENCE
> 
> https://www.youtube.com/watch?v=GEg7s3i6Jak
> 
> https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/storage/redis/clustering
> 
> 
> 
> 


## RabbitMQ cluster
1. Implement Ansible Playbook to deploy RabbitMQ cluster in docker containers.

2. After first playbook run, RabbitMQ cluster must be properly initialized. 

3. Management interface must be present, admin username and password must be configurable via Ansible variables.
>
> REFERENCE
>
> https://www.youtube.com/watch?v=FzqjtU2x6YA
>
> https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/messaging/rabbitmq
> 
> 
> 


## MySQL replication
1. Implement Ansible Playbook which deploys MySQL master and slave in Docker containers.

2. First playbook run must result in replication process running with now errors. 

3. MySQL data directories must be persisted on host’s disk.

>
> REFERENCE
> 
> https://www.digitalocean.com/community/tutorials/how-to-set-up-master-slave-replication-in-mysql
> 
> https://galaxy.ansible.com/opichon/docker-mysql
>
> https://github.com/nhat2008/docker-percona-mysql-replicate
> 
> https://hub.docker.com/r/mysql/mysql-cluster/
> 
> 

## References


 <b>MYSQL</b>
 
 - https://www.digitalocean.com/community/tutorials/how-to-set-up-master-slave-replication-in-mysql
 
 - https://galaxy.ansible.com/opichon/docker-mysql

 - https://github.com/nhat2008/docker-percona-mysql-replicate
 
 - https://hub.docker.com/r/mysql/mysql-cluster/
 
 


 <b>RABBITMQ</b>

 - https://www.youtube.com/watch?v=FzqjtU2x6YA

 - https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/messaging/rabbitmq
 
 
 


 <b>REDIS</b>
 
 - https://www.youtube.com/watch?v=GEg7s3i6Jak
 
 - https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/storage/redis/clustering
 
 
 
