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

my ($url,$fname,$b,$te,$s);

  my $d = strftime "%d_%m", localtime;
  my $url = 'http://www.mubint.ru/admitting_commission/new/documents/zachislenie15-16/rangir_ochka.pdf';

  my $vuz = 'mubint';
  #print "$vuz\n";
  my $spec = 'UNKNOWN';
  $fname = $dname.'/'.$vuz.'.pdf';

  getstore($url, $fname);

  #my $cmd = "pdftotext -layout -nopgbrk ".$dname."/voenmeh.pdf ".$dname."/voenmeh.txt";
  my $cmd = "bash pdf2text.sh ".$dname."/".$vuz.".pdf ".$dname."/".$vuz.".txt";
  system($cmd);
  my $incomplete1 = 0;
  my $incomplete2 = 0;
  my $ball = 0;
  my ($fio,$s2,$s);
  open(FILE,$dname."/".$vuz.".txt");
  while(my $s = <FILE>)  {
    #1   �������     271    88     92   86                            5
    # ���������
    # ���������
    #2    ����������      254   74   95   77   3                   5
    # ����� ���������
    $s = trim($s);
	$s = decode('utf8',$s);
    if ( $s !=~ /^\s+$/ ) {
            #print $s."\n";
                 #2      ����������      254   74   95   77   3                   5
    if ( $s =~ /(\d+)\s+(\S+ \S+)(\d\d\d).*$/ ) {
            $incomplete1 = 1;
            $incomplete2 = 0;
            $fio = $2;
            $ball = $3;
            #print $fio."\n";
            #print $ball."\n";
            #print "incomplete ".$fio." ".$spec."\n";
          }
          else
            {
              if ( ($incomplete1 eq 1) and ($incomplete2 eq 0) and ($s =~ /^(\S+)$/) ) {
                $fio = $fio." ".$1;
                print $vuz.";";
      			    print $spec.";";
      			    print trim('0').";";  # �
      			    print trim($fio).";";  # ���
      			    print trim('0').";";    # ���������
      			    print trim('n/a').";"; 	# ��������
      			    print trim($ball);	   	# ����
      			    print "\n";
               $incomplete1 = 0;
               $incomplete2 = 0;
        }
        else {
            if ( $s =~ /(\d+)\s+(\S+)\s+(\d\d\d)\s+(\d+).*$/ ) {
                $incomplete1 = 1;
                $incomplete2 = 1;
                $fio = $2;
                $ball = $3;
            } else
              {
                if ( ($incomplete1 eq 1) and ($incomplete2 eq 1) and ($s =~ /^(\S+)$/) ) {
                  $fio = $fio." ".$1;
                  $incomplete1 = 0;
                }
                else
                  {
                      if ( ($incomplete1 eq 0) and ($incomplete2 eq 1) and ($s =~ /^(\S+)$/) ) {
                          $fio = $fio." ".$1;
                          $incomplete1 = 0;
                          $incomplete2 = 0;
                          print $vuz.";";
                          print $spec.";";
                          print trim('0').";";  # �
                          print trim($fio).";";  # ���
                          print trim('0').";";    # ���������
                          print trim('n/a').";"; 	# ��������
                          print trim($ball);	   	# ����
                          print "\n";
                        }
                  } # else
                } # else
              } # else
            } #else
          } # if
  	} # while
  close(FILE);
