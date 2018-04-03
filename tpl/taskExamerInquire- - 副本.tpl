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
<div class="title">{$year}年个人工作量统计表（{$staffId}）；统计截止日期：{$tjTime}；本月最后出案日：<font style="color:{$color};">{$dataFinalDay['finalDay']}，还剩：{$leftDays}天</font></div>
A;
echo $html;
$query1="select ytJan,ytFeb,ytMar,ytApr,ytMay,ytJun,ytJul,ytAug,ytSep,ytOct,ytNov,ytDec,jaJan,jaFeb,jaMar,jaApr,jaMay,jaJun,jaJul,jaAug,jaSep,jaOct,jaNov,jaDec,adjust from task_conf where staffId=$staffId and year=$year";
$result1=execute($link,$query1);
$data1=mysqli_fetch_assoc($result1);
$ytTaskAll=$data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']+$data1['ytAug']+$data1['ytSep']+$data1['ytOct']+$data1['ytNov']+$data1['ytDec'];
$html=<<<A
<table class="list1">
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
	<tr>
A;
	echo $html;
	$ytLj01=@round(($yt[0]/$data1['ytJan'])*100,2).'%';
	$ytLj02=@round((($yt[0]+$yt[1])/($data1['ytJan']+$data1['ytFeb']))*100,2).'%';
	$ytLj03=@round((($yt[0]+$yt[1]+$yt[2])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']))*100,2).'%';
	$ytLj04=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']))*100,2).'%';
	$ytLj05=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']))*100,2).'%';
	$ytLj06=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']))*100,2).'%';
	$ytLj07=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']))*100,2).'%';
	$ytLj08=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']+$data1['ytAug']))*100,2).'%';
	$ytLj09=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']+$data1['ytAug']+$data1['ytSep']))*100,2).'%';
	$ytLj10=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']+$data1['ytAug']+$data1['ytSep']+$data1['ytOct']))*100,2).'%';
	$ytLj11=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9]+$yt[10])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']+$data1['ytAug']+$data1['ytSep']+$data1['ytOct']+$data1['ytNov']))*100,2).'%';
	$ytLj12=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9]+$yt[10]+$yt[11])/($data1['ytJan']+$data1['ytFeb']+$data1['ytMar']+$data1['ytApr']+$data1['ytMay']+$data1['ytJun']+$data1['ytJul']+$data1['ytAug']+$data1['ytSep']+$data1['ytOct']+$data1['ytNov']+$data1['ytDec']))*100,2).'%';
	$ytLj=@round(($ytFinishAll/$ytTaskAll)*100,2).'%';
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
		<td style="text-align:center;" >累计完成率</td>
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
		<td style="text-align:center;">{$ytLj}</td>
	</tr>
	<tr>
A;
	echo $html;
	$ytNd01=@round(($yt[0]/$ytTaskAll)*100,2).'%';
	$ytNd02=@round((($yt[0]+$yt[1])/$ytTaskAll)*100,2).'%';
	$ytNd03=@round((($yt[0]+$yt[1]+$yt[2])/$ytTaskAll)*100,2).'%';
	$ytNd04=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3])/$ytTaskAll)*100,2).'%';
	$ytNd05=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4])/$ytTaskAll)*100,2).'%';
	$ytNd06=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5])/$ytTaskAll)*100,2).'%';
	$ytNd07=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6])/$ytTaskAll)*100,2).'%';
	$ytNd08=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7])/$ytTaskAll)*100,2).'%';
	$ytNd09=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8])/$ytTaskAll)*100,2).'%';
	$ytNd10=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9])/$ytTaskAll)*100,2).'%';
	$ytNd11=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9]+$yt[10])/$ytTaskAll)*100,2).'%';
	$ytNd12=@round((($yt[0]+$yt[1]+$yt[2]+$yt[3]+$yt[4]+$yt[5]+$yt[6]+$yt[7]+$yt[8]+$yt[9]+$yt[10]+$yt[11])/$ytTaskAll)*100,2).'%';
	$ytNd=@round(($ytFinishAll/$ytTaskAll)*100,2).'%';	
$html=<<<A
		<td style="text-align:center;">年度完成率</td>
		<td style="text-align:center;" >{$ytNd01}</td>
		<td style="text-align:center;" >{$ytNd02}</td>
		<td style="text-align:center;" >{$ytNd03}</td>
		<td style="text-align:center;" >{$ytNd04}</td>
		<td style="text-align:center;" >{$ytNd05}</td>
		<td style="text-align:center;" >{$ytNd06}</td>
		<td style="text-align:center;" >{$ytNd07}</td>
		<td style="text-align:center;" >{$ytNd08}</td>
		<td style="text-align:center;" >{$ytNd09}</td>
		<td style="text-align:center;" >{$ytNd10}</td>
		<td style="text-align:center;" >{$ytNd11}</td>
		<td style="text-align:center;" >{$ytNd12}</td>
		<td style="text-align:center;" >{$ytNd}</td>
	</tr>
	<tr>
A;
	echo $html;
		$jaTaskAll=$data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']+$data1['jaJul']+$data1['jaAug']+$data1['jaSep']+$data1['jaOct']+$data1['jaNov']+$data1['jaDec']+$data1['adjust'];
		$JaFenjie=array($data1['jaJan'],$data1['jaFeb'],$data1['jaMar'],$data1['jaApr'],$data1['jaMay'],$data1['jaJun'],$data1['jaJul'],$data1['jaAug'],$data1['jaSep'],$data1['jaOct'],$data1['jaNov'],$data1['jaDec']);
$html=<<<A
		<td style="text-align:center;">结案计划量</td>
		<td style="text-align:center;" >{$data1['jaJan']}</td>
		<td style="text-align:center;" >{$data1['jaFeb']}</td>
		<td style="text-align:center;" >{$data1['jaMar']}</td>
		<td style="text-align:center;" >{$data1['jaApr']}</td>
		<td style="text-align:center;" >{$data1['jaMay']}</td>
		<td style="text-align:center;" >{$data1['jaJun']}</td>
		<td style="text-align:center;" >{$data1['jaJul']}</td>
		<td style="text-align:center;" >{$data1['jaAug']}</td>
		<td style="text-align:center;" >{$data1['jaSep']}</td>
		<td style="text-align:center;" >{$data1['jaOct']}</td>
		<td style="text-align:center;" >{$data1['jaNov']}</td>
		<td style="text-align:center;" >{$data1['jaDec']}</td>
		<td style="text-align:center;" >{$jaTaskAll}
A;
	echo $html;	
if($data1['adjust']<>0){
	echo "</br><font color='green'>({$data1['adjust']})</font>"; 
}
$html=<<<A
		</td>
	</tr>
	<tr>
A;
	echo $html;
		$month=array('01','02','03','04','05','06','07','08','09','10','11','12');
		$ja=array();
		for($i=0;$i<12;$i++){
		$query2="select sum(bzCount) from finish_task where staffId=$staffId and type in ('授权决定','驳回','通后视撤','前置审查','主动撤回','二次结案','PCT检索') and chuanTime like '{$year}-{$month[$i]}-__'";
		$result2=execute($link,$query2);
		$data2=mysqli_fetch_assoc($result2);
		$ja[$i]=ROUND($data2['sum(bzCount)'],3);
		}
		$jaFinishAll=array_sum($ja);
		//查询当月首次结案自然件
		$jaZrj=array();
		for($i=0;$i<12;$i++){
		$queryjaZrj="select count(id) from finish_task where staffId=$staffId and specificType in ('系统外首次结案补点','首次结案') and chuanTime like '{$year}-{$month[$i]}-__'";
		$resultjaZrj=execute($link,$queryjaZrj);
		$datajaZrj=mysqli_fetch_assoc($resultjaZrj);
		$queryjaZrjXz="select count(id) from finish_task where staffId=$staffId and specificType='系统外首次结案补点' and bzCount<0 and chuanTime like '{$year}-{$month[$i]}-__'";
		$resultjaZrjXz=execute($link,$queryjaZrjXz);
		$datajaZrjXz=mysqli_fetch_assoc($resultjaZrjXz);
		$jaZrj[$i]=$datajaZrj['count(id)']-2*$datajaZrjXz['count(id)'];
		}
		$jaZrjAll=array_sum($jaZrj);
$html=<<<A
		<td style="text-align:center;">结案完成量</br><font color="#C0C0C0">(首结自然件)</font></td>
A;
	echo $html; 		
		for($i=0;$i<12;$i++){
$html=<<<A
		<td style="text-align:center;" ><a href="task_examer_inquire_ja?month=$month[$i]">{$ja[$i]}</a></br><font color="#C0C0C0">({$jaZrj[$i]})</font></td>
A;
		echo $html;
		}
$html=<<<A
		<td style="text-align:center;" ><a href="task_examer_inquire_ja?month=__">{$jaFinishAll}</a></br><font color="#C0C0C0">({$jaZrjAll})</font></td>
					</tr>
	<tr>
A;
	echo $html; 
	$jaDy01=@round(($ja[0]/$data1['jaJan'])*100,2).'%';
	$jaDy02=@round(($ja[1]/$data1['jaFeb'])*100,2).'%';
	$jaDy03=@round(($ja[2]/$data1['jaMar'])*100,2).'%';
	$jaDy04=@round(($ja[3]/$data1['jaApr'])*100,2).'%';
	$jaDy05=@round(($ja[4]/$data1['jaMay'])*100,2).'%';
	$jaDy06=@round(($ja[5]/$data1['jaJun'])*100,2).'%';
	$jaDy07=@round(($ja[6]/$data1['jaJul'])*100,2).'%';
	$jaDy08=@round(($ja[7]/$data1['jaAug'])*100,2).'%';
	$jaDy09=@round(($ja[8]/$data1['jaSep'])*100,2).'%';
	$jaDy10=@round(($ja[9]/$data1['jaOct'])*100,2).'%';
	$jaDy11=@round(($ja[10]/$data1['jaNov'])*100,2).'%';
	$jaDy12=@round(($ja[11]/$data1['jaDec'])*100,2).'%';
	$jaDy=@round(($jaFinishAll/$jaTaskAll)*100,2).'%';
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
		<td style="text-align:center;" >{$jaDy}</td>
			</tr>
	<tr>
A;
	echo $html;
	$jaLj01=@round(($ja[0]/$data1['jaJan'])*100,2);
	$jaLj02=@round((($ja[0]+$ja[1])/($data1['jaJan']+$data1['jaFeb']))*100,2);
	$jaLj03=@round((($ja[0]+$ja[1]+$ja[2])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']))*100,2);
	$jaLj04=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']))*100,2);
	$jaLj05=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']))*100,2);
	$jaLj06=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']))*100,2);
	$jaLj07=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']+$data1['jaJul']))*100,2);
	$jaLj08=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']+$data1['jaJul']+$data1['jaAug']))*100,2);
	$jaLj09=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']+$data1['jaJul']+$data1['jaAug']+$data1['jaSep']))*100,2);
	$jaLj10=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']+$data1['jaJul']+$data1['jaAug']+$data1['jaSep']+$data1['jaOct']))*100,2);
	$jaLj11=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9]+$ja[10])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']+$data1['jaJul']+$data1['jaAug']+$data1['jaSep']+$data1['jaOct']+$data1['jaNov']))*100,2);
	$jaLj12=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9]+$ja[10]+$ja[11])/($data1['jaJan']+$data1['jaFeb']+$data1['jaMar']+$data1['jaApr']+$data1['jaMay']+$data1['jaJun']+$data1['jaJul']+$data1['jaAug']+$data1['jaSep']+$data1['jaOct']+$data1['jaNov']+$data1['jaDec']))*100,2);
	$jaLj=@round(($jaFinishAll/$jaTaskAll)*100,2);
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
	$jaLjLvEC=array($jaLj01,$jaLj02,$jaLj03,$jaLj04,$jaLj05,$jaLj06,$jaLj07,$jaLj08,$jaLj09,$jaLj10,$jaLj11,$jaLj12);
$html=<<<A
		<td style="text-align:center;">累计完成率</td>
		<td style="text-align:center;color:$isJaDonw01;">{$jaLj01}%</td>
		<td style="text-align:center;color:$isJaDonw02;">{$jaLj02}%</td>
		<td style="text-align:center;color:$isJaDonw03;">{$jaLj03}%</td>
		<td style="text-align:center;color:$isJaDonw04;">{$jaLj04}%</td>
		<td style="text-align:center;color:$isJaDonw05;">{$jaLj05}%</td>
		<td style="text-align:center;color:$isJaDonw06;">{$jaLj06}%</td>
		<td style="text-align:center;color:$isJaDonw07;">{$jaLj07}%</td>
		<td style="text-align:center;color:$isJaDonw08;">{$jaLj08}%</td>
		<td style="text-align:center;color:$isJaDonw09;">{$jaLj09}%</td>
		<td style="text-align:center;color:$isJaDonw10;">{$jaLj10}%</td>
		<td style="text-align:center;color:$isJaDonw11;">{$jaLj11}%</td>
		<td style="text-align:center;color:$isJaDonw12;">{$jaLj12}%</td>
		<td style="text-align:center;">{$jaLj}%</td>
	</tr>
	<tr>
A;
	echo $html;
	$jaNd01=@round(($ja[0]/$jaTaskAll)*100,2).'%';
	$jaNd02=@round((($ja[0]+$ja[1])/$jaTaskAll)*100,2).'%';
	$jaNd03=@round((($ja[0]+$ja[1]+$ja[2])/$jaTaskAll)*100,2).'%';
	$jaNd04=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3])/$jaTaskAll)*100,2).'%';
	$jaNd05=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4])/$jaTaskAll)*100,2).'%';
	$jaNd06=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5])/$jaTaskAll)*100,2).'%';
	$jaNd07=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6])/$jaTaskAll)*100,2).'%';
	$jaNd08=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7])/$jaTaskAll)*100,2).'%';
	$jaNd09=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8])/$jaTaskAll)*100,2).'%';
	$jaNd10=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9])/$jaTaskAll)*100,2).'%';
	$jaNd11=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9]+$ja[10])/$jaTaskAll)*100,2).'%';
	$jaNd12=@round((($ja[0]+$ja[1]+$ja[2]+$ja[3]+$ja[4]+$ja[5]+$ja[6]+$ja[7]+$ja[8]+$ja[9]+$ja[10]+$ja[11])/$jaTaskAll)*100,2).'%';
	$jaNd=@round(($jaFinishAll/$jaTaskAll)*100,2).'%';	
$html=<<<A
		<td style="text-align:center;">年度完成率</td>
		<td style="text-align:center;" >{$jaNd01}</td>
		<td style="text-align:center;" >{$jaNd02}</td>
		<td style="text-align:center;" >{$jaNd03}</td>
		<td style="text-align:center;" >{$jaNd04}</td>
		<td style="text-align:center;" >{$jaNd05}</td>
		<td style="text-align:center;" >{$jaNd06}</td>
		<td style="text-align:center;" >{$jaNd07}</td>
		<td style="text-align:center;" >{$jaNd08}</td>
		<td style="text-align:center;" >{$jaNd09}</td>
		<td style="text-align:center;" >{$jaNd10}</td>
		<td style="text-align:center;" >{$jaNd11}</td>
		<td style="text-align:center;" >{$jaNd12}</td>
		<td style="text-align:center;" >{$jaNd}</td>
		</tr>
A;
	echo $html;
		//查询当月首次结案授权自然件
		$sq=array();
		for($i=0;$i<12;$i++){
		$querySq="select count(id) from finish_task where staffId=$staffId and type='授权决定' and specificType='首次结案' and chuanTime like '{$year}-{$month[$i]}-__'";
		$resultSq=execute($link,$querySq);
		$dataSq=mysqli_fetch_assoc($resultSq);
		$querySqXz="select count(id) from finish_task where staffId=$staffId and type='授权决定' and specificType='系统外首次结案补点' and bzCount<0 and chuanTime like '{$year}-{$month[$i]}-__'";
		$resultSqXz=execute($link,$querySqXz);
		$dataSqXz=mysqli_fetch_assoc($resultSqXz);
		$sq[$i]=$dataSq['count(id)']-$dataSqXz['count(id)'];
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
		<td style="text-align:center;" >{$sqDy01}</td>
		<td style="text-align:center;" >{$sqDy02}</td>
		<td style="text-align:center;" >{$sqDy03}</td>
		<td style="text-align:center;" >{$sqDy04}</td>
		<td style="text-align:center;" >{$sqDy05}</td>
		<td style="text-align:center;" >{$sqDy06}</td>
		<td style="text-align:center;" >{$sqDy07}</td>
		<td style="text-align:center;" >{$sqDy08}</td>
		<td style="text-align:center;" >{$sqDy09}</td>
		<td style="text-align:center;" >{$sqDy10}</td>
		<td style="text-align:center;" >{$sqDy11}</td>
		<td style="text-align:center;" >{$sqDy12}</td>
		<td style="text-align:center;" >{$sqDy}</td>
			</tr>
A;
	echo $html;
		//查询当月首次结案驳回自然件
		$bh=array();
		for($i=0;$i<12;$i++){
		$queryBh="select count(id) from finish_task where staffId=$staffId and type='驳回' and specificType='首次结案' and chuanTime like '{$year}-{$month[$i]}-__'";
		$resultBh=execute($link,$queryBh);
		$dataBh=mysqli_fetch_assoc($resultBh);
		$queryBhXz="select count(id) from finish_task where staffId=$staffId and type='驳回' and specificType='系统外首次结案补点' and bzCount<0 and chuanTime like '{$year}-{$month[$i]}-__'";
		$resultBhXz=execute($link,$queryBhXz);
		$dataBhXz=mysqli_fetch_assoc($resultBhXz);
		$bh[$i]=$dataBh['count(id)']-$dataBhXz['count(id)'];
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
		<td style="text-align:center;" >{$bhDy01}</td>
		<td style="text-align:center;" >{$bhDy02}</td>
		<td style="text-align:center;" >{$bhDy03}</td>
		<td style="text-align:center;" >{$bhDy04}</td>
		<td style="text-align:center;" >{$bhDy05}</td>
		<td style="text-align:center;" >{$bhDy06}</td>
		<td style="text-align:center;" >{$bhDy07}</td>
		<td style="text-align:center;" >{$bhDy08}</td>
		<td style="text-align:center;" >{$bhDy09}</td>
		<td style="text-align:center;" >{$bhDy10}</td>
		<td style="text-align:center;" >{$bhDy11}</td>
		<td style="text-align:center;" >{$bhDy12}</td>
		<td style="text-align:center;" >{$bhDy}</td>
			</tr>
A;
	echo $html;
		//查询当月首次结案视撤自然件
		$sc=array();
		for($i=0;$i<12;$i++){
		$querySc="select count(id) from finish_task where staffId=$staffId and type='通后视撤' and specificType='首次结案' and chuanTime like '{$year}-{$month[$i]}-__'";
		$resultSc=execute($link,$querySc);
		$dataSc=mysqli_fetch_assoc($resultSc);
		$queryScXz="select count(id) from finish_task where staffId=$staffId and type='通后视撤' and specificType='系统外首次结案补点' and bzCount<0 and chuanTime like '{$year}-{$month[$i]}-__'";
		$resultScXz=execute($link,$queryScXz);
		$dataScXz=mysqli_fetch_assoc($resultScXz);
		$sc[$i]=$dataSc['count(id)']-$dataScXz['count(id)'];
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
		<td style="text-align:center;" >{$scDy01}</td>
		<td style="text-align:center;" >{$scDy02}</td>
		<td style="text-align:center;" >{$scDy03}</td>
		<td style="text-align:center;" >{$scDy04}</td>
		<td style="text-align:center;" >{$scDy05}</td>
		<td style="text-align:center;" >{$scDy06}</td>
		<td style="text-align:center;" >{$scDy07}</td>
		<td style="text-align:center;" >{$scDy08}</td>
		<td style="text-align:center;" >{$scDy09}</td>
		<td style="text-align:center;" >{$scDy10}</td>
		<td style="text-align:center;" >{$scDy11}</td>
		<td style="text-align:center;" >{$scDy12}</td>
		<td style="text-align:center;" >{$scDy}</td>
			</tr>
	<tr>
	<td colspan="14">注：<font style="color:red;">红色</font>警示完成率较低，请审查员合理安排任务进度</td>
	</tr>	
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
//出案日前一通
	$queryStaff="select examId,name from staff where staffId={$staffId}";
	$resultStaff=execute($link,$queryStaff);
	$dataStaff=mysqli_fetch_assoc($resultStaff);
	$staff=$dataStaff['examId']."--".$dataStaff['name'];
	$queryYtCac1="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType='一通出案' and chuanchi.ap like '____1________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.staff='{$staff}'";
	$resultYtCac1=execute($link,$queryYtCac1);
	$dataYtCac1=mysqli_fetch_assoc($resultYtCac1);
	$queryYtCac8="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType='一通出案' and chuanchi.ap like '____8________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.staff='{$staff}'";
	$resultYtCac8=execute($link,$queryYtCac8);
	$dataYtCac8=mysqli_fetch_assoc($resultYtCac8);
	$ytCac=ROUND($dataYtCac1['sum']+$dataYtCac8['sum']*0.8,3);
	$i=$thisMonth-1;
	$ytYc=$ytCac+$yt[$i];
	$arrayYt=array($data1['ytJan'],$data1['ytFeb'],$data1['ytMar'],$data1['ytApr'],$data1['ytMay'],$data1['ytJun'],$data1['ytJul'],$data1['ytAug'],$data1['ytSep'],$data1['ytOct'],$data1['ytNov'],$data1['ytDec']);
	$ytDyYc=@round(($ytYc/$arrayYt[$i])*100,2).'%';
	$ytCountLjYc=0;
	$ytTaskLj=0;
	for($a=0;$a<=$i;$a++){
		$ytCountLjYc=$yt[$a]+$ytCountLjYc;
		$ytTaskLj=$ytTaskLj+$arrayYt[$a];
	}
	$ytCountLjYc=$ytCountLjYc+$ytCac;
	$ytLjYc=@round(($ytCountLjYc/$ytTaskLj)*100,2).'%';
//出案日前结案
	$queryJa1Cac1="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType in ('普通驳回','普通授权') and chuanchi.ap like '____1________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.staff='{$staff}'";
	$resultJa1Cac1=execute($link,$queryJa1Cac1);
	$dataJa1Cac1=mysqli_fetch_assoc($resultJa1Cac1);
	$queryJa1Cac8="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType in ('普通驳回','普通授权') and chuanchi.ap like '____8________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.staff='{$staff}'";
	$resultJa1Cac8=execute($link,$queryJa1Cac8);
	$dataJa1Cac8=mysqli_fetch_assoc($resultJa1Cac8);
	$queryJa2Cac1="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType in ('二次结案驳回','二次结案授权','前置审查') and chuanchi.ap like '____1________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.staff='{$staff}'";
	$resultJa2Cac1=execute($link,$queryJa2Cac1);
	$dataJa2Cac1=mysqli_fetch_assoc($resultJa2Cac1);
	$queryJa2Cac8="select sum(ic.count) sum from chuanchi left join ipc_count ic on chuanchi.ic=ic.IPC where chuanchi.chuanType in ('二次结案驳回','二次结案授权','前置审查') and chuanchi.ap like '____8________' and chuanchi.outTime<='{$dataFinalDay['finalDay']}' and chuanchi.staff='{$staff}'";
	$resultJa2Cac8=execute($link,$queryJa2Cac8);
	$dataJa2Cac8=mysqli_fetch_assoc($resultJa2Cac8);
	$querySqCacZrj="select count(id) from chuanchi where chuanType='普通授权' and outTime<='{$dataFinalDay['finalDay']}' and staff='{$staff}'";
	$resultSqCacZrj=execute($link,$querySqCacZrj);
	$dataSqCacZrj=mysqli_fetch_assoc($resultSqCacZrj);
	$queryBhCacZrj="select count(id) from chuanchi where chuanType='普通驳回' and outTime<='{$dataFinalDay['finalDay']}' and staff='{$staff}'";
	$resultBhCacZrj=execute($link,$queryBhCacZrj);
	$dataBhCacZrj=mysqli_fetch_assoc($resultBhCacZrj);
	$jaCac=ROUND($dataJa1Cac1['sum']+$dataJa1Cac8['sum']*0.8+$dataJa2Cac1['sum']*0.5+$dataJa2Cac8['sum']*0.4,3);
	$jaYc=$jaCac+$ja[$i];
	$sqYcZrj=$dataSqCacZrj['count(id)']+$sq[$i];
	$bhYcZrj=$dataBhCacZrj['count(id)']+$bh[$i];
	$scYcZrj=$sc[$i];
	$jaYcZrj=$dataSqCacZrj['count(id)']+$dataBhCacZrj['count(id)']+$jaZrj[$i];
	$arrayJa=array($data1['jaJan'],$data1['jaFeb'],$data1['jaMar'],$data1['jaApr'],$data1['jaMay'],$data1['jaJun'],$data1['jaJul'],$data1['jaAug'],$data1['jaSep'],$data1['jaOct'],$data1['jaNov'],$data1['jaDec']);
	$jaDyYc=@round(($jaYc/$arrayJa[$i])*100,2).'%';
	$jaCountLjYc=0;
	$jaTaskLj=0;
	for($a=0;$a<=$i;$a++){
		$jaCountLjYc=$ja[$a]+$jaCountLjYc;
		$jaTaskLj=$jaTaskLj+$arrayJa[$a];
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
		<th style="text-align:center;width:40px;"></th>
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
		<td style="text-align:center;"><a href="task_examer_inquire_ytYc">{$ytCac}</a></td>
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
		<td style="text-align:center;"><a href="task_examer_inquire_jaYc">{$jaCac}</a></td>
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
	/*确定ECharts左坐标最大值
		$maxJa=max($ja);		
		$maxJaFenjie=max($JaFenjie);
		$maxyAxis=max($maxJa,$maxJaFenjie);  //标准件最大量
		$part=$maxyAxis/6;					//6等分
		$partKX=sprintf("%E",$part);		//转换为科学计数法
		$partST=(string)$partKX;			//转换为字符串
		$mi1=ceil(substr($partKX,0,3));		//提取前三位向上近似
		$mi2=strstr($partST,"E");			//提取科学技术法数量级
		$mi=$mi1.$mi2;						//还原
		$maxyAxis=$mi*6;					//坐标轴最大值
		$mi=$maxyAxis/6;					//务必转一下格式
		//确定ECharts右坐标最大值
		$maxJaLjLv=max($jaLjLvEC);
		$part_2=$maxJaLjLv/6;					//6等分
		$partKX_2=sprintf("%E",$part_2);		//转换为科学计数法
		$partST_2=(string)$partKX_2;			//转换为字符串
		$mi1_2=ceil(substr($partKX_2,0,3));		//提取前三位向上近似
		$mi2_2=strstr($partST_2,"E");			//提取科学技术法数量级
		$mi_2=$mi1_2.$mi2_2;					//还原
		$maxyAxis_2=$mi_2*6;					//坐标轴最大值
		$mi_2=$maxyAxis_2/6;					//务必转一下格式
		*/
	?>
	<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="ECharts" style="width: 800px;height:400px;"></div>
    <script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('ECharts'));

        // 指定图表的配置项和数据
        var option = {
				tooltip: {
					trigger: 'axis',
					axisPointer: {
						type: 'cross',
						crossStyle: {
							color: '#999'
						}
					}
				},
				toolbox: {
					feature: {
						dataView: {show: true, readOnly: false},
						magicType: {show: true, type: ['line', 'bar']},
						restore: {show: true},
						saveAsImage: {show: true}
					}
				},
				legend: {
					data:['结案完成量','结案任务量','累计完成率']
				},
				xAxis: [
					{
						type: 'category',
						data: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
						axisPointer: {
							type: 'shadow'
						}
					}
				],
				yAxis: [
					{
						type: 'value',
						name: '标准件',
						axisLabel: {
							formatter: '{value}'
						}
					},
					{
						type: 'value',
						name: '累计完成率',
						axisLabel: {
							formatter: '{value} %'
						}
					}
				],
				series: [
					{
						name:'结案完成量',
						type:'bar',
						data:<?php echo json_encode($ja) ?>
					},
					{
						name:'结案任务量',
						type:'bar',
						data:<?php echo json_encode($JaFenjie) ?>
					},
					{
						name:'累计完成率',
						type:'line',
						yAxisIndex: 1,
						data:<?php echo json_encode($jaLjLvEC) ?>
					}
				]
			};
        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    </script>
	</div>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       