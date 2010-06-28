package Quran::Web::Schema::Result::GlyphAyahBbox;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::GlyphAyahBbox

=cut

__PACKAGE__->table("glyph_ayah_bbox");

=head1 ACCESSORS

=head2 glyph_ayah_bbox_id

  data_type: 'integer'
  is_nullable: 0

=head2 glyph_ayah_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 img_width

  data_type: 'integer'
  is_nullable: 0

=head2 min_x

  data_type: 'integer'
  is_nullable: 0

=head2 max_x

  data_type: 'integer'
  is_nullable: 0

=head2 min_y

  data_type: 'integer'
  is_nullable: 0

=head2 max_y

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "glyph_ayah_bbox_id",
  { data_type => "integer", is_nullable => 0 },
  "glyph_ayah_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "img_width",
  { data_type => "integer", is_nullable => 0 },
  "min_x",
  { data_type => "integer", is_nullable => 0 },
  "max_x",
  { data_type => "integer", is_nullable => 0 },
  "min_y",
  { data_type => "integer", is_nullable => 0 },
  "max_y",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("glyph_ayah_bbox_id");

=head1 RELATIONS

=head2 glyph_ayah

Type: belongs_to

Related object: L<Quran::Web::Schema::Result::GlyphAyah>

=cut

__PACKAGE__->belongs_to(
  "glyph_ayah",
  "Quran::Web::Schema::Result::GlyphAyah",
  { glyph_ayah_id => "glyph_ayah_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nUMn7sFGXQeSBEuEoVuTtg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
