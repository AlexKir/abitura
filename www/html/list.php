<?php
include_once "../php/connect.php";

echo "<a href='all.php'>Полный список абитуриенотов</a>&nbsp;&nbsp<a href='mylist.php'>Мой список</a></br>";
echo "<a href='/abitura/'>csv файлы </a></br>";

#$sql = "select trim(univer),trim(u.univer_long_name) from univer_tbl u order by 2";
$sql = "select distinct trim(d.univer),trim(u.univer_long_name) from data d left outer join univer_tbl u on d.univer = u.univer order by 1,2";
$result = pg_query($dbconn3,$sql);
if (!$result) {
  echo "Произошла ошибка.\n";
  exit;
}
while ($row = pg_fetch_row($result)) {
  echo "<h2>$row[0] - $row[1]</h2>";
  $univer = $row[0];
#  $sql = "select distinct trim(d1.spec),(select trim(spec_name) from spec_tbl s where d1.spec = s.spec) spec
#          from data d1 join univer_tbl u on d1.univer = u.univer
#          where d1.univer = '$univer'
#          order by 1,2;";

        $sql =  "select distinct trim(d1.spec), trim(s.spec_name) spec
                  from data d1 left outer join univer_tbl u on d1.univer = u.univer left outer join spec_tbl s on d1.spec = s.spec
                  where d1.univer = '$univer'
                  order by 1,2";

          $result2 = pg_query($dbconn3,$sql);
          if (!$result2) {
            echo "Произошла ошибка.\n";
            exit;
          }
          while ($row2 = pg_fetch_row($result2)) {
            echo "<a href='spec.php?univer=$univer&spec=$row2[0]'>$row2[0] - $row2[1]</a></br>";
          }
}

#echo "<p>";
#include "js/ya.js";
#echo "</p>";
 ?>
