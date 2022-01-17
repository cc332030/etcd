
# cd /usr/lib/systemd/system/
# cd /lib/systemd/system/

# rm -f etcd.service

# vi etcd.service

# systemctl daemon-reload

# systemctl start etcd.service
# systemctl status etcd.service
# systemctl stop etcd.service

# systemctl enable etcd.service

# Created symlink from /etc/systemd/system/multi-user.target.wants/etcd.service to /usr/lib/systemd/system/etcd.service.

# 每个机器填写自己主机名, 取 hostname -s 值即可,

[Unit]
Description=Etcd service
Wants=network-online.target
After=network.target

[Service] 
Type=notify
ExecStart=/root/program/etcd/etcd --name node-128 --data-dir /root/program/etcd/data --initial-advertise-peer-urls http://192.168.25.128:2380 --listen-peer-urls http://192.168.25.128:2380 --listen-client-urls http://192.168.25.128:2379,http://127.0.0.1:2379 --advertise-client-urls http://192.168.25.128:2379 --initial-cluster-token etcd-cluster --initial-cluster "node-128=http://192.168.25.128:2380,node-33=http://192.168.25.33:2380" --initial-cluster-state new
#ExecReload=/usr/local/frp/etcd
#ExecStop=/usr/local/frp/etcd

StandardOutput = syslog
StandardError = inherit

PrivateTmp=true 

[Install] 
WantedBy=multi-user.target
