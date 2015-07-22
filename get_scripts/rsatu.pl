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

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;
my ($url,$fname,$b,$te,$s);

  $url = 'http://www.rsatu.ru/sites/priem/index.php?option=com_remository&Itemid=53&func=download&id=230&chk=c9ff522cbf62be3366e978aefc772870&no_html=1';

  my $vuz = 'rsatu';
  my $spec = 'UNKNOWN';

  $fname = $dname.'/rsatu.xls';
  getstore($url, $fname);

  my $parser   = Spreadsheet::ParseExcel->new();
  my $workbook = $parser->parse($fname);

  die $parser->error(), ".\n" if ( !defined $workbook );

  my $cell;
  my ($fio,$b,$orig);
  for my $worksheet ( $workbook->worksheets() ) {

        # Find out the worksheet ranges
        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();

        for my $row ( $row_min .. $row_max ) {
                #  print "Row, Col    = ($row, $col)\n";
                #  print "Value       = ", $cell->value(),       "\n";
                # vuz;spec;�;���;���������;���������;���+��
                  $cell = $worksheet->get_cell( $row, 1 );
                    if ($cell == undef) {next;}
                    $fio = decode('utf8',$cell->value());
                  $cell = $worksheet->get_cell( $row, 2 );
                    if ($cell == undef) {next;}
                    $b = $cell->value();
                    if (length($b) eq 0 ) {$b=0;}
                  $cell = $worksheet->get_cell( $row, 5 );
                    if ($cell == undef) {next;}
                    $orig = decode('utf8',$cell->value());
              if ($fio =~ /\S+ \S+ \S+/ ) {
                  #$cell = $worksheet->get_cell( $row, 2 );
                print $vuz.";";
                print $spec.";";
                print trim(0).";";  # �
                print trim($fio).";";  	# ���
                print trim('0').";";    			# ���������
                print trim($orig).";"; 	# ��������
                print trim($b);		# ����
                print "\n";
              }
      }
  }
