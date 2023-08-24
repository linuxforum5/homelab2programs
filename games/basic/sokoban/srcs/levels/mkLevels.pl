#!/usr/bin/perl
# Legenerálja a plyákhoz tartozó basic kódokat
my $src='sokoban-maps-60-plain.txt';
my $index = 0;
my $X = 0;
my $Y = 0;
my $maxX = 0;
my $maxY = 0;
my $maxB = 0;
my $minV = 256;
my $maxV = 0;
my $LN = 0;
my $DD = $ARGV[0];
$DD = 76 if ( !$DD );
my $DataCounter = 0; # Az eddigi DATA adatok száma
my @levels;
$levels[0]='';
open( SRC, '<', $src );
while( my $sor=<SRC> ) {
    if ( $sor =~ /^\*{10,}/o ) {
        if ( $index ) {
            open( DEST, '>', 'maze.'.$index.'.bas' );
            print DEST $levels[$index]."\n";
            close( DEST );
        }
        $index++;
        $levels[$index]=''; # Next Maze
    } elsif ( $sor =~ /^Size ([XY]):\s*(\d+)\s*$/o ) {
        $X = $2 if ( $1 eq 'X' );
        if ( $1 eq 'Y' ) {
            $Y = $2;
            $maxX = $X if ( $X > $maxX );
            $maxY = $Y if ( $Y > $maxY );
            $LN = 2000 + $index;
            $levels[ $index ] = sprintf( '%d DATA %d,%d,%d', $LN, $index, $X, $Y ) ; # , $DataCounter );
            $DataCounter += 4;
        }
    } elsif ( $sor =~ /^\s*x/io ) { # Pályasor
        chop( $sor );
        $LN += 10;
        my @data = convert_line( $sor, $X );
        $DataCounter += $#data+1;
        $levels[ $index ] .= ',"';
        for( my $idx=0; $idx<=$#data; $idx++ ) {
            $levels[ $index ] .= chr( $data[$idx] );
        }
        $levels[ $index ] .= '"'
        # $levels[ $index ] .= ',' . join( ',', @data );
    } elsif ( $sor =~ /^([MFEL].*|)$/o ) { # SKIP
    } else {
        print STDERR "Fel nem ismert sor:\n$sor\n";exit;
    }
}

printf "MaxX=%d, maxY=%d. Max blokkhossz=%d, Value min.:%d, Value max.:%d\n", $maxX, $maxY, $maxB, $minV, $maxV;

sub convert_line {
    my $sor = shift;
    my $X = shift;
    my @data;
    if ( length( $sor ) != $X ) {
        print STDERR "Mérethiba X\n"; exit;
    } else {
        my $x=0;
        while ( $x < $X ) {
            my $cnt = 1;
            my $char = substr( $sor, $x, 1 ); 
            while ( ( $x+$cnt < $X ) && ( $char eq substr( $sor, $x+$cnt, 1 ) ) ) {
                $cnt++;
            }
            my $type = get_type( $char );
            my $value = $type*32 + $cnt;
$minV = $value if ( $value < $minV );
$maxV = $value if ( $value > $maxV );
            $value += $DD;
if ( $value == 96 ) { print STDERR "JAJJ 0x60!\n";exit; }
if ( $value == 34 ) { print STDERR "JAJJ 0x22!\n";exit; }
if ( $value == 10 ) { print STDERR "JAJJ 0x0A!\n";exit; }
if ( $value>255 ) { print STDERR "JAJJ túl nagy!\n";exit; }
            @data[ $#data+1 ] = $value;
            $maxB = $cnt if ( $cnt > $maxB );
            $x+=$cnt;
        }
    }
    return @data;
}

sub get_char {
    my $type = shift;
    if ( $type == 0 ) { return 32;
    } elsif ( $type == 1 ) { return 119; # Üres négyet/tolnivaló láda
    } elsif ( $type == 2 ) { return 121; # pötty. Ez a cél
    } elsif ( $type == 3 ) { return 101; # Teli négyzet, láda a helyén
    } elsif ( $type == 4 ) { return 251; # Fal, szürke nyégzet
    } elsif ( $type == 5 ) { return 99; # Mandró alap. Ez a játékos
    } else {
        print STDERR "Invalid type!\n";exit;
    }
}

sub get_type {
    my $char = shift;
    if ( $char eq ' ' ) { return 0;    # SPACE
    } elsif ( $char eq '*' ) { return 1; # STONE
    } elsif ( $char eq '.' ) { return 2; # PLACE
    } elsif ( $char eq '&' ) { return 3; # STONE ON PLACE
    } elsif ( $char eq 'X' ) { return 4; # WALL
    } elsif ( $char eq '@' ) { return 5; # START
    } else {
        print STDERR "Invalid character : '$char'!\n";exit;
    }
}
