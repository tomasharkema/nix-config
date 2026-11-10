FROM registry.suse.com/suse/sle15
RUN zypper ref
RUN zypper --non-interactive install iputils wget curl net-tools systemd udev usbutils glibc-locale-base gawk dbus-1 systemd-sysvinit dmidecode
RUN zypper --gpg-auto-import-keys ref
RUN zypper clean --all
RUN zypper --non-interactive update

#ism install from repo can be updated
#RUN wget https://linux.dell.com/repo/hardware/ism/os_dependent/ism_docker/docker_bootstrap.sh
RUN wget https://linux.dell.com/repo/hardware/ism/bootstrap.sh
RUN sed -i -e 's/\/repo\/hardware\/ism/\/repo\/hardware\/ISM_5400/g' bootstrap.sh
RUN echo y|sh bootstrap.sh
RUN zypper --non-interactive --ignore-unknown --no-cd install dcism
RUN systemctl enable dcismeng.service
ENV CONTAINER_ENV=1
CMD ["/sbin/init"]
# ENTRYPOINT "/opt/dell/srvadmin/iSM/sbin/dsm_ism_srvmgrd"
