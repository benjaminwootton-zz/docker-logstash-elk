# Docker 

Logstash is the leading open source log management server.

It is usually backed with Elasticsearch as the datastore, and Kibana is the frontend.

This project aims to provide two things:

- A production ready dockerised version of Elasticsearch, Kibana and LogStash.
- An example of how to call into this via a syslog daemon hosted on a remote host (which is called into from some remote docker container)

## Running The Server 

Build and run the docker image:
   
    git clone http://github.com/benjaminwootton/docker-elk-example.git
    docker build .
    docker run -p 9200:9200 -p 9292:9292 -p 5000:5000 <image id>


# To publish to Logstash via RSYSLOG

    sudo su - root
    vim /etc/rsyslog.conf 
    # Log Messages Over UDP                          
    *.* @192.168.1.92:514                            
                           
