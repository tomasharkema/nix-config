FROM almalinux:8 AS sysd-replace
WORKDIR /app
RUN yum -y install git
RUN git clone https://github.com/gdraheim/docker-systemctl-replacement

FROM almalinux:8

ENV PATH $PATH:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin
ENV TOMCATCFG /opt/dell/srvadmin/lib64/openmanage/apache-tomcat/conf/server.xml
ENV TERM xterm
ENV USER root
ENV PASS password
ENV SYSTEMCTL_SKIP_REDIRECT=1
ENV container docker

COPY --from=sysd-replace /app/docker-systemctl-replacement/files/docker/systemctl3.py /usr/bin/systemctl

RUN echo "$USER:$PASS" | chpasswd && \
    set -x && \
    yum -y install passwd dmidecode perl procps which tar gcc python3 && \
    curl -fsSL "https://linux.dell.com/repo/hardware/dsu/bootstrap.cgi" | bash -x && \
    curl -O https://linux.dell.com/repo/hardware/ism/bootstrap.sh && \
    sed -i 's#SERVER=""#SERVER="https://linux.dell.com"#g' bootstrap.sh && \
    sed -i 's#REPO_URL=""#REPO_URL="/repo/hardware/ism/"#g' bootstrap.sh && \
    echo "y" | sh bootstrap.sh -x && \
    yum update -y && \
    yum install -y net-snmp ipmitool srvadmin-all dell-system-update dcism && \
    yum clean all && \
    systemctl enable dcismeng instsvcdrv.service dsm_om_connsvc.service dsm_sa_snmpd.service dsm_om_shrsvc.service dsm_sa_datamgrd.service dsm_sa_eventmgrd.service && \
    sed -i -e 's/SSL_DHE_RSA_WITH_3DES_EDE_CBC_SHA/TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256/' -e 's/TLS_DHE_RSA_WITH_AES_128_CBC_SHA/TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA/' -e 's/TLS_DHE_DSS_WITH_AES_128_CBC_SHA/TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384/' -e 's/SSL_DHE_DSS_WITH_3DES_EDE_CBC_SHA/TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA/' $TOMCATCFG



WORKDIR /opt/dell/srvadmin/bin
EXPOSE 1311 161 162
CMD /usr/bin/systemctl
