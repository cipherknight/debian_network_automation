# docker base image for Netmiko, NAPALM, Pyntc, and Ansible

FROM debian:stretch

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y --no-install-recommends \
    install telnet curl openssh-client vim iputils-ping python build-essential \
    libssl-dev libffi-dev python-pip python3-pip python-setuptools \
    python-dev net-tools python3-setuptools python3-dev python3 dirmngr gnupg2

RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list.d/ansible.list \
    && DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
    && apt-get update && apt-get -y --no-install-recommends install ansible \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip3 install --upgrade pip

RUN pip install cryptography netmiko napalm pyntc \
    && pip install --upgrade paramiko && pip install --upgrade six

RUN pip3 install cryptography netmiko napalm pyntc \
    && pip3 install --upgrade paramiko && pip3 install --upgrade six

RUN mkdir /scripts \
    && mkdir /root/.ssh/ \
    && echo "KexAlgorithms diffie-hellman-group1-sha1,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1" > /root/.ssh/config \
    && echo "Ciphers 3des-cbc,blowfish-cbc,aes128-cbc,aes128-ctr,aes256-ctr" >> /root/.ssh/config

VOLUME [ "/root","/usr", "/scripts" ]

CMD [ "sh", "-c", "cd; exec /bin/bash -i" ]
