
echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
service postgresql restart
tail -f /var/log/postgresql/postgresql-9.3-main.log
