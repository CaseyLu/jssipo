<div id="main" style="">
<?php
include_once '/inc/config.inc.php';
$link=connect();
if(!$staffId=isLogin($link)['staffId']){
	skip('login','error','您未登录！');   //判断是否登录
}
//获取可查询任务量的年份
$queryPre="select MAX(chuanTime) from finish_task";
$result=execute($link,$queryPre);
$dataPre=mysqli_fetch_assoc($result);
if($dataPre['MAX(chuanTime)']==''){
	echo "正在更新工作量数据，请稍候！";
	exit();
}
$year=substr($dataPre['MAX(chuanTime)'],0,4);
$tjTime=$dataPre['MAX(chuanTime)'];
//查询本月最后出案日
$dateNow=date("Y-m-d");
$monthNow=date("Y-m");
$thisMonth=date("m");
$queryFinalDay="select finalDay,updateTime from final_day where id={$thisMonth}";
$resultFinalDay=execute($link,$queryFinalDay);
$dataFinalDay=mysqli_fetch_assoc($resultFinalDay);
$leftDays=round((strtotime($dataFinalDay['finalDay'])-strtotime($dateNow))/86400)+1;
$color="";
if($leftDays<4 && $leftDays>0){
	$color="red";
}
if($leftDays<0){
	$leftDays=0;
}
$html=<<<A
<div class="title">{$year}年个人PCT工作量统计表（{$staffId}）；统计截止日期：{$tjTime}；本月最后出案日：<font style="color:{$color};">{$dataFinalDay['finalDay']}，还剩：{$leftDays}天</font></div>
A;
echo $html;
$query1="select ytJan,ytFeb,ytMar,ytApr,ytMay,ytJun,ytJul,ytAug,ytSep,ytOct,ytNov,ytDec,jaJan,jaFeb,jaMar,jaApr,jaMay,jaJun,jaJul,jaAug,jaSep,jaOct,jaNov,jaDec,adjust from task_conf where staffId=$staffId and year=$year";
$result1=execute($link,$query1);
$data1=mysqli_fetch_assoc($result1);
$ytTaskAll=$data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']+$data1['ytAug']+$data1['ytSep']+$data1['ytOct']+$data1['ytNov']+$data1['ytDec'];
$html=<<<A
<table id="listCustomer" class="listtest">
	<tr>
		<th></th>	 	 	
		<th>1月</th>
		<th>2月</th>
		<th>3月</th>
		<th>4月</th>
		<th>5月</th>
		<th>6月</th>
		<th>7月</th>
		<th>8月</th>
		<th>9月</th>
		<th>10月</th>
		<th>11月</th>
		<th>12月</th>
		<th style="text-align:center;">总计
A;
echo $html;
if($data1['adjust']<>0){
	echo"</br><font color='green'>(调整量)</font>";
}
$html=<<<A
	</th>
	</tr>
	<tr>
		<td style="text-align:center;">一通计划量</td>
		<td style="text-align:center;">{$data1['ytJan']}</td>
		<td style="text-align:center;">{$data1['ytFeb']}</td>
		<td style="text-align:center;">{$data1['ytMar']}</td>
		<td style="text-align:center;">{$data1['ytApr']}</td>
		<td style="text-align:center;">{$data1['ytMay']}</td>
		<td style="text-align:center;">{$data1['ytJun']}</td>
		<td style="text-align:center;">{$data1['ytJul']}</td>
		<td style="text-align:center;">{$data1['ytAug']}</td>
		<td style="text-align:center;">{$data1['ytSep']}</td>
		<td style="text-align:center;">{$data1['ytOct']}</td>
		<td style="text-align:center;">{$data1['ytNov']}</td>
		<td style="text-align:center;">{$data1['ytDec']}</td>
		<td style="text-align:center;">{$ytTaskAll}</td>
	</tr>
	<tr>
A;
	echo $html;
		$month=array('01','02','03','04','05','06','07','08','09','10','11','12');
		$yt=array();
		for($i=0;$i<12;$i++){
		$query2="select sum(bzCount) from finish_task where staffId=$staffId and type='一通' and chuanTime like '{$year}-{$month[$i]}-__'";
		$result2=execute($link,$query2);
		$data2=mysqli_fetch_assoc($result2);
		$yt[$i]=ROUND($data2['sum(bzCount)'],3);
		$query3Xz="select count(id) from finish_task where staffId=$staffId and type='一通' and bzCount<0 and chuanTime like '{$year}-{$month[$i]}-__'";
		$result3Xz=execute($link,$query3Xz);
		$data3Xz=mysqli_fetch_assoc($result3Xz);
		$query3="select count(id) from finish_task where staffId=$staffId and type='一通' and chuanTime like '{$year}-{$month[$i]}-__'";
		$result3=execute($link,$query3);
		$data3=mysqli_fetch_assoc($result3);
		$ytZiran[$i]=$data3['count(id)']-$data3Xz['count(id)']*2;
		}
		$ytFinishAll=array_sum($yt);
		$ytFinishZiranAll=array_sum($ytZiran);
$html=<<<A
		<td style="text-align:center;">一通完成量</br><font color="#C0C0C0">(自然件)</font></td>
A;
	echo $html;
		for($i=0;$i<12;$i++){
$html=<<<A
		<td style="text-align:center;"><a href="task_examer_inquire_yt?month=$month[$i]">{$yt[$i]}</a></br><font color="#C0C0C0">({$ytZiran[$i]})</font></td>
A;
		echo $html;
		}
$html=<<<A
		<td style="text-align:center;" ><a href="task_examer_inquire_yt?month=__">{$ytFinishAll}</a></br><font color="#C0C0C0">({$ytFinishZiranAll})</font></td>
		</tr>
	<tr>
A;
	echo $html;
	$ytDy01=@round(($yt[0]/$data1['ytJan'])*100,2).'%';
	$ytDy02=@round(($yt[1]/$data1['ytFeb'])*100,2).'%';
	$ytDy03=@round(($yt[2]/$data1['ytMar'])*100,2).'%';
	$ytDy04=@round(($yt[3]/$data1['ytApr'])*100,2).'%';
	$ytDy05=@round(($yt[4]/$data1['ytMay'])*100,2).'%';
	$ytDy06=@round(($yt[5]/$data1['ytJun'])*100,2).'%';
	$ytDy07=@round(($yt[6]/$data1['ytJul'])*100,2).'%';
	$ytDy08=@round(($yt[7]/$data1['ytAug'])*100,2).'%';
	$ytDy09=@round(($yt[8]/$data1['ytSep'])*100,2).'%';
	$ytDy10=@round(($yt[9]/$data1['ytOct'])*100,2).'%';
	$ytDy11=@round(($yt[10]/$data1['ytNov'])*100,2).'%';
	$ytDy12=@round(($yt[11]/$data1['ytDec'])*100,2).'%';
	$ytDy=@round(($ytFinishAll/$ytTaskAll)*100,2).'%';
	$isYtDy01=($ytDy01<85 or $ytDy01>150) ? "red" : "";
	$isYtDy02=($ytDy02<85 or $ytDy02>150) ? "red" : "";
	$isYtDy03=($ytDy03<85 or $ytDy03>150) ? "red" : "";
	$isYtDy04=($ytDy04<85 or $ytDy04>150) ? "red" : "";
	$isYtDy05=($ytDy05<85 or $ytDy05>150) ? "red" : "";
	$isYtDy06=($ytDy06<85 or $ytDy06>150) ? "red" : "";
	$isYtDy07=($ytDy07<85 or $ytDy07>150) ? "red" : "";
	$isYtDy08=($ytDy08<85 or $ytDy08>150) ? "red" : "";
	$isYtDy09=($ytDy09<85 or $ytDy09>150) ? "red" : "";
	$isYtDy10=($ytDy10<85 or $ytDy10>150) ? "red" : "";
	$isYtDy11=($ytDy11<85 or $ytDy11>150) ? "red" : "";
	$isYtDy12=($ytDy12<85 or $ytDy12>150) ? "red" : "";
	
$html=<<<A
		<td style="text-align:center;">当月完成率</td>
		<td style="text-align:center;color:$isYtDy01;">{$ytDy01}</td>
		<td style="text-align:center;color:$isYtDy02;">{$ytDy02}</td>
		<td style="text-align:center;color:$isYtDy03;">{$ytDy03}</td>
		<td style="text-align:center;color:$isYtDy04;">{$ytDy04}</td>
		<td style="text-align:center;color:$isYtDy05;">{$ytDy05}</td>
		<td style="text-align:center;color:$isYtDy06;">{$ytDy06}</td>
		<td style="text-align:center;color:$isYtDy07;">{$ytDy07}</td>
		<td style="text-align:center;color:$isYtDy08;">{$ytDy08}</td>
		<td style="text-align:center;color:$isYtDy09;">{$ytDy09}</td>
		<td style="text-align:center;color:$isYtDy10;">{$ytDy10}</td>
		<td style="text-align:center;color:$isYtDy11;">{$ytDy11}</td>
		<td style="text-align:center;color:$isYtDy12;">{$ytDy12}</td>
		<td style="text-align:center;">{$ytDy}</td>
			</tr>
	
A;
	echo $html;


$html=<<<A
	<tr>
	<td colspan="14">注：<font style="color:red;">红色</font>警示完成率较低，请审查员合理安排任务进度</td>
	</tr>	
</table>
A;
echo $html;

// 显示当前的PCT案件完成情况
$html=<<<A
	<tr>
	<td>
	<form> 
	Select a User:
	<select name="users" onchange="showUser(this.value)">
	<option>选择月份</option>
	<option value="5">Peter Griffin</option>
	<option value="2">Lois Griffin</option>
	<option value="322">Glenn Quagmire</option>
	<option value="1422">Joseph Swanson</option>
	</select>
	</form>

<p>
<div id="txtHint"><b>内容User info will be listed here.</b></div>
</p>
	</td>
	<td></td>
	</tr>	
</table>
A;
echo $html;

	
?>
</div>