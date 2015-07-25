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
use warnings;
binmode(STDOUT,':utf8');

warn "run *** $0 ***";

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;

my $vuz = 'ifmo';
my ($url,$fname,$b,$te,$s,$flag);
my $spec = 'UNKNOWN';

sub ifmo_spec  {
   my $url = shift;
   my $spec = shift;
   #print $url." ".$spec."\n";
   #return;
   #print $url;
   my $fname = $dname.'/ifmo_spec.htm';
   $url = 'http://ums.abit.ifmo.ru/abitUMS/'.$url;
   getstore($url, $fname);

   #open(FILE1,$fname);
   #while(my $s	= <FILE1>) {
   #if ( $s =~ /.*\s+(\S+)\.(\d+)\.(\d+).*/ ) {$spec = $1.'.'.$2.'.'.$3;}
   #}
   #close(FILE1);
   #print $spec;
   my $te = HTML::TableExtract->new( depth => 0, count => 0);
   $te->parse_file($fname);

   my $fio = '';
   foreach my $table ( $te->tables ) {
      foreach my $row ($table->rows) {
         #print "   ", join(',', $row), "n";
         #print Dumper $row;
         #$flag = Encode::is_utf8(@$row[1]);
         #print $flag;
         # № 	ФИО 	Приоритет 	Кафедра 	Условие поступления 	ЕГЭ+ИД 	ЕГЭ 	ИД(а-г) 	ИД(д) 	Подлинник
         if ( Encode::is_utf8(@$row[1]) ) {$fio = trim (decode('utf8',@$row[1])) } else { $fio = trim (@$row[1]);}
         if ( defined $fio and $fio !~ /ФИО/ and $fio =~ /\S+ \S+ \S+/ ) {
          print $vuz.";";
          print $spec.";";
          print trim(@$row[0]).";"; # №
          print trim(decode('utf8',$fio)).";"; # ФИО
          print trim(@$row[2]).";"; # Приоритет
          print trim(decode('utf8',@$row[9])).";"; # Оригинал
          print trim(@$row[5]);	    # Балл
          print "\n";
       }
      }
     }
   #print Dumper $te;
   #die;
   return;
  } # ifmo_spec

  $url = 'http://ums.abit.ifmo.ru/abitUMS/statsAll.htm';

  #print "$vuz\n";


  $fname = $dname.'/ifmo_list.htm';
  getstore($url, $fname);

  $te = HTML::TableExtract->new( depth => 0, count => 0, keep_html => 1);
  $te->parse_file($fname);

  foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
	   $s = '';
	   if (defined @$row[0]) { $s = trim(@$row[0]);}
       #<a href="statByUsers.htm?fid=1&edform=1&facid=2&spid=1">
       if ($s =~ /.*href="(.*)">/) {
          $url = $1;
          if ( $s =~ /.*\s+(\S+)\.(\d+)\.(\d+).*/ ) {$spec = $1.'.'.$2.'.'.$3;} else {$spec = 'UNKNOWN';}
          $spec = $spec.'-'.trim(decode('utf8',@$row[1]));
          ifmo_spec($url,$spec);
          }
     }
    }

  #<a href="statByUsers.htm?fid=1&edform=1&facid=2&spid=1">
  #open(FILE,$fname);
  #while(my $s	= <FILE>) {
  #  if ( $s =~ /.*href="(.*)">/ ) {ifmo_spec($1);}
  #} # while
  #close (FILE);
