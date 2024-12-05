
FROM almalinux:8

ENV PATH $PATH:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin
ENV TOMCATCFG /opt/dell/srvadmin/lib64/openmanage/apache-tomcat/conf/server.xml
ENV TERM xterm
ENV USER root
ENV PASS password
ENV SYSTEMCTL_SKIP_REDIRECT=1
ENV container podman

RUN yum -y install passwd dmidecode && \
    curl -fsSL https://linux.dell.com/repo/hardware/dsu/bootstrap.cgi | bash -x && \
    curl -O https://linux.dell.com/repo/hardware/ism/bootstrap.sh && \
    sed -i 's#SERVER=""#SERVER="https://linux.dell.com"#g' bootstrap.sh && \
    sed -i 's#REPO_URL=""#REPO_URL="/repo/hardware/ism/"#g' bootstrap.sh && \
    sh bootstrap.sh -x && \
    yum update -y && \
    yum install -y net-snmp ipmitool srvadmin-all dell-system-update dcism && \
    systemctl enable dcismeng instsvcdrv.service dsm_om_connsvc.service dsm_sa_snmpd.service dsm_om_shrsvc.service dsm_sa_datamgrd.service dsm_sa_eventmgrd.service    

CMD ["/usr/sbin/init"]

WORKDIR /opt/dell/srvadmin/bin

EXPOSE 1311 161 162