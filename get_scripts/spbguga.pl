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

my ($url,$fname,$b,$te,$s);

my $d = strftime "%d_%m", localtime;

$url = 'http://www.spbguga.ru/files/2015/%D0%9F%D0%9A/%D1%81%D0%BF%D0%B8%D1%81%D0%BA%D0%B8%20%D0%9F%D0%9A/spisok__'.$d.'_2015.pdf';

# insert into univer_tbl values ('spbguga','�������','�����-������������� ��������������� ����������� ����������� �������','http://www.spbguga.ru/abiturientam/tekushchaya-statistika-priema');
my $vuz = 'spbguga';
my $spec = 'UNKNOWN';
my $fio = '';
$fname = $dname.'/'.$vuz.'.pdf';

my $incomplete = 0;
getstore($url, $fname);
my $cmd = "bash pdf2text.sh ".$dname."/spbguga.pdf ".$dname."/spbguga.txt";
system($cmd);

open(FILE,$dname."/spbguga.txt");
while(my $s = <FILE>)
	{
	$s = trim(decode('utf8',$s));
	# 1    ����� ����� ���������       ���            2         ���       141          0            141
	#print $s."\n";
	if ( $s =~ /\d+\s+(\S+ \S+ \S+)\s+(\S+)\s+\d+\s+\S+\s+(\d+)\s+\d+.*/ ) {
		print $vuz.";";
		print $spec.";";
		print trim('0').";";  # �
		print trim($1).";";  # ���
		print trim('0').";";    # ���������
		print trim($2).";"; 	# ��������
		print trim($3);	   	# ����
		print "\n";
	}

}
