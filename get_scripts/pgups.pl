#!/usr/bin/perl
  use URI;
  use Data::Dumper;
  use HTML::TableExtract;
  use LWP::Simple;
  use Encode;
  use WWW::Mechanize;
  #use Spreadsheet::ParseExcel;
  #use switch;
  use v5.14;
  use utf8;
  binmode(STDOUT,':utf8');
  use warnings;

warn "run *** $0 ***";

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

# insert into univer_tbl values ('sut','СПбГУТ','Санкт-Петербургский государственный университет телекоммуникаций им. проф. М.А.Бонч-Бруевича','http://www.anketa.sut.ru/spisok_fio.php?n=101');

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my ($d,$url,$fname,$b,$te,$s,$cmd,$fio,$key,$result);

my $vuz = 'pgups';
my $spec = 'UNKNOWN';

sub spec {
	my $fname = shift;
  my $spec = shift;

	$te = HTML::TableExtract->new( attribs => { class=>"plan_gridtable" } );
	$te->parse_file($fname);
  #print Dumper $te;
  #die;
	foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
# \'1',
# \'Авелан Егор Юрьевич',
# \'Общий конкурс',
# \'214',
# \'2',
# \'копия'
        $fio = decode('utf8',@$row[1]);
        if ( defined $fio and $fio =~ /\S+ \S+ \S+/ and $fio !~ /.*Фамилия.*/ ) {
          print $vuz.";";
          print $spec.";";
          print trim(@$row[0]).";";  # №
          print trim($fio).";";  # ФИО
          print trim(@$row[4]).";";  # Приоритет
          print trim(decode('utf8',@$row[5])).";"; # Оригинал
          print trim(@$row[3]);	   # Балл
          print "\n";
       }
     }
    }
} # spec

$url = 'http://priem.pgups.ru/?page_id=42';

my $mech = WWW::Mechanize->new();
$mech->cookie_jar(HTTP::Cookies->new());
$mech->get($url);
#print Dumper $mech->forms();
$result = $mech->submit_form(
  #form_id => 'frm', #name of the form
  form_number => 1,
  #instead of form name you can specify
  #form_number => 1
  fields      =>
      {
        #facCode => decode('utf-8','ИТфак'),
        'epf' => 'Очная',
        'epk' => 'бакалавриат',
        'konk' => 'Общий конкурс',
        'spec' => 'Информатика и вычислительная техника'
      }
);
#print Dumper $result->content();
$fname = $dname.'/'.$vuz.'-'.$spec.'.html';
$mech->save_content($fname);
spec ($fname,'09.03.01');

# next
$mech->get($url);
#print Dumper $mech->forms();
$result = $mech->submit_form(
  #form_id => 'frm', #name of the form
  form_number => 1,
  #instead of form name you can specify
  #form_number => 1
  fields      =>
      {
        #facCode => decode('utf-8','ИТфак'),
        'epf' => 'Очная',
        'epk' => 'бакалавриат',
        'konk' => 'Общий конкурс',
        'spec' => 'Информационные системы и технологии'
      }
);
$mech->save_content($fname);
spec ($fname,'09.03.02');

# next
$mech->get($url);
#print Dumper $mech->forms();
$result = $mech->submit_form(
  #form_id => 'frm', #name of the form
  form_number => 1,
  #instead of form name you can specify
  #form_number => 1
  fields      =>
      {
        #facCode => decode('utf-8','ИТфак'),
        'epf' => 'Очная',
        'epk' => 'бакалавриат',
        'konk' => 'Общий конкурс',
        'spec' => 'Приборостроение'
      }
);
$mech->save_content($fname);
spec ($fname,'12.03.01');
