
# 恢复数据，查看节点
etcdctl member list

# 设置节点参数
# etcdctl member update 6c50343cbe01 http://192.168.25.128:2380

curl http://192.168.25.128:2379/v2/members/6c50343cbe01 -XPUT \
 -H "Content-Type:application/json" -d '{"peerURLs":["http://192.168.25.128:2380"]}'

# 添加节点，添加后会显示子节点需要注意的配置信息，复制过去
etcdctl member add node-33 http://192.168.25.33:2380

# 输出的配置信息
#ETCD_NAME="node-33"
#ETCD_INITIAL_CLUSTER="node-128=http://127.0.0.1:2380,node-128=http://192.168.25.128:2380,node-33=http://192.168.25.33:2380"
#ETCD_INITIAL_CLUSTER_STATE="existing"

# 删除节点
etcdctl member remove a8266ecf031671f3
