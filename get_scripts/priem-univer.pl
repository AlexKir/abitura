#!/usr/bin/perl
  use URI;
  use Data::Dumper;
  use HTML::TableExtract;
  use LWP::Simple;
  use Encode;
  #use WWW::Mechanize;
  #use Spreadsheet::ParseExcel;
  #use switch;
  use v5.14;
#  use utf8;
use warnings;

warn "run *** $0 ***";

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;

my $vuz = 'priem-univer';
my ($url,$fname,$b,$te,$s,$spec,$fio,$orig);

sub spec {
	my $url = shift;
	my $spec = shift;
 #print $url.$spec."\n";
 #return;
	my $vuz = 'priem-univer';
  #print "$vuz\n";
	my $fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	my $te = HTML::TableExtract->new( attribs => { class => "prikaz" });
	$te->parse_file($fname);
	#print Dumper $te;
	#return;

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        $fio = '';
	if ( defined @$row[2] ) { $fio = @$row[2];}
	if ( $fio =~ /\S+ \S+ \S+/ ) {
         print $vuz.";";
         print $spec.";";
         print trim(0).";";  # №
         print trim(@$row[2]).";";  # ФИО
         print trim(@$row[3]).";";  # Приоритет
	 $orig = '';
	 if (defined @$row[4]) { $orig = trim(@$row[4]); }
	 $orig =~ s/\s/#/g; $orig =~ s/#+/ /g;
         print trim($orig).";";  # Оригинал
         print trim(@$row[5]);	   # Балл
         print "\n";
	}
     }
    }
} # spec

$url = 'http://priem-univer.ru/byudzhet';
$fname = $dname.'/'.$vuz.'-list.html';
getstore($url, $fname);
$te = HTML::TableExtract->new( depth => 0, count => 0,keep_html => 1);
$te->parse_file($fname);
#print Dumper $te;
foreach my $table ( $te->tables ) {
   foreach my $row ($table->rows) {
     $spec = trim(@$row[0]);
     #print $spec;
     $spec =~ s/\<p\>//g;
     $spec =~ s/\<\/p\>//g;
     $s = trim(@$row[1]);
     #<a href="ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie/ochnaya/byudzhet/radiotehnika">список</a>
     if ($s =~ /.*href=\"(.*)\"\s+target.*/) {  spec ($1,$spec);    }
   }
  }



# 09.03.01 ИНФОРМАТИКА И ВЫЧИСЛИТЕЛЬНАЯ ТЕХНИКА
#priemuniver ('http://priem-univer.ru/render/bakalavr_spisok_byudzhet_090301-informatika-i-vychislitelynaja-tehnika.html','09.03.01');
# 09.03.02 ИНФОРМАЦИОННЫЕ СИСТЕМЫ И ТЕХНОЛОГИИ
#priemuniver ('http://priem-univer.ru/render/bakalavr_spisok_byudzhet_090302-informacionnyje-sistemy-i-tehnologii.html','09.03.02');
# 11.03.04 ЭЛЕКТРОНИКА И НАНОЭЛЕКТРОНИКА
#priemuniver ('http://priem-univer.ru/render/bakalavr_spisok_byudzhet_110304-elektronika-i-nanoelektronika.html','11.03.04');
# 27.03.04 УПРАВЛЕНИЕ В ТЕХНИЧЕСКИХ СИСТЕМАХ
#priemuniver ('h#ttp://priem-univer.ru/render/bakalavr_spisok_byudzhet_270304-upravlenije-v-tehnicheskih-sistemah.html','27.03.04');
