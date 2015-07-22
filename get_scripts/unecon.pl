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

my $vuz = 'unecon';
my $spec = '';

sub spec {
	my $spec = shift;
  my $url = 'http://priem.unecon.ru/stat/stat_konkurs.php?zel=0&filial_kod=1&zayav_type_kod=1&grp_spec_kod='.$spec.'&ob_forma_kod=1&ob_osnova_kod=2&prior=all&is_orig_doc=all&obr_konkurs_kod=1&status_kod=all&show=%D0%9F%D0%BE%D0%BA%D0%B0%D0%B7%D0%B0%D1%82%D1%8C';
	$fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	$te = HTML::TableExtract->new(  depth => 0, count => 1 );
	$te->parse_file($fname);

  $spec = 'UNKNOWN';

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        # 1	Мамедова Виктория Валерьевна	9617	3	273	92	92	85	4		Копия
        $fio = trim(decode('utf8',@$row[1]));
        if ( defined $fio and $fio =~ /\S+ \S+ \S+/ ) {
          print $vuz.";";
          print $spec.";";
          print trim(@$row[0]).";";  # №
          print trim($fio).";";  # ФИО
          print trim(@$row[3]).";";  # Приоритет
          print trim(decode('utf8',@$row[10])).";"; # Оригинал
          print trim(@$row[4]);	   # Балл
          print "\n";
       }
     }
    }
} # spec


$url = 'http://priem.unecon.ru/stat/stat_konkurs.php?zel=0&filial_kod=1&zayav_type_kod=1&grp_spec_kod=12014&ob_forma_kod=1&ob_osnova_kod=2&prior=all&is_orig_doc=all&obr_konkurs_kod=1&status_kod=all&show=%D0%9F%D0%BE%D0%BA%D0%B0%D0%B7%D0%B0%D1%82%D1%8C';

#$fname = $dname.'/unecon-list.html';
#getstore($url, $fname);

my @spec = ('12019','12015','12006','12016','12020','12009','12012','12002','12004','12039','12008','12017','12021','12074','12068','12018','12003','12005','12011','12010','12001','12055','12007');

foreach ( @spec ) {
    spec($_);
}
