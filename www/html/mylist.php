<?php
include_once "../php/connect.php";

echo "<a href='all.php'>Полный список абитуриентов</a>&nbsp;&nbsp;<a href='list.php'>Полный список вузов</a></br>";

$sql = "select trim(univer),trim(u.univer_long_name) from univer_tbl u where u.univer in ('guap','eltech','spbstu','uniyar','sut') order by 2";
$result = pg_query($dbconn3,$sql);
if (!$result) {
  echo "Произошла ошибка.\n";
  exit;
}
while ($row = pg_fetch_row($result)) {
  echo "<h2>$row[1]</h2>";
  $univer = $row[0];
#  $sql = "select distinct trim(d1.spec),(select trim(spec_name) from spec_tbl s where d1.spec = s.spec) spec
#          from data d1 join univer_tbl u on d1.univer = u.univer
#          where d1.univer = '$univer'
#          order by 1,2;";

        switch ($univer) {
          case "guap" : $spec = "'02.03.03','09.03.03','09.03.04'"; break;
          case "uniyar" : $spec = "'01.03.02','02.03.02','09.03.03'"; break;
          case "sut" : $spec = "'09.03.01','09.03.02','09.03.04'"; break;
          case "eltech" : $spec = "'01.03.02','09.03.01','09.03.04'"; break;
          case "spbstu" : $spec = "'02.03.02','09.03.01','09.03.04'"; break;
          default : $spec = "'09.03.01','01.03.02','02.03.02','09.03.02','02.03.03','09.03.03','09.04.03','09.03.04'";
        }
        $sql =  "select distinct trim(d1.spec), trim(s.spec_name) spec
                  from data d1 join univer_tbl u on d1.univer = u.univer join spec_tbl s on d1.spec = s.spec
                  where d1.univer = '$univer' and d1.spec in (".$spec.") order by 1,2";

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
