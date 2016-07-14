#!/bin/bash
docker stop nginx
docker rm nginx
docker run -d --name nginx -p 80:80 -v $(pwd)/config:/etc/nginx/conf.d --link gitlab:gitlabos index.alauda.cn/library/nginx
