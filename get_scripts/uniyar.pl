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
$fname = $dname.'/'.$vuz.'.pdf';

my $incomplete = 0;

getstore($url, $fname);
my $cmd = "bash pdf2text.sh ".$dname."/uniyar.pdf ".$dname."/uniyar.txt";
system($cmd);

open(FILE,$dname."/uniyar.txt");
while(my $s = <FILE>)
	{
    # 33701        ���������� ����� ���������� ��������� �������� �      05.03.06 �������� �            �����            ���������         ���           1
    #           1                 2
    #print $s."\n";
    #print $s;
	$s = trim(decode('utf8',$s));
    if ( $s =~ /\d+\s+(\S+ \S+ \S+).*(\S\S\.\S+\.\S+).*1$/ ) {
			print $vuz.";";
			print trim($2).";";
			print trim('0').";";  # �
			print trim($1).";";  # ���
			print trim('0').";";    # ���������
			print trim('n/a').";"; 	# ��������
			print trim('0');	   	# ����
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
    			print trim('0').";";  # �
    			print trim($fio).";";  # ���
    			print trim('0').";";    # ���������
    			print trim('n/a').";"; 	# ��������
    			print trim('0');	   	# ����
    			print "\n";
          $incomplete = 0;
      }
    } # else
	} # while
close(FILE);
