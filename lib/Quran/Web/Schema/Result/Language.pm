package Quran::Web::Schema::Result::Language;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::Language

=cut

__PACKAGE__->table("language");

=head1 ACCESSORS

=head2 language_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 language_code

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 english_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 native_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "language_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "language_code",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "english_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "native_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("language_id");
__PACKAGE__->add_unique_constraint("UNIQUE", ["language_code"]);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vPLicxbw+hOEEsidFLVSng


# You can replace this text with custom content, and it will be preserved on regeneration
1;
