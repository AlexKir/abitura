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

my $vuz = 'spbstu';
my ($url,$b);

sub spec {
	my $url = shift;
	my $spec = shift;

  #print "$vuz\n";
	my $fname = $dname.'/'.$vuz.'-'.$spec.'.html';

	getstore($url, $fname);

	my $te = HTML::TableExtract->new( depth => 0, count => 0 );
	$te->parse_file($fname);

	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        print $vuz.";";
        print $spec.";";
        print trim(@$row[0]).";"; # №
        print trim(@$row[1]).";"; # ФИО
        print trim(@$row[2]).";"; # Приоритет
        print trim(@$row[3]).';';	  # Оригинал
        print trim("0");	  # Балл
        print "\n";
     }
    }
}


# 02.03.02 Фундаментальная информатика и информационные технологии
spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=910&contest_group=kg-301&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','02.03.02');
# 02.03.03 Математическое обеспечение и администрирование информационных систем
spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=910&contest_group=kg-306&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','02.03.03');
# 09.03.01 Информатика и вычислительная техника
spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=910&contest_group=kg-330&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','09.03.01');
# 09.03.04 Программная инженерия
spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=910&contest_group=kg-348&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','09.03.04');
# 01.03.02 Прикладная математика и информатика
spec ('http://www.spbstu.ru/applicants/welcome-to-the-university/the-course-of-the-reception/abiturients/main/?PROGRAM=765&EDUC_FORM=749&EDUC_TYPE=751&BASE_EDUC=752&INSTITUTE=783&contest_group=kg-286&arrFilter_pf[CATEGORY]=890&arrFilter_pf[DOCUMENTS_FORM]=&set_filter=&set_filter=Y','01.03.02');
