#!/bin/bash
mysqluser=You mysql user
mysqlpasswd=Youmysql password
gitlab_doman=You Domain
echo "Stop And Delete Redis Service..."
docker stop redis
docker rm redis
echo "Start Redis Service..."
docker run --name redis -d \
  --publish 6379:6379 \
  --volume /data/redis:/var/lib/redis \
  index.alauda.cn/sameersbn/redis:latest

echo "Stop And Delete MySql Service..."
docker stop mysql
docker rm mysql
echo "Start Mysql Service..."
docker run --name mysql -d \
    --publish 3306:3306 \
    -e "DB_REMOTE_ROOT_NAME=$mysqluser" -e 'DB_REMOTE_ROOT_HOST=%' -e "DB_REMOTE_ROOT_PASS=$mysqlpasswd" \
    --env 'DB_NAME=git_tanzi_production' \
    --env 'DB_USER=gitanz' --env 'DB_PASS=git*HJ$adsA12' \
    --volume /data/mysql:/var/lib/mysql \
    index.alauda.cn/sameersbn/mysql

echo "Stop And Delete gitlab Service..."
docker stop gitlab
docker rm gitlab
echo "Start gitlab Service..."



docker run --name gitlab -d \
    --env 'GITLAB_SECRETS_DB_KEY_BASE=Rpwq35wjLJ5N6CrkvdXsqTDHsh6XG3QkhdtRTkt87fvLwzvlmtdNWMCwNjDj5Xk9' \
    --env "GITLAB_HOST=$gitlab_doman" \
    --link mysql:mysql \
    --link redis:redisio \
    --volume /data/gitlab:/home/git/data \
    index.alauda.cn/sameersbn/gitlab


sleep 10

echo "Stop And Delete Nginx Service..."
docker stop nginx
docker rm nginx
echo "Start nginx Service..."
docker run -d --name nginx -p 80:80 \
    -v /data/nginx/config:/etc/nginx/conf.d \
    --link gitlab:gitlabos \
    index.alauda.cn/library/nginx
sleep 10
echo ""
echo ""
echo ""
echo "Start Is Ok..."
echo "mysql User : $mysqluser"
echo "mysql pwd  : $mysqlpasswd"
echo "gitlab root password: $gitlab_pwd"
echo "gitlab HOST SERVER : $gitlab_doman"
