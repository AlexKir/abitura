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

warn "run *** $0 ***";

# insert into univer_tbl values ('voenmeh','БГТУ «Военмех»','Балтийский государственный технический университет «Военмех»','http://www.voenmeh.ru/abiturients/reiting');

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $vuz = 'voenmeh';
my ($url,$fname,$b,$te,$s);


my $d = strftime "%d_%m", localtime;
$url = 'http://voenmeh.ru/files/0/reiting'.$d.'_2015.pdf';

  #print "$vuz\n";
my $spec = 'n/a';
$fname = $dname.'/'.$vuz.'.pdf';

	getstore($url, $fname);

    #my $cmd = "pdftotext -layout -nopgbrk ".$dname."/voenmeh.pdf ".$dname."/voenmeh.txt";
    my $cmd = "bash pdf2text.sh ".$dname."/voenmeh.pdf ".$dname."/voenmeh.txt";
    system($cmd);

    open(FILE,$dname."/voenmeh.txt");
	while(my $s = <FILE>)
	{
		#180   ������� ������ ���������                      168   0    �����     168   3
		# ������ ���-�� � ������ ������� �����
		if ( $s =~ /\d+\s+(\S+) (\S+) (\S+)\s+(\d+)\s+\d+\s+(\S+).*\d+$/ ) {
			#print $s;

			print $vuz.";";
			print $spec.";";
			print trim('0').";";  # �
			print $1." ".$2." ".$3.";";  # ���
			print trim('0').";";    # ���������
			print trim($5).";"; 	# ��������
			print trim($4);	   	# ����
			print "\n";

		}
	}
	close(FILE);
