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

my $vuz = 'eltech';
my ($url,$fname,$b,$te,$s);

sub spec {
	my $url = shift;
  my $spec = shift;
	$fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	$te = HTML::TableExtract->new( depth => 0 , count => 0);
	$te->parse_file($fname);

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        if ( trim(@$row[1]) =~ /\S+ \S+ \S+/ ) {
          print $vuz.";";
          print $spec.";";
          print trim(@$row[0]).";";  # №
          print trim(@$row[1]).";";  # ФИО
          print trim(@$row[2]).";";  # Приоритет
          print trim(@$row[10]).";"; # Оригинал
          print trim(@$row[4]);	   # Балл
          print "\n";
       }
     }
    }

    $te = HTML::TableExtract->new( depth => 0 , count => 1);
  	$te->parse_file($fname);

  	foreach my $table ( $te->tables ) {
       foreach my $row ($table->rows) {
          #print "   ", join(',', $row), "n";
          #print Dumper $row;
          if ( trim(@$row[1]) =~ /\S+ \S+ \S+/ ) {
            print $vuz.";";
            print $spec.";";
            print trim(@$row[0]).";";  # №
            print trim(@$row[1]).";";  # ФИО
            print trim(@$row[2]).";";  # Приоритет
            print trim(@$row[10]).";"; # Оригинал
            print trim(@$row[4]);	   # Балл
            print "\n";
         }
       }
      }

      $te = HTML::TableExtract->new( depth => 0 , count => 2);
    	$te->parse_file($fname);

    	foreach my $table ( $te->tables ) {
         foreach my $row ($table->rows) {
            #print "   ", join(',', $row), "n";
            #print Dumper $row;
            if ( trim(@$row[1]) =~ /\S+ \S+ \S+/ ) {
              print $vuz.";";
              print $spec.";";
              print trim(@$row[0]).";";  # №
              print trim(@$row[1]).";";  # ФИО
              print trim(@$row[2]).";";  # Приоритет
              print trim(@$row[10]).";"; # Оригинал
              print trim(@$row[4]);	   # Балл
              print "\n";
           }
         }
        }

} # spec

$url = 'http://www.eltech.ru/ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie';
$fname = $dname.'/'.$vuz.'-'.'list.html';
getstore($url, $fname);
$te = HTML::TableExtract->new( depth => 0, count => 0, keep_html => 1);
$te->parse_file($fname);
#print Dumper $te;

foreach my $table ( $te->tables ) {
   foreach my $row ($table->rows) {
     $s = trim(@$row[2]);
     #<a href="ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie/ochnaya/byudzhet/radiotehnika">список</a>
     if ($s =~ /.*href=\"(.*)\".*/) {  spec ('http://www.eltech.ru/'.$1,trim(@$row[0]));    }
   }
  }

# 11.03.02 Инфокоммуникационные технологии и системы связи
#spec('http://www.eltech.ru/ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie/ochnaya/byudzhet/infokommunikacionnye-tehnologii-i-sistemy-svyazi','11.03.02');
# 01.03.02 Прикладная математика и информатика
#spec('http://www.eltech.ru/ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie/ochnaya/byudzhet/prikladnaya-matematika-i-informatika','01.03.02');
# 09.03.01 Информатика и вычислительная техника
#spec('http://www.eltech.ru/ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie/ochnaya/byudzhet/informatika-i-vychislitelnaya-tehnika','09.03.01');
# 09.03.04 Программная инженерия
#spec('http://www.eltech.ru/ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie/ochnaya/byudzhet/programmnaya-inzheneriya','09.03.04');
# 10.05.01 Компьютерная безопасность
#spec('http://www.eltech.ru/ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie/ochnaya/byudzhet/kompyuternaya-bezopasnost','10.05.01');
