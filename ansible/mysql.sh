sleep 5

ps aux | grep -v 'grep' | grep 'mysqld' &>/dev/null

if [ $? -ne 0 ];then
	systemctl start mysqld
fi

old_password=$( grep 'temporary' /var/log/mysqld.log | awk '{print $NF}')
new_password={{ new_password }}

mysql -uroot -p"${old_password}" -e "alter user 'root'@'localhost' identified by '${new_password}';"

mysql -uroot -p"${new_password}" -e "create database project;"

mysql -uroot -p"${new_password}" -e "grant all privileges on project.* to 'php'@'localhost' identified by '${new_password}';"


