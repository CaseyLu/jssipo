<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>江苏中心审查业务管理系统</title>
<link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />
<link rel="stylesheet" type="text/css" href="css/style.css" />
<link rel="stylesheet" type="text/css" href="style/public.css" />
<style type="text/css">
</style>
<script src="js/jquery-1.8.3.min.js"></script>
<script src="js/jquery.JPlaceholder.js"></script>
</head>
<div style="margin:0 0 0 100px;">
<?php
include_once 'inc/config.php';
include_once '/inc/config.inc.php';
include_once '/inc/tool.inc.php';
$link=connect();
if(isLogin($link)){
	skip('task','error','您已经登录，请先注销！');
}
if(isset($_POST['submit'])){
	//部门控制
	$org=array(64);
	$query="select orgId from staff where staffId='{$_POST['staffId']}'";
	$result=execute($link, $query);
	$data=mysqli_fetch_assoc($result);
	if(in_array($data['orgId'],$org)){
		skip('login','error','您没此系统权限！');
	}
	include 'inc/check_login.inc.php';
	escape($link,$_POST);
	$query="select id from admin where staffId='{$_POST['staffId']}' and pwd=md5('{$_POST['pwd']}')";
	$result=execute($link, $query);
	if(mysqli_num_rows($result)==1){
		$_POST['remember']=isset($_POST['remember']) ? $_POST['remember'] : '';
		if($_POST['remember']==1){
			setcookie('jssipo[staffIdR]',$_POST['staffId'],time()+3600*24*356);
			setcookie('jssipo[pwdR]',$_POST['pwd'],time()+3600*24*356);
			setcookie('jssipo[rememberR]',$_POST['remember'],time()+3600*24*356);
		}else{
			setcookie('jssipo[staffIdR]',$_POST['staffId'],time()-3600*24*356);
			setcookie('jssipo[pwdR]',$_POST['pwd'],time()-3600*24*356);
			setcookie('jssipo[rememberR]',$_POST['remember'],time()-3600*24*356);
		}
		setcookie('jssipo[staffId]',$_POST['staffId'],time()+3600);
		setcookie('jssipo[pwd]',sha1(md5($_POST['pwd'])),time()+3600);
		skip('index','ok','登录成功！');
	}else{
		skip('login', 'error', '用户ID或密码填写错误！忘记密码请联系协调室！');
	}
}
$_COOKIE['jssipo']['staffIdR']=isset($_COOKIE['jssipo']['staffIdR']) ? $_COOKIE['jssipo']['staffIdR'] : '';
$_COOKIE['jssipo']['pwdR']=isset($_COOKIE['jssipo']['pwdR']) ? $_COOKIE['jssipo']['pwdR'] : '';
$_COOKIE['jssipo']['rememberR']=isset($_COOKIE['jssipo']['rememberR']) ? $_COOKIE['jssipo']['rememberR'] : '';
?>
</div>
<body style="background:#ebebeb;">
<div class="main">
	<div class="header hide"> 审查业务管理系统 Beta 2.0 </div>
	<div class="content">
		<div class="title hide">用户登录</div>
		<form name="login" method="post">
			<fieldset>
			<table style="margin:0 130px auto;">
				<tr>
				<td>
				<div class="input">
					<input class="input_all name" autocomplete="off" name="staffId" id="staffId" value="<?php echo $_COOKIE['jssipo']['staffIdR'];?>" placeholder="用户ID（工号）" type="text" onFocus="this.className='input_all name_now';" onBlur="this.className='input_all name'" maxLength="24" />
				</div>
				</td>
				</tr>
				<tr>
				<td>
				<div class="input">
					<input class="input_all password" name="pwd" id="pwd" value="<?php echo $_COOKIE['jssipo']['pwdR'];?>" type="password" placeholder="密码" onFocus="this.className='input_all password_now';" onBlur="this.className='input_all password'" maxLength="24" />
				</div>
				</td>
				</tr>
				<tr>
				<td>
				<div class="input">
					<input class="input_all vcode" autocomplete="off" name="vcode" id="vcode" placeholder="验证码" type="text" onFocus="this.className='input_all vcode_now';" onBlur="this.className='input_all vcode'" maxLength="24" />
				</div>
				</td>
				<td><img class="vcode" src="show_vcode.php"/></td>
				</tr>
				<tr>
				<td>
				<div class="checkbox">
					<?php if($_COOKIE['jssipo']['rememberR']==1){?><input style="margin:0px 0px auto;" type="checkbox" name="remember" value="1" id="remember" checked><?php }else{($_COOKIE['jssipo']['rememberR']=="")?><input style="margin:0px 0px auto;" type="checkbox" name="remember" value="1" id="remember"><?php }?>
					<label for="remember"><span>记住密码</span></label>
				</div>
				</td>
				</tr>
				<tr>
				<td>
				<div class="enter">
					<input class="button hide" name="submit" type="submit" value="登录" />
				</div>
				</td>
				</tr>
			</table>
			</fieldset>
		</form>
	</div>
</div>
<script type="text/javascript" src="js/placeholder.js"></script>
<!--[if IE 6]>
<script type="text/javascript" src="js/belatedpng.js" ></script>
<script type="text/javascript">
	DD_belatedPNG.fix("*");
</script>
<![endif]-->
</body>
</html>