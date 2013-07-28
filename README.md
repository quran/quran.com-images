INSTALLATION SUMMARY
--------------------

`perl Makefile.PL`
`make`
`make install`
`mysql -u root -p your_password < sql/schema.sql`
`mysql -u root -p your_password -e "create user 'nextgen'@'localhost' identified by 'nextgen'"`
`mysql -u root -p your_password -e "grant all privileges on nextgen.* to 'nextgen'@'localhost'"`
`mysql -u root -p your_password -e "flush privileges"`

USAGE
-----

`./script/generate.pl --width 1300 --output ./output/ --pages 50`
`./script/generate.pl --width 1300 --output ./output/ --pages 1..3`

etc.
