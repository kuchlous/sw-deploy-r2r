FROM ubuntu:14.04
SHELL ["/bin/bash","-l","-c"]

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &&\
    apt-get update && apt-get install -y curl &&\
    apt-get install -y  postgresql postgresql-contrib

USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE ROLE spp_user superuser;" &&\
    psql --command "ALTER ROLE spp_user WITH LOGIN;" &&\
    psql --command "ALTER USER spp_user WITH PASSWORD 'grablempga';" &&\
    psql --command "GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO spp_user;" &&\
    psql --command "GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO spp_user;" &&\
    psql --command "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO spp_user;" &&\
    psql --command "GRANT ALL ON ALL TABLES IN SCHEMA public TO spp_user;"

RUN sed -i "90i\local   all             spp_user                                trust" /etc/postgresql/9.3/main/pg_hba.conf
USER root

RUN service postgresql restart

USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';" &&\
    psql --command "DROP DATABASE template1;" &&\
    psql --command "CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';" &&\
    psql --command "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';" &&\
    psql --command "\c template1" &&\
    psql --command "VACUUM FREEZE"

USER root
RUN service postgresql restart

RUN apt-get update &&\
    apt-get install -y vim software-properties-common python-software-properties &&\
    add-apt-repository ppa:webupd8team/java &&\
    apt-get update &&\
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections &&\
    apt-get install -y oracle-java8-installer

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.0.deb &&\
    dpkg -i elasticsearch-5.2.0.deb
    
COPY start.sh /tmp/


CMD ["/bin/bash", "-l","/tmp/start.sh"]
