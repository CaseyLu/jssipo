<?php

// include_once '../inc/config.php';
// include_once '../inc/config.inc.php';
// include_once '../inc/tool.inc.php';
// include_once '../inc/page.inc.php';
// include_once '../inc/functions.php';
$year=2017;
$get_month=10;
$staffId=11178;
//$link=connect();

$users=$_GET["q"];
$mysqli = new mysqli('localhost', "jssipo", "jssipo1415", "jssipo");

//$sql="SELECT * FROM finish_task WHERE id ='".$users."'";
$sql="SELECT * FROM finish_task where id = 2";
$result = $mysqli->query($sql);
$i = 1;

echo "shit user fsatss";
echo "<table border='1'>";
while($row = mysqli_fetch_assoc($result))
{
	echo "<tr bgcolor='grey'>";
	echo "<td>" . $i++ . "</td>";
	echo "<td>" . $row['orgName'] . "</td>";
	echo "<td>" . $row['orgName'] . "</td>";
	echo "<td>" . $row['staffId'] .".....". "</td>";
	echo "<td>" . "狗子". "</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td>" . $i++ . "</td>";
	echo "<td>" . $row['orgName'] . "</td>";
	echo "<td>" . $row['orgName'] . "</td>";
	echo "<td>" . $row['staffId'] .".....". "</td>";
	echo "<td>" . $row['orgName'] . "</td>";
	echo "</tr>";
}
echo "</table>";
$mysqli->close();

//mysql_close($mysqli);
?>