INSTALLATION SUMMARY
--------------------

$ mysql -uroot -p

mysql> create user 'quran_image'@'localhost' identified by 'quran_image';
Query OK, 0 rows affected (0.00 sec)

mysql> create database quran_image charset utf8 collate utf8_general_ci;
Query OK, 1 row affected (0.00 sec)

mysql> grant all privileges on quran_image.* to 'quran_image'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> quit
Bye

$ mysql -uquran_image -pquran_image quran_image < res/db/database.sql



`mysql -u root -p your_password -e "create user 'nextgen'@'localhost' identified by 'nextgen'"`
`mysql -u root -p your_password -e "grant all privileges on nextgen.* to 'nextgen'@'localhost'"`
`mysql -u root -p your_password -e "flush privileges"`
mysql -u nextgen -p nextgen -e 'create database nextgen'
mysql -u nextgen -p nextgen nextgen < db/database.sql

USAGE
-----

`./script/generate --width 1300 --output ./output/ --pages 50`
`./script/generate --width 1300 --output ./output/ --pages 1..3`

etc.
