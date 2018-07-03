source /etc/profile.d/rvm.sh
echo "In the new start file- Alok"

RAILS_PATH=/workdir/spp

ln -s /shared/system/ $RAILS_PATH/public/system
ln -s /shared/tmp/ $RAILS_PATH/tmp
ln -s /shared/log/ $RAILS_PATH/log 

RAILS_PATH=/workdir/spp

cd $RAILS_PATH
RAILS_ENV=production bundle install --local --path $RAILS_PATH/vendor/bundle 

NEWRELIC_API_KEY=$NEWRELIC_API_KEY NEWRELIC_NAME=$NEWRELIC_NAME MAILER_USER=$MAILER_USER MAILER_PASSWORD=$MAILER_PASSWORD MAILER_DOMAIN=$MAILER_DOMAIN RAILS_ENV=production rootUrl=$HOST_IP RAILS_PORT=8080 FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP bundle exec rake db:migrate -t

NEWRELIC_API_KEY=$NEWRELIC_API_KEY NEWRELIC_NAME=$NEWRELIC_NAME MAILER_USER=$MAILER_USER MAILER_PASSWORD=$MAILER_PASSWORD MAILER_DOMAIN=$MAILER_DOMAIN RAILS_ENV=production rootUrl=$HOST_IP RAILS_PORT=8080 FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP bundle exec rake db:seed -t

RAILS_ENV=production rootUrl=$HOST_IP FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP ELASTICSEARCH_URL=$ELASTICSEARCH_IP bundle exec rake illustrations:reindex

RAILS_ENV=production rootUrl=$HOST_IP FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP ELASTICSEARCH_URL=$ELASTICSEARCH_IP bundle exec rake blog_posts:reindex

RAILS_ENV=production rootUrl=$HOST_IP FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP ELASTICSEARCH_URL=$ELASTICSEARCH_IP bundle exec rake users:reindex

RAILS_ENV=production rootUrl=$HOST_IP FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP ELASTICSEARCH_URL=$ELASTICSEARCH_IP bundle exec rake stories:reindex

RAILS_ENV=production rootUrl=$HOST_IP FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP ELASTICSEARCH_URL=$ELASTICSEARCH_IP bundle exec rake lists:reindex

bundle exec pumactl -P /workdir/spp_puma.pid stop; NEWRELIC_API_KEY=$NEWRELIC_API_KEY NEWRELIC_NAME=$NEWRELIC_NAME MAILER_USER=$MAILER_USER MAILER_PASSWORD=$MAILER_PASSWORD MAILER_DOMAIN=$MAILER_DOMAIN RAILS_ENV=production rootUrl=$HOST_IP RAILS_PORT=8080 FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP ELASTICSEARCH_URL=$ELASTICSEARCH_IP bundle exec puma -e production -d -b unix:///workdir/spp.sock --pidfile /workdir/spp_puma.pid -w '1' -t '0':'32' --preload

RAILS_ENV=production rootUrl=$HOST_IP FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP ELASTICSEARCH_URL=$ELASTICSEARCH_IP bundle exec rake swagger:docs

NEWRELIC_API_KEY=$NEWRELIC_API_KEY NEWRELIC_NAME=$NEWRELIC_NAME MAILER_USER=$MAILER_USER MAILER_PASSWORD=$MAILER_PASSWORD MAILER_DOMAIN=$MAILER_DOMAIN RAILS_ENV=production rootUrl=$HOST_IP RAILS_PORT=8080 FACEBOOK_APP_ID=$FACEBOOK_APP_ID FACEBOOK_SECRET_KEY=$FACEBOOK_SECRET_KEY GOOGLE_SIGNIN_APP_ID=$GOOGLE_SIGNIN_APP_ID GOOGLE_SECRET_KEY=$GOOGLE_SECRET_KEY GA_PROPERTY_ID=$GA_PROPERTY_ID GOOGLE_APP_ID=$GOOGLE_TRANSLATE_APP_ID MAILCHIMP_LIST_ID=$MAILCHIMP_LIST_ID MAILCHIMP_API_KEY=$MAILCHIMP_API_KEY DEVISE_SECRET_KEY_BASE=$DEVISE_SECRET_KEY_BASE SECRET_KEY_BASE=$SECRET_KEY_BASE GOOGLE_STORAGE_ACCESS_KEY_ID=$GOOGLE_STORAGE_ACCESS_KEY_ID GOOGLE_STORAGE_SECRET_ACCESS_KEY=$GOOGLE_STORAGE_SECRET_ACCESS_KEY COUCHBASE_IP=$COUCHBASE_IP ELASTICSEARCH_URL=$ELASTICSEARCH_IP bin/delayed_job  restart

tail -f /shared/log/production.log
 
