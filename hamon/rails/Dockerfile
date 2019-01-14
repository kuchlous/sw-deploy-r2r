FROM ubuntu:18.04 
SHELL ["/bin/bash","-l","-c"]

# Installing rvm and ruby 2.1.4 version

RUN apt-get update
RUN apt-get install -y imagemagick gpg

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN apt-get update
RUN apt-get install -y curl
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh
RUN echo "source /etc/profile.d/rvm.sh" >> /root/.bashrc
RUN source /etc/profile.d/rvm.sh && rvm install 2.1.4
RUN source /etc/profile.d/rvm.sh && rvm use 2.1.4 --default

RUN apt-get install -y wget

RUN apt-get install -y software-properties-common
#RUN apt-get install -y software-properties-common python-software-properties &&\
#    apt-get install -y vim &&\
#    apt-get install -y imagemagick 
RUN mkdir /espeak
WORKDIR /espeak
#RUN sudo apt-get install ffmpeg
# RUN apt-get install -y unzip
# RUN wget http://sourceforge.net/projects/espeak/files/espeak/espeak-1.48/espeak-1.48.04-source.zip
# RUN unzip espeak-1.48.04-source.zip
# WORKDIR /espeak/espeak-1.48.04-source/src
# RUN make
# RUN make install
# RUN apt-get install -y portaudio19-dev libpulse-dev libsonic-dev
# RUN apt-get install -y libasound-dev
# RUN make
# RUN make install
RUN apt-get install -y espeak libespeak-dev
RUN espeak --version
#RUN add-apt-repository ppa:kirillshkrogalev/ffmpeg-next
RUN apt-get update
RUN apt-get install -y ffmpeg
RUN apt-get install -y python-pip
RUN pip install BeautifulSoup4
RUN pip install lxml
RUN pip install numpy
RUN pip install aeneas
RUN python -m aeneas.diagnostics
RUN pip install httplib2
RUN pip install --upgrade google-api-python-client
RUN pip install --upgrade oauth2client

#RUN apt-get install -y python-software-properties

RUN apt-get install -y vim

# RUN add-apt-repository ppa:ecometrica/servers &&\
#     apt-get install -y wkhtmltopdf 

# Install wkhtmltopdf, needed to generate pdfs. Note that we need 0.12.1 while apt-get installs an older version.
# RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb &&\
#     dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz &&\
    tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz &&\
    cp wkhtmltox/bin/wk* /usr/local/bin/
RUN echo "$(wkhtmltopdf --version)"

# RUN add-apt-repository ppa:webupd8team/java &&\
#     apt-get update &&\
#     echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections &&\
#     apt-get install -y oracle-java8-installer

RUN wget -O - http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -
RUN echo "deb http://packages.couchbase.com/ubuntu bionic bionic/main" > /etc/apt/sources.list.d/couchbase.list
RUN apt-get update
RUN apt-get install -y libcouchbase-dev libcouchbase2-bin build-essential

RUN apt-get update &&\
    apt-get install -y  git &&\
    apt-get install -y libpq-dev &&\
    apt-get install -y libmagickwand-dev 

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - &&\
    apt-get install -y nodejs

# Install  bundler
RUN source /etc/profile.d/rvm.sh && gem install bundler -v 1.17.3
# Install Qt before capybara
RUN apt-get update &&\
    apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

#COPY Gemfile* /tmp/
#WORKDIR /tmp
#RUN bundle install
WORKDIR /

RUN mkdir workdir
COPY spp /workdir/spp
COPY sw-js /workdir/sw-js

# Install gems using bundle
WORKDIR /workdir/spp

RUN apt-get install libmagickwand-6-headers
# RUN source /etc/profile.d/rvm.sh && gem install rack-cors
#RUN source /etc/profile.d/rvm.sh && gem install capybara-webkit -v '1.15.1' --source 'http://rubygems.org'
RUN mkdir /workdir/spp/vendor/bundle
RUN source /etc/profile.d/rvm.sh && export LC_ALL=C.UTF-8 &&\
    export LANG=en_US.UTF-8 &&\
    export LANGUAGE=en_US.UTF-8 &&\
#    export RAILS_ENV=production &&\
    bundle install #--path /workdir/spp/vendor/bundle 

# Setup packages for building frontend
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update &&\
    apt-get install yarn
## Build and copy frontend using build_script
WORKDIR /workdir
ADD build-script.sh /workdir
RUN /bin/bash build-script.sh

WORKDIR /workdir/spp
ADD start.sh /workdir/spp

#Adds the tzinfo-data gem to get Timezone data
RUN source /etc/profile.d/rvm.sh && gem install tzinfo-data

#RUN apt install -y postgresql-9.5
RUN echo "source /etc/profile.d/rvm.sh" > ~/.bashrc

CMD ["/bin/bash", "-l", "/workdir/spp/start.sh"]
