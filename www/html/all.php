<?php
include_once "../php/connect.php";

echo "<h3><a href='list.php'>Выбор</a></h3>";

$sql = "select distinct fio,
 (select max(ball) from data d2 where d1.fio = d2.fio) calc_ball,
 (select commajoin (' '||d3.univer||' '||d3.spec||' '||d3.original) from data d3 where d1.fio = d3.fio)  calc_original
from data d1
order by calc_ball desc,calc_original";

#$statement = pg_prepare($dbconn3,'myquery', $sql);

$result = pg_query($dbconn3,$sql);
if (!$result) {
  echo "Произошла ошибка.\n";
  exit;
}

 #echo "$univer $spec";
echo "<table border=1 width=90%>";
 echo "<tr><th>Номер</th><th>ФИО</th><th>Балл</th><th>Заявления</th></tr>";
 $i = 1;
 while ($row = pg_fetch_row($result)) {
  echo "<tr>";
   echo "<td>".$i."</td>";
   echo "<td>".$row[0]."</td>";
   echo "<td>".$row[1]."</td>";
   echo "<td>".$row[2]."</td>";
  echo "</tr>";
  $i++;
 }
 echo "</table>";

#echo "<p>";
#include "js/ya.js";
#echo "</p>";

?>
