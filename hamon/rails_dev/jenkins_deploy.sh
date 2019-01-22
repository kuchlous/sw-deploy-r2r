#! /usr/bin/env /bin/bash
echo $IMAGE
echo $FILE_PATH

latest_dir=$(date +%Y%m%d%H%M%S)
#mkdir $VERSION_PATH/$latest_dir
tar -zxf $VERSION_PATH/pkg/spp-0.0.1.tgz -C $VERSION_PATH
mv $VERSION_PATH/spp-0.0.1 $VERSION_PATH/$latest_dir

rm -rf $FILE_PATH/spp
cp -frp $VERSION_PATH/$latest_dir -T $FILE_PATH/spp

build_spp=$FILE_PATH/spp
rm -rf $build_spp/public/system
rm -rf $build_spp/log
rm -rf $build_spp/tmp

#Updating eh nginx assets
rm -rf $FILE_PATH/nginx/assets
cp -frp $build_spp/public -T $FILE_PATH/nginx/assets


#Building a new image and updating the service
sudo docker build -t $IMAGE $FILE_PATH
sudo docker service update --force --image $IMAGE --update-delay 300s sw-rails

#Building a new image and updating the nginx service
sudo docker build -t $NGINX_IMAGE $FILE_PATH/nginx
sudo docker service update --force --image $NGINX_IMAGE sw-nginx

#Removing the old directories
cd $VERSION_PATH && ls -t | tail -n +6 | xargs rm -rf

