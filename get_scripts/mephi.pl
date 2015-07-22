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
  use utf8;
  binmode(STDOUT,':utf8');
  use warnings;

warn "run *** $0 ***";

# insert into univer_tbl values ('mephi','МИФИ','Национальный исследовательский ядерный университет «МИФИ»','https://org.mephi.ru/pupil-rating');
#

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;

my $vuz = 'mephi';
my ($url,$fname,$b,$te,$s,$spec,$fio);

$url = 'https://org.mephi.ru/pupil-rating';
$fname = $dname.'/'.$vuz.'-'.'list.html';
getstore($url, $fname);

$te = HTML::TableExtract->new( depth => 0, count => 0, keep_html => 1);
$te->parse_file($fname);

#print Dumper $te;

sub spec {
	my $url = shift;
  #print $url."\n";
  my $spec = shift;
	$fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	$te = HTML::TableExtract->new( depth => 0, count => 0);
	$te->parse_file($fname);

  #print Dumper $te;
  #return;
# 1 	НИЯУ МИФИ-12846 	Пузырев Дмитрий Александрович 	Обязательно 	300 	10 	1 	311 	Копия
	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        $fio = trim(decode('utf8',@$row[2]));
        if ( $fio =~ /\S+ \S+ \S+/ ) {
          print $vuz.";";
          #print $spec.";";
          print "UNKNOWN;";
          print trim(0).";";  # №
          print trim($fio).";";  # ФИО
          print trim(0).";";  # Приоритет
          print trim(decode('utf8',@$row[8])).";"; # Оригинал
          $b = trim(decode('utf8',@$row[7]));
          #print $b;
          if ( length($b) eq 0) {$b = 0;}
          print trim($b);	   # Балл
          print "\n";
       }
     }
    }
} # spec


foreach my $table ( $te->tables ) {
   foreach my $row ($table->rows) {
     $s = trim(@$row[1]);
     ## <a href="/pupil-rating/get-rating/entity/3602/original/no">
     if ($s =~ /.*href=\"(.*)\".*/) {
       $url = $1;
       if ( $s =~ /entity.(\d+).original/ ) { $spec = $1}
       spec ('https://org.mephi.ru'.$url,$spec);
     }
    }
  }
