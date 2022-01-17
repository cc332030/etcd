
# /etc/etcd/etcd.conf

rm -rf data

# 每个机器填写自己主机名, 取 hostname -s 值即可,
NAME=node-128

#本机IP地址
LOCAL_IP=192.168.25.128

#ETCD存储目录
DATA_DIR=/root/program/etcd/data

# 用于 etcdctl 命令连接, 其中 127.0.01 用于本地连接
LISTEN_CLIENT_URLS="http://192.168.25.128:2379,http://127.0.0.1:2379"

# 用于监听其他 etcd member 连接
LISTEN_PEER_URLS="http://192.168.25.128:2380,http://127.0.0.1:2380"

# 本地用于监听并连接其他 member 的地址
INITIAL_ADVERTISE_PEER_URLS="http://192.168.25.128:2380"

# 用于标记集群唯一性的 token
INITIAL_CLUSTER_TOKEN="etcd-cluster"

# 启动集群使, 使用静态连接方法, 定义每个 member 主机名 endpoint
INITIAL_CLUSTER="node-128=http://192.168.25.128:2380,node-33=http://192.168.25.33:2380"

#初始化状态
INITIAL_CLUSTER_STATE=new
# INITIAL_CLUSTER_STATE=existing

./etcd --name ${NAME} --data-dir ${DATA_DIR} \
    --initial-advertise-peer-urls http://${LOCAL_IP}:2380 \
    --listen-peer-urls http://${LOCAL_IP}:2380 \
    --listen-client-urls http://${LOCAL_IP}:2379,http://127.0.0.1:2379 \
    --advertise-client-urls http://${LOCAL_IP}:2379 \
    --initial-cluster-token ${INITIAL_CLUSTER_TOKEN} \
    --initial-cluster ${INITIAL_CLUSTER} \
    --initial-cluster-state ${INITIAL_CLUSTER_STATE} \
    --force-new-cluster

/root/program/etcd/etcd --name node-128 --data-dir /root/program/etcd/data --initial-advertise-peer-urls http://192.168.25.128:2380 --listen-peer-urls http://192.168.25.128:2380 --listen-client-urls http://192.168.25.128:2379,http://127.0.0.1:2379 --advertise-client-urls http://192.168.25.128:2379 --initial-cluster-token etcd-cluster --initial-cluster "node-128=http://192.168.25.128:2380,node-33=http://192.168.25.33:2380" --initial-cluster-state new
