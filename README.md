بسم الله الرحمن الرحيم
<br>_In the name of Allah, Most Gracious, Most Merciful_

# Quran Image Generator

These are a set of scripts that generate Quran page images based on the old madani fonts provided by the King Fahd Quran Complex in Saudi Arabia. They are currently being used in quran.com and its mobile apps.

This script outputs images, and also updates a database with the bounds of each of the generated glyphs (allowing apps to highlight individual words or verses).

The code is copyleft GPL (read: free) but the actual fonts and pages (in the `res/fonts` directory) belong to the [King Fahd Quran Complex in Saudia Arabia](http://www.qurancomplex.com)

## Prerequisites
Following prerequisites are required before instructions below can work. I tried this on my windows box (no reason to believe it will not work on other platform as long as you use the right tools for this platform)

#### Required Packages
- ppm install dmake
- ppm install dbd-mysql
- ppm install yaml
- Go to your perl package manager and add 'Mojo-Log-More' package and all dependencies.

#### Required Software
- Install MySQL server and tools.
- Add mysql.exe path to system path (convenience)

#### Notes about following installation summary
- If you installed dmake, replace all 'make' in commands below with 'dmake'
- Note that there is no space between -p and password, e.g.: -pMyPasswor
- Replace '< sql/database.sql' with '-Dnextgen < sql/database.sql' - otherwise you'll get an error. 'nextgen' is the database name.

Now you should be good to go with the following instructions

## Installation Summary

```
perl Makefile.PL
make
make install
mysql -u root -p your_password < sql/schema.sql
mysql -u root -p your_password < sql/database.sql
mysql -u root -p your_password -e "create user 'nextgen'@'localhost' identified by 'nextgen'"
mysql -u root -p your_password -e "grant all privileges on nextgen.* to 'nextgen'@'localhost'"
mysql -u root -p your_password -e "flush privileges"
```

## Docker installation

Install [Docker](https://www.docker.com/) 
and [Docker Compose](https://docs.docker.com/compose/install/).

Build and run services (mysql and perl libs):

```
docker-compose up -d
```

To run scripts (see Usage section below) use the `gen` service:

```
docker-compose run gen /app/script/generate.pl --output ./output/ ...
docker-compose run gen zopflipng --prefix=comp/ ... ./output/*.png
```

Stop sevices when done:

```
docker-compose down
```

Note that mysql data is persisted on the host as a docker volume.
You must set the `--output` option value to `./output/` to persist
the output on the host machine. Any other output path will be local 
to the container.

## Usage

generate page 50 with a width of 1300:

`./script/generate.pl --width 1300 --output ./output/ --pages 50`

generate pages 1 through 3 with a width of 1300:

`./script/generate.pl --width 1300 --output ./output/ --pages 1..3`

## Compression

make sure to run the images through [ImageOptim](https://imageoptim.com) or through [zopflipng](https://github.com/google/zopfli) to get optimized images.

`zopflipng --prefix=out/ --lossy_transparent --lossy_8bit --splitting=2 --iterations=100 *.png`

## Ayah by ayah images

For generating ayah by ayah images, see our [legacy branch](https://github.com/quran/quran.com-images/tree/legacy)
