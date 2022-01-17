
# alpine 启动 etcd

## start
```shell script
app_home=/home/program

image=alpine
tag=latest

name=etcd
ip=0.0.0.0

docker pull $image:$tag

docker stop $name
docker rm $name

docker run -d \
  \
  --privileged=true \
  --restart unless-stopped \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  \
  -v /etc/localtime:/etc/localtime \
  \
  -v $app_home/$name:/etcd \
  \
  -p 2379:2379 \
  -p 2380:2380 \
  \
  --name $name \
  \
  $image:$tag \
  \
  /etcd/bin/etcd \
  --name node-128 \
  --data-dir /etcd/data \
  --initial-advertise-peer-urls http://$ip:2380 \
  --listen-peer-urls http://$ip:2380 \
  --listen-client-urls http://$ip:2379 \
  --advertise-client-urls http://$ip:2379 \
  --initial-cluster-token etcd-cluster \
  --initial-cluster "node-128=http://$ip:2380" \
  --initial-cluster-state new

```

## 备份
```shell script
dexec etcd /etcd/bin/etcdctl backup --data-dir /etcd/data --backup-dir /etcd/backup/2020-06-16
```
