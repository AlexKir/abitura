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

my ($d,$url,$fname,$b,$te,$s,$cmd,$fio,$key);

my $vuz = 'sut';
my $spec = '';

sub spec {
  my $spec_id = shift;
  $spec = shift;
  #print $spec_id.' '.$spec."\n";
  #return;
	$url = 'http://www.anketa.sut.ru/spisok_fio.php?n=101';
	my $mech = WWW::Mechanize->new();
	$mech->cookie_jar(HTTP::Cookies->new());
	$mech->get($url);
	my $result = $mech->submit_form(
		form_id => 'frm', #name of the form
		#instead of form name you can specify
		#form_number => 1
		fields      =>
				{
					#facCode => decode('utf-8','ИТфак'),
					'napravl' => $spec_id,
					'fo' => '4',
          'type' => '4',
          'general' => '101'
				}
	);
	#print Dumper $result->content();
  $fname = $dname.'/'.$vuz.'-'.$spec.'.html';
  $mech->save_content($fname);

  $te = HTML::TableExtract->new(  depth => 0, count => 0 );
  $te->parse_file($fname);

  #print Dumper $te;
  #return;

  foreach my $table ( $te->tables ) {
     foreach my $row ($table->rows) {
        #print "   ", join(',', $row), "n";
        #print Dumper $row;
        #Фамилия, имя, отчество 	Документ об образовании 	Приоритет 	Сумма баллов 	ВИ с учетом приоритета 	Инд. достижения 	Основание зачисления 	Очередность зачисления*
        #Григорьевский Иван Васильевич	Оригинал	1	248	61	100	87	0	0	0	0	Выделенные места (Крым)	1
        $fio = trim(decode('utf8',@$row[0]));
        if ( defined @$row[3]) { $b = @$row[3]; } else { $b = 0;}
        if ( defined $fio and $fio =~ /\S+ \S+ \S+/ and $fio !~ /Фамилия/ and $fio !~ /образование/) {
          print $vuz.";";
          print $spec.";";
          #print trim(@$row[12]).";";  # №
          print trim(0).";";  # №
          print trim($fio).";";  # ФИО
          print trim(@$row[2]).";";  # Приоритет
          print trim(decode('utf8',@$row[1])).";"; # Оригинал
          print trim($b);	   # Балл
          print "\n";
       }
     }
    }

} # spec

my %spec_list = (
  '2892' => '09.03.01', '2893' => '09.03.02', '2895' => '09.03.04', '2897' => '09.04.02', '2904' => '10.03.01',
  '2905' => '10.04.01', '2926' => '11.03.01', '3679' => '11.03.02', '2927' => '11.03.02', '2928' => '11.03.03',
  '2929' => '11.03.04', '2930' => '11.04.01', '2931' => '11.04.02', '2932' => '11.04.03', '3680' => '11.05.04',
  '2947' => '12.03.03', '2948' => '12.03.04', '2997' => '15.03.04', '3003' => '15.04.04', '3195' => '27.03.01',
  '3198' => '27.03.04', '3420' => '38.03.02', '3423' => '38.03.05', '3430' => '38.04.05', '3457' => '41.03.01',
  '3463' => '41.04.01', '3471' => '42.03.01', '3476' => '42.04.01', '3493' => '43.03.01'
);

foreach $key(keys %spec_list){
  spec($key,$spec_list{$key});
}
