FROM ubuntu:16.04

RUN apt-get update; \
    apt-get install -y python-software-properties \
                       software-properties-common

# Install Java7
RUN add-apt-repository -y ppa:webupd8team/java; \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections;

RUN apt-get update; \
    apt-get -y install oracle-java7-installer

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list; \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update; \
    apt-get install -y postgresql-9.6

RUN echo "local all all md5" >> /etc/postgresql/9.6/main/pg_hba.conf;

ADD . /opt/api-server
WORKDIR /opt/api-server
ENV JAVA_HOME="/usr/lib/jvm/java-7-oracle/"

EXPOSE 8080
CMD service postgresql start && su postgres -c 'psql < init.sql' && ./grailsw run-app
