#!/bin/bash
echo 'hello world'
bash -lc "if [ `wc  -l < /workdir/spp/config/locales/en.yml` != `wc  -l < /workdir/spp/config/locales/hi.yml` ];
then 
  exit 1 
else 
  echo 'successful localization' 
fi"


#Build and copy react app
bash -lc "rm -rf /workdir/spp/public/assets/js/*"
bash -lc "rm -rf /workdir/spp/public/assets/css/*"
bash -lc "python3 /workdir/spp/lib/scripts/localisations_check.py /workdir/sw-js/src/components/ jsx /workdir/sw-js/src/i18n/en.json"
bash -lc "python3 /workdir/spp/lib/scripts/localisations_check.py /workdir/sw-js/src/components/ jsx /workdir/sw-js/src/i18n/hi.json" 
bash -lc "if [ `wc  -l < /workdir/sw-js/src/i18n/en.json` != `wc  -l < /workdir/sw-js/src/i18n/hi.json` ];
then 
  exit 1 
else 
  echo 'successful localization' 
fi"
cd /workdir/sw-js
bash -lc "yarn install"
bash -lc "REACT_APP_EXPANDED_SEARCH_ORGANISATION_TAB=true REACT_APP_EXPANDED_SEARCH_PEOPLE_TAB=true REACT_APP_FEATURE_ILLUSTRATIONS=true REACT_APP_FACEBOOK_APP_ID=535222303499596 REACT_APP_GOOGLE_CLIENT_ID=399055675590-f8ccat0kcltrbq2jccn968jnk79cc894.apps.googleusercontent.com REACT_APP_FEATURE_OFFLINE=true REACT_APP_API_URL=http://localhost:3000/api/v1 yarn build"
cd
cp -r /workdir/sw-js/build/assets /workdir/spp/public/.
cp /workdir/sw-js/build/*.js /workdir/spp/public/.
cp /workdir/sw-js/build/*.json /workdir/spp/public/.
cp /workdir/sw-js/build/*.png /workdir/spp/public/.
#cp react/build/*.map public/.
cp /workdir/sw-js/build/index.html /workdir/spp/public/.
cp /workdir/sw-js/build/index.html /workdir/spp/app/views/react/.

#meta-tag changes
mv /workdir/spp/app/views/react/index.html /workdir/spp/app/views/react/index.html.erb
sed -i -e 's/$DESCRIPTION/<%= @description %>/g' /workdir/spp/app/views/react/index.html.erb
sed -i -e 's/$OG_TITLE/<%= @title %>/g' /workdir/spp/app/views/react/index.html.erb
sed -i -e 's/$OG_URL/<%= @url %>/g' /workdir/spp/app/views/react/index.html.erb
sed -i -e 's/$OG_DESCRIPTION/<%= @description %>/g' /workdir/spp/app/views/react/index.html.erb
sed -i -e 's/$OG_IMAGE/<%= @image %>/g' /workdir/spp/app/views/react/index.html.erb

# added ga property id
sed -i -e 's/%GA_PROPERTY_ID%/UA-125313674-1/g' /workdir/spp/app/views/react/index.html.erb
sed -i -e 's/%GA_PROPERTY_ID%/UA-125313674-1/g' /workdir/spp/public/index.html

#Build and copy react header/footer for server pages
cd /workdir/sw-js 
bash -lc "REACT_APP_EXPANDED_SEARCH_ORGANISATION_TAB=true REACT_APP_EXPANDED_SEARCH_PEOPLE_TAB=true REACT_APP_FEATURE_ILLUSTRATIONS=true REACT_APP_FACEBOOK_APP_ID=535222303499596 REACT_APP_GOOGLE_CLIENT_ID=399055675590-f8ccat0kcltrbq2jccn968jnk79cc894.apps.googleusercontent.com REACT_APP_FEATURE_OFFLINE=true REACT_APP_API_URL=https://uat.pbees.party/api/v1 yarn build-bookends"
cd
cp -r /workdir/sw-js/build/assets /workdir/spp/public/.
 cp /workdir/sw-js/build/assets/js/*.js /workdir/spp/public/assets/js/.
 cp /build/assets/css/bookends.*.css /workdir/spp/public/assets/css/.
 cp -r /workdir/sw-js/build/assets/media /workdir/spp/public/assets/.

bash -lc "RAILS_ROOT=/workdir/spp SW_BUILD_DIR=/workdir/sw-js/build /workdir/spp/lib/scripts/add_react_version.sh"


