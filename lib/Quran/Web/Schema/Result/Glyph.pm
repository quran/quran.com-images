package Quran::Web::Schema::Result::Glyph;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::Glyph

=cut

__PACKAGE__->table("glyph");

=head1 ACCESSORS

=head2 glyph_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 font_file

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 glyph_code

  data_type: 'integer'
  is_nullable: 0

=head2 page_number

  data_type: 'integer'
  is_nullable: 0

=head2 glyph_type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 glyph_type_meta

  data_type: 'integer'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "glyph_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "font_file",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "glyph_code",
  { data_type => "integer", is_nullable => 0 },
  "page_number",
  { data_type => "integer", is_nullable => 0 },
  "glyph_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "glyph_type_meta",
  { data_type => "integer", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("glyph_id");
__PACKAGE__->add_unique_constraint("UNIQUE2", ["glyph_code", "page_number"]);
__PACKAGE__->add_unique_constraint("UNIQUE1", ["font_file", "glyph_code"]);

=head1 RELATIONS

=head2 glyph_type

Type: belongs_to

Related object: L<Quran::Web::Schema::Result::GlyphType>

=cut

__PACKAGE__->belongs_to(
  "glyph_type",
  "Quran::Web::Schema::Result::GlyphType",
  { glyph_type_id => "glyph_type_id" },
  { join_type => "LEFT", on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 glyph_ayahs

Type: has_many

Related object: L<Quran::Web::Schema::Result::GlyphAyah>

=cut

__PACKAGE__->has_many(
  "glyph_ayahs",
  "Quran::Web::Schema::Result::GlyphAyah",
  { "foreign.glyph_id" => "self.glyph_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 glyph_page_lines

Type: has_many

Related object: L<Quran::Web::Schema::Result::GlyphPageLine>

=cut

__PACKAGE__->has_many(
  "glyph_page_lines",
  "Quran::Web::Schema::Result::GlyphPageLine",
  { "foreign.glyph_id" => "self.glyph_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 word

Type: might_have

Related object: L<Quran::Web::Schema::Result::Word>

=cut

__PACKAGE__->might_have(
  "word",
  "Quran::Web::Schema::Result::Word",
  { "foreign.glyph_id" => "self.glyph_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mR4buSV5kDPcQxa/AUeNSg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
