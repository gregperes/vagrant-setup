#!/usr/bin/env bash

# Functions
function printMessage() {
	echo -e "\n=> $1 \n"
}

function printDone() {
	echo "==> done..."
}

function dos2unix(){
  tr -d '\r' < "$1" > t
  mv -f t "$1"
}

function unix2dos(){
  sed -i 's/$/\r/' "$1"
}
#========================

# Var declarations
pm="apt-get install -y"
#========================

# apt-get updating
printMessage "apt-get updating..."

sudo apt-get update
sudo apt-get upgrade

printDone
#========================

# Installing essential tools
printMessage "Installing essential tools"

sudo $pm wget curl build-essential clang
sudo $pm bison openssl zlib1g
sudo $pm libxslt1.1 libssl-dev libxslt1-dev install tcl8.5
sudo $pm libxml2 libffi-dev libyaml-dev
sudo $pm libxslt-dev autoconf libc6-dev
sudo $pm libreadline6-dev zlib1g-dev libcurl4-openssl-dev libtool
sudo $pm libsqlite3-0 sqlite3 libsqlite3-dev libmysqlclient-dev
sudo $pm git-core python-software-properties libpq-dev

printDone
#========================

# Nodejs install
printMessage "Installing NodeJS"

curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo $pm nodejs

printDone
#========================

# MySQL install
printMessage "Installing MySQL 5.6"

sudo $pm mysql-server-5.6

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

printDone
#========================

# Redis Install
printMessage "Installing Redis"

sudo apt-add-repository ppa:chris-lea/redis-server
sudo apt-get update
sudo $pm redis-server

printDone
#========================

# Ruby on Rails install
printMessage "Installing Ruby"

wget https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz
echo -e "\n==> done..."
echo -e "\n=> Extracting Ruby 2.5.1"
tar -xzvf ruby-2.5.1.tar.gz
cd ruby-2.5.1

./configure --prefix=/usr/local
make
make install

cd ..
rm -R ruby-2.5.1
rm ruby-2.5.1.tar.gz

sudo gem update --system --no-ri --no-rdoc

printMessage "Installing Rails"

sudo gem install bundler --no-rdoc --no-ri
sudo gem install rails --no-rdoc --no-ri

printDone
#========================

# PHP install
printMessage "Installing PHP 7.2"

sudo add-apt-repository ppa:ondrej/php
sudo apt-get update

sudo $pm php7.2 php7.2-common php7.2-dev php7.2-mbstring php7.2-cli php7.2-curl php7.2-gd php7.2-mysql php7.2-sqlite3

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

printDone
#========================

printMessage "Installing bash"

git clone https://github.com/gregperes/bash.git /home/vagrant/.bash
dos2unix /home/vagrant/.bash/**/*.sh
echo 'source /home/vagrant/.bash/init.sh' >> /home/vagrant/.bash_profile

printMessage "All done. Enjoy! ;)"
#========================