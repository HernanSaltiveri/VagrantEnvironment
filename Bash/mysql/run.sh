
docker network create mysql
docker volume create mysql

docker run -d --rm --net mysql --hostname mysql-1 --name mysql-1 -v redis:/data/ mysql/mysql-server:8.0

#docker pull mysql/mysql-server:tag

#docker run --name=container_name  --restart on-failure -d image_name:tag


# PERSISTENCIA
#docker run --name=mysql80 \
#   --mount type=bind,src=/path-on-host-machine/my.cnf,dst=/etc/my.cnf \
#   --mount type=bind,src=/path-on-host-machine/datadir,dst=/var/lib/mysql \
#   -d mysql/mysql-server:8.0

docker inspect mysql-1

#https://phoenixnap.com/kb/mysql-docker-container