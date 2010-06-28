package Quran::Web::Schema::Result::Word;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Quran::Web::Schema::Result::Word

=cut

__PACKAGE__->table("word");

=head1 ACCESSORS

=head2 word_id

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

=head2 sura_number

  data_type: 'integer'
  is_nullable: 0

=head2 ayah_number

  data_type: 'integer'
  is_nullable: 0

=head2 position

  data_type: 'integer'
  is_nullable: 0

=head2 word_arabic_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 word_stem_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 word_lemma_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 word_root_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "word_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "glyph_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "page_number",
  { data_type => "integer", is_nullable => 0 },
  "sura_number",
  { data_type => "integer", is_nullable => 0 },
  "ayah_number",
  { data_type => "integer", is_nullable => 0 },
  "position",
  { data_type => "integer", is_nullable => 0 },
  "word_arabic_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "word_stem_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "word_lemma_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "word_root_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("word_id");
__PACKAGE__->add_unique_constraint(
  "sura_ayah_position_index",
  ["sura_number", "ayah_number", "position"],
);
__PACKAGE__->add_unique_constraint("glyph_unique", ["glyph_id"]);

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

=head2 word_root

Type: belongs_to

Related object: L<Quran::Web::Schema::Result::WordRoot>

=cut

__PACKAGE__->belongs_to(
  "word_root",
  "Quran::Web::Schema::Result::WordRoot",
  { word_root_id => "word_root_id" },
  { join_type => "LEFT", on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 word_lemma

Type: belongs_to

Related object: L<Quran::Web::Schema::Result::WordLemma>

=cut

__PACKAGE__->belongs_to(
  "word_lemma",
  "Quran::Web::Schema::Result::WordLemma",
  { word_lemma_id => "word_lemma_id" },
  { join_type => "LEFT", on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 word_stem

Type: belongs_to

Related object: L<Quran::Web::Schema::Result::WordStem>

=cut

__PACKAGE__->belongs_to(
  "word_stem",
  "Quran::Web::Schema::Result::WordStem",
  { word_stem_id => "word_stem_id" },
  { join_type => "LEFT", on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 word_arabic

Type: belongs_to

Related object: L<Quran::Web::Schema::Result::WordArabic>

=cut

__PACKAGE__->belongs_to(
  "word_arabic",
  "Quran::Web::Schema::Result::WordArabic",
  { word_arabic_id => "word_arabic_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-06-10 14:47:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z2dZs+q/lcGJwsXoCIZ1JA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
