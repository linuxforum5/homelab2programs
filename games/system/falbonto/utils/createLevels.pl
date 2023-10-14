#!/usr/bin/perl
# A falbontó pályaadatainak generálása
# A pályák mérete 6x39 féltégla
# Egy pálya adatszerkezete:
#   A 6 sor egymás után.
# Egy sor adatszerkezete:
#   Blokkok egymás után, míg a 39 féltéglányi hely ki nem töltődik
# Egy blokk 1 bájt
#   Felső 4 bit tégla típusa,
#   Alsó 4 bit a darabszáma
# A forrásadatok textfileok
my $filename;
my $lineIndex;
convert( 'level0.txt', 'level_training_data.bin' );
convert( 'levels.txt', 'levels_data.bin' );
print "Konverzió ok!\n";

sub convert {
    my $src = shift;
    my $dest = shift;
    open( SRC, '<', $src );
    open( DEST, '>', "../levels/$dest" );
    binmode DEST;
    $filename = $src;
    $lineIndex = 0;
    my $cnt = 1;
    if ( <SRC> =~ /^=+.*$/o ) {
        while ( convertNextLevel() ) {
            $cnt++;
        }
        print DEST chr(0);
    } else {
        print STDERR "Hibás forrásfájlkezdet: $src\n"; exit;
    }
    close DEST;
    close SRC;
    print "$cnt levels converted\n";
}

sub convertNextLevel {
    my $counter = 0;
    for( my $i = 0; $i < 6; $i++ ) {
        if ( my $sor = <SRC> ) {
            $sor =~ s/\s*$//mso;
            if ( length( $sor ) == 40 ) {
                convertLevelLine( $sor );
            } else {
                print STDERR "Hibás sorhossz: '$sor'\n";exit;
            }
        } else {
            printf STDERR "Hibás EOF in file '%s'\n", $filename;exit;
        }
    }
    if ( my $sor = <SRC> ) {
        if ( $sor !~ /^=+.*$/o ) {
            print STDERR "Hibás elválasztósor : '$sor'\n";exit;
        }
        print DEST chr(0);
        return 1;
    }
    print DEST chr(0);
    return 0;
}

sub convertLevelLine {
    my $sor = shift;
    $lineIndex++;
    for( my $index = 0; $index < 39; ) {
        my $sameCounter = 0;
        my $char = substr($sor,$index,1);
        my $code = getCodeFromChar( $char, $index );
        while( ( $sameCounter < 15 ) && ( $char eq substr( $sor, $index + $sameCounter, 1 ) ) ) {
            $sameCounter++;
            if ( $code > 3 ) { # dupla széles tégla
                if ( substr( $sor, $index+$sameCounter, 1 ) eq ':' ) {
                    $index++;
                } else {
                    printf STDERR "Hibás duplaszéles tégla: '%s'! File='%s', Sor1=%d, Oszlop0=%d\n", $char, $filename, $lineIndex, $index;exit(4);
                }
            }
        }
        if ( !$sameCounter ) {
            print STDERR "Téglasorolvasási hiba!\n"; exit;
        }
        print DEST chr( 16 * $code + $sameCounter );
        $index += $sameCounter;
        if ( $index > 39 ) {
            print STDERR "Blokkolvasási szinkronhiba!\n"; exit;
        }
    }
    if ( ! ( substr($sor,39,1) eq '!' ) ) {
        print STDERR "Hibás sorvégejel\n"; exit;
    }
}

sub getCodeFromChar {
    my $chr = shift;
    my $oszlop = shift;
    return 0 if ( $chr eq ' ' );
    return 1 if ( $chr eq 'L' );
    return 2 if ( $chr eq 'R' );
    return 3 if ( $chr eq 'H' );
    return 4 if ( $chr eq 'F' );
    return 5 if ( $chr eq '2' );
    return 6 if ( $chr eq '3' );
    return 7 if ( $chr eq '4' );
    return 8 if ( $chr eq '5' );
    return 9 if ( $chr eq '6' );
    return 10 if ( $chr eq 'P' );
    return 11 if ( $chr eq 'T' );
    return 12 if ( $chr eq 'E' );
    printf STDERR "Hibás karakter: '%s' (kódja=%d) File='%s', Sor1=%d, Oszlop0=%d\n", $chr, ord( $chr ), $filename, $lineIndex, $oszlop;
    exit;
}
