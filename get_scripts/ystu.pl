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

  # insert into univer_tbl values ('ystu','ЯГТУ','Ярославский государственный технический университет','http://www.ystu.ru/files/prkom_svod/svodkaBOB.htm');

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my ($url,$fname,$b,$te,$s);

my $d = strftime "%d%m", localtime;

my $vuz = 'ystu';
my $spec = '';

sub ystu_spec {
    my $url = shift;
    #print $url."\n";

    my $spec = 'UNKNOWN';
    my $b;
    if ( $url eq "saBOB874.htm" ) {$spec='09.03.02';}
    if ( $url eq "saBOB881.htm" ) {$spec='09.03.04';}
    my $fname = $dname.'/ystu_spec.htm';
    $url = 'http://www.ystu.ru/files/prkom_svod/'.$url;
    getstore($url, $fname);

    my $te = HTML::TableExtract->new( depth => 0, count => 0);
    $te->parse_file($fname);

    my $fio = '';
    foreach my $table ( $te->tables ) {
       foreach my $row ($table->rows) {
          #print "   ", join(',', $row), "n";
          #print Dumper $row;
          $fio = decode('cp1251',trim (@$row[1]));
          print $vuz.";";
          print $spec.";";
          print trim(@$row[0]).";"; # �
          print trim($fio).";"; # ���
          print trim(0).";"; # ���������
          print trim(decode('cp1251',@$row[7])).";"; # ��������
          $b = @$row[4];
          #print $b;
          if ( $b =~ /(\d+)\s+\(.*/ ) {
            $b = $1;
          } else { $b = 0;}
          print trim($b);	    # ����
          print "\n";
       }
      }
    #print Dumper $te;
    #die;
    return;

  } #ystu_spec
  $url = 'http://www.ystu.ru/files/prkom_svod/svodkaBOB.htm';

  #print "$vuz\n";

  $fname = $dname.'/ystu_list.htm';
  getstore($url, $fname);

  #<a href="saBOB865.htm" style
  open(FILE,$fname);
	while(my $s	= <FILE>) {
		if ( $s =~ /.*\<a href="(.*)" style/ ) {ystu_spec($1);}
	} # while
  close (FILE);
