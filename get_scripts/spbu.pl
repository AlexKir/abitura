#!/usr/bin/perl
  use URI;
  use Data::Dumper;
  use HTML::TableExtract;
  use LWP::Simple;
  use Encode;
  use WWW::Mechanize;
  use Spreadsheet::ParseExcel;
  #use switch;
  use v5.14;
#  use utf8;
use warnings;

warn "run *** $0 ***";

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;

my $vuz = 'spbu';
my ($url,$b);
my %fio_list = ();

sub spec {
	my $url = shift;
	my $spec = shift;

  #print "$vuz\n";
	my $fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	my $te = HTML::TableExtract->new( depth => 0, count => 0);
	$te->parse_file($fname);

	#print Dumper $te;
	#return;

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        print $vuz.";";
        print $spec.";";
        print trim(@$row[0]).";";  # №
        print trim(@$row[2]).";";  # ФИО
        print trim(@$row[5]).";";  # Приоритет
        print $fio_list{ trim(@$row[2]) }.";"; 	# Оригинал
        $b = trim(@$row[6]);
        $b =~ s/,0//;
        if ( $b le 1 ) {$b=0;}
        print $b;	   	# Балл
        print "\n";
     }
    }
}


$url = 'https://cabinet.spbu.ru/Lists/1k_EntryLists/';

my $fname = $dname.'/'.$vuz.'-list.html';
getstore($url, $fname);

# Кто подал оригиналы?
my $te = HTML::TableExtract->new( depth => 0, count => 0);
$te->parse_file($fname);
#print Dumper $te;
foreach my $table ( $te->tables ) {
  foreach my $row ($table->rows) {
    $fio_list{ trim(@$row[2]) } = trim(@$row[5]);
  }
}

#print Dumper %fio_list;
#die;

# 02.03.02 Фундаментальная информатика и информационные технологии
#spbu('https://cabinet.spbu.ru/Lists/1k_EntryLists/list1_1_1_10_835_.html','02.03.02');
# 02.03.03 Математическое обеспечение и администрирование информационных систем
#spbu('https://cabinet.spbu.ru/Lists/1k_EntryLists/list1_1_1_13_836_.html','02.03.03');
# 09.03.03 Прикладная информатика
#spbu('https://cabinet.spbu.ru/Lists/1k_EntryLists/list1_1_1_86_871_.html','09.03.03');
# 09.03.04 Программная инженерия
#spbu('https://cabinet.spbu.ru/Lists/1k_EntryLists/list1_1_1_88_873_.html','09.03.04');
# 38.03.05 Бизнес-информатика
#spbu('https://cabinet.spbu.ru/Lists/1k_EntryLists/list1_1_1_80_940_.html','38.03.05');

#    01.03.02 - https://cabinet.spbu.ru/Lists/1k_EntryLists/list_cba1ee3e-cf3f-4011-bc88-f5b7144472bf.html#a00946e4-81f2-4c57-8338-a18b27da88aa
#    02.03.02 - https://cabinet.spbu.ru/Lists/1k_EntryLists/list_003e7c64-268f-4764-85aa-8b0c7ae2b3a8.html#9f3e00dc-ee24-44d4-84cd-baddc9f7cba7
#    02.03.03 - https://cabinet.spbu.ru/Lists/1k_EntryLists/list_13956a8c-736c-49c4-9fa6-f6fa2ae79461.html#e36fe36a-8f96-4f47-aa3e-650413b94b02
#    09.03.04 - https://cabinet.spbu.ru/Lists/1k_EntryLists/list_c50f709a-385f-4804-86b8-d128b363b83f.html#6cd40435-18e7-4823-9f8b-6fdabfcd6f83
#    38.03.05 - https://cabinet.spbu.ru/Lists/1k_EntryLists/list_05962e79-530e-4185-bda0-b62312ecd042.html#608b8166-bad7-4c2a-8d4c-a1b195fe048e
#    38.03.04 - https://cabinet.spbu.ru/Lists/1k_EntryLists/list_ef6dc390-ffa1-4309-8325-c35de766d845.html#7ef656f5-41cf-42b6-86f8-8485511fd368

spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_cba1ee3e-cf3f-4011-bc88-f5b7144472bf.html','01.03.02');
spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_003e7c64-268f-4764-85aa-8b0c7ae2b3a8.html','02.03.02');
spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_13956a8c-736c-49c4-9fa6-f6fa2ae79461.html','02.03.03');
spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_c50f709a-385f-4804-86b8-d128b363b83f.html','09.03.04');
spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_05962e79-530e-4185-bda0-b62312ecd042.html','38.03.05');
spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_ef6dc390-ffa1-4309-8325-c35de766d845.html','38.03.04');
spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_414d568f-5f4a-4622-b93c-c45dbaa8a22a.html','01.05.01');
spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_2155a7b9-6511-4c90-9168-a09661287dde.html','01.05.01');
spec ('https://cabinet.spbu.ru/Lists/1k_EntryLists/list_ca5a1000-d425-4f2f-808c-fa2d4e2caf51.html','03.03.01');
