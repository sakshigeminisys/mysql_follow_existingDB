#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
clear
echo "****************************************"
echo "Starting MariaDB replication on Master"
echo "****************************************"
sleep 1
echo "Make sure you allow port 3306 through the firewall"
echo "  "

sleep 1
#INSTALLATION
echo "*** INSTALLING MARIA DB ***"
echo "   "
sleep 1
sudo yum install mariadb-server mariadb
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo "   "
echo "****  Installation Complete   ****"
sleep 2

#SET DB PASSWORD
echo "*** Setting DB password ***"
sleep 1
mysql_secure_installation

echo "****************************************"
echo "          Show Databases"
echo "****************************************"

mysql -u root -pabcd -e 'show databases;'

echo "****************************************"
echo "          Create more DBs"
echo "****************************************"

mysql -u root -pabcd -e 'create database apporbit;'
mysql -u root -pabcd -e 'create database gemini;'

echo "****************************************"
echo "          create Table for DB apporbit"
echo "****************************************"

mysql -u root -pabcd -e 'use apporbit;create table sample (c int);insert into sample (c) values (1);'
#mysql -u root -pabcd -e 'create table sample (c int);'
#mysql -u root -pabcd -e 'insert into sample (c) values (1);'

echo "****************************************"
echo "          show apporbit table values"
echo "****************************************"
mysql -u root -pabcd -e 'use apporbit;select * from sample;'

echo "****************************************"
echo "          show Exisiting databases"
echo "****************************************"
mysql -u root -pabcd -e 'show databases;'

echo "****************************************"
echo "          Create Replication user"
echo "****************************************"

mysql -u root -pabcd -e "GRANT REPLICATION SLAVE ON *.* TO 'sk'@'%' IDENTIFIED BY 'centos';"
mysql -u root -pabcd -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'abcd';"

echo "****************************************"
echo "          Put read lock on tables"
echo "****************************************"

mysql -u root -pabcd -e "FLUSH TABLES WITH READ LOCK;"

echo "****************************************"
echo "          show master status"
echo "****************************************"

mysql -u root -pabcd -e 'SHOW MASTER STATUS;'

#EDIT CONFIG FILE

echo "  "
echo "************************************************"
echo "*EDIT CONFIG FILE. SETTING PRODUCTION AS MASTER*"
echo "************************************************"
sleep 2

sudo sed -i '2iserver_id=1' /etc/my.cnf
sudo sed -i '3ilog-bin=mysql-bin' /etc/my.cnf

echo "**********************************"
echo "****BACKING UP Production  DB****"
echo "**********************************"
sleep 1
mysqldump --all-databases --user=root --password > masterdatabase.sql

mysql -u root -pabcd -e 'UNLOCK TABLES;'

ls

echo "****************************************"
echo "          Restarting mariaDB"
echo "****************************************"
sudo systemctl restart mariadb

echo "****************************************"
echo "          COPY FILES TO SLAVE"
echo "****************************************"

echo "****************************************"
echo "    Put read lock on tables again!!"
echo "****************************************"

mysql -u root -pabcd -e "FLUSH TABLES WITH READ LOCK;"


#sleep 180

#echo "****************************************"
#echo "    Unlocking!!"
#echo "****************************************"
#mysql -u root -pabcd -e 'UNLOCK TABLES;'
