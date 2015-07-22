#!/usr/bin/perl
use DBI;
use POSIX qw(strftime);
use Data::Dumper;
use utf8;
use Encode;
use v5.14;

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

my $vuz=$ARGV[0];
my $fname=$ARGV[1];

if ( (length($vuz) eq 0) or (length($fname) eq 0) ) {
  print "error: need vuz and filemane\n";
  die;
}

my ($sth,$result,$dbh,$result);
# univer | spec | number | fio | prioritet | original | ball
my ($univer,$spec,$number,$fio,$prioritet,$original,$ball);

require "pass.pl";

$dbh = pg_init();
$dbh->{AutoCommit} = 0;

if ($DBI::err != 0) {
  print $DBI::errstr . "\n";
  exit($DBI::err);
}

open(FILE,$fname);
$dbh->do ("delete from data where univer='$vuz'");
$dbh->commit();
$sth = $dbh->prepare("INSERT INTO data values (?,?,?,?,?,?,?)");
my $i = 0;
while(my $s = <FILE>) {
  if ( $s !=~ /Фамилия / or $s !=~ /ФИО/ or $s !=~ /\,/){
    ($univer,$spec,$number,$fio,$prioritet,$original,$ball) = ('','','','','','','');
    ($univer,$spec,$number,$fio,$prioritet,$original,$ball) = split /;/,$s;
	$fio = decode('utf8',$fio);
    if ( length( $fio ) > 0 ) {
      $dbh->pg_savepoint('sv'.$i);
      $sth->bind_param(1, trim($univer));
      $sth->bind_param(2, trim($spec));
      $sth->bind_param(3, trim($number));
      $sth->bind_param(4, trim($fio));
      if (length(trim($prioritet)>0)) {  $sth->bind_param(5, trim($prioritet));} else {$sth->bind_param(5,0);}
      $sth->bind_param(6, trim($original));
      if ( ($ball =~ /^\s+$/) or (length("$ball") == 0) ) {$ball = 0};
      $sth->bind_param(7, $ball);
      $sth->execute;
      #$dbh->commit();
      #if ( $fio =~ /Кобылин/ ) { print $univer,$spec,$number,$fio,$prioritet,$original,$ball,"\n"; }
      if ($DBI::err != 0) {
        print $DBI::errstr . "\n";
        print $univer,$spec,$number,$fio,$prioritet,$original,$ball,"\n";
        $dbh->pg_rollback_to('sv'.$i);
        #exit($DBI::err);
      }
      $i++;
    }
    #print "result=".$result."\n";
  }
}
$dbh->commit();
close (FILE);

# hse баллы за 4 предмета
$dbh->do("update data set ball = 0 where univer = 'hse' and spec in
          ('38.03.01','41.03.03','45.03.02','38.03.04','38.03.02','41.03.05','40.03.01','41.03.04','42.03.01','37.03.01','39.03.01','47.03.01','51.03.01','46.03.01','42.03.02')");
$dbh->commit();

$dbh->disconnect();
