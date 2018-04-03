<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=7" />
<meta charset="utf-8" />
<title>江苏中心审查业务管理系统</title>
<link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<script language="javascript" type="text/javascript" src="js/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="style/public.css" />
<script src="js/echarts.js"></script>
<script src="js/selectuser.js"></script>
</head>
<div style="margin:0 0 0 100px;">
<?php 
include_once 'config.php';
include_once '/inc/config.inc.php';
include_once '/inc/tool.inc.php';
$link=connect();
if(!$staffId=isLogin($link)['staffId']){
	skip('login','error','您未登录，请重新登录！');   //判断是否登录
}else{
	$amdinOrg=isLogin($link)['adminOrg'];
}
//查询结案模块是否有更高权限
if($amdinOrg!='all'){
	$queryAdminExtr="select adminOrg from admin_extr where staffId=$staffId and module='jiean'";
	$resultAdminExtr=execute($link,$queryAdminExtr);
	if($dataAdminExtr=mysqli_fetch_assoc($resultAdminExtr)){
		$amdinOrg=$dataAdminExtr['adminOrg'];
	}
}
//重新计算cookie时间，一小时不操作则退出
setcookie('jssipo[staffId]',$_COOKIE['jssipo']['staffId'],time()+3600);
setcookie('jssipo[pwd]',$_COOKIE['jssipo']['pwd'],time()+3600);
$_GET['type']=isset($_GET['type']) ? $_GET['type'] : '';
$_GET['content']=isset($_GET['content']) ? $_GET['content'] : '';
?>
</div>
<body>
	<div class="header_wrap">
		<div id="header" class="auto">
			<a href="http://10.85.58.175/jssipo/"><div class="logo">审查业务管理系统</div></a>
			<div class="nav">
				<a href="task_examer_inquire" <?php if($_GET['type']=='task'){echo 'class="hover"';}?>>任务管理</a>
			</div>
			<div class="nav">
				<a href="shenxian" <?php if($_GET['type']=='shenxian'){echo 'class="hover"';}?>>案件监控</a>
			</div>
			<div class="nav">
			    <a href="biaoge_jiean_index" <?php if($_GET['type']=='biaoge'){echo 'class="hover"';}?>>业务表格</a>
			</div>
			<div class="nav">
				<a href="class_list_new?page=1" <?php if($_GET['type']=='class'){echo 'class="hover"';}?>>课程讲座</a>
			</div>
			<div class="nav">
			<a href="vote_todo?page=1" <?php if($_GET['type']=='vote'){echo 'class="hover"';}?>>问卷调查</a>
			</div>	
			<div class="nav">
				<a href="links_index" <?php if($_GET['type']=='links'){echo 'class="hover"';}?>>业务资料</a>
			</div>
			<div class="nav">
				<a href="beian_shencha_list?page=1" <?php if($_GET['type']=='beian'){echo 'class="hover"';}?>>文件递送</a>
			</div>
			<!--<div class="nav">
				<a>课题管理</a>
			</div>-->
			<?php 
			if($amdinOrg=='all'){
				$class=$_GET['type']=='orgStaff' ? 'class="hover"' : "";
				$html=<<<A
			<div class="nav">
			<a href="staff_admin_control" {$class}>人员机构</a>
			</div>	
A;
				echo $html;
			}		
			?>
			<div class="nav">
							<a href="info_staff" <?php if($_GET['type']=='staff'){echo 'class="hover"';}?>>档案信息</a>
						</div>
			<div class="login_info">
			<?php 
			if($staffId){
				include_once 'totalOnline.php';  //加载在线人数
				$date=date("m-d");
				$queryName="select name,birthday from staff where staffId='{$staffId}'";
				$resultName=execute($link,$queryName);
				$dataName=mysqli_fetch_assoc($resultName);
				$date1=date("m-d",strtotime($dataName['birthday']));
				if($date1==$date){
$str=<<<A
				&nbsp;&nbsp;<font style="color:yellow;font-weight:bold;">生日快乐！{$dataName['name']}</font>&nbsp;&nbsp;&nbsp;&nbsp;<a href="logout">[注销]</a>
A;
echo $str;
				}else{
$str=<<<A
				&nbsp;&nbsp;欢迎您，{$dataName['name']}&nbsp;&nbsp;&nbsp;&nbsp;<a href="logout">[注销]</a>
A;
echo $str;
				}
			}
			?>
			</div>
		</div>
	</div>
<?php 
func_loadTpl_sidebar();//加载模板
func_loadTpl_main();//加载内容模板
?>