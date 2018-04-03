<?php 
//建立通用函数给各个页面调用
function func_loadTpl_sidebar()
{
	$tpl_root="tpl/";
	$tpl_set=array(
    "task"=>"task.tpl",//任务管理的模板
    "orgStaff"=>"orgStaff.tpl",//人员机构的模板
	"staff"=>"staff.tpl",//档案模板
	"links"=>"links.tpl",//业务管理模板
	"vote"=>"vote.tpl",//问卷调查管理模板
	"class"=>"class.tpl",//课程讲座管理模板
	"shenxian"=>"shenxian.tpl",//案件监控模板
	"biaoge"=>"biaoge.tpl",//业务表格管理模板
	"beian"=>"beian.tpl",//文件递送管理模板
    );
	 //加载模板
	$get_type=isset($_GET['type']) ? $_GET['type'] : '';
	if($get_type){
		//用数组来判断
		if($tpl_set[$get_type]){
			include $tpl_root.$tpl_set[$get_type]; //加载 对应的模板
		}else{
			include $tpl_root."task.tpl"; //没有匹配到 ，依然加载首页
		}
	}else{
		include $tpl_root."task.tpl"; //没有传递参数 加载首页
	}
	}
function func_loadTpl_main()
	{
		$tpl_root="tpl/";
		$tpl_set=array(
				"taskExamerInquire"=>"taskExamerInquire.tpl",//个人工作量查询的模板
				"taskExamerInquirePCT"=>"taskExamerInquirePCT.tpl",//个人工作量PCT查询的模板
				"taskExamerApp"=>"taskExamerApp.tpl",//审查员填报任务量模板
				"finishListExamerYt"=>"finishListExamerYt.tpl",//一通任务清单模板
				"finishListExamerJa"=>"finishListExamerJa.tpl",//结案任务清单模板
				"errorAdd"=>"errorAdd.tpl",//错误反馈模板
				"errorReplyList"=>"errorReplyList.tpl",//反馈案件列表模板
				"errorDelConfirm"=>"errorDelConfirm.tpl",//反馈案件审查员删除确认模板
				"errorDelete"=>"errorDelete.tpl",//反馈案件审查员删除模板
				"appControl"=>"appControl.tpl",//申报开启控制模板
				"appControlDelConfirm"=>"appControlDelConfirm.tpl",//申报开启控制删除确认模板
				"appControlDelete"=>"appControlDelete.tpl",//申报开启控制删除模板
				"appControlUpdate"=>"appControlUpdate.tpl",//申报开启控制修改模板
				"taskChushiApp"=>"taskChushiApp.tpl",//处室修改任务量模板
				"taskChushiInquire"=>"taskChushiInquire.tpl",//处室工作量查询模板
				"taskChushi2Inquire"=>"taskChushiInquire2.tpl",//处室工作量查询模板.新
				"finishChushiDetail"=>"finishChushiDetail.tpl",//处室个人工作量查询模板
				"finishChushiDetailAll"=>"finishChushiDetailAll.tpl",//处室工作总量查询模板
				"finish2ChushiDetail"=>"finishChushiDetail2.tpl",//处室个人工作量查询模板.新
				"finish2ChushiDetailAll"=>"finishChushiDetailAll2.tpl",//处室工作总量查询模板.新
				"finishChushiDetailYtList"=>"finishChushiDetailYtList.tpl",//处室个人一通工作量清单模板
				"finishChushiDetailJaList"=>"finishChushiDetailJaList.tpl",//处室个人结案工作量清单模板
				"finish2ChushiDetailYtList"=>"finishChushiDetailYtList2.tpl",//处室个人一通工作量清单模板
				"finish2ChushiDetailJaList"=>"finishChushiDetailJaList2.tpl",//处室个人结案工作量清单模板
				"finishListChushiYt"=>"finishListChushiYt.tpl",//处室一通任务清单模板
				"finishListChushiJa"=>"finishListChushiJa.tpl",//处室结案任务清单模板
				"finishList2ChushiYt"=>"finishListChushiYt2.tpl",//处室一通任务清单模板.新
				"finishList2ChushiJa"=>"finishListChushiJa2.tpl",//处室结案任务清单模板.新
				"taskBumenApp"=>"taskBumenApp.tpl",//部门修改任务量模板
				"taskBumenAppChushi"=>"taskBumenAppChushi.tpl",//部门-处室修改任务量模板
				"taskBumenInquire"=>"taskBumenInquire.tpl",//部门工作量查询模板
				"taskBumen2Inquire"=>"taskBumenInquire2.tpl",//部门工作量查询模板.新
				"yuliuBumenDetail"=>"yuliuBumenDetail.tpl",//部门工作预留量模板
				"finishBumenDetail"=>"finishBumenDetail.tpl",//部门处室工作量查询模板
				"finish2BumenDetail"=>"finishBumenDetail2.tpl",//部门处室工作量查询模板
				"finishBumenDetailSingle"=>"finishBumenDetailSingle.tpl",//部门单人工作量查询模板
				"finishBumenDetailAll"=>"finishBumenDetailAll.tpl",//部门工作总量查询模板
				"finish2BumenDetailAll"=>"finishBumenDetailAll2.tpl",//部门工作总量查询模板
				"finishBumenDetailAllSingle"=>"finishBumenDetailAllSingle.tpl",//部门单人工作总量查询模板
				"finish2BumenDetailAllSingle"=>"finishBumenDetailAllSingle2.tpl",//部门单人工作总量查询模板.新 
				"finishBumenDetailChushi"=>"finishBumenDetailChushi.tpl",//部门处室人员工作量查询模板
				"finishBumenDetailChushiAll"=>"finishBumenDetailChushiAll.tpl",//部门处室人员总工作量查询模板
				"finish2BumenDetailChushi"=>"finishBumenDetailChushi2.tpl",//部门处室人员工作量查询模板.新 
				"finish2BumenDetailChushiAll"=>"finishBumenDetailChushiAll2.tpl",//部门处室人员总工作量查询模板.新
				"finishListBumenYt"=>"finishListBumenYt.tpl",//部门一通任务清单模板.新
				"finishList2BumenYt"=>"finishListBumenYt2.tpl",//部门一通任务清单模板
				"finishListBumenYt2016"=>"finishListBumenYt2016.tpl",//部门2016年一通任务清单模板
				"finishListBumenJa"=>"finishListBumenJa.tpl",//部门结案任务清单模板
				"finishList2BumenJa"=>"finishListBumenJa2.tpl",//部门结案任务清单模板.新
				"taskZhongxinInquire"=>"taskZhongxinInquire.tpl",//中心工作量查询模板
				"taskZhongxinInquire2016"=>"taskZhongxinInquire2016.tpl",//2016年中心工作量查询模板
				"taskZhongxin2Inquire"=>"taskZhongxinInquire2.tpl",//中心工作量查询模板.新
				"taskZhongxinTonghou"=>"taskZhongxinTonghou.tpl",//中心工作量查询模板
				"taskOrg"=>"taskOrg.tpl",//机构审限统计表
				"yuliuZhongxinDetail"=>"yuliuZhongxinDetail.tpl",//中心部门工作预留量模板
				"finishZhongxinDetail"=>"finishZhongxinDetail.tpl",//中心部门工作量查询模板
				"finishZhongxinDetailAll"=>"finishZhongxinDetailAll.tpl",//中心部门工作总量查询模板
				"finishZhongxin2Detail"=>"finishZhongxinDetail2.tpl",//中心部门工作量查询模板.新
				"finishZhongxin2DetailAll"=>"finishZhongxinDetailAll2.tpl",//中心部门工作总量查询模板.新
				"finish2016ZhongxinDetail"=>"finishZhongxinDetail2016.tpl",//2016年中心部门工作量查询模板
				"finish2016ZhongxinDetailAll"=>"finishZhongxinDetailAll2016.tpl",//2016年中心部门工作总量查询模板
				"finishZhongxinDetailSingle"=>"finishZhongxinDetailSingle.tpl",//中心单人工作量查询模板
				"finishZhongxinDetailAllSingle"=>"finishZhongxinDetailAllSingle.tpl",//中心单人工作总量查询模板
				"finishZhongxinDetailSingle2016"=>"finishZhongxinDetailSingle2016.tpl",//2016年中心单人工作量查询模板
				"finishZhongxinDetailAllSingle2016"=>"finishZhongxinDetailAllSingle2016.tpl",//2016年中心单人工作总量查询模板
				"finishZhongxinDetailBumen"=>"finishZhongxinDetailBumen.tpl",//中心部门处室工作量查询模板
				"finishZhongxinDetailBumenAll"=>"finishZhongxinDetailBumenAll.tpl",//中心部门处室工作总量查询模板
				"finishZhongxin2DetailBumen"=>"finishZhongxinDetailBumen2.tpl",//中心部门处室工作量查询模板.新
				"finishZhongxin2DetailBumenAll"=>"finishZhongxinDetailBumenAll2.tpl",//中心部门处室工作总量查询模板.新
				"finishZhongxinDetailBumenSingle"=>"finishZhongxinDetailBumenSingle.tpl",//中心部门单人工作量查询模板
				"finishZhongxinDetailBumenAllSingle"=>"finishZhongxinDetailBumenAllSingle.tpl",//中心部门单人工作总量查询模板
				"finishListZhongxinYt"=>"finishListZhongxinYt.tpl",//中心一通任务清单模板
				"finish2016ListZhongxinYt"=>"finishListZhongxinYt2016.tpl",//2016年中心一通任务清单模板
				"finishListZhongxinJa"=>"finishListZhongxinJa.tpl",//中心结案任务清单模板
				"finishList2ZhongxinJa"=>"finishListZhongxinJa2.tpl",//中心结案任务清单模板.新
				"finish2016ListZhongxinJa"=>"finishListZhongxinJa2016.tpl",//2016年中心结案任务清单模板
				"taskTypeControl"=>"taskTypeControl.tpl",//申报类别控制模板
				"taskTypeControlUpdate"=>"taskTypeControlUpdate.tpl",//申报类别控制修改模板
				"taskTypeControlDelete"=>"taskTypeControlDelete.tpl",//申报类别控制删除模板
				"taskTypeControlDelConfirm"=>"taskTypeControlDelConfirm.tpl",//申报类别控制删除确认模板
				"taskFenjieControl"=>"taskFenjieControl.tpl",//任务量分解控制模板
				"taskFenjieControlUpdate"=>"taskFenjieControlUpdate.tpl",//任务量分解修改模板
				"taskFenjieControlDelete"=>"taskFenjieControlDelete.tpl",//任务量分解删除模板
				"taskFenjieControlDelConfirm"=>"taskFenjieControlDelConfirm.tpl",//任务量分解删除确认模板
				"taskConfirmControl"=>"taskConfirmControl.tpl",//任务量确认模板
				"errorAdminList"=>"errorAdminList.tpl",//管理员错误反馈控制模板
				"errorAdminDelConfirm"=>"errorAdminDelConfirm.tpl",//反馈案件管理员删除确认模板
				"errorAdminDelete"=>"errorAdminDelete.tpl",//反馈案件管理员删除模板
				"errorAdminFastDeal"=>"errorAdminFastDeal.tpl",//反馈案件管理员快速处理模板
				"errorAdminDeal"=>"errorAdminDeal.tpl",//反馈案件管理员处理模板
				"errorAdminDealDelConfirm"=>"errorAdminDealDelConfirm.tpl",//反馈案件工作量管理员删除确认模板
				"errorAdminDealDelete"=>"errorAdminDealDelete.tpl",//反馈案件工作量管理员删除模板
				"chuanTypeControl"=>"chuanTypeControl.tpl",//出案类型控制模板
				"chuanTypeControlUpdate"=>"chuanTypeControlUpdate.tpl",//出案类型修改模板
				"chuanTypeControlDelete"=>"chuanTypeControlDelete.tpl",//出案类型删除模板
				"chuanTypeControlDelConfirm"=>"chuanTypeControlDelConfirm.tpl",//出案类型删除确认模板
				"orgControl"=>"orgControl.tpl",//机构控制模板
				"orgControlUpdate"=>"orgControlUpdate.tpl",//机构修改模板
				"orgControlDelete"=>"orgControlDelete.tpl",//机构删除模板
				"orgControlDelConfirm"=>"orgControlDelConfirm.tpl",//机构删除确认模板
				"staffControl"=>"staffControl.tpl",//人员控制模板
				"staffControlBumen"=>"staffControlBumen.tpl",//部门人员控制模板
				"staffControlUpdate"=>"staffControlUpdate.tpl",//人员修改模板
				"staffControlDelete"=>"staffControlDelete.tpl",//人员删除模板
				"staffControlDelConfirm"=>"staffControlDelConfirm.tpl",//人员删除确认模板
				"staffControlReset"=>"staffControlReset.tpl",//密码重置模板
				"staffControlResetConfirm"=>"staffControlResetConfirm.tpl",//密码重置确认模板
				"staffControlZhuxiao"=>"staffControlZhuxiao.tpl",//密码注销模板
				"staffControlZhuxiaoConfirm"=>"staffControlZhuxiaoConfirm.tpl",//密码注销确认模板
				"staffAdminExtr"=>"staffAdminExtr.tpl",//补充权限设置模板
				"staffAdminExtrUpdate"=>"staffAdminExtrUpdate.tpl",//补充权限修改模板
				"staffInfo"=>"staffInfo.tpl",//个人信息模板
				"staffPWDUpdate"=>"staffPWDUpdate.tpl",//密码修改模板
				"PCT"=>"PCT.tpl",//PCT改点模板
				"PCTDelConfirm"=>"PCTDelConfirm.tpl",//PCT改点删除确认模板
				"PCTDelete"=>"PCTDelete.tpl",//PCT改点删除模板
				"PCTUpdate"=>"PCTUpdate.tpl",//PCT改点修改模板
				"linksType"=>"linksType.tpl",//业务资料类型控制模板
				"linksTypeUpdate"=>"linksTypeUpdate.tpl",//业务资料类型修改模板
				"linksTypeDelete"=>"linksTypeDelete.tpl",//业务资料类型删除模板
				"linksTypeDelConfirm"=>"linksTypeDelConfirm.tpl",//业务资料类型删除确认模板
				"linksTitle"=>"linksTitle.tpl",//业务资料标题控制模板
				"linksTitleUpdate"=>"linksTitleUpdate.tpl",//业务资料标题修改模板
				"linksTitleDelete"=>"linksTitleDelete.tpl",//业务资料标题删除模板
				"linksTitleDelConfirm"=>"linksTitleDelConfirm.tpl",//业务资料标题删除确认模板
				"linksList"=>"linksList.tpl",//业务资料标题列表模板
				"linksListContent"=>"linksListContent.tpl",//业务资料标题内容页面模板
				"linksIndex"=>"linksIndex.tpl",//业务资料主页模板
				"voteTodo"=>"voteTodo.tpl",//待答调查问卷列表模板
				"voteList"=>"voteList.tpl",//调查问卷列表模板
				"voteContent"=>"voteContent.tpl",//调查问卷标题控制模板
				"voteTitle"=>"voteTitle.tpl",//调查问卷标题控制模板
				"voteTitleUpdate"=>"voteTitleUpdate.tpl",//调查问卷标题修改模板
				"voteQues"=>"voteQues.tpl",//调查问卷问题控制模板
				"voteCopy"=>"voteCopy.tpl",//调查问卷复制控制模板
				"voteResult"=>"voteResult.tpl",//调查问卷结果控制模板
				"voteText"=>"voteText.tpl",//调查问卷反馈内容控制模板
				"voteUserOrg"=>"voteUserOrg.tpl",//调查问卷用户控制模板1
				"voteUserTerm"=>"voteUserTerm.tpl",//调查问卷用户控制模板2
				"voteUserSelected"=>"voteUserSelected.tpl",//调查问卷用户控制模板3
				"classTitle"=>"classTitle.tpl",//课程标题控制模板
				"classTitleUpdate"=>"classTitleUpdate.tpl",//课程标题修改控制模板
				"classList"=>"classList.tpl",//课程讲座列表模板
				"classListNew"=>"classListNew.tpl",//最新课程讲座列表模板
				"classStudentOrg"=>"classStudentOrg.tpl",//课程讲座用户控制模板1
				"classStudentTerm"=>"classStudentTerm.tpl",//课程讲座用户控制模板2
				"classStudentSelected"=>"classStudentSelected.tpl",//课程讲座用户控制模板3
				"classCountReport"=>"classCountReport.tpl",//课程讲座学时申报控制模板
				"classCountConfirm"=>"classCountConfirm.tpl",//课程讲座学时确认控制模板
				"classApp"=>"classApp.tpl",//课程讲座报名控制模板
				"classAppTerm"=>"classAppTerm.tpl",//课程讲座期次报名控制模板
				"classAppSelected"=>"classAppSelected.tpl",//课程讲座报名控制模板2
				"classContent"=>"classContent.tpl",//课程讲座内容模板
				"classInquire"=>"classInquire.tpl",//学时查询模板
				"classInquireExamer"=>"classInquireExamer.tpl",//个人学时查询模板
				"classCountList"=>"classCountList.tpl",//课程讲座学时列表控制模板
				"finishZhongxinDetailYc"=>"finishZhongxinDetailYc.tpl",//中心部门工作量预测模板
				"finishZhongxin2DetailYc"=>"finishZhongxinDetail2Yc.tpl",//中心部门工作量预测模板.新
				"finishZhongxinDetailBumenYc"=>"finishZhongxinDetailBumenYc.tpl",//中心处室工作量预测模板
				"finishBumenDetailChushiYc"=>"finishBumenDetailChushiYc.tpl",//部门处室工作量预测模板
				"finish2BumenDetailChushiYc"=>"finishBumenDetailChushiYc2.tpl",//部门处室工作量预测模板.新
				"finishZhongxinDetailSingleYc"=>"finishZhongxinDetailSingleYc.tpl",//中心单人工作量预测模板
				"finishZhongxinDetailBumenSingleYc"=>"finishZhongxinDetailBumenSingleYc.tpl",//中心部门单人工作量预测模板
				"finishListZhongxinYtYc"=>"finishListZhongxinYtYc.tpl",//中心一通出案池清单模板
				"finishListZhongxinJaYc"=>"finishListZhongxinJaYc.tpl",//中心结案出案池清单模板
				"finishChushiDetailYtListYc"=>"finishChushiDetailYtListYc.tpl",//处室个人一通预测清单模板
				"finishChushiDetailJaListYc"=>"finishChushiDetailJaListYc.tpl",//处室个人结案预测清单模板
				"finish2ChushiDetailYtListYc"=>"finishChushiDetailYtListYc.tpl",//处室个人一通预测清单模板.新
				"finish2ChushiDetailJaListYc"=>"finishChushiDetailJaListYc.tpl",//处室个人结案预测清单模板.新
				"finishListExamerYtYc"=>"finishListExamerYtYc.tpl",//一通预测清单模板
				"finishListExamerJaYc"=>"finishListExamerJaYc.tpl",//结案预测清单模板
				"finishBumenDetailYc"=>"finishBumenDetailYc.tpl",//部门处室工作量预测模板
				"finish2BumenDetailYc"=>"finishBumenDetailYc2.tpl",//部门处室工作量预测模板.新
				"finishBumenDetailSingleYc"=>"finishBumenDetailSingleYc.tpl",//部门单人工作量预测模板
				"finishListBumenYtYc"=>"finishListBumenYtYc.tpl",//部门一通任务预测模板
				"finishListBumenJaYc"=>"finishListBumenJaYc.tpl",//部门结案任务预测模板
				"finishChushiDetailYc"=>"finishChushiDetailYc.tpl",//处室个人工作量预测模板
				"finish2ChushiDetailYc"=>"finishChushiDetailYc2.tpl",//处室个人工作量预测模板.新
				"finishListChushiYtYc"=>"finishListChushiYtYc.tpl",//处室一通任务预测模板
				"finishListChushiJaYc"=>"finishListChushiJaYc.tpl",//处室结案任务预测模板
				"finishList2ChushiYtYc"=>"finishListChushiYtYc2.tpl",//处室一通任务预测模板.新
				"finishList2ChushiJaYc"=>"finishListChushiJaYc2.tpl",//处室结案任务预测模板.新
				"taskChuanTimeControl"=>"taskChuanTimeControl.tpl",//出案日控制模板
				"orgStaffInfo"=>"orgStaffInfo.tpl",//机构内人员审查档案信息
				"orgStaffAssessment"=>"orgStaffAssessment.tpl",//机构内人员年度考核信息
				"orgAssessment"=>"orgAssessment.tpl",//机构年度考核信息
				"staffAbroadInfo"=>"staffAbroadInfo.tpl",//出国信息
				"orgStaffInfoUpdate"=>"orgStaffInfoUpdate.tpl",//机构内人员审查档案信息修改
				"orgStaffAssessmentUpdate"=>"orgStaffAssessmentUpdate.tpl",//机构内人员年度考核信息修改
				"orgAssessmentUpdate"=>"orgAssessmentUpdate.tpl",//机构年度考核信息修改
				"staffAbroadInfoUpdate"=>"staffAbroadInfoUpdate.tpl",//出国信息修改
				"shenxianType"=>"shenxianType.tpl",//审限监控列表
				"shenxianTypeXinanInsert"=>"shenxiantypexinanInsert.tpl",//新案处理反馈填写页面
				"shenxianTypeHuianInsert"=>"shenxiantypehuianInsert.tpl",//回案处理反馈填写页面
				"shenxianTypeXinanUpdate"=>"biaogeJieanUpdate.tpl",//结案案件统计表修改页面
				"shenxianIndex"=>"shenxianIndex.tpl",//个人审限统计表
				"shenxianTypeOrg"=>"shenxianTypeOrg.tpl",//机构审限监控列表
				"shenxianOrg"=>"shenxianOrg.tpl",//机构审限统计表
				"shenxianIndexOrg"=>"shenxianIndexOrg.tpl",//机构审限统计主页
				"shenxianStaff"=>"shenxianStaff.tpl",//单人审限统计主页
				"shenxianCountUpdate"=>"shenxianCountUpdate.tpl",//未匹配点数案件改点页面
				"shenxianChaoqiList"=>"shenxianChaoqiList.tpl",//机构审限超期案件列表
				"shenxianChaoqiUpdate"=>"shenxianChaoqiUpdate.tpl",//机构审限超期案件信息修改页面
				"shenxianTypeReply"=>"shenxianTypeReply.tpl",//审限超期案件信息反馈页面
				"shenxianControl"=>"shenxianControl.tpl",//审限设置页面
				"biaogeJieanIndex"=>"biaogeJieanIndex.tpl",//结案案件统计页面
				"biaogeJieanList"=>"biaogeJieanList.tpl",//结案案件统计表清单页面
				"biaogeJieanInsert"=>"biaogeJieanInsert.tpl",//结案案件统计表填写页面
				"biaogeJieanUpdate"=>"biaogeJieanUpdate.tpl",//结案案件统计表修改页面
				"biaogeJieanOrgIndex"=>"biaogeJieanOrgIndex.tpl",//结案案件机构统计页面
				"biaogeJieanOrg"=>"biaogeJieanOrg.tpl",//结案案件机构详细统计页面
				"biaogeJieanOrgQianzhi"=>"biaogeJieanOrgQianzhi.tpl",//前置率机构详细统计页面
				"biaogeJieanOrgList"=>"biaogeJieanOrgList.tpl",//机构结案案件统计表清单页面
				"biaogeJieanOrgShow"=>"biaogeJieanOrgShow.tpl",//机构结案案件统计表展示页面
				"biaogeJieanOrgStaff"=>"biaogeJieanOrgStaff.tpl",//机构结案案件统计表个人统计页面
				"biaogeJieanOrgStaffQianzhi"=>"biaogeJieanOrgStaffQianzhi.tpl",//前置率个人统计页面
				"biaogeJieanOrgListQianzhi"=>"biaogeJieanOrgListQianzhi.tpl",//机构前置率统计表清单页面
				"biaogeLockedList"=>"biaogeLockedList.tpl",//异常案件清单页面
				"biaogeLockedListUpdate"=>"biaogeLockedListUpdate.tpl",//异常案件修改页面
				"biaogeLockedListOrg"=>"biaogeLockedListOrg.tpl",//异常案件机构页面
				"biaogeCorrectList"=>"biaogeCorrectList.tpl",//更正回案清单页面
				"biaogeCorrectUpdate"=>"biaogeCorrectUpdate.tpl",//更正回案修改页面
				"biaogeCorrectIndex"=>"biaogeCorrectIndex.tpl",//更正回案统计页面
				"biaogeCorrectOrgList"=>"biaogeCorrectOrgList.tpl",//更正回案机构清单页面
				"biaogeFeisanxingList"=>"biaogeFeisanxingList.tpl",//非三性案件清单页面
				"biaogeFeisanxingListUpdate"=>"biaogeFeisanxingListUpdate.tpl",//非三性案件修改页面
				"biaogeFeisanxingListOrg"=>"biaogeFeisanxingListOrg.tpl",//非三性案件机构清单页面
				"biaogeQianzhiList"=>"biaogeQianzhiList.tpl",//前置案件清单页面
				"biaogeQianzhiListUpdate"=>"biaogeQianzhiListUpdate.tpl",//前置案件修改页面
				"biaogeQianzhiListOrg"=>"biaogeQianzhiListOrg.tpl",//前置案件机构清单页面
				"biaogeQianzhiCheboFill"=>"biaogeQianzhiCheboFill.tpl",//前置案件分析填写页面
				"biaogeHuishenList"=>"biaogeHuishenList.tpl",//会审案件清单页面
				"biaogeHuishenListUpdate"=>"biaogeHuishenListUpdate.tpl",//会审案件修改页面
				"biaogeHuishenListOrg"=>"biaogeHuishenListOrg.tpl",//会审案件机构清单页面
				"biaogeLiangyouList"=>"biaogeLiangyouList.tpl",//亮优案件清单页面
				"biaogeLiangyouListUpdate"=>"biaogeLiangyouListUpdate.tpl",//亮优案件修改页面
				"biaogeLiangyouListOrg"=>"biaogeLiangyouListOrg.tpl",//亮优案件机构清单页面
				"biaogeZhijianList"=>"biaogeZhijianList.tpl",//质检案件清单页面
				"biaogeZhijianListOrg"=>"biaogeZhijianListOrg.tpl",//质检案件机构清单页面
				"biaogeZhijianListOrgUpdate"=>"biaogeZhijianListOrgUpdate.tpl",//质检案件修改页面
				"beianshenchaList"=>"beianshenchaList.tpl",//审查业务备案清单页面
				"beianshenchaListUpdate"=>"beianshenchaListUpdate.tpl",//审查业务备案修改页面
				"beianshenchaListOrg"=>"beianshenchaListOrg.tpl",//审查业务备案机构清单页面
				"beianshenchaOrg"=>"beianshenchaOrg.tpl",//审查业务备案审核页面
				"beianfuwuList"=>"beianfuwuList.tpl",//对外知识产权服务备案清单页面
				"beianfuwuListUpdate"=>"beianfuwuListUpdate.tpl",//对外知识产权服务备案修改页面
				"beianfuwuListOrg"=>"beianfuwuListOrg.tpl",//对外知识产权服务备案机构清单页面
				"beianfuwuOrg"=>"beianfuwuOrg.tpl",//对外知识产权服务备案审核页面
				"beiantranslateListOrg"=>"beiantranslateListOrg.tpl",//翻译机构清单页面	
				"beianzhuananListOrg"=>"beianzhuananListOrg.tpl",//转案清单页面	
				"beianzhuananOrg"=>"beianzhuananOrg.tpl",//转案审核页面
				"beianzhuananListUpdate"=>"beianzhuananListUpdate.tpl",//转案修改页面	
				"beianzhuananList"=>"beianzhuananList.tpl",//转案备案清单页面
				"beianqingjiaList"=>"beianqingjiaList.tpl",//请假备案清单页面
				"beianqingjiaListOrg"=>"beianqingjiaListOrg.tpl",//请假机构清单页面		
				"beianhuodongList"=>"beianhuodongList.tpl",//活动备案清单页面
				"beianhuodongListUpdate"=>"beianhuodongListUpdate.tpl",//活动备案修改页面
				"beianhuodongListOrg"=>"beianhuodongListOrg.tpl",//活动机构清单页面	
				"sIn"=>"sIn.tpl",//检索记录录入页面
				"sList"=>"sList.tpl",//个人检索记录清单页面
				"sListSearch"=>"sListSearch.tpl",//个人检索记录查找页面
				"sListUpdate"=>"sListUpdate.tpl",//个人检索记录修改页面
				"sListOrg"=>"sListOrg.tpl",//机构检索记录清单页面
				"sListOrgSearch"=>"sListOrgSearch.tpl",//机构检索记录查找页面
				"sListOrgView"=>"sListOrgView.tpl",//机构检索记录查看页面						
				"index"=>"index.tpl" //首页的模板

		);
		//加载模板
		$get_type=isset($_GET['content']) ? $_GET['content'] : '';
		if($get_type){
			//用数组来判断
			if($tpl_set[$get_type]){
				include $tpl_root.$tpl_set[$get_type]; //加载 对应的模板
			}else{
				include $tpl_root."index.tpl"; //没有匹配到 ，依然加载首页
			}
		}else{
			include $tpl_root."index.tpl"; //没有传递参数 加载首页
		}
	}
//数据库连接
	function connect($host=DB_HOST,$user=DB_USER,$password=DB_PASSWORD,$database=DB_DATABASE,$port=DB_PORT){
		$link=@mysqli_connect($host,$user,$password,$database,$port);
		if(mysqli_connect_errno()){
			exit(mysqli_connect_error());
		}
		mysqli_set_charset($link,'utf8');
		
		return $link;
	}
//执行一条SQL语句,返回结果集对象或者返回布尔值
function execute($link,$query){
	$result=mysqli_query($link,$query);
	if(mysqli_errno($link)){
		exit(mysqli_error($link));
	}
	return $result;
}
//执行一条SQL语句，只会返回布尔值
function execute_bool($link,$query){
	$bool=mysqli_real_query($link,$query);
	if(mysqli_errno($link)){
		exit(mysqli_error($link));
	}
	return $bool;
}
//一次性执行多条SQL语句
/*
 一次性执行多条SQL语句
$link：连接
$arr_sqls：数组形式的多条sql语句
$error：传入一个变量，里面会存储语句执行的错误信息
使用案例：
$arr_sqls=array(
		'select * from sfk_father_module',
		'select * from sfk_father_module',
		'select * from sfk_father_module',
		'select * from sfk_father_module'
);
var_dump(execute_multi($link, $arr_sqls,$error));
echo $error;
*/
function execute_multi($link,$arr_sqls,&$error){
	$sqls=implode(';',$arr_sqls).';';
	if(mysqli_multi_query($link,$sqls)){
		$data=array();
		$i=0;//计数
		do {
			if($result=mysqli_store_result($link)){
				$data[$i]=mysqli_fetch_all($result);
				mysqli_free_result($result);
			}else{
				$data[$i]=null;
			}
			$i++;
			if(!mysqli_more_results($link)) break;
		}while (mysqli_next_result($link));
		if($i==count($arr_sqls)){
			return $data;
		}else{
			$error="sql语句执行失败：<br />&nbsp;数组下标为{$i}的语句:{$arr_sqls[$i]}执行错误<br />&nbsp;错误原因：".mysqli_error($link);
			return false;
		}
	}else{
		$error='执行失败！请检查首条语句是否正确！<br />可能的错误原因：'.mysqli_error($link);
		return false;
	}
}
//获取记录数
function num($link,$sql_count){
	$result=execute($link,$sql_count);
	$count=mysqli_fetch_row($result);
	return $count[0];
}
//数据入库之前进行转义，确保，数据能够顺利的入库
function escape($link,$data){
	if(is_string($data)){
		return mysqli_real_escape_string($link,$data);
	}
	if(is_array($data)){
		foreach ($data as $key=>$val){
			$data[$key]=escape($link,$val);
		}
	}
	return $data;
	//mysqli_real_escape_string($link,$data);
}
//关闭与数据库的连接
function close($link){
	mysqli_close($link);
}
function isdate($str,$format="Y-m-d"){
	$strArr = explode("-",$str);
	if(empty($strArr))
	{return false;}
	foreach($strArr as $val)
	{if(strlen($val)<2)
	{$val="0".$val;}$newArr[]=$val;}
	$str =implode("-",$newArr);
	$unixTime=strtotime($str);
	$checkDate= date($format,$unixTime);
	if($checkDate==$str)
		return true;
	else
		return false;}
function CheckEmailAddr($C_mailaddr)    
{    
if (!preg_match("/^[^0-9][a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*[@][a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*[.][a-zA-Z]{2,4}$/",$C_mailaddr))  
{    
return false;    
}    
return true;    
}
?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   