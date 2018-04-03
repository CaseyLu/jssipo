<?php

include_once '../inc/config.php';
include_once '../inc/config.inc.php';
include_once '../inc/tool.inc.php';
include_once '../inc/page.inc.php';
include_once '../inc/functions.php';
$year=2017;
$get_month=10;
$staffId=11178;
$link=connect();

$users=$_GET["q"];
$mysqli = new mysqli('localhost', "jssipo", "jssipo1415", "jssipo");

//$sql="SELECT * FROM admin WHERE id ='".$users."'";
$sql="SELECT * FROM admin where id = 2";
$result = $mysqli->query($sql);
$i = 1;

echo "shit user fsatss";
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

$html=<<<A
<table class="list">
	<tr>
		<th>序号</th>
		<th>申请号</th>	 	 	
		<th>机构名称</th>
		<th>工作量计入</th>
		<th>所属审查员</th>
		<th>人员姓名</th>
		<th>标准件</th>
		<th>出案类型名称</th>
		<th>统计日期</th>
		<th>类型</th>
		<th>加快标记</th>
		<th>具体类型</th>
		<th></th>
	</tr>
A;
	echo $html;
	
		$page_size=20;
		$query_count="select count(id) from finish_task where staffId=$staffId and type='一通' and chuanTime like '{$year}-{$get_month}-__'";
		$count_all=num($link,$query_count);
		$page=page($count_all,$page_size);
		$query="select ft.id,org.orgName on1,ft.ap,ft.orgName on2,ft.examId,ft.Name,ft.bzCount,ft.typeName,ft.chuanTime,ft.type,ft.jiakuai,ft.specificType from finish_task ft,org where org.id=ft.workFor and staffId=$staffId and ft.type='一通' and ft.chuanTime like '{$year}-{$get_month}-__' order by ft.chuanTime asc {$page['limit']}";
		$result=execute($link,$query);
		$get_page=isset($_GET['page']) ? $_GET['page'] : '';
		$i=($get_page-1)*$page_size+1;
		while($data=mysqli_fetch_assoc($result)){	
		$query="select finishTaskId from task_error where finishTaskId={$data['id']}";
		$result_finishTaskId=execute($link,$query);
		
$html=<<<A
		<tr>
		<td>{$i}</td>
		<td>{$data['ap']}</td>
		<td>{$data['on2']}</td>
		<td>{$data['on1']}</td>
		<td>{$data['examId']}</td>
		<td>{$data['Name']}</td>
		<td>{$data['bzCount']}</td>
		<td>{$data['typeName']}</td>
		<td>{$data['chuanTime']}</td>
		<td>{$data['type']}</td>
		<td>{$data['jiakuai']}</td>
		<td>{$data['specificType']}</td>
		<td></td>
		</tr>
A;
	echo $html;
		$i++;
		}
		
echo "</table>";

$mysqli->close();
//mysql_close($mysqli);
?>