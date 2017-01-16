بسم الله الرحمن الرحيم
In the name of Allah, Most Gracious, Most Merciful

# Quran Image Generator

These are a set of scripts that generate Quran page images based on the old madani fonts provided by the King Fahd Quran Complex in Saudi Arabia. They are currently being used in quran.com and its mobile apps.

This script outputs images, and also updates a database with the bounds of each of the generated glyphs (allowing apps to highlight individual words or verses).

The code is copyleft GPL (read: free) but the actual fonts and pages (in the `res/fonts` directory) belong to the [King Fahd Quran Complex in Saudia Arabia](http://www.qurancomplex.com)

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
