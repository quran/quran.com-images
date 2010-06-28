package Quran::Web::Schema::Result::GlyphType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::GlyphType

=cut

__PACKAGE__->table("glyph_type");

=head1 ACCESSORS

=head2 glyph_type_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 parent_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "glyph_type_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "parent_id",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("glyph_type_id");
__PACKAGE__->add_unique_constraint("UNIQUE", ["name", "parent_id"]);

=head1 RELATIONS

=head2 glyphs

Type: has_many

Related object: L<Quran::Web::Schema::Result::Glyph>

=cut

__PACKAGE__->has_many(
  "glyphs",
  "Quran::Web::Schema::Result::Glyph",
  { "foreign.glyph_type_id" => "self.glyph_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q/IlFdDWJsyyA9FdU1CLZA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
