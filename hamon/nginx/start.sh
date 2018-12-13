HOST_IP = 1234123
sed -i "10i\  server_name $HOST_IP" /etc/nginx/sites-available/spp.conf
service nginx restart
tail -f  /var/log/nginx/access.log
