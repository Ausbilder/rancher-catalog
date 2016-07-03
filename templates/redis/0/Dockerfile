FROM svenahlfeld/centos6jdk8

RUN yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel
RUN yum -y install ruby-rdoc ruby-devel
RUN yum -y install rubygems
RUN yum -y install git-all
RUN yum -y install python-setuptools
RUN easy_install supervisor

# Clone the Unstable Version of redis that contains redis-cluster
RUN git clone -b 3.0 https://github.com/antirez/redis.git

# Install Redis 
WORKDIR /redis
RUN make
RUN gem install redis

# Add config file
ADD conf/redis.conf /redis/redis.conf
ADD conf/supervisord_node.conf /redis/supervisord_node.conf

#Add Scripts
ADD conf/getService.sh /redis/getService.sh
RUN chmod +x /redis/getService.sh

ADD conf/getContainerListForService.sh /redis/getContainerListForService.sh
RUN chmod +x /redis/getContainerListForService.sh

# Add init script
ADD bootstrap.sh /redis/bootstrap.sh
RUN chmod +x /redis/bootstrap.sh

CMD ["/redis/bootstrap.sh"] 
