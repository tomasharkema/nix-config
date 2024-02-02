FROM docker.io/freeipa/freeipa-server:rocky-9

RUN cp /etc/yum.conf /etc/yum.conf.bak && \
    echo "sslverify=false" >> /etc/yum.conf && \
    yum -y reinstall ca-certificates && \
    rm -rf /etc/yum.conf && mv /etc/yum.conf.bak /etc/yum.conf && \
    yum -y install epel-release  && \
    yum -y install certbot python3-certbot-apache 
