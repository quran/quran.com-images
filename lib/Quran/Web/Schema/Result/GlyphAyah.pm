package Quran::Web::Schema::Result::GlyphAyah;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::GlyphAyah

=cut

__PACKAGE__->table("glyph_ayah");

=head1 ACCESSORS

=head2 glyph_ayah_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 glyph_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 sura_number

  data_type: 'integer'
  is_nullable: 0

=head2 ayah_number

  data_type: 'integer'
  is_nullable: 0

=head2 position

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "glyph_ayah_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "glyph_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "sura_number",
  { data_type => "integer", is_nullable => 0 },
  "ayah_number",
  { data_type => "integer", is_nullable => 0 },
  "position",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("glyph_ayah_id");
__PACKAGE__->add_unique_constraint("UNIQUE", ["sura_number", "ayah_number", "position"]);

=head1 RELATIONS

=head2 glyph

Type: belongs_to

Related object: L<Quran::Web::Schema::Result::Glyph>

=cut

__PACKAGE__->belongs_to(
  "glyph",
  "Quran::Web::Schema::Result::Glyph",
  { glyph_id => "glyph_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 glyph_ayah_bboxes

Type: has_many

Related object: L<Quran::Web::Schema::Result::GlyphAyahBbox>

=cut

__PACKAGE__->has_many(
  "glyph_ayah_bboxes",
  "Quran::Web::Schema::Result::GlyphAyahBbox",
  { "foreign.glyph_ayah_id" => "self.glyph_ayah_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CNS9quNHu11ds2np/f9VCw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
