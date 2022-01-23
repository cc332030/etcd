
ln -s /root/program/etcd/etcd /usr/local/bin/etcd
ln -s /root/program/etcd/etcdctl /usr/local/bin/etcdctl

#!/bin/sh

/usr/local/etcd/etcd     --name my-etcd-1 \
    --data-dir /etcd-data \
    --listen-client-urls http://0.0.0.0:2379 \
    --advertise-client-urls http://0.0.0.0:2379 \
    --listen-peer-urls http://0.0.0.0:2380 \
    --initial-advertise-peer-urls http://0.0.0.0:2380 \
    --initial-cluster my-etcd-1=http://0.0.0.0:2380 \
    --initial-cluster-token my-etcd-token \
    --initial-cluster-state new \
    &

etcd --name ${ETCD_NAME} --data-dir ${ETCD_DATA_DIR} \
    --initial-advertise-peer-urls http://${LOCAL_IP}:2380 \
    --listen-peer-urls http://${LOCAL_IP}:2380 \
    --listen-client-urls http://${LOCAL_IP}:2379,http://127.0.0.1:2379 \
    --advertise-client-urls http://${LOCAL_IP}:2379 \
    --initial-cluster-token ${INITIAL_CLUSTER_TOKEN} \
    --initial-cluster ${INITIAL_CLUSTER} \
    --initial-cluster-state ${INITIAL_CLUSTER_STATE} \
    &


# 主机 IP 
export NODE1=192.168.25.128

# 配置Docker卷以存储etcd数据
docker volume create --name etcd-data
export DATA_DIR="etcd-data"

# 运行最新版本的etcd
REGISTRY=quay.io/coreos/etcd
# available from v3.2.5
REGISTRY=gcr.io/etcd-development/etcd

docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:latest \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name node1 \
  --initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster node1=http://${NODE1}:2380




# 直接备份 member 文件夹



# 备份
etcdctl backup --data-dir data --backup-dir .
etcdctl backup --data-dir default.etcd --backup-dir .

etcdctl backup \
      --data-dir /etcd-data \
      --wal-dir %wal_dir% \
      --backup-dir %backup_data_dir% \
      --backup-wal-dir %backup_wal_dir%

etcdctl backup \
      --data-dir %data_dir% \
      --wal-dir %wal_dir% \
      --backup-dir %backup_data_dir% \
      --backup-wal-dir %backup_wal_dir%

# 恢复

etcd -data-dir=/etcd-data --force-new-cluster 
etcd -data-dir=data --force-new-cluster 

etcd \
      -data-dir=%backup_data_dir% \
      [-wal-dir=%backup_wal_dir%] \
      --force-new-cluster \