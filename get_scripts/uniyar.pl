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
  #use utf8;
  binmode(STDOUT,':utf8');

  use warnings;

warn "run *** $0 ***";

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my ($url,$fname,$b,$te,$s);

my $d = strftime "%d%m", localtime;

$url = 'http://priem.uniyar.ac.ru/docs/spisok'.$d.'.pdf';
$d = strftime "%d_%m", localtime;

my $vuz = 'uniyar';
my $spec = '';
my $fio = '';

sub spec {

my $url = shift;
my $spec = shift;
my $incomplete = 0;

$fname = $dname.'/'.$vuz.'-'.$spec.'.pdf';
getstore($url, $fname);
my $cmd = "bash pdf2text.sh ".$fname." ".$dname."/uniyar.txt";
system($cmd);
#die;
open(FILE,$dname."/uniyar.txt");
while(my $s = <FILE>)
	{
    #           1                 2
    #print $s."\n";
    #print $s;
	$s = trim(decode('utf8',$s));
    #print "s1 = ".$s."\n";
    # 1                33515 Пуханов Вячеслав Сергеевич         мат - 86; рус - 87; инф - 97;   (сочинение);                274 Нет
    #301   35904 Басков Михаил Вадимович       мат - 50; рус - 66; инф - 44;   (сочинение)              162 Нет
    if ( $s =~ /(\d+)\s+\d+\s+(\S+ \S+ \S+).*\s+(\d+)\s+(\S+)$/ ) {
      #print $s."\n";
			print $vuz.";";
			print $spec.";";
			print trim($1).";";  #
			print trim($2).";";      #  ФИО
			print trim('0').";";     # Приоритет
			print trim($3).";"; 	 # Оригинал
			print trim($4);	   	   #  Балл
			print "\n";
      $incomplete = 0;
		}
    else {
      if ( $s =~ /\d+\s+(\S+ \S+).*(\S\S\.\S+\.\S+).*1$/ ) {
          $incomplete = 1;
          $fio = $1;
          $spec = $2;
          #print "incomplete ".$fio." ".$spec."\n";
      } if ( ($incomplete eq 1) and ($s =~ /^\s+(\S+)\s+/) ) {
          $fio = $fio." ".$1;
          print $vuz.";";
    			print $spec.";";
    			print trim('0').";";  #
    			print trim($fio).";";  #
          print trim('0').";";    #
    			print trim('n/a').";"; 	#
    			print trim('0');	   	#
    			print "\n";
          $incomplete = 0;
      }
    } # else
	} # while
close(FILE);
}

spec ('http://priem.uniyar.ac.ru/entrant2015/rati/mkn.pdf','02.03.01');
spec ('http://priem.uniyar.ac.ru/entrant2015/rati/pmi_m.pdf','01.03.02-M');
spec ('http://priem.uniyar.ac.ru/entrant2015/rati/pmi_ivt.pdf','01.03.02-IVT');
spec ('http://priem.uniyar.ac.ru/entrant2015/rati/fiit.pdf','02.03.02');
spec ('http://priem.uniyar.ac.ru/entrant2015/rati/kb.pdf','10.05.01');
spec ('http://priem.uniyar.ac.ru/entrant2015/rati/pie.pdf','09.03.03');
spec ('http://priem.uniyar.ac.ru/entrant2015/rati/ikt.pdf','11.03.02');
