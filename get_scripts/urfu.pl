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

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;

my $vuz = 'urfu';
my ($url,$fname,$b,$te,$s,$s2,$fio);

sub spec {
	my $url = shift;
  $url = 'http://old-abiturient.urfu.ru/'.$url;
  my $spec = 'UNKNOWN';
	$fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	$te = HTML::TableExtract->new( depth => 0, count => 0 );
	$te->parse_file($fname);

#  print Dumper $te;
#  die;

# 0  \'Фамилия Имя Отчество',
# 1 \'Рег.№',
# 2 \'Состояние',
# 3 \'Вид конкурса',
# 4 \'Док. об образовании',
# 5 \'Приоритет направления, Направление (специальность)',
# 6 \'Приоритет института, Институт (филиал)',
# 7 \'Форма обучения',
# 8 \'Бюджетная (контрактная) основа',
# 9 \'Вступительные испытания по предметам',
# 10 \undef,
# 11 \undef,
# 12 \'Индивидуальные достижения',
# 13 \'Сумма конкурсных баллов'

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        $fio = decode('utf8',@$row[0]);
        $b = @$row[13];
        if ( defined $fio and $fio =~ /\S+ \S+ \S+/ and $fio !~ /Фамилия/ and defined $b and $b =~ /\d\d/) {
          print $vuz.";";
          print $spec.";";
          print trim(0).";";  # №
          print trim($fio).";";  # ФИО
          print trim(0).";";  # Приоритет
          print trim(decode('utf8',@$row[4])).";"; # Оригинал
          print trim($b);	   # Балл
          print "\n";
       }
     }
    }
} # spec

$url = 'http://old-abiturient.urfu.ru/applicant/rating-2015/alpha/a/';
$fname = $dname.'/'.$vuz.'-'.'list.html';
getstore($url, $fname);

open(FILE,$fname);
while(my $s	= <FILE>) {
  if ( $s =~ /.*<div class=\"top_menu top_menu2.*/ ) {
      foreach ( split /\<\/span>/,$s ) {
          # <span class="item"><a href="applicant/rating-2015/alpha/b/" onfocus="blurLink(this);"  >Б</a>
          $s2 = $_;
          if ( $s2 =~ /.*href=\"(.*)\" onfocus/ ) { spec($1); }
          }
    }
} # while
close (FILE);
