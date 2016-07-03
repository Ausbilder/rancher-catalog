#!/bin/bash

echo "Redis Config: "
cat /redis/redis.conf

echo "Given Variables: Redis Node Port: $(REDIS_NODE_PORT), Replication Factor: $(REPLICATION_FACTOR)"

########### INIT NODE ###########
if [ "$1" = "init" ]; then

	echo "Getting Service Name"
	service=. ./getService.sh
	echo "$servive"
	
	echo "Getting Container List for Service $service" #available in ENV VAR CONTAINER Key-Vale: Hostname - IP
	. ./getContainerListForService.sh $service
	
	for host_name in ${!CONTAINER[@]};
	do
	nodes_with_port+=" $host_name:$(REDIS_NODE_PORT)"
	echo "Adding Container: $host_name to Redis Cluster config"
	done
	
	echo "Starting Cluster with ./src/redis-trib.rb create --replicas $(REPLICATION_FACTOR) $nodes_with_port"
	echo "yes" | /redis/src/redis-trib.rb create --replicas $(REPLICATION_FACTOR) $nodes_with_port

	echo "Redis Cluster up and running - shutting down init Container ... bye"	

	
	########### REDIS NODE ###########
else
	echo "Starting Node with src/redis-server /redis/redis.conf --port $(REDIS_NODE_PORT)"
	. supervisord -c /redis/supervisord_node.conf
fi
