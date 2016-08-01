<!--- define session variables --->
<cfquery name="getUserInfo" datasource="#application.dsn#">
	SELECT username, password 
	FROM tblResumes (nolock) 
	WHERE intResID = <cfqueryparam value="#intResID#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>

<cfparam name="session.EXEC.blnSecurityRedirect" default="0">
<!---Premium variables--->
<cfparam name="session.EXEC.isPremium" default="0">
<cfparam name="session.EXEC.dtePremiumExpires" default="">
<cfparam name="session.EXEC.dtePremiumCancelled" default="">
<cfparam name="session.EXEC.premiumCancelPeriod" default="0">

<cfparam name="session.EXEC.blnLearn365" default="0">
<cfparam name="session.EXEC.isLearn365Active" default="0">
<cfparam name="session.EXEC.hide6FJBtn" default="0">
<cfparam name="session.EXEC.learn365UserID" default="">
<cfparam name="session.EXEC.dteLearn365Expires" default="">
<cfparam name="session.EXEC.dteLearn365Cancelled" default="">
<cfparam name="session.EXEC.learn365CancelPeriod" default="0">

<cfparam name="session.EXEC.strUN" default="0">
<cfparam name="session.EXEC.strPwd" default="0">
<cfparam name="session.EXEC.blnValidLogin" default="0">
<cfparam name="session.EXEC.intResID" default="">
<cfparam name="session.EXEC.blnValidated" default="0">
<cfparam name="session.EXEC.blnArchived" default="0">
<cfparam name="session.EXEC.blnBigs" default="0">
<cfparam name="session.EXEC.intResAdmCode" default="0">
<cfparam name="session.EXEC.intResStatusCode" default="0">
<cfparam name="session.EXEC.blnSearchable" default="0">
<cfparam name="session.EXEC.intPostRecepient" default="0">
<cfparam name="session.EXEC.strFirstName" default="">
<cfparam name="session.EXEC.strLastName" default="">

<cfparam name="session.EXEC.strCity" default="">
<cfparam name="session.EXEC.strState" default="">
<cfparam name="session.EXEC.strZip" default="">		
<cfparam name="session.EXEC.strHomePhone" default="">
<cfparam name="session.EXEC.strMobilePhone" default="">
<cfparam name="session.EXEC.strWorkPhone" default="">		
		
<cfparam name="session.EXEC.strEmail" default="">
<cfparam name="session.EXEC.intListViews" default="">
<cfparam name="session.EXEC.intDetailViews" default="">
<cfparam name="session.EXEC.dteSubmitted" default="">
<cfparam name="session.EXEC.dteEdited" default="">
<cfparam name="session.EXEC.blnEmail" default="0">
<cfparam name="session.EXEC.blnResumeManager" default="0">
<cfparam name="session.EXEC.intResumeManagerCode" default="">
<cfparam name="session.EXEC.blnCoachingVideos" default="">
<cfparam name="session.EXEC.blnMetaJobSearch" default="">
<cfparam name="session.EXEC.blnCoverLetter" default="0">
<cfparam name="session.EXEC.clID1" default="">
<cfparam name="session.EXEC.clName1" default="">
<cfparam name="session.EXEC.clID2" default="">
<cfparam name="session.EXEC.clName2" default="">
<cfparam name="session.EXEC.dteReject" default="">
<cfparam name="session.EXEC.blnSubmitOnTrack" default="0">

<cfparam name="session.Exec.intVerificationStatus" default="0">
<cfparam name="session.Exec.intVerificationID" default="0">
<cfparam name="session.Exec.intStateID" default="">
<cfparam name="session.Exec.strExecJOBTitle_1" default="">
<cfparam name="session.Exec.strExecJOBCompany_1" default="">
<cfparam name="session.Exec.strExecJOBTitle_2" default="">
<cfparam name="session.Exec.strExecJOBCompany_2" default="">
<cfparam name="session.EXEC.strRegistrationMethod" default="">
<cfparam name="session.EXEC.dteResumeEdited" default="">
<cfparam name="session.EXEC.blnCPLPageVisisted" default="1">

<cfstoredproc procedure="sp_exec_login" datasource="#application.dsn#" returncode="Yes">
	<cfprocparam type="IN" variable="@username" value="#getUserInfo.username#" cfsqltype="CF_SQL_VARCHAR">
	<cfprocparam type="IN" variable="@password" value="#getUserInfo.password#" cfsqltype="CF_SQL_VARCHAR">
	<cfprocparam type="IN" variable="@sourceApp" value="#application.sourceApp#" cfsqltype="CF_SQL_VARCHAR">
	<cfprocparam type="OUT" variable="proc_returnCode" cfsqltype="CF_SQL_INTEGER">
	<cfprocresult resultset="1" name="cfqExecLogin">
</cfstoredproc>

<cfset dteLoginNow=DateFormat(Now(),"mmm dd, yyyy")> 
    			
<cfif (cfqExecLogin.blnBigs neq 0)> <!--- determine what preimum packages the candidate has, only if a member --->     
	<!--- job coaching videos --->
	<cfif cfqExecLogin.activeVideo eq 1>	   
		<cfset session.EXEC.blnCoachingVideos=1>
	<cfelse>
		<cfset session.EXEC.blnCoachingVideos=0>
	</cfif>

	<!--- meta job search ---> 
	<cfif cfqExecLogin.activeMeta eq 1>	   
		<cfset session.EXEC.blnMetaJobSearch=1>
	<cfelse>
		<cfset session.EXEC.blnMetaJobSearch=0>
	</cfif>

	<cfset intResCode=0>
	
	<cfif cfqEXECLogin.blnResumeManager neq 0>
		<cfif (cfqExecLogin.ResMngrAdmCde neq "")>
			<cfset intResCode=cfqExecLogin.ResMngrAdmCde>
		</cfif>
	</cfif>
<cfelse> <!--- a NON-member is logged in --->
	<cfset session.EXEC.blnMetaJobSearch=0>
	<cfset session.EXEC.blnCoachingVideos=0>
	<cfset intResCode=0>
</cfif>
<cfscript>
	session.EXEC.blnValidLogin=1;
	//Has To Be Boolean

	//or datediff('d',cfqEXECLogin.DTESUBMITTED,cfqEXECLogin.DTECANCEL) lte 60 

	if ((isboolean(cfqEXECLogin.isPremium) and cfqEXECLogin.isPremium eq 1) or (cfqEXECLogin.dteExpires gte now() )){
		session.EXEC.isPremium=1;
	}
	
	//if (datediff('d',cfqEXECLogin.DTESUBMITTED,cfqEXECLogin.DTECANCEL) lte 60){
		//session.EXEC.isPremium=1;
	//}
	
	//07/19/2011 Commented Out
	//if (isnumeric(cfqEXECLogin.cancelperiod) and cfqEXECLogin.cancelperiod lte 60){
		//session.EXEC.isPremium=1;
	//}
	
	//07/19/2011 - New session variables for premium
	session.EXEC.dtePremiumExpires = cfqEXECLogin.dteExpires;
	session.EXEC.dtePremiumCancelled = cfqEXECLogin.dteCancel;
	session.EXEC.premiumCancelPeriod = cfqEXECLogin.cancelPeriod;
	
	session.EXEC.blnLearn365 = cfqEXECLogin.blnLearn365;
	session.EXEC.isLearn365Active = cfqEXECLogin.learn365Active;
	session.EXEC.learn365UserID = cfqEXECLogin.learn365userid;
	session.EXEC.dteLearn365Expires = cfqEXECLogin.dteExpires;
	session.EXEC.dteLearn365Cancelled = cfqEXECLogin.dteCancel;
	session.EXEC.learn365CancelPeriod = cfqEXECLogin.cancelPeriod;
	
	if (len(cfqEXECLogin.blnHide6FJBtn)){
		session.EXEC.hide6FJBtn = cfqEXECLogin.blnHide6FJBtn;
	}else{
		session.EXEC.hide6FJBtn = 0;
	}
	
	
	session.EXEC.strUN=cfqEXECLogin.username;
	session.EXEC.strPwd=cfqEXECLogin.password;
	session.EXEC.strIndustry=cfqEXECLogin.strIndustry;
	session.EXEC.strFunction=cfqEXECLogin.strFunction;
	session.EXEC.strEmail=cfqEXECLogin.email;
	session.EXEC.intResID=cfqEXECLogin.intResID;
	session.EXEC.blnValidated=cfqEXECLogin.blnValidated;
	session.EXEC.blnArchived=cfqEXECLogin.blnArchived;
	session.EXEC.blnBigs=cfqEXECLogin.blnBigs;
	session.EXEC.intResAdmCode=cfqEXECLogin.intAdmCode;
	session.EXEC.intResStatusCode=cfqEXECLogin.intStatusCode;
	session.EXEC.intResStepsComp=cfqEXECLogin.listCompletedSteps;
	session.EXEC.blnSearchable=cfqEXECLogin.blnSearchable;
	session.EXEC.intPostRecepient=cfqEXECLogin.intPostRecepient;
	session.EXEC.strFirstName=cfqEXECLogin.fname;
	session.EXEC.strLastName=cfqEXECLogin.lname;
	session.EXEC.intListViews=cfqEXECLogin.intListViews;
	session.EXEC.intDetailViews=cfqEXECLogin.intDetailViews;
	session.EXEC.dteSubmitted=cfqEXECLogin.dteSubmitted;
	session.EXEC.dteEdited=cfqEXECLogin.dteEdited;
	session.EXEC.blnEmail=cfqEXECLogin.blnEmail;
	session.EXEC.blnResumeManager=cfqEXECLogin.blnResumeManager;
	session.EXEC.intResumeManagerCode=intResCode;
	
	//Added 12/03/2013
	session.EXEC.strCity=cfqEXECLogin.city;
	session.EXEC.strState=cfqEXECLogin.state;
	session.EXEC.strZip=cfqEXECLogin.zip;		
	session.EXEC.strHomePhone=cfqEXECLogin.home_phone;
	session.EXEC.strMobilePhone=cfqEXECLogin.mobile_phone;
	session.EXEC.strWorkPhone=cfqEXECLogin.work_phone;
	session.EXEC.dteResumeEdited=cfqEXECLogin.dteResumeEdited;
	session.EXEC.strRegistrationMethod=cfqEXECLogin.strRegistrationMethod;
	//Added 12/03/2013
	
	
	session.EXEC.strExecJOBTitle_1=cfqEXECLogin.strExecJOBTitle_1;
	session.EXEC.strExecJOBCompany_1=cfqEXECLogin.strExecJOBCompany_1;
	session.EXEC.strExecJOBTitle_2=cfqEXECLogin.strExecJOBTitle_2;
	session.EXEC.strExecJOBCompany_2=cfqEXECLogin.strExecJOBCompany_2;

	if (len(cfqEXECLogin.intVerificationStatus)){
		session.Exec.intVerificationStatus=cfqEXECLogin.intVerificationStatus;
	}else{
		session.Exec.intVerificationStatus=0;
	}
	
	if (len(cfqEXECLogin.intVerificationID)){
		session.Exec.intVerificationID=cfqEXECLogin.intVerificationID;
	}else{
		session.Exec.intVerificationID=0;
	}	 

	if (len(cfqEXECLogin.dteReject)){
		session.EXEC.dteReject=dateformat(cfqEXECLogin.dteReject, "mm/dd/yyyy");
	}
</cfscript>
