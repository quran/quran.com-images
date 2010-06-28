package Quran::Web::Schema::Result::WordRoot;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::WordRoot

=cut

__PACKAGE__->table("word_root");

=head1 ACCESSORS

=head2 word_root_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 value

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "word_root_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "value",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("word_root_id");
__PACKAGE__->add_unique_constraint("value", ["value"]);

=head1 RELATIONS

=head2 words

Type: has_many

Related object: L<Quran::Web::Schema::Result::Word>

=cut

__PACKAGE__->has_many(
  "words",
  "Quran::Web::Schema::Result::Word",
  { "foreign.word_root_id" => "self.word_root_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UrS0ZjpEH7gsti52f+esog


# You can replace this text with custom content, and it will be preserved on regeneration
1;
