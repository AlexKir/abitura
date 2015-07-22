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

my ($d,$url,$fname,$b,$te,$s,$cmd);

my $vuz = 'chsu';
my $spec = '';

sub chsu_table {
      my $fname = shift;
      my $spec = shift;
      my $tbl_num = shift;
      my $fio;
      my ($s,$s1,$s2);
      $s2 = '';
      my $te = HTML::TableExtract->new( depth => 0, count => $tbl_num);
      $te->parse_file($fname);
      #print Dumper $te;
      #return;
      foreach my $table ( $te->tables ) {
         foreach my $row ($table->rows) {
           #print Dumper $row;
          if (defined  @$row[1]) {
             $fio = decode('utf8',@$row[1]);
             $fio =~ s/\n//g;
             $fio =~ s/\s+/ /g;
          }

           if ( defined @$row[10] ) {
              $s =  decode('utf8',@$row[10]);
           } else {
             $s =  decode('utf8',@$row[8]);
           }

           if ( (defined $fio ) and ($fio !~ /.*\,.*/) and ( defined $s) ) {
             #print Dumper $fio;
             $s =~ s/\n//g;
             $s =~ s/\s+/ /g;
             if (defined @$row[7] ) {
                $s2 = decode('utf8',@$row[7]);
                $s2 =~ s/\n//g;
                $s2 =~ s/\s+/ /g;
              }
             print $vuz.";";
             print $spec.";";
             print trim('0').";";   # №
             print trim($fio).";";  # ФИО
             print trim($s2).";";   #
             print trim($s).";"; 	  #
             print trim(@$row[2]);	# балл
             print "\n";

            #print "   ", join(',', $row), "n";
          }
         }
       }
} # chsu_table

$d = strftime "%d.%m", localtime;
$url = 'http://pk.chsu.ru/upload/pages/spiski/%D0%A1%D0%BF%D0%B8%D1%81%D0%BA%D0%B8%20%D0%B1%D0%B0%D0%BA%D0%B0%D0%BB%D0%B0%D0%B2%D1%80%D0%B8%D0%B0%D1%82%20%D0%BD%D0%B0%20'.$d.'.rtf';

$fname = $dname.'/chsu.rtf';
getstore($url, $fname);
#print $fname;
$cmd = "bash rtf2text.sh ".$dname."/chsu.rtf ".$dname."/chsu.html";
system($cmd);
$fname = $dname.'/chsu.html';

chsu_table($fname,'01.03.02',2);
chsu_table($fname,'03.03.03',4);
chsu_table($fname,'09.03.01',6);
chsu_table($fname,'09.03.02',8);
chsu_table($fname,'09.03.03',11);
chsu_table($fname,'09.03.04',14);
chsu_table($fname,'10.03.01',18);
