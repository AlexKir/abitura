#!/usr/bin/perl
  use URI;
  use Data::Dumper;
  use HTML::TableExtract;
  #use LWP::Simple;
  use LWP::UserAgent;
  #use WWW::Mechanize;
  use WWW::Mechanize::Firefox;
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

my $vuz = 'miet';
my ($url,$fname,$b,$te,$s,$fio,$spec,$res);

my $ua = LWP::UserAgent->new();

sub spec {
	my $url = shift;
  print $url."\n";
  if ( $url =~ /list.php\?d=(\S+.\d+.\d+)\&fo=o\&fin=b/) { $spec = $1; } else {$spec = 'UNKNOWN';}

	$fname = $dname.'/'.$vuz.'-'.$spec.'.html';
	#getstore($url, $fname);
  $res = $ua->mirror($url, $fname);
  print $res;

	$te = HTML::TableExtract->new(depth => 0, count => 0);
	$te->parse_file($fname);
# 1	Л-8435	Лисяк Андрей Игоревич		219	54	78	79	8	+		ОП	1
  print Dumper $te;
  return;

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        $fio = trim(decode('utf8',@$row[2]));
        if ( $fio =~ /\S+ \S+ \S+/ ) {
          print $vuz.";";
          print $spec.";";
          print trim(0).";";  # №
          print trim($fio).";";  # ФИО
          print trim(@$row[10]).";";  # Приоритет
          print trim(decode('utf8',@$row[3])).";"; # Оригинал
          $b = trim(@$row[4]);
          if ( length($b) eq 0) {$b = 0;}
          print $b;	   # Балл
          print "\n";
       }
     }
    }
} # spec

sub spec2 {
  my $url = shift;
  #print $url."\n";
  if ( $url =~ /list.php\?d=(\S+.\d+.\d+)\&fo=o\&fin=b/) { $spec = $1; } else {$spec = 'UNKNOWN';}

  $fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	my $mech = WWW::Mechanize::Firefox->new();
  #$mech->agent_alias( 'Linux Mozilla');
	#$mech->cookie_jar(HTTP::Cookies->new());
	my $result = $mech->get($url);
  $mech->save_content( $fname);
	#print Dumper $result->content();
  $te = HTML::TableExtract->new(depth => 0, count => 0);
	$te->parse_file($fname);
  foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
         $fio = '';
        if (defined  @$row[2] ) { $fio = trim(decode('utf8',@$row[2]));
        if ( $fio =~ /\S+ \S+ \S+/ ) {
          print $vuz.";";
          print $spec.";";
          print trim(0).";";  # №
          print trim($fio).";";  # ФИО
          print trim(@$row[12]).";";  # Приоритет
          if ( defined @$row[3] ) {$s = trim(decode('utf8',@$row[3])); } else {$s = 'Нет';}
          print trim($s).";"; # Оригинал
          $b = trim(@$row[4]);
          if ( length($b) eq 0) {$b = 0;}
          print $b;	   # Балл
          print "\n";
       }
     }
    }
} # spec2

$url = 'https://abit.miet.ru/lists/list-all/index.php';
$fname = $dname.'/'.$vuz.'-'.'list.html';
$res = $ua->mirror($url, $fname);
print $res;

#  <li><a href="list.php?d=12.03.04&fo=o&fin=b">Биотехнические системы и технологии</a></li>
open(FILE,$fname);
while(my $s	= <FILE>) {
  if ( $s =~ /.li.*a href=\"(.*)\"\S+\s+.*li/ ) {
      #print $1."\n";
      $url = 'https://abit.miet.ru/lists/list-all/'.$1;
      spec2($url);
    }
} # while
close (FILE);
