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

my $vuz = 'guap';
my ($url,$fname,$b,$te,$s);

sub spec {
	my $url = shift;
	my $spec = shift;

  #print "$vuz\n";
	my $fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	my $te = HTML::TableExtract->new( depth => 2, count => 0 );
	$te->parse_file($fname);

	#print Dumper $te;
	#return;

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        print $vuz.";";
        print $spec.";";
        print trim("0").";"; # №
        print trim(@$row[1]).";"; # ФИО
        print trim("0").";"; # Приоритет
        print trim("").";";	 # Оригинал
        print trim("0");	 # Балл
        print "\n";
     }
    }
}

$url = 'http://portal.guap.ru/portal/priem/priem2015/lists/11.html';
$fname = $dname.'/'.$vuz.'-list.html';
getstore($url, $fname);
my $te = HTML::TableExtract->new( depth => 2, count => 0, keep_html => 1);
$te->parse_file($fname);
#print Dumper $te;
foreach my $table ( $te->tables ) {
   foreach my $row ($table->rows) {
     $s = trim(@$row[3]);
     #<a href="ru/abiturientam/priyom-na-1-y-kurs/podavshie-zayavlenie/ochnaya/byudzhet/radiotehnika">список</a>
     if ($s =~ /.*href=\"(.*)\".*/) {  spec ($1,trim(@$row[1]));    }
   }
  }

# 09.03.01 "Информатика и вычислительная техника"
#guap ('http://portal.guap.ru/portal/priem/priem2015/lists/11_1_BO.html','09.03.01');
# 01.03.02 "Прикладная математика и информатика"
#guap ('http://portal.guap.ru/portal/priem/priem2015/lists/11_20_BO.html','01.03.02');
# 02.03.03 "Математическое обеспечение и администрирование информационных систем"
#guap ('http://portal.guap.ru/portal/priem/priem2015/lists/11_21_BO.html','02.03.03');
# 09.03.01 "Информатика и вычислительная техника"
#guap ('http://portal.guap.ru/portal/priem/priem2015/lists/11_22_BO.html','09.03.01');
# 09.03.03 "Прикладная информатика"
#guap ('http://portal.guap.ru/portal/priem/priem2015/lists/11_23_BO.html','09.03.03');
# 09.03.02 "Информационные системы и технологии"
#guap ('http://portal.guap.ru/portal/priem/priem2015/lists/11_26_BO.html','09.03.02');
# 10.03.01 "Информационная безопасность"
#guap ('http://portal.guap.ru/portal/priem/priem2015/lists/11_27_BO.html','10.03.01');
