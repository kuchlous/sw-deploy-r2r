#!/bin/bash

# Path to source code
WORKDIR=.

echo 'hello world'
bash -lc "if [ `wc  -l < $WORKDIR/spp/config/locales/en.yml` != `wc  -l < $WORKDIR/spp/config/locales/hi.yml` ];
then 
  exit 1 
else 
  echo 'successful localization' 
fi"

# for setting localisation. Fixes unicode error.
export LC_ALL=C.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#Build and copy react app
bash -lc "rm -rf $WORKDIR/spp/public/assets/js/*"
bash -lc "rm -rf $WORKDIR/spp/public/assets/css/*"
bash -lc "python3 $WORKDIR/spp/lib/scripts/localisations_check.py $WORKDIR/sw-js/src/components/ jsx $WORKDIR/sw-js/src/i18n/en.json"
bash -lc "python3 $WORKDIR/spp/lib/scripts/localisations_check.py $WORKDIR/sw-js/src/components/ jsx $WORKDIR/sw-js/src/i18n/hi.json" 
bash -lc "if [ `wc  -l < $WORKDIR/sw-js/src/i18n/en.json` != `wc  -l < $WORKDIR/sw-js/src/i18n/hi.json` ];
then 
  exit 1 
else 
  echo 'successful localization' 
fi"
cd $WORKDIR/sw-js
bash -lc "yarn install"
bash -lc "REACT_APP_EXPANDED_SEARCH_ORGANISATION_TAB=true REACT_APP_EXPANDED_SEARCH_PEOPLE_TAB=true REACT_APP_FEATURE_ILLUSTRATIONS=true REACT_APP_FACEBOOK_APP_ID=535222303499596 REACT_APP_GOOGLE_CLIENT_ID=399055675590-f8ccat0kcltrbq2jccn968jnk79cc894.apps.googleusercontent.com REACT_APP_FEATURE_OFFLINE=true REACT_APP_API_URL=http://localhost:3000/api/v1 yarn build"
cd
cp -r $WORKDIR/sw-js/build/assets $WORKDIR/spp/public/.
cp $WORKDIR/sw-js/build/*.js $WORKDIR/spp/public/.
cp $WORKDIR/sw-js/build/*.json $WORKDIR/spp/public/.
cp $WORKDIR/sw-js/build/*.png $WORKDIR/spp/public/.
#cp react/build/*.map public/.
cp $WORKDIR/sw-js/build/index.html $WORKDIR/spp/public/.
cp $WORKDIR/sw-js/build/index.html $WORKDIR/spp/app/views/react/.

#meta-tag changes
mv $WORKDIR/spp/app/views/react/index.html $WORKDIR/spp/app/views/react/index.html.erb
sed -i -e 's/$DESCRIPTION/<%= @description %>/g' $WORKDIR/spp/app/views/react/index.html.erb
sed -i -e 's/$OG_TITLE/<%= @title %>/g' $WORKDIR/spp/app/views/react/index.html.erb
sed -i -e 's/$OG_URL/<%= @url %>/g' $WORKDIR/spp/app/views/react/index.html.erb
sed -i -e 's/$OG_DESCRIPTION/<%= @description %>/g' $WORKDIR/spp/app/views/react/index.html.erb
sed -i -e 's/$OG_IMAGE/<%= @image %>/g' $WORKDIR/spp/app/views/react/index.html.erb

# added ga property id
sed -i -e 's/%GA_PROPERTY_ID%/UA-125313674-1/g' $WORKDIR/spp/app/views/react/index.html.erb
sed -i -e 's/%GA_PROPERTY_ID%/UA-125313674-1/g' $WORKDIR/spp/public/index.html

#Build and copy react header/footer for server pages
cd $WORKDIR/sw-js 
bash -lc "REACT_APP_EXPANDED_SEARCH_ORGANISATION_TAB=true REACT_APP_EXPANDED_SEARCH_PEOPLE_TAB=true REACT_APP_FEATURE_ILLUSTRATIONS=true REACT_APP_FACEBOOK_APP_ID=535222303499596 REACT_APP_GOOGLE_CLIENT_ID=399055675590-f8ccat0kcltrbq2jccn968jnk79cc894.apps.googleusercontent.com REACT_APP_FEATURE_OFFLINE=true REACT_APP_API_URL=https://uat.pbees.party/api/v1 yarn build-bookends"
cd
cp -r $WORKDIR/sw-js/build/assets $WORKDIR/spp/public/.
 cp $WORKDIR/sw-js/build/assets/js/*.js $WORKDIR/spp/public/assets/js/.
 cp $WORKDIR/sw-js/build/assets/css/bookends.*.css $WORKDIR/spp/public/assets/css/.
 cp -r $WORKDIR/sw-js/build/assets/media $WORKDIR/spp/public/assets/.

bash -lc "RAILS_ROOT=$WORKDIR/spp SW_BUILD_DIR=$WORKDIR/sw-js/build $WORKDIR/spp/lib/scripts/add_react_version.sh"


