FROM ubuntu:latest

VOLUME [ "/nix/store" ]

# RUN apt-get update && apt-get install -y openssh-server curl xz-utils systemd systemd-sysv

# Enable systemd.
RUN apt-get update ; \
    apt-get install -y openssh-server curl xz-utils systemd systemd-sysv ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ;

# Configure SSH
RUN mkdir /var/run/sshd

# RUN echo 'root:redhat' | chpasswd

#password for user login

# RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN systemctl enable ssh && mkdir -p /root/.ssh && curl https://github.com/tomasharkema.keys > /root/.ssh/authorized_keys

EXPOSE 22

# Start SSH server

# CMD ["/bin/bash", "-c", "nix-daemon & sh <(curl -L https://nixos.org/nix/install) --daemon --yes && /usr/sbin/sshd -D"]

CMD ["/lib/systemd/systemd"]