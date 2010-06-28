package Quran::Web::Schema::Result::GlyphPageLine;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::GlyphPageLine

=cut

__PACKAGE__->table("glyph_page_line");

=head1 ACCESSORS

=head2 glyph_page_line_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 glyph_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 page_number

  data_type: 'integer'
  is_nullable: 0

=head2 line_number

  data_type: 'integer'
  is_nullable: 0

=head2 position

  data_type: 'integer'
  is_nullable: 0

=head2 line_type

  data_type: 'enum'
  extra: {list => ["sura","ayah","bismillah"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "glyph_page_line_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "glyph_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "page_number",
  { data_type => "integer", is_nullable => 0 },
  "line_number",
  { data_type => "integer", is_nullable => 0 },
  "position",
  { data_type => "integer", is_nullable => 0 },
  "line_type",
  {
    data_type => "enum",
    extra => { list => ["sura", "ayah", "bismillah"] },
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("glyph_page_line_id");
__PACKAGE__->add_unique_constraint("UNIQUE", ["page_number", "line_number", "position"]);

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

=head2 glyph_page_line_bboxes

Type: has_many

Related object: L<Quran::Web::Schema::Result::GlyphPageLineBbox>

=cut

__PACKAGE__->has_many(
  "glyph_page_line_bboxes",
  "Quran::Web::Schema::Result::GlyphPageLineBbox",
  { "foreign.glyph_page_line_id" => "self.glyph_page_line_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5FWUp0bHZfVdmEr44WBLCg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
