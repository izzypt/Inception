#!/bin/sh

# This block checks if the directory "/run/mysqld" does not exist, and if not, it creates it and sets ownership to the user and group 'mysql'.
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# This block checks if the directory "/var/lib/mysql/mysql" does not exist, and if not, it initializes the MariaDB data directory. It then sets ownership to 'mysql:mysql'.
if [ ! -d "/var/lib/mysql/mysql" ]; then
	
	chown -R mysql:mysql /var/lib/mysql

	# init database
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
	# This block creates a temporary file using mktemp and checks if it was successfully created.
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi

	# https://stackoverflow.com/questions/10299148/mysql-error-1045-28000-access-denied-for-user-billlocalhost-using-passw
 	# Here, a series of MySQL commands are written to the temporary file. These commands include creating a database, a user, and granting privileges.
	cat << EOF > $tfile
		USE mysql;
		FLUSH PRIVILEGES;
		
		DELETE FROM	mysql.user WHERE User='';
		DROP DATABASE test;
		DELETE FROM mysql.db WHERE Db='test';
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
		
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD';
		
		CREATE DATABASE $WP_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
		CREATE USER '$WP_DATABASE_USR'@'%' IDENTIFIED by '$WP_DATABASE_PWD';
		GRANT ALL PRIVILEGES ON $WP_DATABASE_NAME.* TO '$WP_DATABASE_USR'@'%';
		
		FLUSH PRIVILEGES;
	EOF
	# run init.sql
 	# It runs the MySQL daemon in bootstrap mode using the generated SQL commands in the temporary file and then removes the temporary file.
	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
	rm -f $tfile
fi

# allow remote connections
# These lines modify the MariaDB server configuration to allow remote connections. 
# It comments out the 'skip-networking' line and sets the 'bind-address' to '0.0.0.0', meaning it will bind to all available network interfaces.

sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# Finally, it starts the MariaDB server in console mode, using the 'mysql' user.

exec /usr/bin/mysqld --user=mysql --console
