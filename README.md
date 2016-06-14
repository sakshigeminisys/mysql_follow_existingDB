# mysql_follow_existingDB
This setup is used to simulate a scenario where
1) The Prodcution node contains existing DBs
2) It has not been configured as master

Launch the master script : 1) it will install mariadb
                           2) create DBs and tables
                           3) configure it as master
                           
Launch the slave container via apporbit platform.

The master and slave should have consistent data and replication should work fine.

