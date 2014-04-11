package QuranImage::Generator::Page;
use Moose; with 'Nour::Script'; with 'QuranImage::Generator';
use GD;
use GD::Text;
use List::Util;
use constant PHI => ( sqrt( 5 ) + 1 ) / 2;

has gd_text => (
    is => 'rw'
    , isa => 'GD::Text'
    , required => 1
    , lazy => 1
    , default => sub { new GD::Text }
);

sub generate {
    my $self = shift;
    my $opts = $self->option;
    my $conf = $self->config;

    $conf->{base_font} = $self->path( $conf->{base_font} );
    $opts->{target} = $self->path( $opts->{target}, 'page', $opts->{width} );
    $opts->{pages} = [ eval $opts->{pages} ];

    for my $page ( reverse @{ $opts->{pages} } ) {
        if ( $page >= 1 and $page <= 604 ) {
            my $image = $self->create( page => $page );
            $self->png(
                path => $opts->{target}
                , file => "$page.png"
                , image => $image
            );
        }
    }
}

# ABSTRACT: generate a page in a madani mushaf

sub create {
    my ( $self, %opts ) = @_;
    my ( %page, %font );

    my $opts = $self->option;
    my $conf = $self->config;

    $page{number} = $opts{page};

    $self->info( "page ". $page{number} ."\n" );

    $font{factor} = 21; # 21 is the default
    $font{factor} = 23 if $page{number} eq 270; # page 270 font is slightly larger so it goes off the page
    $font{delta}  = 1; # TODO what was this for ??? => ( 21 - abs( 21 - $font{factor} ) ) / 21;
    $font{base}   = $self->path( $self->config( 'base_font' ) );

    $page{width}      = $opts->{width};
    $page{height}     = $opts->{width} * PHI * $font{delta};
    $page{ptsize}     = int( $opts->{width} / $font{factor} );
    $page{margin_top} = $page{ptsize} / 2;
    $page{coord_y}    = $page{margin_top};
    $page{font}       = $font{base}; # TODO: determine font size algorithmically and trim page height to fit or force fit

    my $image = $page{image} = new GD::Image ( $page{width}, $page{height} );
    my $color = $page{color} = {
        white  => $page{image}->colorAllocateAlpha( 255, 255, 255, 127 )
        ,black => $page{image}->colorAllocate( 0, 0, 0 )
        ,red   => $page{image}->colorAllocate( 19, 50, 112 )
    };

    $image->alphaBlending( 1 );
    $image->interlaced( 'true' );
    $image->setAntiAliased( $color->{black} );
    $image->transparent(    $color->{white} );

    $page{lines} = $self->get_line_data( page => $page{number} );

    for ( my $i = 0; $i < @{ $page{lines} }; $i++ ) {
        my $line = $page{lines}->[ $i ];

        $line->{page} = \%page;
        $line->{box}  = $self->get_box($line);

        $page{coord_y} -= $line->{box}->{min_y}
            if $page{coord_y} <= $page{margin_top} and $line->{box}->{min_y} < 0;

        $line->{previous_w} = 0;
        $page{coord_x}    = 0;

        for ( my $j = 0; $j < @{ $line->{glyphs} }; $j++ ) {
            my $glyph = $line->{glyphs}->[ $j ];

            $glyph->{line} = $line;
            $glyph->{box}  = $self->get_box($glyph);

            if ( $line->{type} ne 'sura' and grep { $page{number} eq $_ } qw/1 2/ ) {
                $glyph->{use_coord_y} = 1;
                $glyph->{box}{coord_y} += 100;
            }

            if ( $glyph->{position} == 1 and $line->{type} eq 'sura' ) {
                my $glyph = $self->get_glyph(
                    parent_type => 'ornament'
                    , glyph_type => 'header-box'
                )->[0];

                $glyph->{line}   = $line;
                $glyph->{ptsize} = $page{ptsize} * 1.8;
                $glyph->{box}    = $self->get_box($glyph);

                $glyph->{use_coords}      = 1;
                $glyph->{box}->{coord_y}  = $page{coord_y};
                $glyph->{box}->{coord_y} -= $glyph->{box}->{char_down};

                $self->set_box( $glyph );
            }

            $page{coord_x}
                = $page{coord_x} ? $page{coord_x} + $line->{previous_w}
                : $line->{box}->{coord_x};

            $line->{previous_w} = $glyph->{box}->{max_x};

            if ( $line->{type} eq 'sura' ) {
                $glyph->{use_coord_y}     = 1;
                $glyph->{box}->{coord_y}  = $page{coord_y};
                $glyph->{box}->{coord_y} += $line->{box}->{height} / 7;
            }

            $glyph->{box} = $self->set_box( $glyph );
            $line->{box}  = $self->get_max_box( $glyph->{box}, $line->{box} );
        }

        $page{coord_y} -= $line->{box}->{char_down};

        if ( $page{number} == 1 || $page{number} == 2 ) {
            $page{coord_y} += PHI * $line->{box}->{char_up};
        }
        else {
            $page{coord_y} += 2 * $line->{box}->{char_up};
        }
    }

    return $page{image};
}

dimensional_stuff: {
    sub set_box {
        my ($self, $glyph) = @_;

        my $line = $glyph->{line}? $glyph->{line} : $glyph;
        my $page = $line->{page};

        my $font   = $glyph->{font}   || $line->{font}   || $page->{font};
        my $ptsize = $glyph->{ptsize} || $line->{ptsize} || $page->{ptsize};

        my $box = $glyph->{box};

        my $color = $page->{color}->{black};

        # begin hack
        my ($coord_x, $coord_y) = $glyph->{use_coords} ? ($glyph->{box}->{coord_x}, $glyph->{box}->{coord_y}) : ($page->{coord_x}, $page->{coord_y});
        $coord_x = $glyph->{box}->{coord_x} if $glyph->{use_coord_x};
        $coord_y = $glyph->{box}->{coord_y} if $glyph->{use_coord_y};
        # end of hack

        if ($line->{type} eq 'ayah') {
            my ($min_x, $max_x, $min_y, $max_y) = (undef, undef, undef, undef);

            $min_x = $page->{coord_x} + $glyph->{box}->{min_x};
            $min_x = int($min_x);
            $max_x = $min_x + ($glyph->{box}->{max_x} - $glyph->{box}->{min_x});
            $max_x = int($max_x + 0.5);

            $min_y = $page->{coord_y} + $glyph->{box}->{min_y};
            $min_y = int($min_y);
            $max_y = $min_y + ($glyph->{box}->{max_y} - $glyph->{box}->{min_y});
            $max_y = int($max_y + 0.5);

            $self->set_page_line_bbox(
                glyph_page_line_id => $glyph->{page_line_id}
                , img_width => $page->{width}
                , min_x => $min_x
                , max_x => $max_x
                , min_y => $min_y
                , max_y => $max_y
            );
        }

        $page->{image}->stringFT($color, $font, $ptsize, 0, $coord_x, $coord_y, $glyph->{text}, {
            resolution => '96,94',
            kerning => 0
        });

        return $box;
    }

    sub get_box {
        my ($self, $glyph) = @_;

        my $line = $glyph->{line}? $glyph->{line} : $glyph;
        my $page = $line->{page};

        my $font   = $glyph->{font}   || $line->{font}   || $page->{font};
        my $ptsize = $glyph->{ptsize} || $line->{ptsize} || $page->{ptsize};

        $self->gd_text->set(
            font   => $font,
            ptsize => $ptsize
        );
        $self->gd_text->set_text( $glyph->{text} );

        my ($space, $char_down, $char_up) = $self->gd_text->get('space', 'char_down', 'char_up');

        # @bbox[0,1]  Lower left corner (x,y)
        # @bbox[2,3]  Lower right corner (x,y)
        # @bbox[4,5]  Upper right corner (x,y)
        # @bbox[6,7]  Upper left corner (x,y)

        my @bbox = GD::Image->stringFT($page->{color}->{black}, $font, $ptsize, 0, 0, 0, $glyph->{text});
        my $min_x = List::Util::min($bbox[0], $bbox[6]);
        my $max_x = List::Util::max($bbox[4], $bbox[2]);
        my $min_y = List::Util::min($bbox[7], $bbox[5]);
        my $max_y = List::Util::max($bbox[1], $bbox[3]);

        my $width = $max_x;# - $min_x;
        my $height = $max_y - $min_y;

        my $coord_x = ($page->{width} - $width) / 2;
        my $coord_y = $page->{coord_y};

        return {
            coord_x   => $coord_x,
            coord_y   => $coord_y,
            min_x     => $min_x,
            max_x     => $max_x,
            min_y     => $min_y,
            max_y     => $max_y,
            space     => $space,
            char_down => $char_down,
            char_up   => $char_up,
            width     => $width,
            height    => $height,
            bbox      => \@bbox,
            corner    => {
                top => {
                    left  => [$bbox[6],$bbox[7]],
                    right => [$bbox[4],$bbox[5]]
                },
                bottom => {
                    left  => [$bbox[0],$bbox[1]],
                    right => [$bbox[2],$bbox[3]]
                }
            }
        };
    }

    sub get_max_box {
        my $self = shift;
        my ($box_a, $box_b) = @_;
        my $box_c;
        my @lt = qw/min_x min_y char_down coord_x coord_y/;
        my @gt = qw/max_x max_y space char_up width height/;
        for (@lt) {
            $box_c->{$_} = ($box_a->{$_} <= $box_b->{$_})? $box_a->{$_} : $box_b->{$_};
        }
        for (@gt) {
            $box_c->{$_} = ($box_a->{$_} >= $box_b->{$_})? $box_a->{$_} : $box_b->{$_};
        }
        return $box_c;
    }
};

database_stuff: {
    sub get_line_data {
        my ( $self, %opts ) = @_;
        my @result = $self->db->query( qq|
            select gpl.glyph_page_line_id
                 , gpl.line_number
                 , gpl.line_type
                 , gpl.position glyph_position
                 , g.font_file line_font
                 , g.glyph_code
                 , gt.name glyph_type
              from glyph_page_line gpl
              left join glyph g using ( glyph_id )
              left join glyph_type gt using ( glyph_type_id )
              where gpl.page_number = ?
              order by gpl.page_number, gpl.line_number, gpl.position desc
        |, $opts{page} )->hashes;

        my @line;

        for my $row ( @result ) {
            $row->{glyph_text} = '&#'. $row->{glyph_code} .';';

            $line[ $row->{line_number} - 1 ] //= {
                number => $row->{line_number},
                type   => $row->{line_type},
                font   => $self->path( qw/res font/, $row->{line_font} ),
            };
            $line[ $row->{line_number} - 1 ]->{text} .= $row->{glyph_text};
            push @{ $line[ $row->{line_number} - 1 ]->{glyphs} }, {
                page_line_id => $row->{glyph_page_line_id},
                code         => $row->{glyph_code},
                text         => $row->{glyph_text},
                type         => $row->{glyph_type},
                position     => $row->{glyph_position}
            };
        }

        return \@line;
    }

    sub set_page_line_bbox {
        my ( $self, %args ) = @_;

        my @glyph_page_bbox_id = $self->db->query( qq|
            select glyph_page_bbox_id
              from glyph_page_line_bbox
             where glyph_page_line_id = ?
               and img_width = ?
        |, $args{glyph_page_line_id}, $args{img_width} )->flat;

        unless ( @glyph_page_bbox_id ) {
            $self->db->query( qq|
                insert into glyph_page_line_bbox
                       ( glyph_page_line_id, img_width, min_x, max_x, min_y, max_y )
                values ( ?, ?, ?, ?, ?, ? )
            |, $args{glyph_page_line_id}, $args{img_width}, $args{min_x}, $args{max_x}, $args{min_y}, $args{max_y} );
        }
        else {
            $self->db->query( qq|
                update glyph_page_line_bbox
                   set min_x = ?
                     , max_x = ?
                     , min_y = ?
                     , max_y = ?
                where glyph_page_line_id = ?
                  and img_width = ?
            |, $args{min_x}, $args{max_x}, $args{min_y}, $args{max_y}, $args{glyph_page_line_id}, $args{img_width} );
        }
    }

    sub get_glyph {
        my ( $self, %args ) = @_;
        my @bind;
        $args{type_secondary} //= $args{type};
        $args{limit} = 1 unless exists $args{limit};
        push @bind, grep{ defined } map { $args{ $_ } } qw/parent_type glyph_type meta page surah ayah line line_type limit/;
        my @result = $self->db->query( qq|
            select g.glyph_id
                 , g.page_number page
                 , l.line_number line
                 , w.sura_number surah
                 , w.ayah_number ayah
                 , l.position
                 , l.line_type
                 , g.font_file
                 , g.glyph_code
                 , g.glyph_type_meta meta
                 , g.description
                 , gtp.name parent_type
                 , gt.name glyph_type
              from glyph g
              left join glyph_type gt using ( glyph_type_id )
              left join glyph_type gtp on gt.parent_id = gtp.glyph_type_id
              left join word w using ( glyph_id )
              left join glyph_page_line l using ( glyph_id )
             where
                |. ( $args{parent_type}    ? 'gtp.name = ?' : '' ) .qq|              -- ayah ornament bismillah label-title
                |. ( $args{glyph_type}     ? 'and gt.name = ?' : '' ) .qq|           -- word end pause hizb sajdah sura juz header-box side-box-full side-box-half bismillah-simple bismillah-default
                |. ( $args{meta}           ? 'and g.glyph_type_meta = ?' : '' ) .qq| -- 0..114 w/ sura or 0..30 w/ juz ( what is 0? )
                |. ( $args{page}           ? 'and g.page_number = ?' : '' ) .qq|
                |. ( $args{surah}          ? 'and w.sura_number = ?' : '' ) .qq|
                |. ( $args{ayah}           ? 'and w.ayah_number = ?' : '' ) .qq|
                |. ( $args{line}           ? 'and l.line_number = ?' : '' ) .qq|
                |. ( $args{line_type}      ? 'and l.line_type = ?' : '' ) .qq|
             order by g.page_number, l.line_number, l.position
                |. ( $args{limit}          ? 'limit ?' : '' ) .qq|
        |, @bind )->hashes;

        return [ map { {
                code => $_->{glyph_code},
                text => '&#'. $_->{glyph_code} .';',
                type => $_->{glyph_type},
            position => $_->{position}
        } } @result ];
    }
};

1;
__END__
