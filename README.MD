
## Requirement to task implementation:
● Solution must contain a valid Vagrantfile to test solution

● All logic must be implemented via Ansible Playbooks/Roles

● You can use public Ansible roles, Ansible Galaxy is preferred source

● Solution must contain basic README

## Redis Cluster
Implement Ansible playbook to deploy Redis cluster in docker containers.
After first playbook run, Redis cluster must be properly initialized. Redis data should be
persistent on host.

> 
> Role folder
> - Docker : to install docker
> - Redis : to set up redis cluster
> 
> Bash folder
> - this folder contains a way to implement the redis replication taking from
> 
> https://www.youtube.com/watch?v=GEg7s3i6Jak
> 
> https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/storage/redis/clustering
> 
> 
> Still work in progress
> 
> 


## RabbitMQ cluster
Implement Ansible Playbook to deploy RabbitMQ cluster in docker containers.
After first playbook run, RabbitMQ cluster must be properly initialized. Management interface
must be present, admin username and password must be configurable via Ansible variables.

> https://www.youtube.com/watch?v=FzqjtU2x6YA
>
> https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/messaging/rabbitmq
> 
> Still work in progress
> 
> 


## MySQL replication
Implement Ansible Playbook which deploys MySQL master and slave in Docker containers.
First playbook run must result in replication process running with now errors. MySQL data
directories must be persisted on host’s disk.

> 
> https://www.digitalocean.com/community/tutorials/how-to-set-up-master-slave-replication-in-mysql
> https://galaxy.ansible.com/opichon/docker-mysql
> https://github.com/nhat2008/docker-percona-mysql-replicate
> 


