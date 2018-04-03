<div id="main" style="">
<?php
include_once '/inc/config.inc.php';
$link=connect();
if(!$staffId=isLogin($link)['staffId']){
	skip('login','error','您未登录，请重新登录！');   //判断是否登录
}else{
	$adminOrg=isLogin($link)['adminOrg'];
}
if(is_numeric($adminOrg)){
	$queryAdmin="select fatherId from org where id=$adminOrg";
			$resultAdmin=execute($link, $queryAdmin);
			$dataAdmin=mysqli_fetch_assoc($resultAdmin);
				if($dataAdmin['fatherId']!='1'){
		skip('index.php','error','您没有此权限！');   //判断权限
				}
	}
//获取可查询任务量的年份和机构名称
$queryPre="select MAX(chuanTime) from finish_task_new";
$result=execute($link,$queryPre);
$dataPre=mysqli_fetch_assoc($result);
if($dataPre['MAX(chuanTime)']==''){
	echo "正在更新工作量数据，请稍候！";
	exit();
}
$year=substr($dataPre['MAX(chuanTime)'],0,4);
$tjTime=$dataPre['MAX(chuanTime)'];
$queryOrg="select orgName from org where id=$adminOrg";
$resultOrg=execute($link, $queryOrg);
$dataOrg=mysqli_fetch_assoc($resultOrg);
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
		<div class="title">{$year}年工作量统计表（{$dataOrg['orgName']}）；统计截止日期：{$tjTime}；本月最后出案日：<font style="color:{$color};">{$dataFinalDay['finalDay']}，还剩：{$leftDays}天</font></div>
A;
		echo $html;
?>

<table class="list1">
	<tr>
		<th></th>	 	 	
		<?php 
		$month=array('01','02','03','04','05','06','07','08','09','10','11','12');
		for($i=0;$i<12;$i++){
$html=<<<A
		<th style="text-align:center;"><a href="task_bumen_2_inquire_detail?month=$month[$i]">{$month[$i]}月</a></th>
A;
		echo $html;
	}
		?>
		<th style="text-align:center;"><a href="task_bumen_yuliu_detail">预留</a></th>
		<th style="text-align:center;"><a href="task_bumen_2_inquire_detail_all">总计</a></th>
	</tr>
	<tr>
		<?php
		if($staffId='11178'){
		$workFor=$adminOrg;
		/*//查询实际填报确认的任务量
		$query1="select tc.staffId,tc.ytJan,tc.ytFeb,tc.ytMar,tc.ytApr,tc.ytMay,tc.ytJun,tc.ytJul,tc.ytAug,tc.ytSep,tc.ytOct,tc.ytNov,tc.ytDec,tc.jaJan,tc.jaFeb,tc.jaMar,tc.jaApr,tc.jaMay,tc.jaJun,tc.jaJul,tc.jaAug,tc.jaSep,tc.jaOct,tc.jaNov,tc.jaDec from task_conf tc,staff where tc.staffId=staff.staffId and tc.year=$year and (staff.workFor=$workFor or staff.workFor in (select id from org where fatherId=$workFor))";
		$result1=execute($link,$query1);
		while($data1=mysqli_fetch_assoc($result1)){
			$ytJan[$data1['staffId']]=$data1['ytJan'];
			$ytFeb[$data1['staffId']]=$data1['ytFeb'];
			$ytMar[$data1['staffId']]=$data1['ytMar'];
			$ytApr[$data1['staffId']]=$data1['ytApr'];
			$ytMay[$data1['staffId']]=$data1['ytMay'];
			$ytJun[$data1['staffId']]=$data1['ytJun'];
			$ytJul[$data1['staffId']]=$data1['ytJul'];
			$ytAug[$data1['staffId']]=$data1['ytAug'];
			$ytSep[$data1['staffId']]=$data1['ytSep'];
			$ytOct[$data1['staffId']]=$data1['ytOct'];
			$ytNov[$data1['staffId']]=$data1['ytNov'];
			$ytDec[$data1['staffId']]=$data1['ytDec'];
			$jaJan[$data1['staffId']]=$data1['jaJan'];
			$jaFeb[$data1['staffId']]=$data1['jaFeb'];
			$jaMar[$data1['staffId']]=$data1['jaMar'];
			$jaApr[$data1['staffId']]=$data1['jaApr'];
			$jaMay[$data1['staffId']]=$data1['jaMay'];
			$jaJun[$data1['staffId']]=$data1['jaJun'];
			$jaJul[$data1['staffId']]=$data1['jaJul'];
			$jaAug[$data1['staffId']]=$data1['jaAug'];
			$jaSep[$data1['staffId']]=$data1['jaSep'];
			$jaOct[$data1['staffId']]=$data1['jaOct'];
			$jaNov[$data1['staffId']]=$data1['jaNov'];
			$jaDec[$data1['staffId']]=$data1['jaDec'];
			$ytTaskAllExamer[$data1['staffId']]=$data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']+$data1['ytAug']+$data1['ytSep']+$data1['ytOct']+$data1['ytNov']+$data1['ytDec'];
			$jaTaskAllExamer[$data1['staffId']]=$data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']+$data1['jaJul']+$data1['jaAug']+$data1['jaSep']+$data1['jaOct']+$data1['jaNov']+$data1['jaDec'];
		}
		$ytTaskAllChushi=@array_sum($ytTaskAllExamer);
		$jaTaskAllChushi=@array_sum($jaTaskAllExamer);
		$ytJanAllChushi=@array_sum($ytJan);
		$ytFebAllChushi=@array_sum($ytFeb);
		$ytMarAllChushi=@array_sum($ytMar);
		$ytAprAllChushi=@array_sum($ytApr);
		$ytMayAllChushi=@array_sum($ytMay);
		$ytJunAllChushi=@array_sum($ytJun);
		$ytJulAllChushi=@array_sum($ytJul);
		$ytAugAllChushi=@array_sum($ytAug);
		$ytSepAllChushi=@array_sum($ytSep);
		$ytOctAllChushi=@array_sum($ytOct);
		$ytNovAllChushi=@array_sum($ytNov);
		$ytDecAllChushi=@array_sum($ytDec);
		$jaJanAllChushi=@array_sum($jaJan);
		$jaFebAllChushi=@array_sum($jaFeb);
		$jaMarAllChushi=@array_sum($jaMar);
		$jaAprAllChushi=@array_sum($jaApr);
		$jaMayAllChushi=@array_sum($jaMay);
		$jaJunAllChushi=@array_sum($jaJun);
		$jaJulAllChushi=@array_sum($jaJul);
		$jaAugAllChushi=@array_sum($jaAug);
		$jaSepAllChushi=@array_sum($jaSep);
		$jaOctAllChushi=@array_sum($jaOct);
		$jaNovAllChushi=@array_sum($jaNov);
		$jaDecAllChushi=@array_sum($jaDec);
		*/
		//查询任务分解量
		$queryFenjie="select yt,ja,yt1,ja1,yt2,ja2,yt3,ja3,yt4,ja4,yt5,ja5,yt6,ja6,yt7,ja7,yt8,ja8,yt9,ja9,yt10,ja10,yt11,ja11,yt12,ja12 from fenjie_task where year={$year} and orgId={$workFor}";
		$resultFenjie=execute($link,$queryFenjie);
		$dataFenjie=mysqli_fetch_assoc($resultFenjie);
		$ytTaskAllChushi=$dataFenjie['yt'];
		$jaTaskAllChushi=$dataFenjie['ja'];
		$ytJanAllChushi=$dataFenjie['yt1'];
		$ytFebAllChushi=$dataFenjie['yt2'];
		$ytMarAllChushi=$dataFenjie['yt3'];
		$ytAprAllChushi=$dataFenjie['yt4'];
		$ytMayAllChushi=$dataFenjie['yt5'];
		$ytJunAllChushi=$dataFenjie['yt6'];
		$ytJulAllChushi=$dataFenjie['yt7'];
		$ytAugAllChushi=$dataFenjie['yt8'];
		$ytSepAllChushi=$dataFenjie['yt9'];
		$ytOctAllChushi=$dataFenjie['yt10'];
		$ytNovAllChushi=$dataFenjie['yt11'];
		$ytDecAllChushi=$dataFenjie['yt12'];
		$jaJanAllChushi=$dataFenjie['ja1'];
		$jaFebAllChushi=$dataFenjie['ja2'];
		$jaMarAllChushi=$dataFenjie['ja3'];
		$jaAprAllChushi=$dataFenjie['ja4'];
		$jaMayAllChushi=$dataFenjie['ja5'];
		$jaJunAllChushi=$dataFenjie['ja6'];
		$jaJulAllChushi=$dataFenjie['ja7'];
		$jaAugAllChushi=$dataFenjie['ja8'];
		$jaSepAllChushi=$dataFenjie['ja9'];
		$jaOctAllChushi=$dataFenjie['ja10'];
		$jaNovAllChushi=$dataFenjie['ja11'];
		$jaDecAllChushi=$dataFenjie['ja12'];
		//查询预留量
		$queryYuliu="select tc.ytJan,tc.ytFeb,tc.ytMar,tc.ytApr,tc.ytMay,tc.ytJun,tc.ytJul,tc.ytAug,tc.ytSep,tc.ytOct,tc.ytNov,tc.ytDec,tc.jaJan,tc.jaFeb,tc.jaMar,tc.jaApr,tc.jaMay,tc.jaJun,tc.jaJul,tc.jaAug,tc.jaSep,tc.jaOct,tc.jaNov,tc.jaDec from task_conf tc,staff where tc.staffId=staff.staffId and tc.year=$year and staff.workFor=$workFor and staff.staffId like '8____'";
		$resultYuliu=execute($link,$queryYuliu);
		$dataYuliu=mysqli_fetch_assoc($resultYuliu);
		$yuliuYt=ROUND($dataYuliu['ytJan']+$dataYuliu['ytFeb']+$dataYuliu['ytMar']+$dataYuliu['ytApr']+$dataYuliu['ytMay']+$dataYuliu['ytJun']+$dataYuliu['ytJul']+$dataYuliu['ytAug']+$dataYuliu['ytSep']+$dataYuliu['ytOct']+$dataYuliu['ytNov']+$dataYuliu['ytDec'],2);
		$yuliuJa=ROUND($dataYuliu['jaJan']+$dataYuliu['jaFeb']+$dataYuliu['jaMar']+$dataYuliu['jaApr']+$dataYuliu['jaMay']+$dataYuliu['jaJun']+$dataYuliu['jaJul']+$dataYuliu['jaAug']+$dataYuliu['jaSep']+$dataYuliu['jaOct']+$dataYuliu['jaNov']+$dataYuliu['jaDec'],2);
$html=<<<A
		<td style="text-align:center;">一通计划量</td>
		<td style="text-align:center;">{$ytJanAllChushi}</td>
		<td style="text-align:center;">{$ytFebAllChushi}</td>
		<td style="text-align:center;">{$ytMarAllChushi}</td>
		<td style="text-align:center;">{$ytAprAllChushi}</td>
		<td style="text-align:center;">{$ytMayAllChushi}</td>
		<td style="text-align:center;">{$ytJunAllChushi}</td>
		<td style="text-align:center;">{$ytJulAllChushi}</td>
		<td style="text-align:center;">{$ytAugAllChushi}</td>
		<td style="text-align:center;">{$ytSepAllChushi}</td>
		<td style="text-align:center;">{$ytOctAllChushi}</td>
		<td style="text-align:center;">{$ytNovAllChushi}</td>
		<td style="text-align:center;">{$ytDecAllChushi}</td>
		<td style="text-align:center;">{$yuliuYt}</td>
		<td style="text-align:center;">{$ytTaskAllChushi}</td>
	</tr>
	<tr>
A;
	echo $html;
		$yt=array();
		for($i=0;$i<12;$i++){
		$query2="select sum(bzCount2) from finish_task_new where (workFor=$workFor or workFor in (select id from org where fatherId=$workFor)) and type='一通出案' and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$result2=execute($link,$query2);
		$data2=mysqli_fetch_assoc($result2);
		$yt[$i]=ROUND($data2['sum(bzCount2)'],2);
		$query3="select count(id) from finish_task_new where (workFor=$workFor or workFor in (select id from org where fatherId=$workFor)) and type='一通出案' and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$result3=execute($link,$query3);
		$data3=mysqli_fetch_assoc($result3);
		$ytZiran[$i]=$data3['count(id)'];
		}
		$ytFinishAll=array_sum($yt);
		$ytFinishZiranAll=array_sum($ytZiran);
$html=<<<A
		<td style="text-align:center;">一通完成量</br><font color="#C0C0C0">(自然件)</font></td>
A;
	echo $html;
	for($i=0;$i<12;$i++){
$html=<<<A
		<td style="text-align:center;"><a href="task_bumen_2_inquire_yt?month=$month[$i]">{$yt[$i]}</a></br><font color="#C0C0C0">({$ytZiran[$i]})</font></td>
A;
		echo $html;
	}
$html=<<<A
		<td></td>
		<td style="text-align:center;"><a href="task_bumen_2_inquire_yt?month=__">{$ytFinishAll}</a></br><font color="#C0C0C0">({$ytFinishZiranAll})</font></td>
		</tr>
	<tr>
A;
	echo $html;
	$ytDy01=@round(($yt[0]/$ytJanAllChushi)*100,2).'%';
	$ytDy02=@round(($yt[1]/$ytFebAllChushi)*100,2).'%';
	$ytDy03=@round(($yt[2]/$ytMarAllChushi)*100,2).'%';
	$ytDy04=@round(($yt[3]/$ytAprAllChushi)*100,2).'%';
	$ytDy05=@round(($yt[4]/$ytMayAllChushi)*100,2).'%';
	$ytDy06=@round(($yt[5]/$ytJunAllChushi)*100,2).'%';
	$ytDy07=@round(($yt[6]/$ytJulAllChushi)*100,2).'%';
	$ytDy08=@round(($yt[7]/$ytAugAllChushi)*100,2).'%';
	$ytDy09=@round(($yt[8]/$ytSepAllChushi)*100,2).'%';
	$ytDy10=@round(($yt[9]/$ytOctAllChushi)*100,2).'%';
	$ytDy11=@round(($yt[10]/$ytNovAllChushi)*100,2).'%';
	$ytDy12=@round(($yt[11]/$ytDecAllChushi)*100,2).'%';
	$ytDy=@round(($ytFinishAll/$ytTaskAllChushi)*100,2).'%';
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
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$ytDy}</td>
			</tr>
	<tr>
A;
	echo $html;
	$ytLj01=@round(($yt[0]/$ytJanAllChushi)*100,2).'%';
	$ytLj02=@round((($yt[0]+$yt[1])/($ytJanAllChushi+$ytFebAllChushi))*100,2).'%';
	$ytLj03=@round((($yt[0]+$yt[1]+$yt[2])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi))*100,2).'%';
	$ytLj04=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi+$ytAprAllChushi))*100,2).'%';
	$ytLj05=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi+$ytAprAllChushi+$ytMayAllChushi))*100,2).'%';
	$ytLj06=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi+$ytAprAllChushi+$ytMayAllChushi+$ytJunAllChushi))*100,2).'%';
	$ytLj07=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi+$ytAprAllChushi+$ytMayAllChushi+$ytJunAllChushi+$ytJulAllChushi))*100,2).'%';
	$ytLj08=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi+$ytAprAllChushi+$ytMayAllChushi+$ytJunAllChushi+$ytJulAllChushi+$ytAugAllChushi))*100,2).'%';
	$ytLj09=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi+$ytAprAllChushi+$ytMayAllChushi+$ytJunAllChushi+$ytJulAllChushi+$ytAugAllChushi+$ytSepAllChushi))*100,2).'%';
	$ytLj10=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi+$ytAprAllChushi+$ytMayAllChushi+$ytJunAllChushi+$ytJulAllChushi+$ytAugAllChushi+$ytSepAllChushi+$ytOctAllChushi))*100,2).'%';
	$ytLj11=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9]+$yt[10])/($ytJanAllChushi+$ytFebAllChushi+$ytMarAllChushi+$ytAprAllChushi+$ytMayAllChushi+$ytJunAllChushi+$ytJulAllChushi+$ytAugAllChushi+$ytSepAllChushi+$ytOctAllChushi+$ytNovAllChushi))*100,2).'%';
	$ytLj12=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9]+$yt[10]+$yt[11])/$ytTaskAllChushi)*100,2).'%';
	$ytLj=@round(($ytFinishAll/$ytTaskAllChushi)*100,2).'%';
	$isYtDonw01=($ytLj01<85 or $ytLj01>110) ? "red" : "";
	$isYtDonw02=($ytLj02<85 or $ytLj02>110) ? "red" : "";
	$isYtDonw03=($ytLj03<85 or $ytLj03>110) ? "red" : "";
	$isYtDonw04=($ytLj04<90 or $ytLj04>110) ? "red" : "";
	$isYtDonw05=($ytLj05<90 or $ytLj05>110) ? "red" : "";
	$isYtDonw06=($ytLj06<90 or $ytLj06>110) ? "red" : "";
	$isYtDonw07=($ytLj07<95 or $ytLj07>110) ? "red" : "";
	$isYtDonw08=($ytLj08<95 or $ytLj08>110) ? "red" : "";
	$isYtDonw09=($ytLj09<95 or $ytLj09>110) ? "red" : "";
	$isYtDonw10=($ytLj10<100 or $ytLj10>110) ? "red" : "";
	$isYtDonw11=($ytLj11<100 or $ytLj11>110) ? "red" : "";
	$isYtDonw12=($ytLj12<100 or $ytLj12>110) ? "red" : "";
$html=<<<A
		<td style="text-align:center;">累计完成率</td>
		<td style="text-align:center;color:$isYtDonw01;">{$ytLj01}</td>
		<td style="text-align:center;color:$isYtDonw02;">{$ytLj02}</td>
		<td style="text-align:center;color:$isYtDonw03;">{$ytLj03}</td>
		<td style="text-align:center;color:$isYtDonw04;">{$ytLj04}</td>
		<td style="text-align:center;color:$isYtDonw05;">{$ytLj05}</td>
		<td style="text-align:center;color:$isYtDonw06;">{$ytLj06}</td>
		<td style="text-align:center;color:$isYtDonw07;">{$ytLj07}</td>
		<td style="text-align:center;color:$isYtDonw08;">{$ytLj08}</td>
		<td style="text-align:center;color:$isYtDonw09;">{$ytLj09}</td>
		<td style="text-align:center;color:$isYtDonw10;">{$ytLj10}</td>
		<td style="text-align:center;color:$isYtDonw11;">{$ytLj11}</td>
		<td style="text-align:center;color:$isYtDonw12;">{$ytLj12}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$ytLj}</td>
	</tr>
	<tr>
A;
	echo $html;
	$ytNd01=@round(($yt[0]/$ytTaskAllChushi)*100,2).'%';
	$ytNd02=@round((($yt[0]+$yt[1])/$ytTaskAllChushi)*100,2).'%';
	$ytNd03=@round((($yt[0]+$yt[1]+$yt[2])/$ytTaskAllChushi)*100,2).'%';
	$ytNd04=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3])/$ytTaskAllChushi)*100,2).'%';
	$ytNd05=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4])/$ytTaskAllChushi)*100,2).'%';
	$ytNd06=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5])/$ytTaskAllChushi)*100,2).'%';
	$ytNd07=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6])/$ytTaskAllChushi)*100,2).'%';
	$ytNd08=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7])/$ytTaskAllChushi)*100,2).'%';
	$ytNd09=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8])/$ytTaskAllChushi)*100,2).'%';
	$ytNd10=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9])/$ytTaskAllChushi)*100,2).'%';
	$ytNd11=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9]+$yt[10])/$ytTaskAllChushi)*100,2).'%';
	$ytNd12=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9]+$yt[10]+$yt[11])/$ytTaskAllChushi)*100,2).'%';
	$ytNd=@round(($ytFinishAll/$ytTaskAllChushi)*100,2).'%';	
$html=<<<A
		<td style="text-align:center;">年度完成率</td>
		<td style="text-align:center;">{$ytNd01}</td>
		<td style="text-align:center;">{$ytNd02}</td>
		<td style="text-align:center;">{$ytNd03}</td>
		<td style="text-align:center;">{$ytNd04}</td>
		<td style="text-align:center;">{$ytNd05}</td>
		<td style="text-align:center;">{$ytNd06}</td>
		<td style="text-align:center;">{$ytNd07}</td>
		<td style="text-align:center;">{$ytNd08}</td>
		<td style="text-align:center;">{$ytNd09}</td>
		<td style="text-align:center;">{$ytNd10}</td>
		<td style="text-align:center;">{$ytNd11}</td>
		<td style="text-align:center;">{$ytNd12}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$ytNd}</td>
	</tr>
	<tr>
A;
	echo $html;
$html=<<<A
		<td style="text-align:center;">结案计划量</td>
		<td style="text-align:center;">{$jaJanAllChushi}</td>
		<td style="text-align:center;">{$jaFebAllChushi}</td>
		<td style="text-align:center;">{$jaMarAllChushi}</td>
		<td style="text-align:center;">{$jaAprAllChushi}</td>
		<td style="text-align:center;">{$jaMayAllChushi}</td>
		<td style="text-align:center;">{$jaJunAllChushi}</td>
		<td style="text-align:center;">{$jaJulAllChushi}</td>
		<td style="text-align:center;">{$jaAugAllChushi}</td>
		<td style="text-align:center;">{$jaSepAllChushi}</td>
		<td style="text-align:center;">{$jaOctAllChushi}</td>
		<td style="text-align:center;">{$jaNovAllChushi}</td>
		<td style="text-align:center;">{$jaDecAllChushi}</td>
		<td style="text-align:center;">{$yuliuJa}</td>
		<td style="text-align:center;">{$jaTaskAllChushi}</td>
	</tr>
	<tr>
A;
	echo $html;
		$ja=array();
		for($i=0;$i<12;$i++){
		$query2="select sum(bzCount1) from finish_task_new where (workFor=$workFor or workFor in (select id from org where fatherId=$workFor)) and type in ('普通授权','普通驳回','视撤结案','主撤结案','国优视撤','前置审查','二次结案驳回','二次结案授权','一次授权','一次授权') and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$result2=execute($link,$query2);
		$data2=mysqli_fetch_assoc($result2);
		$ja[$i]=ROUND($data2['sum(bzCount1)'],2);
		}
		$jaFinishAll=array_sum($ja);
		//查询当月首次结案自然件
		$jaZrj=array();
		for($i=0;$i<12;$i++){	
		$queryjaZrj="select count(id) from finish_task_new where (workFor=$workFor or workFor in (select id from org where fatherId=$workFor)) and type in ('普通授权','普通驳回','视撤结案','主撤结案','国优视撤','一次授权') and typeName not in('110') and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultjaZrj=execute($link,$queryjaZrj);
		$datajaZrj=mysqli_fetch_assoc($resultjaZrj);
		$jaZrj[$i]=$datajaZrj['count(id)'];
		}
		$jaZrjAll=array_sum($jaZrj);
$html=<<<A
		<td style="text-align:center;">结案完成量</br><font color="#C0C0C0">(首结自然件)</font></td>
A;
	echo $html;
	for($i=0;$i<12;$i++){
$html=<<<A
		<td style="text-align:center;"><a href="task_bumen_2_inquire_ja?month=$month[$i]">{$ja[$i]}</a></br><font color="#C0C0C0">({$jaZrj[$i]})</font></td>
A;
		echo $html;
	}
$html=<<<A
		<td></td>
		<td style="text-align:center;"><a href="task_bumen_2_inquire_ja?month=__">{$jaFinishAll}</a></br><font color="#C0C0C0">({$jaZrjAll})</font></td>
		</tr>
	<tr>
A;
	echo $html;
	$jaDy01=@round(($ja[0]/$jaJanAllChushi)*100,2).'%';
	$jaDy02=@round(($ja[1]/$jaFebAllChushi)*100,2).'%';
	$jaDy03=@round(($ja[2]/$jaMarAllChushi)*100,2).'%';
	$jaDy04=@round(($ja[3]/$jaAprAllChushi)*100,2).'%';
	$jaDy05=@round(($ja[4]/$jaMayAllChushi)*100,2).'%';
	$jaDy06=@round(($ja[5]/$jaJunAllChushi)*100,2).'%';
	$jaDy07=@round(($ja[6]/$jaJulAllChushi)*100,2).'%';
	$jaDy08=@round(($ja[7]/$jaAugAllChushi)*100,2).'%';
	$jaDy09=@round(($ja[8]/$jaSepAllChushi)*100,2).'%';
	$jaDy10=@round(($ja[9]/$jaOctAllChushi)*100,2).'%';
	$jaDy11=@round(($ja[10]/$jaNovAllChushi)*100,2).'%';
	$jaDy12=@round(($ja[11]/$jaDecAllChushi)*100,2).'%';
	$jaDy=@round(($jaFinishAll/$jaTaskAllChushi)*100,2).'%';
	$isjaDy01=($jaDy01<85 or $jaDy01>150) ? "red" : "";
	$isjaDy02=($jaDy02<85 or $jaDy02>150) ? "red" : "";
	$isjaDy03=($jaDy03<85 or $jaDy03>150) ? "red" : "";
	$isjaDy04=($jaDy04<85 or $jaDy04>150) ? "red" : "";
	$isjaDy05=($jaDy05<85 or $jaDy05>150) ? "red" : "";
	$isjaDy06=($jaDy06<85 or $jaDy06>150) ? "red" : "";
	$isjaDy07=($jaDy07<85 or $jaDy07>150) ? "red" : "";
	$isjaDy08=($jaDy08<85 or $jaDy08>150) ? "red" : "";
	$isjaDy09=($jaDy09<85 or $jaDy09>150) ? "red" : "";
	$isjaDy10=($jaDy10<85 or $jaDy10>150) ? "red" : "";
	$isjaDy11=($jaDy11<85 or $jaDy11>150) ? "red" : "";
	$isjaDy12=($jaDy12<85 or $jaDy12>150) ? "red" : "";
$html=<<<A
		<td style="text-align:center;">当月完成率</td>
		<td style="text-align:center;color:$isjaDy01;" >{$jaDy01}</td>
		<td style="text-align:center;color:$isjaDy02;" >{$jaDy02}</td>
		<td style="text-align:center;color:$isjaDy03;" >{$jaDy03}</td>
		<td style="text-align:center;color:$isjaDy04;" >{$jaDy04}</td>
		<td style="text-align:center;color:$isjaDy05;" >{$jaDy05}</td>
		<td style="text-align:center;color:$isjaDy06;" >{$jaDy06}</td>
		<td style="text-align:center;color:$isjaDy07;" >{$jaDy07}</td>
		<td style="text-align:center;color:$isjaDy08;" >{$jaDy08}</td>
		<td style="text-align:center;color:$isjaDy09;" >{$jaDy09}</td>
		<td style="text-align:center;color:$isjaDy10;" >{$jaDy10}</td>
		<td style="text-align:center;color:$isjaDy11;" >{$jaDy11}</td>
		<td style="text-align:center;color:$isjaDy12;" >{$jaDy12}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$jaDy}</td>
			</tr>
	<tr>
A;
	echo $html;
	$jaLj01=@round(($ja[0]/$jaJanAllChushi)*100,2).'%';
	$jaLj02=@round((($ja[0]+$ja[1])/($jaJanAllChushi+$jaFebAllChushi))*100,2).'%';
	$jaLj03=@round((($ja[0]+$ja[1]+$ja[2])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi))*100,2).'%';
	$jaLj04=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi+$jaAprAllChushi))*100,2).'%';
	$jaLj05=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi+$jaAprAllChushi+$jaMayAllChushi))*100,2).'%';
	$jaLj06=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi+$jaAprAllChushi+$jaMayAllChushi+$jaJunAllChushi))*100,2).'%';
	$jaLj07=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi+$jaAprAllChushi+$jaMayAllChushi+$jaJunAllChushi+$jaJulAllChushi))*100,2).'%';
	$jaLj08=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi+$jaAprAllChushi+$jaMayAllChushi+$jaJunAllChushi+$jaJulAllChushi+$jaAugAllChushi))*100,2).'%';
	$jaLj09=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi+$jaAprAllChushi+$jaMayAllChushi+$jaJunAllChushi+$jaJulAllChushi+$jaAugAllChushi+$jaSepAllChushi))*100,2).'%';
	$jaLj10=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi+$jaAprAllChushi+$jaMayAllChushi+$jaJunAllChushi+$jaJulAllChushi+$jaAugAllChushi+$jaSepAllChushi+$jaOctAllChushi))*100,2).'%';
	$jaLj11=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9]+$ja[10])/($jaJanAllChushi+$jaFebAllChushi+$jaMarAllChushi+$jaAprAllChushi+$jaMayAllChushi+$jaJunAllChushi+$jaJulAllChushi+$jaAugAllChushi+$jaSepAllChushi+$jaOctAllChushi+$jaNovAllChushi))*100,2).'%';
	$jaLj12=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9]+$ja[10]+$ja[11])/$jaTaskAllChushi)*100,2).'%';
	$jaLj=@round(($jaFinishAll/$jaTaskAllChushi)*100,2).'%';
	$isJaDonw01=($jaLj01<85 or $jaLj01>110) ? "red" : "";
	$isJaDonw02=($jaLj02<85 or $jaLj02>110)? "red" : "";
	$isJaDonw03=($jaLj03<85 or $jaLj03>110)? "red" : "";
	$isJaDonw04=($jaLj04<90 or $jaLj04>110)? "red" : "";
	$isJaDonw05=($jaLj05<90 or $jaLj05>110)? "red" : "";
	$isJaDonw06=($jaLj06<90 or $jaLj06>110)? "red" : "";
	$isJaDonw07=($jaLj07<95 or $jaLj07>110)? "red" : "";
	$isJaDonw08=($jaLj08<95 or $jaLj08>110)? "red" : "";
	$isJaDonw09=($jaLj09<95 or $jaLj09>110)? "red" : "";
	$isJaDonw10=($jaLj10<100 or $jaLj10>110)? "red" : "";
	$isJaDonw11=($jaLj11<100 or $jaLj11>110)? "red" : "";
	$isJaDonw12=($jaLj12<100 or $jaLj12>110)? "red" : "";
$html=<<<A
		<td style="text-align:center;">累计完成率</td>
		<td style="text-align:center;color:$isJaDonw01;">{$jaLj01}</td>
		<td style="text-align:center;color:$isJaDonw02;">{$jaLj02}</td>
		<td style="text-align:center;color:$isJaDonw03;">{$jaLj03}</td>
		<td style="text-align:center;color:$isJaDonw04;">{$jaLj04}</td>
		<td style="text-align:center;color:$isJaDonw05;">{$jaLj05}</td>
		<td style="text-align:center;color:$isJaDonw06;">{$jaLj06}</td>
		<td style="text-align:center;color:$isJaDonw07;">{$jaLj07}</td>
		<td style="text-align:center;color:$isJaDonw08;">{$jaLj08}</td>
		<td style="text-align:center;color:$isJaDonw09;">{$jaLj09}</td>
		<td style="text-align:center;color:$isJaDonw10;">{$jaLj10}</td>
		<td style="text-align:center;color:$isJaDonw11;">{$jaLj11}</td>
		<td style="text-align:center;color:$isJaDonw12;">{$jaLj12}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$jaLj}</td>
	</tr>
	<tr>
A;
	echo $html;
	$jaNd01=@round(($ja[0]/$jaTaskAllChushi)*100,2).'%';
	$jaNd02=@round((($ja[0]+$ja[1])/$jaTaskAllChushi)*100,2).'%';
	$jaNd03=@round((($ja[0]+$ja[1]+$ja[2])/$jaTaskAllChushi)*100,2).'%';
	$jaNd04=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3])/$jaTaskAllChushi)*100,2).'%';
	$jaNd05=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4])/$jaTaskAllChushi)*100,2).'%';
	$jaNd06=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5])/$jaTaskAllChushi)*100,2).'%';
	$jaNd07=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6])/$jaTaskAllChushi)*100,2).'%';
	$jaNd08=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7])/$jaTaskAllChushi)*100,2).'%';
	$jaNd09=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8])/$jaTaskAllChushi)*100,2).'%';
	$jaNd10=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9])/$jaTaskAllChushi)*100,2).'%';
	$jaNd11=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9]+$ja[10])/$jaTaskAllChushi)*100,2).'%';
	$jaNd12=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9]+$ja[10]+$ja[11])/$jaTaskAllChushi)*100,2).'%';
	$jaNd=@round(($jaFinishAll/$jaTaskAllChushi)*100,2).'%';	
$html=<<<A
		<td style="text-align:center;">年度完成率</td>
		<td style="text-align:center;">{$jaNd01}</td>
		<td style="text-align:center;">{$jaNd02}</td>
		<td style="text-align:center;">{$jaNd03}</td>
		<td style="text-align:center;">{$jaNd04}</td>
		<td style="text-align:center;">{$jaNd05}</td>
		<td style="text-align:center;">{$jaNd06}</td>
		<td style="text-align:center;">{$jaNd07}</td>
		<td style="text-align:center;">{$jaNd08}</td>
		<td style="text-align:center;">{$jaNd09}</td>
		<td style="text-align:center;">{$jaNd10}</td>
		<td style="text-align:center;">{$jaNd11}</td>
		<td style="text-align:center;">{$jaNd12}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$jaNd}</td>
	</tr>
A;
	echo $html;	
	//查询当月首次结案授权自然件
		$sq=array();
		for($i=0;$i<12;$i++){
		$querySq="select count(id) from finish_task_new where (workFor=$workFor or workFor in (select id from org where fatherId=$workFor)) and type='普通授权' and typeName not in('110') and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultSq=execute($link,$querySq);
		$dataSq=mysqli_fetch_assoc($resultSq);
		$sq[$i]=$dataSq['count(id)'];
		}
		$sqAll=array_sum($sq);
	$sqDy01=@round(($sq[0]/$jaZrj[0])*100,2).'%';
	$sqDy02=@round(($sq[1]/$jaZrj[1])*100,2).'%';
	$sqDy03=@round(($sq[2]/$jaZrj[2])*100,2).'%';
	$sqDy04=@round(($sq[3]/$jaZrj[3])*100,2).'%';
	$sqDy05=@round(($sq[4]/$jaZrj[4])*100,2).'%';
	$sqDy06=@round(($sq[5]/$jaZrj[5])*100,2).'%';
	$sqDy07=@round(($sq[6]/$jaZrj[6])*100,2).'%';
	$sqDy08=@round(($sq[7]/$jaZrj[7])*100,2).'%';
	$sqDy09=@round(($sq[8]/$jaZrj[8])*100,2).'%';
	$sqDy10=@round(($sq[9]/$jaZrj[9])*100,2).'%';
	$sqDy11=@round(($sq[10]/$jaZrj[10])*100,2).'%';
	$sqDy12=@round(($sq[11]/$jaZrj[11])*100,2).'%';
	$sqDy=@round(($sqAll/$jaZrjAll)*100,2).'%';
$html=<<<A
		<tr>
		<td style="text-align:center;">当月授权率</td>
		<td style="text-align:center;">{$sqDy01}</td>
		<td style="text-align:center;">{$sqDy02}</td>
		<td style="text-align:center;">{$sqDy03}</td>
		<td style="text-align:center;">{$sqDy04}</td>
		<td style="text-align:center;">{$sqDy05}</td>
		<td style="text-align:center;">{$sqDy06}</td>
		<td style="text-align:center;">{$sqDy07}</td>
		<td style="text-align:center;">{$sqDy08}</td>
		<td style="text-align:center;">{$sqDy09}</td>
		<td style="text-align:center;">{$sqDy10}</td>
		<td style="text-align:center;">{$sqDy11}</td>
		<td style="text-align:center;">{$sqDy12}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$sqDy}</td>
			</tr>
A;
	echo $html;
		//查询当月首次结案驳回自然件
		$bh=array();
		for($i=0;$i<12;$i++){
		$queryBh="select count(id) from finish_task_new where (workFor=$workFor or workFor in (select id from org where fatherId=$workFor)) and type='普通驳回' and typeName not in('110') and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultBh=execute($link,$queryBh);
		$dataBh=mysqli_fetch_assoc($resultBh);
		$bh[$i]=$dataBh['count(id)'];
		}
		$bhAll=array_sum($bh);
	$bhDy01=@round(($bh[0]/$jaZrj[0])*100,2).'%';
	$bhDy02=@round(($bh[1]/$jaZrj[1])*100,2).'%';
	$bhDy03=@round(($bh[2]/$jaZrj[2])*100,2).'%';
	$bhDy04=@round(($bh[3]/$jaZrj[3])*100,2).'%';
	$bhDy05=@round(($bh[4]/$jaZrj[4])*100,2).'%';
	$bhDy06=@round(($bh[5]/$jaZrj[5])*100,2).'%';
	$bhDy07=@round(($bh[6]/$jaZrj[6])*100,2).'%';
	$bhDy08=@round(($bh[7]/$jaZrj[7])*100,2).'%';
	$bhDy09=@round(($bh[8]/$jaZrj[8])*100,2).'%';
	$bhDy10=@round(($bh[9]/$jaZrj[9])*100,2).'%';
	$bhDy11=@round(($bh[10]/$jaZrj[10])*100,2).'%';
	$bhDy12=@round(($bh[11]/$jaZrj[11])*100,2).'%';
	$bhDy=@round(($bhAll/$jaZrjAll)*100,2).'%';
$html=<<<A
		<tr>
		<td style="text-align:center;">当月驳回率</td>
		<td style="text-align:center;">{$bhDy01}</td>
		<td style="text-align:center;">{$bhDy02}</td>
		<td style="text-align:center;">{$bhDy03}</td>
		<td style="text-align:center;">{$bhDy04}</td>
		<td style="text-align:center;">{$bhDy05}</td>
		<td style="text-align:center;">{$bhDy06}</td>
		<td style="text-align:center;">{$bhDy07}</td>
		<td style="text-align:center;">{$bhDy08}</td>
		<td style="text-align:center;">{$bhDy09}</td>
		<td style="text-align:center;">{$bhDy10}</td>
		<td style="text-align:center;">{$bhDy11}</td>
		<td style="text-align:center;">{$bhDy12}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$bhDy}</td>
			</tr>
A;
	echo $html;
		//查询当月首次结案视撤自然件
		$sc=array();
		for($i=0;$i<12;$i++){
		$querySc="select count(id) from finish_task_new where (workFor=$workFor or workFor in (select id from org where fatherId=$workFor)) and type='视撤结案' and typeName not in('110') and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultSc=execute($link,$querySc);
		$dataSc=mysqli_fetch_assoc($resultSc);
		$sc[$i]=$dataSc['count(id)'];
		}
		$scAll=array_sum($sc);
	$scDy01=@round(($sc[0]/$jaZrj[0])*100,2).'%';
	$scDy02=@round(($sc[1]/$jaZrj[1])*100,2).'%';
	$scDy03=@round(($sc[2]/$jaZrj[2])*100,2).'%';
	$scDy04=@round(($sc[3]/$jaZrj[3])*100,2).'%';
	$scDy05=@round(($sc[4]/$jaZrj[4])*100,2).'%';
	$scDy06=@round(($sc[5]/$jaZrj[5])*100,2).'%';
	$scDy07=@round(($sc[6]/$jaZrj[6])*100,2).'%';
	$scDy08=@round(($sc[7]/$jaZrj[7])*100,2).'%';
	$scDy09=@round(($sc[8]/$jaZrj[8])*100,2).'%';
	$scDy10=@round(($sc[9]/$jaZrj[9])*100,2).'%';
	$scDy11=@round(($sc[10]/$jaZrj[10])*100,2).'%';
	$scDy12=@round(($sc[11]/$jaZrj[11])*100,2).'%';
	$scDy=@round(($scAll/$jaZrjAll)*100,2).'%';
$html=<<<A
		<tr>
		<td style="text-align:center;">当月视撤率</td>
		<td style="text-align:center;">{$scDy01}</td>
		<td style="text-align:center;">{$scDy02}</td>
		<td style="text-align:center;">{$scDy03}</td>
		<td style="text-align:center;">{$scDy04}</td>
		<td style="text-align:center;">{$scDy05}</td>
		<td style="text-align:center;">{$scDy06}</td>
		<td style="text-align:center;">{$scDy07}</td>
		<td style="text-align:center;">{$scDy08}</td>
		<td style="text-align:center;">{$scDy09}</td>
		<td style="text-align:center;">{$scDy10}</td>
		<td style="text-align:center;">{$scDy11}</td>
		<td style="text-align:center;">{$scDy12}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;">{$scDy}</td>
			</tr>
		<tr><td colspan="15">注：部门计划量为分解任务量</td></tr>
		</table>
A;
	echo $html;
//查询当月出案池数据
$cacUpdate=$dataFinalDay['updateTime']==0 ? "本月未更新" : $dataFinalDay['updateTime'];
$html=<<<A
<div class="title">{$year}年{$thisMonth}月出案日前出案池数据（更新时间：{$cacUpdate}）；本月最后出案日：<font style="color:{$color};">{$dataFinalDay['finalDay']}，还剩：{$leftDays}天</font></div>
A;
	echo $html;	
if($dataFinalDay['updateTime']<>0){
	$arrayOrgName=array();
	$queryOrgName0="select orgName from org where id={$adminOrg}";
	$resultOrgName0=execute($link,$queryOrgName0);
	$dataOrgName0=mysqli_fetch_assoc($resultOrgName0);
	$arrayOrgName="'专利审查协作江苏中心{$dataOrgName0['orgName']}'";
	$queryOrgName1="select orgName from org where fatherId={$adminOrg}";
	$resultOrgName1=execute($link,$queryOrgName1);
	while($dataOrgName1=mysqli_fetch_assoc($resultOrgName1)){
		$arrayOrgName="{$arrayOrgName},'专利审查协作江苏中心{$dataOrgName0['orgName']}{$dataOrgName1['orgName']}'";
	}
//出案日前一通
	$queryYtCac1="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType='一通出案' and chuanchi.ap like '____1________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.orgName in({$arrayOrgName})";
	$resultYtCac1=execute($link,$queryYtCac1);
	$dataYtCac1=mysqli_fetch_assoc($resultYtCac1);
	$queryYtCac8="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType='一通出案' and chuanchi.ap like '____8________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.orgName in({$arrayOrgName})";
	$resultYtCac8=execute($link,$queryYtCac8);
	$dataYtCac8=mysqli_fetch_assoc($resultYtCac8);
	$ytCac=ROUND($dataYtCac1['sum']+$dataYtCac8['sum']*0.8,3);
	$i=$thisMonth-1;
	$ytYc=$ytCac+$yt[$i];
	$arrayYt=array($ytJanAllChushi,$ytFebAllChushi,$ytMarAllChushi,$ytAprAllChushi,$ytMayAllChushi,$ytJunAllChushi,$ytJulAllChushi,$ytAugAllChushi,$ytSepAllChushi,$ytOctAllChushi,$ytNovAllChushi,$ytDecAllChushi);
	$ytDyYc=@round(($ytYc/$arrayYt[$i])*100,2).'%';
	$ytCountLjYc=0;
	$ytTaskLj=0;
	for($a=0;$a<=$i;$a++){
		$ytCountLjYc=$yt[$a]+$ytCountLjYc;
		$ytTaskLj=$ytTaskLj+$arrayYt[$a];
	}
	if($i==11){
		$ytTaskLj=$ytTaskAllChushi;
	}
	$ytCountLjYc=$ytCountLjYc+$ytCac;
	$ytLjYc=@round(($ytCountLjYc/$ytTaskLj)*100,2).'%';
//出案日前结案
	$queryJa1Cac1="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType in ('普通驳回','普通授权') and chuanchi.ap like '____1________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.orgName in({$arrayOrgName})";
	$resultJa1Cac1=execute($link,$queryJa1Cac1);
	$dataJa1Cac1=mysqli_fetch_assoc($resultJa1Cac1);
	$queryJa1Cac8="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType in ('普通驳回','普通授权') and chuanchi.ap like '____8________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.orgName in({$arrayOrgName})";
	$resultJa1Cac8=execute($link,$queryJa1Cac8);
	$dataJa1Cac8=mysqli_fetch_assoc($resultJa1Cac8);
	$queryJa2Cac1="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType in ('二次结案驳回','二次结案授权','前置审查') and chuanchi.ap like '____1________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.orgName in({$arrayOrgName})";
	$resultJa2Cac1=execute($link,$queryJa2Cac1);
	$dataJa2Cac1=mysqli_fetch_assoc($resultJa2Cac1);
	$queryJa2Cac8="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType in ('二次结案驳回','二次结案授权','前置审查') and chuanchi.ap like '____8________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.orgName in({$arrayOrgName})";
	$resultJa2Cac8=execute($link,$queryJa2Cac8);
	$dataJa2Cac8=mysqli_fetch_assoc($resultJa2Cac8);
	$querySqCacZrj="select count(id) from chuanchi where chuanType='普通授权' and outTime<='{$dataFinalDay['finalDay']}' and orgName in({$arrayOrgName})";
	$resultSqCacZrj=execute($link,$querySqCacZrj);
	$dataSqCacZrj=mysqli_fetch_assoc($resultSqCacZrj);
	$queryBhCacZrj="select count(id) from chuanchi where chuanType='普通驳回' and outTime<='{$dataFinalDay['finalDay']}' and orgName in({$arrayOrgName})";
	$resultBhCacZrj=execute($link,$queryBhCacZrj);
	$dataBhCacZrj=mysqli_fetch_assoc($resultBhCacZrj);
	$jaCac=ROUND($dataJa1Cac1['sum']+$dataJa1Cac8['sum']*0.8+$dataJa2Cac1['sum']*0.5+$dataJa2Cac8['sum']*0.4,3);
	$jaYc=$jaCac+$ja[$i];
	$sqYcZrj=$dataSqCacZrj['count(id)']+$sq[$i];
	$bhYcZrj=$dataBhCacZrj['count(id)']+$bh[$i];
	$scYcZrj=$sc[$i];
	$jaYcZrj=$dataSqCacZrj['count(id)']+$dataBhCacZrj['count(id)']+$jaZrj[$i];
	$arrayJa=array($jaJanAllChushi,$jaFebAllChushi,$jaMarAllChushi,$jaAprAllChushi,$jaMayAllChushi,$jaJunAllChushi,$jaJulAllChushi,$jaAugAllChushi,$jaSepAllChushi,$jaOctAllChushi,$jaNovAllChushi,$jaDecAllChushi);
	$jaDyYc=@round(($jaYc/$arrayJa[$i])*100,2).'%';
	$jaCountLjYc=0;
	$jaTaskLj=0;
	for($a=0;$a<=$i;$a++){
		$jaCountLjYc=$ja[$a]+$jaCountLjYc;
		$jaTaskLj=$jaTaskLj+$arrayJa[$a];
	}
	if($i==11){
		$jaTaskLj=$jaTaskAllChushi;
	}
	$jaCountLjYc=$jaCountLjYc+$jaCac;
	$jaLjYc=@round(($jaCountLjYc/$jaTaskLj)*100,2).'%';
	$sqYcAll=$sqAll+$dataSqCacZrj['count(id)'];
	$bhYcAll=$bhAll+$dataBhCacZrj['count(id)'];	
	$scYcAll=$scAll;
	$jaZrjYcAll=$jaZrjAll+$dataSqCacZrj['count(id)']+$dataBhCacZrj['count(id)'];
	$sqDyYc=@round(($sqYcZrj/$jaYcZrj)*100,2).'%';
	$bhDyYc=@round(($bhYcZrj/$jaYcZrj)*100,2).'%';
	$scDyYc=@round(($scYcZrj/$jaYcZrj)*100,2).'%';
	$sqLjYc=@round(($sqYcAll/$jaZrjYcAll)*100,2).'%';
	$bhLjYc=@round(($bhYcAll/$jaZrjYcAll)*100,2).'%';
	$scLjYc=@round(($scYcAll/$jaZrjYcAll)*100,2).'%';
$html=<<<A
<table class="list">
		<tr>
		<th style="text-align:center;width:40px;"><a href="task_bumen_2_inquire_detailYc">查看详情</a></th>
		<th style="text-align:center;">出案池量</th>
		<th style="text-align:center;">当月计划量</th>
		<th style="text-align:center;">当月预计完成量</th>
		<th style="text-align:center;">当月预计完成率</th>
		<th style="text-align:center;">累计计划量</th>
		<th style="text-align:center;">累计预计完成量</th>
		<th style="text-align:center;">累计预计完成率</th>
		<th style="text-align:center;">出案池首次授权</th>
		<th style="text-align:center;">出案池首次驳回</th>
		<th style="text-align:center;">当月预计授权率</th>
		<th style="text-align:center;">当月预计驳回率</th>
		<th style="text-align:center;">当月预计视撤率</th>
		<th style="text-align:center;">累计预计授权率</th>
		<th style="text-align:center;">累计预计驳回率</th>
		<th style="text-align:center;">累计预计视撤率</th>
			</tr>
		<tr>
		<td style="text-align:center;">一通</td>
		<td style="text-align:center;">{$ytCac}</td>
		<td style="text-align:center;">{$arrayYt[$i]}</td>
		<td style="text-align:center;">{$ytYc}</td>
		<td style="text-align:center;">{$ytDyYc}</td>
		<td style="text-align:center;">{$ytTaskLj}</td>
		<td style="text-align:center;">{$ytCountLjYc}</td>
		<td style="text-align:center;">{$ytLjYc}</td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;"></td>
		<td style="text-align:center;"></td>
			</tr>
		<tr>
		<td style="text-align:center;">结案</td>
		<td style="text-align:center;">{$jaCac}</td>
		<td style="text-align:center;">{$arrayJa[$i]}</td>
		<td style="text-align:center;">{$jaYc}</td>
		<td style="text-align:center;">{$jaDyYc}</td>
		<td style="text-align:center;">{$jaTaskLj}</td>
		<td style="text-align:center;">{$jaCountLjYc}</td>
		<td style="text-align:center;">{$jaLjYc}</td>
		<td style="text-align:center;">{$dataSqCacZrj['count(id)']}</td>
		<td style="text-align:center;">{$dataBhCacZrj['count(id)']}</td>
		<td style="text-align:center;">{$sqDyYc}</td>
		<td style="text-align:center;">{$bhDyYc}</td>
		<td style="text-align:center;">{$scDyYc}</td>
		<td style="text-align:center;">{$sqLjYc}</td>
		<td style="text-align:center;">{$bhLjYc}</td>
		<td style="text-align:center;">{$scLjYc}</td>
			</tr>
						<tr>
	<td colspan="14">注：<font style="color:red;">系统统计截止时间至出案池数据更新时间之间的出案可能存在遗漏情况，数据仅供参考！</td>
	</tr>
		</table>
A;
	echo $html;	
	}	
}
		
	?>
	</div>