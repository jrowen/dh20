FROM rocker/hadleyverse
MAINTAINER "Jonathan Owen" jonathanro@gmail.com

# Install Java
# https://github.com/William-Yeh/docker-java7/blob/master/Dockerfile
RUN \
  echo "===> add webupd8 repository..."  && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
  apt-get update  && \
  \
  \
  echo "===> install Java"  && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
  DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java7-installer oracle-java7-set-default  && \
  \
  \
  echo "===> clean up..."  && \
  rm -rf /var/cache/oracle-jdk7-installer  && \
  apt-get clean  && \
  rm -rf /var/lib/apt/lists/*

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Fetch h2o mirzakhani
RUN \
  wget http://h2o-release.s3.amazonaws.com/h2o/rel-noether/4/h2o-2.8.4.4.zip -O /opt/h2o.zip && \
  unzip -d /opt /opt/h2o.zip && \
  rm /opt/h2o.zip && \
  cd /opt && \
  cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \ 
  cp h2o.jar /opt && \
  wget https://s3.amazonaws.com/h2o-training/mnist/train.csv.gz && \
  gunzip train.csv.gz 

EXPOSE 54321
EXPOSE 54322

# install caret related packages
RUN install2.r --error \
    RCurl \
    rjson \
    statmod \
    survival \
    stats \
    tools \
    utils \
    methods \
    h2o \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
