FROM ubuntu:14.04
MAINTAINER "Benjamin Wootton <benjamin.wootton@contino.co.uk>"

# Prerequisites
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install --fix-missing
RUN apt-get install -y wget

# Install Java
RUN apt-get -y install openjdk-7-jre-headless 

# Install Logstash
RUN cd /root && wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz --no-check-certificate
RUN cd /root && tar -xzf logstash-1.4.0.tar.gz
RUN cd /root && rm -rf logstash-1.4.0.tar.gz 
ADD ./docker/logstash.conf /root/logstash-1.4.0/logstash.conf

# Install Elastic
RUN cd /root && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz  
RUN cd /root && tar -xzf elasticsearch-1.1.1.tar.gz
RUN cd /root && rm -rf /root/elasticsearch-1.1.1.tar.gz

# Install Supervisor
RUN apt-get install -y supervisor
ADD ./docker/supervisor/elasticsearch.conf /etc/supervisor/conf.d/
ADD ./docker/supervisor/logstash.conf /etc/supervisor/conf.d/
ADD ./docker/supervisor/kibana.conf /etc/supervisor/conf.d/

# Expose Kibana, ElasticSearch, and SYSLOG port respectively
EXPOSE 9292 
EXPOSE 9200
EXPOSE 5000

# Start supervisor
CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
