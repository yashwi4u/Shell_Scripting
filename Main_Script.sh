#!/bin/sh

#Installing Python and  other essentials
#sudo apt-get install -y build-essential python3-dev python3-pip
tar xf Python-3.7.3.tar.xz
cd Python-3.7.3
./configure
make
make test
sudo make install
cd ..

#Extracting jdk for respective architechture
arch=$(getconf LONG_BIT)
if [$getconf==32]
then
	echo "Extraction started for 32-bit Architechture"
	tar xf jdk-8u211-linux-i586.tar.gz
	sudo dpkg -i libpcre3_8.39-9_i386.deb
	sudo dpkg -i libpcre3-dev_8.39-9_i386.deb
else
	echo "Extraction started for 64-bit Architechture"
	tar xf jdk-8u211-linux-x64.tar.gz
	sudo dpkg -i libpcre3_8.39-9_amd64.deb
	sudo dpkg -i libpcre3-dev_8.39-9_amd64.deb
fi

sudo mkdir -p usr/lib/jvm
sudo mv ./jdk1.8.0_211 /usr/lib/jvm/

sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_211/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_211/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.0_211/bin/javaws" 1

#Adding JAVA_HOME to ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_211">>~/.bashrc

#Installing enginx
tar xf nginx-1.17.1.tar.gz
cd nginx-1.17.1
./configure
make
sudo make install

#Extracting spark and moving to /usr/local
tar xf spark-2.4.3-bin-hadoop2.7.tgz
mv spark-2.4.3-bin-hadoop2.7 spark
sudo mv spark /usr/local

#Adding environment variables to /etc/environment
python3 edit_env.py

#Adding $PATH and $SPARK_HOME to bashrc
echo "export PATH=$PATH:/usr/local/spark/bin">>~/.bashrc
echo "export SPARK_HOME=$PATH:/usr/local/spark">>~/.bashrc

source ~/.bashrc
source /etc/environment

#Installing Mysql
sudo dpkg -i mysql-apt-config_0.8.13-1_all.deb
sudo mysql_secure_installation

cd Desktop
sudo git clone https://github.com/HarshadKavathiya/acciom_portal.git
cd acciom_portal
sudo apt-get install unixodbc-dev
pip3 install -r requirements.txt

mysql -u root -p < InsertDataScript/create_db_user.sql

export FLASK_APP="manage.py"
flask db upgrade

echo "Now you can launch the server by typing : python3 app.py"
