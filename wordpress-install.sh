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

echo "upload_max_filesize = 10M\n" >> php.ini
echo "post_max_size = 10M\n" >> php.ini

rm -R Work
rm wordpress/wp-config-sample.php

mv wp-config.php wordpress/wp-config.php
mv router.php wordpress/router.php
mv PHPModules wordpress/PHPModules
mv php.ini wordpress/php.ini


