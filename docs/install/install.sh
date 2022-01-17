
# 监听 0.0.0.0
# export NODE1=192.168.25.128


# for docker

docker volume create --name etcd-data
export DATA_DIR="etcd-data"



REGISTRY=quay.io/coreos/etcd
# available from v3.2.5
REGISTRY=gcr.io/etcd-development/etcd


docker run --net=host \
    --name etcd-v2.3.8 \
    --volume=/tmp/etcd-data:/etcd-data \
    quay.io/coreos/etcd:v2.3.8 \
    /usr/local/bin/etcd \
    --name my-etcd-1 \
    --data-dir /etcd-data \
    --listen-client-urls http://0.0.0.0:2379 \
    --advertise-client-urls http://0.0.0.0:2379 \
    --listen-peer-urls http://0.0.0.0:2380 \
    --initial-advertise-peer-urls http://0.0.0.0:2380 \
    --initial-cluster my-etcd-1=http://0.0.0.0:2380 \
    --initial-cluster-token my-etcd-token \
    --initial-cluster-state new

docker exec etcd-v2 /bin/sh -c "/usr/local/bin/etcd -version"
docker exec etcd-v2 /bin/sh -c "/usr/local/bin/etcdctl version"

docker exec etcd-v2 /bin/sh -c "/usr/local/bin/etcdctl set foo bar"
docker exec etcd-v2 /bin/sh -c "/usr/local/bin/etcdctl get foo"


etcdctl --endpoints=http://${NODE1}:2379 member list



# for docker 2
export NODE1=192.168.25.128

REGISTRY=quay.io/coreos/etcd
# available from v3.2.5
# REGISTRY=gcr.io/etcd-development/etcd

docker volume create --name etcd-data
export DATA_DIR="etcd-data"

docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:v2.3.8 \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name node1 \
  --initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster node1=http://${NODE1}:2380


# for linux

ETCD_VER=v2.3.8
DOWNLOAD_URL=https://github.com/coreos/etcd/releases/download

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

mkdir -p /tmp/test-etcd && tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/test-etcd --strip-components=1

/tmp/test-etcd/etcd --version

Git SHA: 7e4fc7e
Go Version: go1.7.5
Go OS/Arch: linux/amd64


# start a local etcd server
/tmp/test-etcd/etcd

# write,read to etcd
/tmp/test-etcd/etcdctl --endpoints=localhost:2379 set foo "bar"
/tmp/test-etcd/etcdctl --endpoints=localhost:2379 get foo