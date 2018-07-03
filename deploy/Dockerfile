FROM ubuntu:14.04 
SHELL ["/bin/bash","-l","-c"]

# Installing rvm and ruby 2.1.4 version

RUN apt-get update 
RUN apt-get install -y imagemagick 

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &&\
    apt-get update &&\
    apt-get install -y curl &&\
    curl -sSL https://rvm.io/mpapis.asc | gpg --import - &&\
    curl -sSL https://get.rvm.io | bash -s stable &&\
    source /etc/profile.d/rvm.sh &&\ 
    rvm install 2.1.4 &&\
    rvm use 2.1.4 --default

RUN apt-get install wget

#RUN apt-get install -y software-properties-common python-software-properties &&\
#    apt-get install -y vim &&\
#    apt-get install -y imagemagick 

RUN apt-get install -y software-properties-common

RUN apt-get install -y python-software-properties

RUN apt-get install -y vim

RUN add-apt-repository ppa:ecometrica/servers &&\
    apt-get install -y wkhtmltopdf 

# Install wkhtmltopdf, needed to generate pdfs. Note that we need 0.12.1 while apt-get installs an older version.
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb &&\
    dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb

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
    gem install bundler &&\
    apt-get install -y libpq-dev &&\
    apt-get install -y libmagickwand-dev 

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - &&\
    apt-get install -y nodejs

# Install Qt before capybara
RUN apt-get update &&\
    apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

#COPY Gemfile* /tmp/
#WORKDIR /tmp
#RUN bundle install
#WORKDIR /

RUN mkdir workdir
COPY spp /workdir/spp

WORKDIR /workdir/spp
ADD start.sh /workdir/spp

RUN echo "source /etc/profile.d/rvm.sh" > ~/.bashrc

CMD ["/bin/bash", "-l", "/workdir/spp/start.sh"]
