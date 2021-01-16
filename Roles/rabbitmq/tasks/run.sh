docker network create rabbits
docker run -d --rm --net rabbits --hostname rabbit-1 --name rabbit-1 -p 8060:15672 -e RABBITMQ_ERLANG_COOKIE=DSHEVCXBBETJJVJWTOWT rabbitmq:3.8-management
docker run -d --rm --net rabbits --hostname rabbit-2 --name rabbit-2 -p 8061:15672 -e RABBITMQ_ERLANG_COOKIE=DSHEVCXBBETJJVJWTOWT rabbitmq:3.8-management
docker run -d --rm --net rabbits --hostname rabbit-3 --name rabbit-3 -p 8062:15672 -e RABBITMQ_ERLANG_COOKIE=DSHEVCXBBETJJVJWTOWT rabbitmq:3.8-management 
 

docker exec -it rabbit-1 rabbitmqctl start_app
docker exec -it rabbit-1 rabbitmqctl cluster_status

#join node 2

docker exec -it rabbit-2 rabbitmqctl stop_app
docker exec -it rabbit-2 rabbitmqctl reset
docker exec -it rabbit-2 rabbitmqctl join_cluster rabbit@rabbit-1
docker exec -it rabbit-2 rabbitmqctl start_app
docker exec -it rabbit-2 rabbitmqctl cluster_status

#join node 3
docker exec -it rabbit-3 rabbitmqctl stop_app
docker exec -it rabbit-3 rabbitmqctl reset
docker exec -it rabbit-3 rabbitmqctl join_cluster rabbit@rabbit-1
docker exec -it rabbit-3 rabbitmqctl start_app
docker exec -it rabbit-3 rabbitmqctl cluster_status

docker run -d --rm --net rabbits -p 8080:15672 -e RABBITMQ_ERLANG_COOKIE=DSHEVCXBBETJJVJWTOWT --hostname rabbit-manager --name rabbit-manager rabbitmq:3.8-management


#docker exec -it rabbit-1 service rabbitmq-server start
#docker exec -it rabbit-1 rabbitmqctl start_app