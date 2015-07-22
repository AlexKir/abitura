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

my ($url,$fname,$b,$te,$s,$cmd);


sub gumrf_row {
  my $vuz = shift;
  my $spec = shift;
  my $row = shift;
  my $fio = decode('utf8',@$row[1]);
  my $s = decode('utf8',@$row[8]);

  if ( ( defined $fio ) and ( defined $s ) ){
    $fio =~ s/\n//g;
    $fio =~ s/\s+/ /g;
    $fio = trim($fio);

    $s =~ s/\n//g;
    $s =~ s/\s+/ /g;
    $s = substr($s,0,8);

    #print Dumper $fio;
    print $vuz.";";
    print $spec.";";
    print trim(@$row[0]).";";  # �
    print trim($fio).";";  # ���
    print trim(@$row[6]).";";    # ���������
    print trim($s).";"; 	# ��������
    print trim(@$row[2]);	   	# ����
    print "\n";
 }
} # sub gumrf_row

  my $d = strftime "%d%m", localtime;
  $url = 'http://abitur.gumrf.ru/files/hod_priema/Reiting_o_b_'.$d.'15.rtf';

  my $vuz = 'gumrf';
  #print "$vuz\n";
  my $spec = '';

  $fname = $dname.'/gumrf.rtf';
  my $fio = '';
  $s = '';
  getstore($url, $fname);
  $cmd = "bash rtf2text.sh ".$dname."/gumrf.rtf ".$dname."/gumrf.html";
  system($cmd);

  $fname = $dname.'/gumrf.html';

$te = HTML::TableExtract->new( depth => 0, count => 2);
$te->parse_file($fname);
$spec = '01.03.02';
foreach my $table ( $te->tables ) {
	foreach my $row ($table->rows) {
	gumrf_row($vuz,$spec,$row);
	#print "   ", join(',', $row), "n";
    #print Dumper $row;
  }
}

$te = HTML::TableExtract->new( depth => 0, count => 15);
$te->parse_file($fname);
$spec = '09.03.02';
foreach my $table ( $te->tables ) {
	foreach my $row ($table->rows) {gumrf_row($vuz,$spec,$row);}
}

$te = HTML::TableExtract->new( depth => 0, count => 20);
$te->parse_file($fname);
$spec = '09.03.02';
foreach my $table ( $te->tables ) {
	foreach my $row ($table->rows) {gumrf_row($vuz,$spec,$row);}
}

$te = HTML::TableExtract->new( depth => 0, count => 24);
$te->parse_file($fname);
$spec = '09.03.03';
foreach my $table ( $te->tables ) {
	foreach my $row ($table->rows) { gumrf_row($vuz,$spec,$row);}
}

$te = HTML::TableExtract->new( depth => 0, count => 28);
$te->parse_file($fname);
$spec = '10.03.01';
 foreach my $table ( $te->tables ) {
   foreach my $row ($table->rows) {gumrf_row($vuz,$spec,$row);}
}

 #    print Dumper $te;
 #    return;
