ips=ifconfig | grep -m 1 "inet addr:" | awk '{print $2}' | sed "s/.*://"
echo $ips
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
sed -i "88i\host    all      spp_user         192.168.1.0/24           md5" /etc/postgresql/9.3/main/pg_hba.conf
service postgresql restart
service elasticsearch restart
tail -f /var/log/postgresql/postgresql-9.3-main.log
