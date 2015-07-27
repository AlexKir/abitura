#!/usr/bin/perl
use DBI;
use POSIX qw(strftime);
use Data::Dumper;
use utf8;
use Encode;
use v5.14;
use HTML::TableExtract;
use LWP::Simple;

require "pass.pl";

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

my ($sth,$result,$result,@array,$sth2);
# univer | spec | number | fio | prioritet | original | ball
my ($univer,$spec,$number,$fio,$prioritet,$original,$ball,$i,$seats);

my $dbh = pg_init();
$dbh->{AutoCommit} = 0;

if ($DBI::err != 0) {
  print $DBI::errstr . "\n";
  exit($DBI::err);
}

use POSIX qw(strftime);

my $dname = strftime "%m-%d", localtime;
$dname = 'in/'.$dname;
mkdir $dname;

my $d = strftime "%d_%m", localtime;
my $vuz = 'ifmo';
my ($seats,$pass_score,$fname,$te,$s);

$dbh->do ("delete from limit_tbl where univer='ifmo'");

$sth = $dbh->prepare("INSERT INTO limit_tbl values (?,?,?,?)");

my $url = 'http://ums.abit.ifmo.ru/abitUMS/statsAll.htm';
$fname = $dname.'/ifmo_list.htm';
getstore($url, $fname);

$te = HTML::TableExtract->new( depth => 0, count => 0, keep_html => 1);
$te->parse_file($fname);
#print Dumper $te;

foreach my $table ( $te->tables ) {
   foreach my $row ($table->rows) {
     $s = trim(@$row[0]);
     #<a href="statByUsers.htm?fid=1&edform=1&facid=2&spid=1">
     if ($s =~ /.*href="(.*)">/) {
        $url = $1;
        if ( $s =~ /.*\s+(\S+)\.(\d+)\.(\d+).*/ ) {$spec = $1.'.'.$2.'.'.$3;} else {$spec = 'UNKNOWN';}
        $spec = $spec.'-'.trim(decode('utf8',@$row[1]));
        if (defined @$row[2] and @$row[2] =~ /\d/ ) { $seats = trim(@$row[2]); } else {$seats=0}
        if (defined @$row[3] and @$row[3] =~ /\d/ ) { $pass_score = trim(@$row[3]);} else {$pass_score = 999;}
        $sth->bind_param(1, trim($vuz));
        $sth->bind_param(2, trim($spec));
        $sth->bind_param(3, trim($seats));
        $sth->bind_param(4, trim($pass_score));
        #print $vuz."-".$spec." ".$seats.' '.$pass_score."\n";
        $sth->execute;
        if ($DBI::err != 0) {
          print $DBI::errstr . "\n";
          exit($DBI::err);
        }

      }
   }
  }

$dbh->commit();

my $sql = 'update limit_tbl l set pass_score =
(select min(ball) b from ( SELECT d.fio, d.ball, row_number() OVER (PARTITION BY d.spec ORDER BY d.ball DESC) r
 FROM data d where d.univer = l.univer and d.spec = l.spec) t where r < l.seats)';

$sth = $dbh->prepare($sql);
$result = $sth->execute();
if (!defined $result) {
  print "При выполнении запроса '$sql' возникла ошибка: " . $dbh->errstr . "\n";
  exit(0);
}

$dbh->commit();

$sql = "update data set original1 = 1 where lower(original) like '%да%'  or lower(original) like '%Да%' or lower(original) like '%ригинал%' or lower(original) like '%одлинник%' or lower(original) like '%+%'";

$sth = $dbh->prepare($sql);
$result = $sth->execute();
if (!defined $result) {
  print "При выполнении запроса '$sql' возникла ошибка: " . $dbh->errstr . "\n";
  exit(0);
}

$dbh->commit();


$dbh->disconnect();
