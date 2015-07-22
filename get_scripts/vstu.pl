#!/usr/bin/perl
  use URI;
  use Data::Dumper;
  #use HTML::TableExtract;
  #use LWP::Simple;
  use LWP::UserAgent;
  use Encode;
  #use WWW::Mechanize;
  #use Spreadsheet::ParseExcel;
  #use switch;
  use v5.14;
  use utf8;
  binmode(STDOUT,':utf8');
  use warnings;

warn "run *** $0 ***";

# insert into univer_tbl values ('vstu','ВоГУ','Вологодский государственный технический университет','http://www.abiturient.vstu.edu.ru/');

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;

my ($res,$url,$fname,$b,$te,$s,$s2);

$url = 'http://www.abiturient.vstu.edu.ru/';

#
my $vuz = 'vstu';
my $spec = 'UNKNOWN';
my $fio = '';
$fname = $dname.'/'.$vuz.'-list.html';
my $ua = LWP::UserAgent->new();

my $res = $ua->mirror($url, $fname);

sub spec {
 my $f = shift;
 my $spec = shift;
 open(FILE1,$f);
 while(my $s = <FILE1>) {
# ������ ���, ����������� �� �������� �� ��������� �����
# 253   ����� ����� �����������              84     87     82          0      0       0          0   �����       -                    1
 $s = decode('utf8',$s);
 #print $s."\n";
 if ( $s =~ /.*(\d\d\d)\s+(\S+ \S+ \S+)\s+\d+\s+\d+\s+\d+.*\s+(\S+)\s+\-/ ) {
   #print $1." ".$2." ".$3."\n";
    print $vuz.";";
    print $spec.";";
    print trim('0').";";  # �
	print trim($2).";";  # ���
    print trim('0').";";    # ���������
    print trim($3).";"; 	# ��������
    print trim($1);	   	# ����
    print "\n";
  }
 }
 close(FILE1);
}

$s2='0';
open(FILE,$fname);
while(my $s = <FILE>)  {
#<li><a class="doclink" href="/index.php/priem-v-university/dokumenty-dlya-postupayushhix/rejting/359-if">������������ ���������</a></li>
#print $s;
$s = decode('utf8',$s);
 if ( $s =~ /dokumenty-dlya-postupayushhix\/rejting/ and $s !~ /.*361-magistratura.*/) {
  if ( $s =~ /.*href=\"(.*)\".*li/) {
   $s2 = $1;
   $url = 'http://www.abiturient.vstu.edu.ru'.$s2.'/file';
   if ( $s2 =~ /.*rejting\/(\d+)\-.*/ ) { $s2 = $1} else { $s2 = '0'}
   $fname = $dname."/vstu-".$s2.".txt";
   #print $url."\n";
   #$res = $ua->mirror($url, $fname);
   #print $res."\n";
   my $cmd = "bash getpdf.sh ".$url." ".$dname."/vstu-".$s2.".pdf ".$fname;
   system($cmd);
   spec($fname,'UNKNOWN');
  }
 }
}

#http://www.abiturient.vstu.edu.ru/index.php/priem-v-university/dokumenty-dlya-postupayushhix/rejting/363---108/file
#http://www.abiturient.vstu.edu.ru/index.php/priem-v-university/dokumenty-dlya-postupayushhix/rejting/363---108/file
