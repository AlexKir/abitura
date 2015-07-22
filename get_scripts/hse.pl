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

  my $d = strftime "%d_%m", localtime;

  my $vuz = 'hse';
  my ($url,$fname,$b,$te,$s,$spec);
  my $spec = '';

sub hse_spec {
        my $url = shift;
        #print $url."\n";
        my $spec = 'UNKNOWN';
        my $cell;
        my $fname = $dname.'/hse_spec.xls';
        getstore($url, $fname);

        my $parser   = Spreadsheet::ParseExcel->new();
        my $workbook = $parser->parse($fname);

      	die $parser->error(), ".\n" if ( !defined $workbook );

      	for my $worksheet ( $workbook->worksheets() ) {

              # Find out the worksheet ranges
              my ( $row_min, $row_max ) = $worksheet->row_range();
              my ( $col_min, $col_max ) = $worksheet->col_range();

              $cell = $worksheet->get_cell( 0, 0 );
              $spec = $cell->value();
              if ( $spec =~ /.*(\S)(\d)\.(\d+)\.(\d+).*/ ) { $spec = $1.$2.".".$3.".".$4; }
              else {$spec = 'UNKNOWN';}
              #print "spec=".$spec."\n";
              for my $row ( 6 .. $row_max ) {
                      #  print "Row, Col    = ($row, $col)\n";
                      #  print "Value       = ", $cell->value(),       "\n";
                      # vuz;spec;№;ФИО;Приоритет;Подлинник;ЕГЭ+ИД
                      print $vuz.";";
      				        print $spec.";";
                        $cell = $worksheet->get_cell( $row, 0 );
                      print trim($cell->value()).";";  # №
                        $cell = $worksheet->get_cell( $row, 2 );
                      print trim($cell->value()).";";  	# ФИО
                      print trim('0').";";    			# Приоритет
                        $cell = $worksheet->get_cell( $row, 3 );
                      print trim($cell->value()).";"; 	# Оригинал
                        $cell = $worksheet->get_cell( $row, 13 );
                      $b =  trim($cell->value());
                      if ( length($b) eq 0 ) { $b = 0;}
                      print $b;		# Балл
                      print "\n";
      	    }
        }
} #hse_spec


    $url = 'http://ba.hse.ru/base2015/';

    #print "$vuz\n";

    $fname = $dname.'/hse_list.htm';
    getstore($url, $fname);

    # <td class="xl65" style="height: 15.75pt; width: 395pt; text-align: center;" width="526" height="21"><a id="227::152906462"
    # href="http://www.hse.ru/data/2015/07/08/1082861580/Мат 08.07.2015.xls" class="mceXwFile"><img class="xwfileicon"
    # src="/images/share/portal2/fileicons/xls.gif" alt="" width="16" height="16" border="0">&nbsp;.xls</a>&nbsp;</td>
    open(FILE,$fname);
  	while(my $s	= <FILE>) {
  		if ( $s =~ /<td.*href="(.*)" class/ ) {hse_spec($1);}
  	} # while
    close (FILE);
