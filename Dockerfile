FROM ubuntu:16.04

# Install package
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y git vim nano htop net-tools python-pip openssl telnet nmap iputils-ping
RUN pip install --upgrade pip
RUN pip install boto boto3 awscli ansible


# Setup SSH daemon
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir ~/.ssh/
RUN chmod 700 ~/.ssh/
RUN touch ~/.ssh/authorized_keys
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZ5d5QRkv6tRFgKpzxrmpm7QAYKiX5hqM/4Sr7mHHUK5lkqFTv2B74Ks7HKcpyYW2GkKGYcQo6S4Ugaj4Iv3xGPRqSKMC4Jt+O78hsQlRJ90h4B5OgQ2HdE77RMNSnEvNswo7D6dTEUpJeT6J/C7eSi/DjPRyvUhqxRU1uU4Eh35WU1URXbwTdou1RjNoqSTSUltczxVluPZ1TJiP+aNibEMeenmNFXjZH+UmomPTAyEd0yIcryl0osAF1mUfs5RcEvNuPiZGcGwWHABGFf1XSXty2hFawLHExMfochHja9BgbIobS1pTSH7vptyHg7pXtKwsdSb6/AF/Wc2USPbBN root@webistrano.icubeonline.com" > ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]