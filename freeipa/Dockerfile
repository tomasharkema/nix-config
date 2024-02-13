FROM docker.io/freeipa/freeipa-server:rocky-9

    # rm -rf /etc/sysconfig && \

        # rm -rf /etc/sysconfig/certbot && \

RUN cp /etc/yum.conf /etc/yum.conf.bak && \
    echo "sslverify=false" >> /etc/yum.conf && \
    mkdir -p /tmp/var/tmp && \
    rm -rf /var/tmp/* && \
    yum -y reinstall ca-certificates && \
    cp /etc/yum.conf.bak /etc/yum.conf && \
    yum makecache -y && \
    yum install epel-release -y && \
    yum install e2fsprogs -y && \
    ls -la /etc/sysconfig && \
    lsattr /etc/sysconfig && \
    yum install letsencrypt git -y && \
    yum clean all && \
    rm -rf /tmp/*

RUN pwd
WORKDIR /root
RUN git clone https://github.com/freeipa/freeipa-letsencrypt
WORKDIR /root/freeipa-letsencrypt
COPY freeipa-letsencrypt.patch .
RUN git apply freeipa-letsencrypt.patch
WORKDIR /