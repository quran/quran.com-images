package Quran::Web::Schema::Result::GlyphPageLineBbox;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::GlyphPageLineBbox

=cut

__PACKAGE__->table("glyph_page_line_bbox");

=head1 ACCESSORS

=head2 glyph_page_bbox_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 glyph_page_line_id

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
  "glyph_page_bbox_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "glyph_page_line_id",
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
__PACKAGE__->set_primary_key("glyph_page_bbox_id");
__PACKAGE__->add_unique_constraint(
  "glyph_page_line_id_img_width",
  ["glyph_page_line_id", "img_width"],
);

=head1 RELATIONS

=head2 glyph_page_line

Type: belongs_to

Related object: L<Quran::Web::Schema::Result::GlyphPageLine>

=cut

__PACKAGE__->belongs_to(
  "glyph_page_line",
  "Quran::Web::Schema::Result::GlyphPageLine",
  { glyph_page_line_id => "glyph_page_line_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TqaZDGepg40qaKyrd8E0bQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
