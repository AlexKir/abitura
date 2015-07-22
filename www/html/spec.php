<html>
<head></head>
<body>
<?php
include_once "../php/connect.php";
?>

<?php
// Показывать всю информацию, по умолчанию INFO_ALL
#phpinfo();
// Показывать информацию только о загруженных модулях.
// phpinfo(8) выдает тот же результат.
#phpinfo(INFO_MODULES);
?>

<?php
 if (isset($_GET['univer'],$_GET['spec']) ) {
    $univer = $_GET['univer'];
    $spec = $_GET['spec'];
    if(isset($_GET['original_o'])) {$original_o=1;} else {$original_o=0;}; # Оригинал в другом
    if(isset($_GET['original_h'])) {$original_h=1;} else {$original_h=0;}; # Оригинал здесь
    if(isset($_GET['prioritet1'])) {$prioritet1=1;} else {$prioritet1=0;}; # Только 1 приоритет
    if(isset($_GET['ifmo_spbu'])) {$ifmo_spbu=1;} else {$ifmo_spbu=0;}; # Только 1 приоритет

echo "<h3><a href='list.php'>Список вузов</a> <a href='mylist.php'>Мой список</a> </h3>";

$sql = "select trim(u.univer_long_name),trim(link) from univer_tbl u where univer = $1";
$statement = pg_prepare($dbconn3,'myquery1', $sql);
$result = pg_execute($dbconn3,'myquery1',array("$univer"));
if (!$result) {
  echo "Произошла ошибка.\n";
  exit;
}
while ($row = pg_fetch_row($result)) {
  echo "<b>Университет: </b><a href=$row[1]>$row[0]</a><br>";
}

$sql = "select trim(spec),trim(spec_name) from spec_tbl s where spec = $1";
$statement = pg_prepare($dbconn3,'myquery2', $sql);
$result = pg_execute($dbconn3,'myquery2',array("$spec"));
if (!$result) {
  echo "Произошла ошибка.\n";
  exit;
}
while ($row = pg_fetch_row($result)) {
  echo "<b>Специальность: </b>$row[0] - $row[1]<br>";
}
?>
<form action=/spec.php>
<?php
  echo '<input type="hidden" name="univer" value="'.$univer.'">';
  echo '<input type="hidden" name="spec" value="'.$spec.'">';
  if ( $original_o == 1 ) {echo '<input type="checkbox" name="original_o" checked>Попытаться убрать абитуриентов у кого оригиналы в других вузах.</input><br>';}
  else {echo '<input type="checkbox" name="original_o">Попытаться убрать абитуриентов у кого оригиналы в других вузах.</input><br>';}
  if ( $original_h == 1 ) {echo '<input type="checkbox" name="original_h" checked>Оставить только с оригиналами</input><br>';}
  else {echo '<input type="checkbox" name="original_h">Оставить только с оригиналами</input><br>';}
  if ( $prioritet1 == 1 ) {echo '<input type="checkbox" name="prioritet1" checked>Попытаться убрать абитуриентов не с 1 приоритетом</input><br>'; }
  else {echo '<input type="checkbox" name="prioritet1">Попытаться убрать абитуриентов не с 1 приоритетом</input><br>';}
  if ( $ifmo_spbu == 1 ) {echo '<input type="checkbox" name="ifmo_spbu" checked>Попытаться убрать абитуриентов кто проходит в ИТМО</input><br>'; }
  else {echo '<input type="checkbox" name="ifmo_spbu">Попытаться убрать абитуриентов кто проходит в ИТМО</input><br>';}
?>
  <input type="submit" value="Обновить">
</form>

<?php
$sql = "select seats from limit_tbl where univer = $1 and spec = $2";
$statement = pg_prepare($dbconn3,'myquery3', $sql);
$result = pg_execute($dbconn3,'myquery3',array("$univer","$spec"));
while ($row = pg_fetch_row($result)) {
  echo "<b>Количество мест: </b>$row[0]<br>";
}


$sql = "select distinct number,fio,prioritet,original,ball,
 CASE when  d1.ball > 0
  then 0
  else (select max(ball) from data d2 where d1.fio = d2.fio and ball < 320)
 end calc_ball,
 (select commajoin (' '||d3.univer||' '||d3.spec||' '||d3.original) from data d3 where
   d1.fio = d3.fio
   and d1.univer <> d3.univer
 )  calc_original
from data d1
where
 univer = $1 and spec = $2 ";

if ( $prioritet1 == 1 ) {  $sql = $sql."  and prioritet < 2 "; }

if ( $original_h == 1 ) {
    $sql = $sql."  and (original is null
    or lower(original) like '%да%'
    or lower(original) like '%Да%'
    or lower(original) like '%ригинал%'
    or lower(original) like '%одлинник%'
    or lower(original) like '%+%')  ";
}

if ( $original_o == 1 ) {
# Исключить тех у кого оригиналы в других вузах
# тех у кого оригиналы здесь всё равно оставить
  $sql = "select * from ( ".$sql." )
  t where
  ( original is null
    or lower(original) like '%да%'
    or lower(original) like '%Да%'
    or lower(original) like '%ригинал%'
    or lower(original) like '%одлинник%'
    or lower(original) like '%+%' )
  or
  ( calc_original is null or   (
   lower(calc_original) not like '%да%'
   and lower(calc_original) not like '%Да%'
   and lower(calc_original) not like '%ригинал%'
   and lower(calc_original) not like '%одлинник%'
   and lower(calc_original) not like '%+%'
   )
  )
  ";
}

if ( $ifmo_spbu == 1 ) {
  $sql = "select * from ( ".$sql." ) t
  where fio not in
  ( select fio from data d
    where
    d.univer in ('ifmo','spbu')
    and d.prioritet = 1
    and d.ball > (select max(pass_score) from limit_tbl l where l.univer = d.univer and l.spec = d.spec)
  ) " ;
}

$sql = $sql." order by ball desc,calc_ball desc,calc_original";

#echo $sql;

$statement = pg_prepare($dbconn3,'myquery', $sql);

$result = pg_execute($dbconn3,'myquery',array("$univer","$spec"));
if (!$result) {
  echo "Произошла ошибка.\n";
  exit;
}

 #echo "$univer $spec";

echo "<table border=1 width=90%>";
 echo "<tr><th>Номер</th><th>ФИО</th><th>Приоритет</th><th>Оригинал</th><th>Балл</th><th>Балл(2)</th><th>Другие заявления</th></tr>";
 $i = 1;
 while ($row = pg_fetch_row($result)) {
  echo "<tr>";
   echo "<td>".$i."</td>";
   echo "<td>".$row[1]."</td>";
   echo "<td>".$row[2]."</td>";
   echo "<td>".$row[3]."</td>";
   echo "<td>".$row[4]."</td>";
   echo "<td>".$row[5]."</td>";
   echo "<td>".$row[6]."</td>";
  echo "</tr>";
  $i++;
 }
 echo "</table>";
}
else {
  header("Location: list.php");
};
#echo "<p>";
#include "js/ya.js";
#echo "</p>";
?>
</body>
</html>
