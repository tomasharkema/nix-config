
FROM almalinux:8

ENV PATH $PATH:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin
ENV TOMCATCFG /opt/dell/srvadmin/lib64/openmanage/apache-tomcat/conf/server.xml
ENV TERM xterm
ENV USER root
ENV PASS password
ENV SYSTEMCTL_SKIP_REDIRECT=1
ENV container podman

RUN yum -y install passwd # gcc wget perl passwd which tar nano dmidecode strace less openssl-devel

RUN curl -fsSL https://linux.dell.com/repo/hardware/dsu/bootstrap.cgi | bash -x
RUN curl -O https://linux.dell.com/repo/hardware/ism/bootstrap.sh
RUN sed -i 's#SERVER=""#SERVER="https://linux.dell.com"#g' bootstrap.sh
RUN sed -i 's#REPO_URL=""#REPO_URL="/repo/hardware/ism/"#g' bootstrap.sh
RUN sh bootstrap.sh -x

RUN yum update -y
RUN yum install -y srvadmin-all dell-system-update dcism

RUN systemctl enable dcismeng instsvcdrv.service dsm_om_connsvc.service dsm_sa_snmpd.service dsm_om_shrsvc.service dsm_sa_datamgrd.service dsm_sa_eventmgrd.service    
# RUN systemctl disable instsvcdrv.service          

CMD ["/usr/sbin/init"]

# FROM ubuntu:focal

# ENV PATH $PATH:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin
# ENV TOMCATCFG /opt/dell/srvadmin/lib64/openmanage/apache-tomcat/conf/server.xml
# ENV TERM xterm
# ENV USER root
# ENV PASS password

# RUN apt-get -y update 
# RUN apt-get -y install wget gnupg apt-utils systemd

# RUN echo 'deb http://linux.dell.com/repo/community/openmanage/950/focal focal main' > /etc/apt/sources.list.d/linux.dell.com.sources.list 

# RUN wget https://linux.dell.com/repo/pgp_pubkeys/0x1285491434D8786F.asc 

# RUN apt-key add 0x1285491434D8786F.asc 
# RUN apt-get -y update
# RUN apt-get -y install ipmitool snmpd
# RUN apt-get -y install srvadmin-all || true # dell-system-update

# RUN cat "/bin/true" > /var/lib/dpkg/info/srvadmin-hapi.postinst
# RUN cat "/bin/true" > /var/lib/dpkg/info/srvadmin-idracadm7.postinst
# RUN dpkg --configure -a
# RUN apt-get -y install srvadmin-hapi srvadmin-idracadm7
# RUN ls -la / /sbin/
# CMD [ "/sbin/init" ]