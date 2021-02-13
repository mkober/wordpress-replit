#!/bin/bash
# Source: https://repl.it/talk/learn/Installing-WordPress-on-Replit/34284

mkdir Work
cd Work

wget http://archive.ubuntu.com/ubuntu/pool/main/p/php7.2/php7.2-mysql_7.2.3-1ubuntu1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/p/php7.2/php7.2-sqlite3_7.2.3-1ubuntu1_amd64.deb
wget https://wordpress.org/latest.zip

wget https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip

for Module in $( ls php*.deb )
do
	dpkg -x $Module .
done

unzip -d ../ latest.zip

mkdir ../PHPModules/ # Made for PHP libraries
cp usr/lib/php/*/* ../PHPModules/

wget https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip
unzip sqlite-integration.1.8.1.zip
cp sqlite-integration/db.php ../wordpress/wp-content/
mv sqlite-integration/ ../wordpress/wp-content/plugins/

cd ../ # Changing work dir
mv PHPModules/mysqlnd.so PHPModules/A-mysqlnd.so # Only for change sequence (mysqlnd.so should be loaded before mysqli.so)
echo 'extension=pdo.so' > php.ini
for Module in $( ls PHPModules/* )
do
	echo "extension=$Module" >> php.ini
done

rm -R Work
mv router.php wordpress/router.php
mv PHPModules wordpress/PHPModules
mv php.ini wordpress/php.ini

sed -i "1 s/^/<?php \n define('FORCE_SSL_ADMIN', true); \n if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) \n \$_SERVER['HTTPS']='on' \n ?>\n\n/" wordpress/wp-config-sample.php

mv wordpress/wp-config-sample.php wordpress/wp-config.php
