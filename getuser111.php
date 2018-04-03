<?php
//$users=$_POST["users"];
$users=$_GET["q"];
$mysqli = new mysqli('localhost', "jssipo", "jssipo1415", "jssipo");

//$con = mysql_connect('localhost', 'jssipo', 'jssipo1415');
/* if (!$con)
 {
 die('Could not connect: ' . mysql_error());
 } */

//mysql_select_db("jssipo", $con);

//$susersl="SELECT * FROM admin WHERE id = '".$users."'";

//$sql="SELECT * FROM admin WHERE id ='".$users."'";
$sql="SELECT * FROM admin";
//$result = mysql_query($sql);
$result = $mysqli->query($sql);
$i = 1;
echo "<table border='1'>";
while($row = mysqli_fetch_assoc($result))
{
	echo "<tr bgcolor='grey'>";
	echo "<td>" . $i++ . "</td>";
	echo "<td>" . $row['pwd'] . "</td>";
	echo "<td>" . $row['pwd'] . "</td>";
	echo "<td>" . $row['staffId'] .".....". "</td>";
	echo "<td>" . $row['pwd'] . "</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td>" . $i++ . "</td>";
	echo "<td>" . $row['pwd'] . "</td>";
	echo "<td>" . $row['pwd'] . "</td>";
	echo "<td>" . $row['staffId'] .".....". "</td>";
	echo "<td>" . $row['pwd'] . "</td>";
	echo "</tr>";
}
echo "</table>";

$mysqli->close();
//mysql_close($mysqli);
?>