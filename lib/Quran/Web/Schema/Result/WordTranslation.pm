package Quran::Web::Schema::Result::WordTranslation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::WordTranslation

=cut

__PACKAGE__->table("word_translation");

=head1 ACCESSORS

=head2 word_translation_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 language_id

  data_type: 'integer'
  is_nullable: 0

=head2 word_id

  data_type: 'integer'
  is_nullable: 0

=head2 value

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 strength

  data_type: 'double precision'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "word_translation_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "language_id",
  { data_type => "integer", is_nullable => 0 },
  "word_id",
  { data_type => "integer", is_nullable => 0 },
  "value",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "strength",
  { data_type => "double precision", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("word_translation_id");
__PACKAGE__->add_unique_constraint("UNIQUE", ["word_id", "language_id", "value"]);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:R4aj3vbfX08ulU3ynYTO+w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
