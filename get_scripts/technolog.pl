#!/usr/bin/perl
  use URI;
  use Data::Dumper;
  use HTML::TableExtract;
  use LWP::Simple;
  use Encode;
  #use WWW::Mechanize;
  use Spreadsheet::ParseExcel;
  #use switch;
  use v5.14;
  use utf8;
  binmode(STDOUT,':utf8');
  use warnings;

warn "run *** $0 ***";

# insert into univer_tbl values ('technolog','СПбГТИ (ТУ)','Санкт-Петербургский государственный технологический институт (технический университет)','http://technolog.edu.ru/ru/abiturientu/item/1060.html');

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;

my $vuz = 'technolog';
my ($url,$fname,$b,$te,$s,$spec);

sub spec {
	my $url = shift;
	my $spec = shift;
  #print $url.' '.$spec."\n";
  #return;
	my $vuz = 'technolog';
  #print "$vuz\n";
	my $fname = $dname.'/'.$vuz.'-'.$spec.'.xls';

	getstore($url, $fname);

	my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->parse($fname);

	die $parser->error(), ".\n" if ( !defined $workbook );

	for my $worksheet ( $workbook->worksheets() ) {

        # Find out the worksheet ranges
        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();

        for my $row ( $row_min .. $row_max ) {
                #  print "Row, Col    = ($row, $col)\n";
                #  print "Value       = ", $cell->value(),       "\n";
				print $vuz.";";
				print $spec.";";
				print trim($row).";";  # №
			my $cell = $worksheet->get_cell( $row, 1 );
				print trim($cell->value()).";";  	# ФИО
				print trim('0').";";    			# Приоритет
			my $cell = $worksheet->get_cell( $row, 7 );
				print trim($cell->value()).";"; 	# Оригинал
			my $cell = $worksheet->get_cell( $row, 2 );
				print trim($cell->value()).";";		# Балл
				print "\n";

         }
	}
}

$url = 'http://technolog.edu.ru/ru/abiturientu/item/1060.html';

$fname = $dname.'/'.$vuz.'-list.html';
getstore($url, $fname);
my $te = HTML::TableExtract->new( depth => 0, count => 0, keep_html => 1);
$te->parse_file($fname);
#print Dumper $te;
#die;
foreach my $table ( $te->tables ) {
   foreach my $row ($table->rows) {
     $spec = trim(@$row[0]);
     $spec =~ s/\<p\>//g;
     $spec =~ s/\<\/p\>//g;
     $s = trim(@$row[4]);
     #	<a href="/files/70/Spiski_2015/OCH_BUD/09_03_01_Informatika_i_vychislitelnaya_tehnika.xls">скачать</a></p>
     if ($s =~ /.*href=\"(.*)\"\>.*/) {  spec ('http://technolog.edu.ru/'.$1,trim($spec));    }
   }
  }

#  09.03.01 Информатика и вычислительная техника
#technolog('http://technolog.edu.ru/files/70/Spiski_2015/OCH_BUD/09_03_01_Informatika_i_vychislitelnaya_tehnika.xls','09.03.01');
# 09.03.03 Прикладная информатика
#technolog('http://technolog.edu.ru/files/70/Spiski_2015/OCH_BUD/09_03_03_Prikladnaya_informatika.xls','09.03.03');
# 27.03.03 Системный анализ и управление
#technolog('http://technolog.edu.ru/files/70/Spiski_2015/OCH_BUD/27_03_03_Sistemnyy_analiz_i_upravlenie.xls','27.03.03');
