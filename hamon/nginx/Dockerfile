FROM nginx
SHELL ["/bin/bash","-l","-c"]

COPY nginx.conf /etc/nginx/nginx.conf
COPY spp.conf /etc/nginx/sites-available/spp.conf
#COPY assets /assets
COPY start.sh /

RUN mkdir /etc/nginx/sites-enabled &&\
    ln -s /etc/nginx/sites-available/spp.conf /etc/nginx/sites-enabled/spp.conf

EXPOSE 80 443

CMD ["/bin/bash", "-l", "start.sh"]
