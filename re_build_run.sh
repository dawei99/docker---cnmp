#!/usr/bin/sh
# 打包新的镜像并启动
docker stop cnmp$1
docker rm cnmp$1
docker build -t diannao99/cnmp$1  /opt/xinzhongzhi/build_docker/
docker run -ditp 32780:80 --name cnmp$1 -v /opt/xinzhongzhi/mysql_data:/data/mysql -v /opt/xinzhongzhi/vhosts:/usr/local/nginx/conf/vhosts -v /opt/xinzhongzhi/www:/www diannao99/cnmp:$1

