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

my ($d,$url,$fname,$b,$te,$s,$cmd,$fio);

my $vuz = 'mstu';
my $spec = '';

sub spec {
	my $spec = shift;
  my $url = 'http://abit.mstu.edu.ru/results/2015/?napr=%C5%C3%DD&spec='.$spec.'&form=1';
	$fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	$te = HTML::TableExtract->new(  depth => 0, count => 0 );
	$te->parse_file($fname);

  #print Dumper $te;
  #die;
  $spec = 'UNKNOWN';

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        # N 	Фамилия 	Имя 	Отчество	Математика	Информатика и ИКТ	Русский язык	Индивидуальные достижения 	Сумма 	Приоритет* 	Копия/оригинал 	Льгота*
        # 1	Иванова	Ирина	Дмитриевна	76 	81 	92 	10 	259 	1 	Оригинал
        $fio = trim(decode('cp1251',@$row[1])).' '.trim(decode('cp1251',@$row[2])).' '.trim(decode('cp1251',@$row[3]));
        $b = @$row[8];
        if ( defined $fio and $fio =~ /\S+ \S+ \S+/ and $fio !~ /Фамилия/ and defined $b) {
          print $vuz.";";
          print $spec.";";
          print trim(@$row[0]).";";  # №
          print trim($fio).";";  # ФИО
          print trim(@$row[9]).";";  # Приоритет
          print trim(decode('cp1251',@$row[10])).";"; # Оригинал
          print trim($b);	   # Балл
          print "\n";
       }
     }
    }
} # spec

#$url = 'http://abit.mstu.edu.ru/results/2015/?napr=%C5%C3%DD&spec=22&form=1';

#$fname = $dname.'/mstu-list.html';
#getstore($url, $fname);

my @spec = ('22','1314','5','7','5239','23','827','20','109','10109','12','16','36','2420','25110','25111','34','27','31119','37','51','29','1918',
  '19112','26114','26113','28','14','4','17117','17116','64','11','35','33','32','21','18','8');

  foreach ( @spec ) {
      spec($_);
  }
