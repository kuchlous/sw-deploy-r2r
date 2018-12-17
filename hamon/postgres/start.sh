
echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
sed -i "88i\host    all      $USER          $HOST          md5" /etc/postgresql/9.3/main/pg_hba.conf

service postgresql restart
tail -f /var/log/postgresql/postgresql-9.3-main.log
