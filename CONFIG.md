# 从头部署指南
## 平台
部署成功的平台有Ubuntu 16.04/Ubuntu 18.04/Ubuntu 20.04/Centos 7.6
## nginx 1.10.1
./conf/nginx.conf需要配置的项目
- worker_processes 1 工作进程数
- 在events字段里添加use epoll 使用epoll
- worker_connections 1024 最大连接数
- listen 80 默认监听端口为80
- 静态网页配置
- 设置反向代理与负载均衡（可选）:

    访问域名对应location内设置代理：`location / { proxy_pass http://linux.test;}`

    设置代理的服务器：`upstream linux.test{server ip:port;}`
## fastcgi 2.4.1
./conf/nginx.conf内进行cgi命令请求的转发配置
- 编辑后，会被拷贝到/usr/local/nginx/conf目录下
- ip设置为本地，端口号与fcgi.sh里的端口号对应，同时要include同目录下的fastcgi.conf
## spawn-fcgi 1.6.4
- 对cgi命令请求进程转发，启动命令已写在fcgi.sh中，无特殊配置项
## MySQL 5.7
设置远程访问
- 配置文件/etc/mysql/mysql.cnf内将bind-address = 127.0.0.1注释，允许远程访问
- 还需要设置远程权限：登录后执行`grant all privileges on 库名.表名 to '用户名'@'IP地址' identified by '密码' with grant option;`，接着执行`flush privileges;`，然后再sudo service mysql restart重启mysql服务

设置utf8字符集
- 配置文件/etc/mysql/mysql.conf.d/mysqld.cnf在[mysqld]下添加`character-set-server=utf8`，默认使用utf8字符集
- 配置文件/etc/mysql/conf.d/mysql.cnf,[mysqld]下添加`default-character-set=utf8`

设置字段名不区分大小写
- 配置文件/etc/mysql/mysql.conf.d/mysqld.cnf在[mysqld]下添加`lower_case_table_names=1`，设置不区分大小写

最后重启mysql服务
- `sudo service mysql restart`
## redis 3.2.8
配置文件./conf/redis.conf需要配置的项目
    - bind IP 设置后，redis只接收来自该IP的请求
    - protected-mode no 设置为no，才能远程访问
    - port redis运行的端口，默认为6379
    - daemonize yes 以守护进程方式运行
    - pidfile "./redis/redis.pid" 将pid存放在redis/redis.pid文件中
    - timeout 0 设置连接超时时间，为0则不会超时
    - logfile "redis/redis.log" 将日志存放在redis/redis.log文件中
    - redis数据库镜像频率
    - dbfilename dump.rdb 数据库镜像备份文件名称
    - dir ./reids 数据库镜像备份文件的路径
## hiredis
无需配置项
## fastDFS 5.10
追踪器配置文件./conf/tracker.conf需要配置的项
- bind_addr=192.168.213.128 设置主机IP
- port=22122 设置端口
- base_path=/home/xxx/CloudDisk/fastdfs 设置log日志、pid等数据的路径

存储结点配置文件./conf/storage.conf需要配置的项
- group_name=group1 结点所在组名
- bind_addr=192.168.213.128 设置主机IP
- port=23000 设置端口
- base_path=/home/xxx/CloudDisk/fastdfs/storage 日志文件保存路径
- store_path_count=1 设置存储目录数量
- store_path0=/home/xxx/CloudDisk/fastdfs/storage 数据存储路径
- tracker_server=192.168.213.128:22122 tracker的IP和端口

客户端配置文件./conf/client.conf需要配置的项
- base_path=/home/xxx/CloudDisk/fastdfs/client 日志文件保存路径
- tracker_server=192.168.213.128:22122 tracker的IP和端口

脚本文件fastfds.sh内也需要修改配置路径
## fastdfs-nginx-module 1.16
obj/Makefile内需要添加两个头文件目录
- -I /usr/include/fastdfs
- -I /usr/include/fastcommon

由于用的同一台主机，可直接编辑配置文件./conf/mod_fastdfs.conf，之后会被拷贝到/etc/fdfs目录下
- base_path=/home/xxx/CloudDisk/fastdfs/storage
- tracker_server=192.168.213.128:22122
- storage_server_port=23000
- group_name=group1
- url_have_group_name=true 浏览器访问时要包含组名
- store_path_count=1
- store_path0=/home/xxx/CloudDisk/fastdfs/sotrage

除了编辑配置文件外，还要拷贝两个文件到/etc/fdfs目录
- 从fastDFS源码包的conf文件夹中的http.conf拷贝到/etc/fdfs
- 从nginx的源码包的conf文件夹中将mime.types拷贝到/etc/fdfs