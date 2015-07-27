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
  use utf8;
  binmode(STDOUT,':utf8');
  use warnings;

warn "run *** $0 ***";

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;

my $vuz = 'spbstu';
my ($url,$b,$fname,$pri,$fio);

sub spec {
	my $url = shift;
	my $spec = shift;

  #print "$vuz\n";
	my $fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);
  #print $url."\n";
	#my $te = HTML::TableExtract->new( attribs => { class=>"contentTableContainer" } );
  my $te = HTML::TableExtract->new( depth => 1, count => 0 );
	$te->parse_file($fname);
  #print Dumper $te;
  #die;
	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        $fio = trim(decode('cp1251',@$row[1]));
        if ( defined $fio and $fio !~ /Фамилия/ ) {
          print $vuz.";";
          print $spec.";";
          print trim(@$row[0]).";"; # №
          print $fio.";"; # ФИО
          if (defined @$row[2] ) {
              $pri = trim(@$row[2]);
              $pri = length($pri);
            } else { $pri = 0;}
          print $pri.";"; # Приоритет
          print trim(decode('cp1251',@$row[8])).';';	  # Оригинал
          print trim(@$row[3]);	  # Балл
          print "\n";
       }
     }
    }
}


# 02.03.02 Фундаментальная информатика и информационные технологии
#spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=910&contest_group=kg-301&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','02.03.02');
# 02.03.03 Математическое обеспечение и администрирование информационных систем
#spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=910&contest_group=kg-306&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','02.03.03');
# 09.03.01 Информатика и вычислительная техника
#spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=910&contest_group=kg-330&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','09.03.01');
# 09.03.04 Программная инженерия
#spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=910&contest_group=kg-348&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','09.03.04');
# 01.03.02 Прикладная математика и информатика
#spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=783&contest_group=kg-286&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','01.03.02');

$url = 'http://old.spbstu.ru/education/entrance/abitur15.asp?v=b&z=o&g=*&l=o&c=b&p=b&e=o&s=0&dt=0&dr=0&xc=1';
$fname = $dname.'/'.$vuz.'-list.html';

getstore($url, $fname);

open(FILE,$fname);
while(my $s	= <FILE>) {
  #<option value="1">ГИ, 40.03.01 Юриспруденция</option>
  #<option value="35">ИКНТ, 10.03.01 Информационная безопасность</option>
  if ( defined $s and $s =~ /<option value=\"(\d+)\">\S+, (\S\S.\d\d.\d\d) .*<\/option>/ ) {
      #print $1." ".$2."\n";
      $url = 'http://old.spbstu.ru/education/entrance/abitur15.asp?v=b&z=o&g='.$1.'&l=o&c=b&p=b&e=o&s=0&dt=0&dr=0&xc=1';
      spec ($url,$2);
      }
} # while
close (FILE);
