use 5.008008;
use ExtUtils::MakeMaker;
use File::Path;
use List::Util;
use GD;
use GD::Text;
use DBD::mysql;
use DBI;
use YAML;
WriteMakefile(
    NAME              => 'Quran',
    VERSION_FROM      => 'lib/Quran.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
       (AUTHOR         => 'Nour Sharabash <nour.sharabash@gmail.com>') : ()),
);
