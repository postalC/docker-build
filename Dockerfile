FROM ubuntu:14.04

# Proxy
# ENV http_proxy http://proxy.wdf.sap.corp:8080
# ENV https_proxy http://proxy.wdf.sap.corp:8080
# ENV no_proxy sap.corp,wdf.sap.corp,localhost,127.0.0.1,moo-repo,169.254.169.254,repo

# install java7
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true \
  | debconf-set-selections && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer 
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# install openssh-server
RUN apt-get update && apt-get install -y openssh-server

# add user
# clonzc
RUN useradd -m -d /home/clonzc -s /bin/bash clonzc && \
  echo clonzc:initial | chpasswd 

ADD startup.sh /home/clonzc/etc/
ADD sshd_config /home/clonzc/ssh/etc/sshd_config
RUN chown -R clonzc:clonzc /home/clonzc && chmod -R a+x /home/clonzc  

USER clonzc
ENV HOME /home/clonzc

# setup ssh server
RUN \
  mkdir -p ~/ssh/run ~/ssh/etc && \
  ssh-keygen -t rsa -f ~/ssh/etc/ssh_host_rsa_key -N ''

WORKDIR /home/clonzc/
CMD bash -C ~/etc/startup.sh;bash
