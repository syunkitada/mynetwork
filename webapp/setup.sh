#!/bin/sh

pwd=`pwd`

cd /tmp
wget https://nodejs.org/dist/v6.9.4/node-v6.9.4-linux-x64.tar.xz
tar xf node-v6.9.4-linux-x64.tar.xz
cd node-v6.9.4-linux-x64

cp -r bin/* /usr/bin/
cp -r include/* /usr/include/
cp -r lib/* /usr/lib/
cp -r share/* /usr/share/

cd $pwd

npm install -g grunt-cli
npm install -g bower
npm install -g node-dev
npm install

bower install
