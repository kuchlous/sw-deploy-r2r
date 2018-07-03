FROM ubuntu:14.04
SHELL ["/bin/bash","-l","-c"]

# Installing rvm and ruby 2.1.4 version

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &&\
    apt-get update &&\
    apt-get install -y curl &&\
    curl -sSL https://rvm.io/mpapis.asc | gpg --import - &&\
    curl -sSL https://get.rvm.io | bash -s stable &&\
    source /etc/profile.d/rvm.sh &&\
    rvm install 2.1.4 &&\
    rvm use 2.1.4 --default

RUN apt-get install -y software-properties-common python-software-properties &&\
    apt-get install -y vim &&\
    apt-get install -y imagemagick &&\
    add-apt-repository ppa:ecometrica/servers &&\
    apt-get install -y wkhtmltopdf &&\
    ln /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf

RUN add-apt-repository ppa:webupd8team/java &&\
    apt-get update &&\
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections &&\
    apt-get install -y oracle-java8-installer

RUN wget http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-3-amd64.deb &&\
    dpkg -i couchbase-release-1.0-3-amd64.deb &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6EF1EAC479CF7903 &&\
    apt-get update &&\
    apt-get install -y libcouchbase-dev libcouchbase2-bin build-essential

RUN apt-get update &&\
    apt-get install -y  bundler &&\
    apt-get install -y  git &&\
    apt-get install -y nodejs &&\
    gem install bundler &&\
    apt-get install -y libpq-dev &&\
    apt-get install -y libmagickwand-dev

# Installing Postgres and setting up the config.

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &&\
    apt-get update && apt-get install -y curl &&\
    apt-get install -y  postgresql postgresql-contrib

USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE ROLE spp_user superuser;" &&\
    psql --command "ALTER ROLE spp_user WITH LOGIN;" &&\
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

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.0.deb &&\
    dpkg -i elasticsearch-5.2.0.deb

# Install Qt before capybara
RUN apt-get update &&\
    apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

#Install nodejs, xvfb for running capybara in terminal mode.
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - &&\
    apt-get install -y nodejs &&\
    npm install -g yarn &&\
    apt-get install -y python-pip &&\
    apt-get install -y xvfb xserver-xephyr vnc4server &&\
    pip install pyvirtualdisplay

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install
WORKDIR /
RUN echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc
COPY start.sh .
CMD ["/bin/bash", "-l", "/start.sh"]
