
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
Creating a Docker Network. Creating Redis Nodes with custom configuration settings files. Creating 3 Sentinel nodes to monitor the cluster.
> 
> <b>REDIS ROLE TASKS</b>
> 
>       - name: Create Docker Network
>         become: true
>         shell: "docker network create redis"
>         ignore_errors: yes
>       
>       - name: Create Docker Volume
>         become: true
>         shell: "sudo docker volume create redis"
>         ignore_errors: yes
>       
>       - name: Create Redis Cluster Node 0 
>         become: true
>         shell: "sudo docker run -d --rm --name redis-0 --net redis -v /conf/redis/conf/redis-0:/etc/redis/ -v redis:/data/ redis:6.0-alpine redis-server /etc/redis/redis.conf"
>         ignore_errors: yes
> 
>       - name: Create Redis Cluster Node 1 
>         become: true
>         shell: "sudo docker run -d --rm --name redis-1 --net redis -v /conf/redis/conf/redis-1:/etc/redis/ -v redis:/data/ redis:6.0-alpine redis-server /etc/redis/redis.conf"
>         ignore_errors: yes
>       
>       - name: Create Redis Cluster Node 2 
>         become: true
>         shell: "sudo docker run -d --rm --name redis-2 --net redis -v /conf/redis/conf/redis-2:/etc/redis/ -v redis:/data/ redis:6.0-alpine redis-server /etc/redis/redis.conf"
>         ignore_errors: yes
>       
>       - name: Create Redis Sentinel Node 0 
>         become: true
>         shell: "sudo docker run -d --rm --name sentinel-0 --net redis -v /conf/redis/conf/sentinel-0:/etc/redis/ redis:6.0-alpine redis-sentinel /etc/redis/sentinel.conf"
>         ignore_errors: yes
>       
>       - name: Create Redis Sentinel Node 1 
>         become: true
>         shell: "sudo docker run -d --rm --name sentinel-1 --net redis -v /conf/redis/conf/sentinel-1:/etc/redis/ redis:6.0-alpine redis-sentinel /etc/redis/sentinel.conf"
>         ignore_errors: yes
>       
>       - name: Create Redis Sentinel Node 2 
>         become: true
>         shell: "sudo docker run -d --rm --name sentinel-2 --net redis -v /conf/redis/conf/sentinel-2:/etc/redis/ redis:6.0-alpine redis-sentinel /etc/redis/sentinel.conf"
>         ignore_errors: yes
>       

## RabbitMQ cluster
Creating 3 nodes using custom configuration file settings. Setting a custer using rabbit-1 as the master and rabbit-2 and rabbit-3 as slaves


> 
> <b>RABBIT ROLE TASKS</b>
>
>       - name: Create Docker Network
>         become: true
>         shell: "docker network create rabbits" 
>         ignore_errors: yes
>       
>       - name: Create Rabbit Cluster Node 1 
>         become: true
>         shell: "sudo docker run -d --rm --net rabbits -v /conf/rabbitmq/conf/rabbit-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=WIWVHCDTCIUAWANLMQAW --hostname rabbit-1 --name rabbit-1 -p 8081:15672 rabbitmq:3.8-management"
>         ignore_errors: yes
>       
>       - name: Create Rabbit Cluster Node 2 
>         become: true
>         shell: "sudo docker run -d --rm --net rabbits -v /conf/rabbitmq/conf/rabbit-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=WIWVHCDTCIUAWANLMQAW --hostname rabbit-2 --name rabbit-2 -p 8082:15672 rabbitmq:3.8-management"
>         ignore_errors: yes
>       
>       - name: Create Rabbit Cluster Node 3 
>         become: true
>         shell: "sudo docker run -d --rm --net rabbits -v /conf/rabbitmq/conf/rabbit-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=WIWVHCDTCIUAWANLMQAW --hostname rabbit-3 --name rabbit-3 -p 8083:15672 rabbitmq:3.8-management"
>         ignore_errors: yes
>       
>       - name: Start Rabbit Cluster Node 1 
>         become: true
>         shell: "sudo docker exec -it rabbit-1 rabbitmqctl start_app "
>         ignore_errors: yes
>       
>       - name: Create Rabbit Cluster Node 1 
>         become: true
>         shell: "sudo docker exec -it rabbit-1 rabbitmqctl cluster_status "
>         ignore_errors: yes
>       
>       
>       # JOIN SLAVE 1
>       - name: Join Slave 1 - step 1
>         become: true
>         shell: "sudo docker exec -it rabbit-2 rabbitmqctl stop_app "
>         ignore_errors: yes
>       
>       - name: Join Slave 1 - step 2
>         become: true
>         shell: "sudo docker exec -it rabbit-2 rabbitmqctl reset "
>         ignore_errors: yes
>       
>       - name: Join Slave 1 - step 3
>         become: true
>         shell: "sudo docker exec -it rabbit-2 rabbitmqctl join_cluster rabbit@rabbit-1 "#
>         ignore_errors: yes
>       
>       - name: Join Slave 1 - step 4
>         become: true
>         shell: "sudo docker exec -it rabbit-2 rabbitmqctl start_app "
>         ignore_errors: yes
>       
>       - name: Join Slave 1 - step 5
>         become: true
>         shell: "sudo docker exec -it rabbit-2 rabbitmqctl cluster_status "
>         ignore_errors: yes
>       
>      
>       # JOIN SLAVE 2
>       - name: Join Slave 2 - step 1
>         become: true
>         shell: "sudo docker exec -it rabbit-3 rabbitmqctl stop_app "
>         ignore_errors: yes
>       
>       - name: Join Slave 2 - step 2
>         become: true
>         shell: "sudo docker exec -it rabbit-3 rabbitmqctl reset "
>         ignore_errors: yes
>       
>       - name: Join Slave 2 - step 3
>         become: true
>         shell: "sudo docker exec -it rabbit-3 rabbitmqctl join_cluster rabbit@rabbit-1 "#
>         ignore_errors: yes
>       
>       - name: Join Slave 2 - step 4
>         become: true
>         shell: "sudo docker exec -it rabbit-3 rabbitmqctl start_app "
>         ignore_errors: yes
>       
>       - name: Join Slave 2 - step 5
>         become: true
>         shell: "sudo docker exec -it rabbit-3 rabbitmqctl cluster_status "




## MySQL replication
Setting 1 management mysql node, 2 ndbd data servers ndb1 y ndb2 and 1 mysql node mysql1.

> 
> <b>MYSQL ROLE TASKS</b>
>
>       - name: Create Docker Network
>         become: true
>         shell: "docker network create mysql --subnet=192.168.0.0/16"
>         ignore_errors: yes
>       
>       - name: Create Mysql Management
>         become: true
>         shell: "docker run -d --net=mysql --name=management1 --ip=192.168.0.2 mysql/mysql-cluster ndb_mgmd"
>         ignore_errors: yes
>       
>       - name: Create Mysql Data Node 1
>         become: true
>         shell: "docker run -d --net=mysql --name=ndb1 --ip=192.168.0.3 mysql/mysql-cluster ndbd"
>       
>       - name: Create Mysql Data Node 2
>         become: true
>         shell: "docker run -d --net=mysql --name=ndb2 --ip=192.168.0.4 mysql/mysql-cluster ndbd"
>       
>       - name: Create Mysql Service Node 1
>         become: true
>         shell: "docker run -d --net=mysql --name=mysql1 --ip=192.168.0.10 -e MYSQL_ROOT_PASSWORD='{{ MYSQL_ROOT_PASSWORD }}'  mysql/mysql-cluster mysqld"







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
 
 
 
