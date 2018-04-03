<div style="margin-top:55px;"></div>
	<div id="sidebar">
		<ul>
			<li>
				<div class="small_title">个人任务管理</div>
				<ul class="child">
                                    <!--<a href="taskExamerInquirePCT.tpl"></a> -->
					<li><a <?php if($_GET['content']=='taskExamerInquire' || substr($_GET['content'],0,16)=='finishListExamer' || $_GET['content']=='errorAdd'){echo 'class="current"';}?> href="task_examer_inquire">个人工作量查询</a></li>
					<li><a <?php if($_GET['content']=='taskExamerInquirePCT'){echo 'class="current"';}?> href="task_examer_inquire_PCT">PCT工作量查询</a></li>
					<li><a <?php if($_GET['content']=='taskExamerApp'){echo 'class="current"';}?> href="task_examer_app">个人任务量填报</a></li>
					<!--  <li><a <?php if($_GET['content']=='errorReplyList' || substr($_GET['content'],0,8)=='errorDel'){echo 'class="current"';}?> href="task_examer_inquire_error_list?page=1">任务量反馈/答复</a></li> -->
				</ul>
			</li>
			<?php
			include_once '/inc/config.inc.php';
			$link=connect();
			if(!$staffId=isLogin($link)['staffId']){
			skip('login','error','您未登录，请重新登录！');   //判断是否登录
			}else{
			$amdinOrg=isLogin($link)['adminOrg'];
			}
//获取可查询任务量的年份
	$queryPre="select MAX(chuanTime) from finish_task";
	$result=execute($link,$queryPre);
	$dataPre=mysqli_fetch_assoc($result);
	$this_year=substr($dataPre['MAX(chuanTime)'],0,4);
	$next_year=$this_year+1;
	$thisMonth=date("m");
	$errortext='';
//计算任务量统计表
if(isset($_POST['update'])){
	$year=$this_year;
	$month=array('01','02','03','04','05','06','07','08','09','10','11','12','13');
	$dateTime=date("Y-m-d H:i:s");
	//查询每个机构的任务量完成量
	$queryOrg="select id from org where isExamOrg=1";
	$resultOrg=execute($link,$queryOrg);
	while($dataOrg=mysqli_fetch_assoc($resultOrg)){
		$ytJan=array();
		$ytFeb=array();
		$ytMar=array();
		$ytApr=array();
		$ytMay=array();
		$ytJun=array();
		$ytJul=array();
		$ytAug=array();
		$ytSep=array();
		$ytOct=array();
		$ytNov=array();
		$ytDec=array();
		$jaJan=array();
		$jaFeb=array();
		$jaMar=array();
		$jaApr=array();
		$jaMay=array();
		$jaJun=array();
		$jaJul=array();
		$jaAug=array();
		$jaSep=array();
		$jaOct=array();
		$jaNov=array();
		$jaDec=array();
		$adjust=array();
		//查询确认的任务量
		$workFor=$dataOrg['id'];
		$query1="select tc.staffId,tc.ytJan,tc.ytFeb,tc.ytMar,tc.ytApr,tc.ytMay,tc.ytJun,tc.ytJul,tc.ytAug,tc.ytSep,tc.ytOct,tc.ytNov,tc.ytDec,tc.jaJan,tc.jaFeb,tc.jaMar,tc.jaApr,tc.jaMay,tc.jaJun,tc.jaJul,tc.jaAug,tc.jaSep,tc.jaOct,tc.jaNov,tc.jaDec,tc.adjust from task_conf tc,staff where tc.staffId=staff.staffId and tc.year=$year and staff.workFor=$workFor";
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
			$adjust[$data1['staffId']]=$data1['adjust'];
		}
		$ytAllChushi[0]=@array_sum($ytJan);
		$ytAllChushi[1]=@array_sum($ytFeb);
		$ytAllChushi[2]=@array_sum($ytMar);
		$ytAllChushi[3]=@array_sum($ytApr);
		$ytAllChushi[4]=@array_sum($ytMay);
		$ytAllChushi[5]=@array_sum($ytJun);
		$ytAllChushi[6]=@array_sum($ytJul);
		$ytAllChushi[7]=@array_sum($ytAug);
		$ytAllChushi[8]=@array_sum($ytSep);
		$ytAllChushi[9]=@array_sum($ytOct);
		$ytAllChushi[10]=@array_sum($ytNov);
		$ytAllChushi[11]=@array_sum($ytDec);
		$ytAllChushi[12]=0;
		$jaAllChushi[0]=@array_sum($jaJan);
		$jaAllChushi[1]=@array_sum($jaFeb);
		$jaAllChushi[2]=@array_sum($jaMar);
		$jaAllChushi[3]=@array_sum($jaApr);
		$jaAllChushi[4]=@array_sum($jaMay);
		$jaAllChushi[5]=@array_sum($jaJun);
		$jaAllChushi[6]=@array_sum($jaJul);
		$jaAllChushi[7]=@array_sum($jaAug);
		$jaAllChushi[8]=@array_sum($jaSep);
		$jaAllChushi[9]=@array_sum($jaOct);
		$jaAllChushi[10]=@array_sum($jaNov);
		$jaAllChushi[11]=@array_sum($jaDec);
		$jaAllChushi[12]=@array_sum($adjust);
		//查询一通完成量
		$yt=array();
		for($i=0;$i<12;$i++){
			$query2="select sum(bzCount) from finish_task where workFor={$workFor} and type='一通' and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
			$result2=execute($link,$query2);
			$data2=mysqli_fetch_assoc($result2);
			$yt[$i]=ROUND($data2['sum(bzCount)'],3);
			$query3Xz="select count(id) from finish_task where workFor={$workFor} and type='一通' and bzCount<0 and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
			$result3Xz=execute($link,$query3Xz);
			$data3Xz=mysqli_fetch_assoc($result3Xz);
			$query3="select count(id) from finish_task where workFor={$workFor} and type='一通' and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
			$result3=execute($link,$query3);
			$data3=mysqli_fetch_assoc($result3);
			$ytZiran[$i]=$data3['count(id)']-$data3Xz['count(id)']*2;
		}
		$yt[12]=0;
		$ytZiran[12]=0;
		//查询结案完成量
		$ja=array();
		for($i=0;$i<12;$i++){
			$query2="select sum(bzCount) from finish_task where workFor={$workFor} and type in ('授权决定','驳回','通后视撤','前置审查','主动撤回','二次结案','PCT检索') and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
			$result2=execute($link,$query2);
			$data2=mysqli_fetch_assoc($result2);
			$ja[$i]=ROUND($data2['sum(bzCount)'],3);
		}
		$ja[12]=0;
		//查询当月首次结案自然件
		$jaZrj=array();
		for($i=0;$i<12;$i++){	
		$queryjaZrj="select count(id) from finish_task where workFor=$workFor and specificType in ('系统外首次结案补点','首次结案') and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultjaZrj=execute($link,$queryjaZrj);
		$datajaZrj=mysqli_fetch_assoc($resultjaZrj);
		$queryjaZrjXz="select count(id) from finish_task where workFor=$workFor and specificType='系统外首次结案补点' and bzCount<0 and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultjaZrjXz=execute($link,$queryjaZrjXz);
		$datajaZrjXz=mysqli_fetch_assoc($resultjaZrjXz);
		$jaZrj[$i]=$datajaZrj['count(id)']-2*$datajaZrjXz['count(id)'];
		}
		$jaZrj[12]=0;
		//查询当月首次结案授权自然件
		$sq=array(); 
		for($i=0;$i<12;$i++){
		$querySq="select count(id) from finish_task where workFor=$workFor and type='授权决定' and specificType='首次结案' and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultSq=execute($link,$querySq);
		$dataSq=mysqli_fetch_assoc($resultSq);
		$querySqXz="select count(id) from finish_task where workFor=$workFor and type='授权决定' and specificType='系统外首次结案补点' and bzCount<0 and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultSqXz=execute($link,$querySqXz);
		$dataSqXz=mysqli_fetch_assoc($resultSqXz);
		$sq[$i]=$dataSq['count(id)']-$dataSqXz['count(id)'];
		}
		$sq[12]=0;
		//查询当月首次结案驳回自然件
		$bh=array();
		for($i=0;$i<12;$i++){
		$queryBh="select count(id) from finish_task where workFor=$workFor and type='驳回' and specificType='首次结案' and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultBh=execute($link,$queryBh);
		$dataBh=mysqli_fetch_assoc($resultBh);
		$queryBhXz="select count(id) from finish_task where workFor=$workFor and type='驳回' and specificType='系统外首次结案补点' and bzCount<0 and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultBhXz=execute($link,$queryBhXz);
		$dataBhXz=mysqli_fetch_assoc($resultBhXz);
		$bh[$i]=$dataBh['count(id)']-$dataBhXz['count(id)'];
		}
		$bh[12]=0;
		//查询当月首次结案视撤自然件
		$sc=array();
		for($i=0;$i<12;$i++){
		$querySc="select count(id) from finish_task where workFor=$workFor and type='通后视撤' and specificType='首次结案' and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultSc=execute($link,$querySc);
		$dataSc=mysqli_fetch_assoc($resultSc);
		$queryScXz="select count(id) from finish_task where workFor=$workFor and type='通后视撤' and specificType='系统外首次结案补点' and bzCount<0 and chuanTime between '{$year}-{$month[$i]}-01' and '{$year}-{$month[$i]}-31'";
		$resultScXz=execute($link,$queryScXz);
		$dataScXz=mysqli_fetch_assoc($resultScXz);
		$sc[$i]=$dataSc['count(id)']-$dataScXz['count(id)'];
		}
		$sc[12]=0;
		//查询是否已有数据，如果没有则添加，有则修改
		for($i=0;$i<13;$i++){
			$query="select id from finish_task_count where month='{$month[$i]}' and year={$this_year} and orgId={$workFor}";
			$result=execute($link,$query);
			if($data=mysqli_fetch_assoc($result)){
				$queryUpdate="update finish_task_count set ytTask={$ytAllChushi[$i]},ytBz={$yt[$i]},ytZr={$ytZiran[$i]},jaTask={$jaAllChushi[$i]},jaBz={$ja[$i]},jaZr={$jaZrj[$i]},sqZr={$sq[$i]},bhZr={$bh[$i]},scZr={$sc[$i]} where id={$data['id']}"; 
				execute($link,$queryUpdate);
			}else{
				$queryIn="insert into finish_task_count(orgId,year,month,ytTask,ytBz,ytZr,jaTask,jaBz,jaZr,sqZr,bhZr,scZr) values({$workFor},{$year},'{$month[$i]}',{$ytAllChushi[$i]},{$yt[$i]},{$ytZiran[$i]},{$jaAllChushi[$i]},{$ja[$i]},{$jaZrj[$i]},{$sq[$i]},{$bh[$i]},{$sc[$i]})";
				execute($link,$queryIn);
			}
		}
		//计算均匀出案情况
		$day=array('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31');
		//查询一通每日出案量
		$queryytZrj="select DATE_FORMAT(chuanTime,'%Y%m%d') days,count(id) count from finish_task where workFor={$workFor} and type='一通' and bzCount>0 group by days";
		$resultytZrj=execute($link,$queryytZrj);
		while($dataytZrj=mysqli_fetch_assoc($resultytZrj)){
			$yt[$dataytZrj['days']]=$dataytZrj['count'];
		}
		//查询当月首次结案自然件
		$queryjaZrj="select DATE_FORMAT(chuanTime,'%Y%m%d') days,count(id) count from finish_task where workFor=$workFor and specificType in ('系统外首次结案补点','首次结案') and bzCount>0 group by days";
		$resultjaZrj=execute($link,$queryjaZrj);
		while($datajaZrj=mysqli_fetch_assoc($resultjaZrj)){
			$ja[$datajaZrj['days']]=$datajaZrj['count'];
		}
		//查询是否已有数据，如果没有则添加，有则修改
		for($i=0;$i<12;$i++){
			for($a=0;$a<31;$a++){
				$dyt[$a]=@$yt[$year.$month[$i].$day[$a]] ? $yt[$year.$month[$i].$day[$a]] : 0;
				$dja[$a]=@$ja[$year.$month[$i].$day[$a]] ? $ja[$year.$month[$i].$day[$a]] : 0;
			}
			$query="select id from finish_task_time where month='{$month[$i]}' and year={$this_year} and orgId={$workFor} and type='yt'";
			$result=execute($link,$query);
			if($data=mysqli_fetch_assoc($result)){
				$queryUpdate="update finish_task_time set d1={$dyt[0]},d2={$dyt[1]},d3={$dyt[2]},d4={$dyt[3]},d5={$dyt[4]},d6={$dyt[5]},d7={$dyt[6]},d8={$dyt[7]},d9={$dyt[8]},d10={$dyt[9]},d11={$dyt[10]},d12={$dyt[11]},d13={$dyt[12]},d14={$dyt[13]},d15={$dyt[14]},d16={$dyt[15]},d17={$dyt[16]},d18={$dyt[17]},d19={$dyt[18]},d20={$dyt[19]},d21={$dyt[20]},d22={$dyt[21]},d23={$dyt[22]},d24={$dyt[23]},d25={$dyt[24]},d26={$dyt[25]},d27={$dyt[26]},d28={$dyt[27]},d29={$dyt[28]},d30={$dyt[29]},d31={$dyt[30]} where id={$data['id']}"; 
				execute($link,$queryUpdate);
			}else{
				$queryIn="insert into finish_task_time(orgId,type,year,month,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31) values({$workFor},'yt',{$year},'{$month[$i]}',{$dyt[0]},{$dyt[1]},{$dyt[2]},{$dyt[3]},{$dyt[4]},{$dyt[5]},{$dyt[6]},{$dyt[7]},{$dyt[8]},{$dyt[9]},{$dyt[10]},{$dyt[11]},{$dyt[12]},{$dyt[13]},{$dyt[14]},{$dyt[15]},{$dyt[16]},{$dyt[17]},{$dyt[18]},{$dyt[19]},{$dyt[20]},{$dyt[21]},{$dyt[22]},{$dyt[23]},{$dyt[24]},{$dyt[25]},{$dyt[26]},{$dyt[27]},{$dyt[28]},{$dyt[29]},{$dyt[30]})";
				execute($link,$queryIn);
			}
			$query="select id from finish_task_time where month='{$month[$i]}' and year={$this_year} and orgId={$workFor} and type='ja'";
			$result=execute($link,$query);
			if($data=mysqli_fetch_assoc($result)){
				$queryUpdate="update finish_task_time set d1={$dja[0]},d2={$dja[1]},d3={$dja[2]},d4={$dja[3]},d5={$dja[4]},d6={$dja[5]},d7={$dja[6]},d8={$dja[7]},d9={$dja[8]},d10={$dja[9]},d11={$dja[10]},d12={$dja[11]},d13={$dja[12]},d14={$dja[13]},d15={$dja[14]},d16={$dja[15]},d17={$dja[16]},d18={$dja[17]},d19={$dja[18]},d20={$dja[19]},d21={$dja[20]},d22={$dja[21]},d23={$dja[22]},d24={$dja[23]},d25={$dja[24]},d26={$dja[25]},d27={$dja[26]},d28={$dja[27]},d29={$dja[28]},d30={$dja[29]},d31={$dja[30]} where id={$data['id']}"; 
				execute($link,$queryUpdate);
			}else{
				$queryIn="insert into finish_task_time(orgId,type,year,month,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31) values({$workFor},'ja',{$year},'{$month[$i]}',{$dja[0]},{$dja[1]},{$dja[2]},{$dja[3]},{$dja[4]},{$dja[5]},{$dja[6]},{$dja[7]},{$dja[8]},{$dja[9]},{$dja[10]},{$dja[11]},{$dja[12]},{$dja[13]},{$dja[14]},{$dja[15]},{$dja[16]},{$dja[17]},{$dja[18]},{$dja[19]},{$dja[20]},{$dja[21]},{$dja[22]},{$dja[23]},{$dja[24]},{$dja[25]},{$dja[26]},{$dja[27]},{$dja[28]},{$dja[29]},{$dja[30]})";
				execute($link,$queryIn);
			}
		}
	}
	$errortext=$errortext.'数据更新成功！'; 
	$queryUpdate="update final_day set updateTime='{$dateTime}' where id=14 or id={$thisMonth}";	
	execute($link,$queryUpdate);
	if(mysqli_affected_rows($link)==2){
		$errortext=$errortext.'时间更新成功！'; 
	}else{
		$errortext=$errortext.'时间未更新或更新失败，请重试！';
	}
}
echo "<script>onload = function(){document.getElementById('errortext').innerHTML='$errortext';}</script>";	
			//查询是否为处室管理员
			if(is_numeric($amdinOrg) || $amdinOrg=='all'){
				if($staffId='11178'){
					$amdinOrg='3';
								$query="select fatherId from org where id=(select fatherId from org where id=$amdinOrg)";
			$result=execute($link, $query);
			$data=mysqli_fetch_assoc($result);
				if($data['fatherId']=='1'){
				$class1_1=($_GET['content']=='taskChushiApp' and $_GET['year']==$this_year) ? 'class="current"' : "";
				$class1_2=($_GET['content']=='taskChushiApp' and $_GET['year']==$next_year) ? 'class="current"' : "";
				$class2=$_GET['content']=='taskChushiInquire' || substr($_GET['content'],0,12)=='finishChushi' || substr($_GET['content'],0,16)=='finishListChushi' ? 'class="current"' : "";
				$class2_3=$_GET['content']=='taskChushi2Inquire' || substr($_GET['content'],0,13)=='finish2Chushi' || substr($_GET['content'],0,17)=='finishList2Chushi' ? 'class="current"' : "";
				$class2_2=($_GET['content']=='taskZhongxinTonghou') ? 'class="current"' : "";
$html=<<<A
			<li>
				<div class="small_title">审查室任务管理</div>
				<ul class="child">
					<li><a {$class2} href="task_chushi_inquire">审查室工作量查询</a></li>
					<li><a {$class2_3} href="task_chushi_2_inquire"><font style='color:red;'>室级工作量查询.新</font></a></li>
					<li><a {$class2_2} href="task_zhongxin_tonghou?page=1">通后未结查询</a></li>
					<li><a {$class1_1} href="task_chushi_app?year={$this_year}">{$this_year}年任务量填报</a></li>
					<li><a {$class1_2} href="task_chushi_app?year={$next_year}">{$next_year}年任务量填报</a></li>
				</ul>
			</li>
A;
	echo $html;
				}
			$query1="select fatherId from org where id=$amdinOrg";
			$result1=execute($link, $query1);
			$data1=mysqli_fetch_assoc($result1);
				if($data1['fatherId']=='1'){
				$class3_1=(substr($_GET['content'],0,12)=='taskBumenApp' and $_GET['year']==$this_year) ? 'class="current"' : "";
				$class3_2=(substr($_GET['content'],0,12)=='taskBumenApp' and $_GET['year']==$next_year) ? 'class="current"' : "";
				$class4=$_GET['content']=='taskBumenInquire' || substr($_GET['content'],0,15)=='finishListBumen' || substr($_GET['content'],0,11)=='finishBumen' || substr($_GET['content'],0,12)=='finishChushi' ? 'class="current"' : "";
				$class4_2=$_GET['content']=='taskBumen2Inquire' || substr($_GET['content'],0,16)=='finishList2Bumen' || substr($_GET['content'],0,12)=='finish2Bumen' || substr($_GET['content'],0,13)=='finish2Chushi' ? 'class="current"' : "";
				$class4_1=($_GET['content']=='taskZhongxinTonghou') ? 'class="current"' : "";
$html=<<<A
			<li>
				<div class="small_title">审查部任务管理</div>
				<ul class="child">
					<li><a {$class4} href="task_bumen_inquire">审查部工作量查询</a></li>
					<li><a {$class4_2} href="task_bumen_2_inquire"><font style='color:red;'>部门工作量查询.新</font></a></li>
					<li><a {$class4_1} href="task_zhongxin_tonghou?page=1">通后未结查询</a></li>
					<li><a {$class3_1} href="task_bumen_app?year={$this_year}">{$this_year}年任务量填报</a></li>
					<li><a {$class3_2} href="task_bumen_app?year={$next_year}">{$next_year}年任务量填报</a></li>
				</ul>
			</li>
A;
	echo $html;
				}
				}

			}
			$amdinOrg='all';
				if($amdinOrg=='1' || $amdinOrg=='all'){
				$class5=$_GET['content']=='taskZhongxinInquire' || substr($_GET['content'],0,20)=='finishZhongxinDetail' || substr($_GET['content'],0,18)=='finishListZhongxin' || substr($_GET['content'],0,12)=='finishChushi' || substr($_GET['content'],0,11)=='finishBumen' ? 'class="current"' : "";
				$class5_1=$_GET['content']=='taskZhongxinInquire2016' || substr($_GET['content'],0,24)=='finish2016ZhongxinDetail' || substr($_GET['content'],0,22)=='finish2016ListZhongxin'? 'class="current"' : "";
				$class5_2=$_GET['content']=='taskZhongxinTonghou' || substr($_GET['content'],0,7)=='taskOrg'? 'class="current"' : "";
				
$html=<<<A
			<li>
				<div class="small_title">中心任务管理</div>
				<ul class="child">
					<li><a {$class5} href="task_zhongxin_inquire">中心工作量查询</a></li>
					<li><a {$class5_1} href="task_zhongxin_inquire_2016">2016工作量查询</a></li>
					<li><a {$class5_2} href="task_zhongxin_tonghou?page=1">通后未结查询</a></li>
				</ul>
			</li>
A;
	echo $html;
				}
				if($staffId=='10309' || $staffId=='10558'|| $staffId=='10171' || $staffId=='10191' || $staffId=='10482' || $staffId=='11353' || $staffId=='11178' ){
				$class5_3=$_GET['content']=='taskZhongxin2Inquire' || substr($_GET['content'],0,21)=='finishZhongxin2Detail' || substr($_GET['content'],0,12)=='finishBumen2' || substr($_GET['content'],0,19)=='finishList2Zhongxin' ? 'class="current"' : "";
$html=<<<A
			<li><a {$class5_3} href="task_zhongxin_2_inquire"><font style='color:red;'>中心工作量查询.新</font></a></li>
			
A;
	echo $html;					
}
				if($amdinOrg=='all'){
				$class6=substr($_GET['content'],0,15)=='taskTypeControl' ? 'class="current"' : "";
				$class7=substr($_GET['content'],0,10)=='appControl' ? 'class="current"' : "";
				$class8=substr($_GET['content'],0,10)=='taskFenjie' || substr($_GET['content'],0,11)=='taskConfirm' ? 'class="current"' : "";
				$class9=substr($_GET['content'],0,3)=='PCT' ? 'class="current"' : "";
				$class10=$_GET['content']=='taskChuanTimeControl' ? 'class="current"' : "";
$html=<<<A
			<li>
				<div class="small_title">任务系统管理</div>
				<ul class="child">
					<li><a {$class6} href="task_admin_control_type?page=1">任务量上下限管理</a></li>
					<li><a {$class7} href="task_admin_control?page=1">任务申报开启控制</a></li>
					<li><a {$class8} href="task_admin_control_fenjie?page=1">任务量分解与确认</a></li>
					<li><a {$class9} href="task_admin_PCT?page=1">PCT补点管理</a></li>
					<li><a {$class10} href="task_chuanTime_control">出案日与出案池</a></li>
A;
	echo $html;
				}
if($amdinOrg=='all'){
	$query="select updateTime from final_day where id=14";
	$result=execute($link,$query);
	$data=mysqli_fetch_assoc($result);
$html=<<<A
	</br>任务量最近更新时间：</br>{$data['updateTime']}
	<form method="post">
	<input class="btn" type="submit" name="update" style="margin:0px;" value="更新" 
		onclick="{if(confirm('确定要更新室级以上工作量统计数据?')){
	    this.document.formname.submit();
	    return true;}return false;
  		}"/>
	<div style="color:red;text-align:center;">
	<h5 id="errortext"></h5>
	</div>
	</form>
A;
echo $html;
	}
			?>
					<!--  <li><a <?php if(substr($_GET['content'],0,9)=='chuanType'){echo 'class="current"';}?> href="chuan_admin_control_type">工作量类型管理</a></li> -->
					<!--  <li><a <?php if(substr($_GET['content'],0,10)=='errorAdmin'){echo 'class="current"';}?> href="task_admin_error_list?page=1">工作量错误管理</a></li> -->
					<!--  <li><a href="#">工作量导入</a></li> -->
				</ul>
			</li>
		</ul>
	</div>