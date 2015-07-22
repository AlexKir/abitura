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
my $vuz = 'mipt';
my $spec = '';

    sub mipt_spec {
    my $spec = shift;

    my $url = 'https://mipt.ru/pk/spec-bac/statistics/full_list/?direction='.$spec.'&program=&form=&condition=443';
    #switch ($spec) {
    #  case '660457' {$spec = '01.03.02';}
    #  case '660465' {$spec = '03.03.01';}
    #  case '660470' {$spec = '09.03.01';}
    #  case '660474' {$spec = '10.03.01';}
    #  case '660486' {$spec = '27.03.03';}
    #  else {$spec = 'UNKNOWN';}
    #}

 given ($spec) {
    when (/^660457/) { $spec = '01.03.02'; }
    when (/^660465/) { $spec = '03.03.01'; }
    when (/^660470/) { $spec = '09.03.01'; }
    when (/^660474/) { $spec = '10.03.01'; }
    when (/^660486/) { $spec = '27.03.03'; }
    default { $spec = 'UNKNOWN'; }
  }
    #print $spec."\n";
    my $fname = $dname.'/'.$vuz.'_spec.htm';
    getstore($url, $fname);

    my $te = HTML::TableExtract->new( depth => 0, count => 1);
    $te->parse_file($fname);
    #print Dumper $te;
    my $fio = '';
    foreach my $table ( $te->tables ) {
       foreach my $row ($table->rows) {
          #print "   ", join(',', $row), "n";
          #print Dumper $row;
          $fio = decode('utf8',trim (@$row[2]));
          $fio =~ s/\s+/ /g;
		  if ( length ($fio) > 0 ) {
			print $vuz.";";
			print $spec.";";
			print trim(0).";"; # �
			print trim($fio).";"; # ���
			print trim(@$row[1]).";"; # ���������
			print trim(decode('utf8',@$row[3])).";"; # ��������
			$b = trim(@$row[8]);
			#print $b;
			#if ( $b =~ /\s+(\d+)\s+/ ) {
			#  $b = $1;
			#} else { $b = 0;}
			print trim($b);	    # ����
			print "\n";
		 }
       }
      }
    #print Dumper $te;
    #die;
    return;

  } #mipt_spec

  $url = 'https://mipt.ru/pk/spec-bac/statistics/full_list/';

  #print "$vuz\n";


  $fname = $dname.'/mipt_list.htm';
  getstore($url, $fname);

  #<a href="saBOB865.htm" style
  my $select = 0;
  open(FILE,$fname);
	while(my $s	= <FILE>) {
		if ( $select eq 0 and $s =~ /.*select onchange=.*this.*parents.*direction.*direction.*/ ) {$select = 1;}
    if ( $select eq 1 and $s =~ /.*option.*value.*\"(\d+)\".*/ )  { mipt_spec($1); }
    if ( $select eq 1 and $s =~ /.*\<\/select\>.*/ ) { last;}
	} # while
  close (FILE);
