create table bounds(
   page int not null,
   word int not null,
   minx int not null,
   maxx int not null,
   miny int not null,
   maxy int not null,
   primary key(page, word)
) default character set utf8;

