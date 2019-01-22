#! /usr/bin/env /bin/bash
IMAGE=sw-prod-build:0.1 
NGINX_IMAGE=nginx-prod:0.1 
BUILD_PATH=/home/kuchlous/whitelabel-docker-deploy-cmdline/build
DEPLOY_PATH=/home/kuchlous/whitelabel-docker-deploy-cmdline/deploy 
VERSION_PATH=/home/kuchlous/whitelabel-docker-deploy-cmdline/versions

latest_dir=$(date +%Y%m%d%H%M%S)
#mkdir $VERSION_PATH/$latest_dir
tar -zxf $BUILD_PATH/spp/pkg/spp-0.0.1.tgz -C $VERSION_PATH
mv $VERSION_PATH/spp-0.0.1 $VERSION_PATH/$latest_dir

rm -rf $DEPLOY_PATH/spp
cp -frp $VERSION_PATH/$latest_dir -T $DEPLOY_PATH/spp

build_spp=$DEPLOY_PATH/spp
rm -rf $build_spp/public/system
rm -rf $build_spp/log
rm -rf $build_spp/tmp

#Updating eh nginx assets
rm -rf $DEPLOY_PATH/nginx/assets
cp -frp $build_spp/public -T $DEPLOY_PATH/nginx/assets

#Building a new image and updating the service
sudo docker build -t $IMAGE $DEPLOY_PATH
sudo docker service update --force --image $IMAGE --update-delay 300s sw-rails

#Building a new image and updating the nginx service
sudo docker build -t $NGINX_IMAGE $DEPLOY_PATH/nginx
sudo docker service update --force --image $NGINX_IMAGE sw-nginx

#Removing the old directories
cd $VERSION_PATH && ls -t | tail -n +6 | xargs rm -rf

