<cfif isdefined("url.track") and url.track EQ 'y'>

	<cfquery name="cfqGetAppMeth" datasource="#application.dsn#">
	select intEmployerID, strjobURL from tblJobs (nolock) 
	where intJobID=<cfqueryparam cfsqltype="cf_sql_integer" value="#intJobID#" />
	</cfquery>
	
	<cfif len(cfqGetAppMeth.strjobURL)>
		<cfif cfqGetAppMeth.strjobURL does not contain "http://">
			<cfif cfqGetAppMeth.strjobURL does not contain "https://">
				<cfset strJobURL="http://" & cfqGetAppMeth.strjobURL>
			<cfelse>
				<cfset strJobURL=cfqGetAppMeth.strjobURL>
			</cfif>
		<cfelse>
			<cfset strJobURL=cfqGetAppMeth.strjobURL>
		</cfif>
	<cfelse>
		<cfset strJobURL="">
	</cfif>
	
	<cfset intEmployerID = val(cfqGetAppMeth.intEmployerID)>
	<cfset strJobURL = rereplacenocase(strJobURL,"&amp;","&","ALL") />
	
	<cftry>
		<!---07/26/2011, Check to see if the candidate already applied to this job---->
		<cfquery name="cfqOneClickHist" datasource="#application.dsn#">
		select COUNT(*) applCnt 
		  from tblOneClickHist (nolock) 
		 where 1=1
		   and intJobID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intJobID#" />
		   and intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" />
		   and intEmployerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intEmployerID#" />
		</cfquery>
		
		<!---Record the job application if the candidate did not apply to the job earlier---> 
		<cfif cfqOneClickHist.applCnt eq 0>
			<cfstoredproc procedure="sp_UpdtExecOneClick" datasource="#application.dsn#" returncode="No">
				<cfprocparam type="IN" dbvarname="@intResID" value="#val(session.exec.intResID)#" cfsqltype="CF_SQL_INTEGER">
				<cfprocparam type="IN" dbvarname="@intJobID" value="#val(intJobID)#" cfsqltype="CF_SQL_INTEGER">
				<cfprocparam type="IN" dbvarname="@intEmployerID" value="#val(intEmployerID)#" cfsqltype="CF_SQL_INTEGER">
			</cfstoredproc>
		</cfif>
		<cfcatch type="any">
			<!---Do not do anything--->
		<cfabort>
		</cfcatch>
	</cftry>	
																	
	<cfif len(strJobURL)>
		<cflocation url="#strJobURL#" addtoken="No">
	<cfelse>
		<div align="center" style="color:red;">There is a problem with the URL listed in this posting. <br>
		Please <a href="6FigureJobs_contactus.cfm?#strappaddtoken#&dept=4" target="_blank" style="color:red;">contact </a>6FigureJobs.com with the job posting information.</div>
	</cfif>

</cfif>




<script language="javascript">
function checkResumeUpload(){
	
	var errormsg = '';
 	var errNum=0;
	
	
	if (document.getElementById('resumeTitle').value == ''){
		document.getElementById('resumeTitle').style.borderColor = '#F00';
		errNum+=1;
		return false;
	}else{
		document.getElementById('resumeTitle').style.borderColor = '#000';	
	}
	
	
	if (document.getElementById('resumeFile').value == ''){
		document.getElementById('resumeUploadDiv').style.display = "block";
		errNum+=1;
		return false;
	} else{
		document.getElementById('resumeUploadDiv').style.display = "none";
	}
	
			
	if (errNum > 0){
  		return false ;
 	}else{
		document.forms["myAccountResumeUpload"].submit();
		document.getElementById("resUploadSubmitBtn").disabled="disabled";
  	}
	
}
</script>

<cfoutput>
<cfset showBotAdSlots = "1"> 
<cfparam name="intJobID"  default="0">
<cfparam name="dteSubmit" default="">
<cfparam name="strCaller" default="">
<cfparam name="intJOD"  default="">
<cfparam name="intPageNo" default="1">
<cfparam name="imgLogo" default="">
<cfparam name="strCoverLetter" default="">
<cfparam name="blnFirstPass" default="1">
<cfparam name="strTitle" default="">
<cfparam name="blnVisit" default="0">
<cfparam name="intLetterID" default="">
<cfparam name="strButtonAction" default="">
<cfparam name="intCount" default="0">
<cfparam name="intResID" default="">
<cfparam name="blnBigs" default="0">
<cfparam name="blnError" default="0">
<cfparam name="URLPostingOnly" default="0">
<cfparam name="intCorpID" default="">
<cfparam name="lcl_howContact" default="">

<cfparam name="showResumeUpload" default="0">
<cfparam name="showResumeSelect" default="1">

<cfparam name="sort" default="date_submitted">
<cfparam name="sortorder" default="desc">

<!--- <cfinclude template="t_attributes.cfm"> --->
<cfinclude template="../member/alerts/alertAttributes.cfm">
<cfset blnSendEmail=0>

<cfset resObj = application.resume />
<cfparam name="form.resumeid" default="0" />
<cfset intResID = session.exec.intResID> 
<cfset intResAdmCode = session.exec.intResAdmCode>
<cfset BLNVALIDLOGIN = session.exec.BLNVALIDLOGIN >

<cfparam name="tm" default="30"><!--- Top menu (redesign) --->
<cfparam name="m" default="2"> <!--- main menu --->
<cfparam name="am" default="3"> <!--- active menu --->
<cfparam name="asm" default="0"> <!--- active sub-menu --->

<script language="JavaScript">
<!--
function apply(a){
	//return false;
	if(a){
		document.applyNow.strButtonAction.value =  a ;
		document.getElementById('Processing').style.visibility = 'visible';
		document.getElementById('AppplyJobSubmitBtn').style.visibility = 'hidden';
		
		return true;
	} else{//document.applyNow.submit();
		return false;
	}
}
//-->
</script>

<cfparam name="url.start1" default="0">
<cfparam name="url.pgNo" default="1">

<!--- 02/18/2011 redirect the user to the new execlogin.cfm page is not logged in --->
<!--- <cfif blnValidLogin neq 1 OR intResID is "">
	<cflocation url="/ExecLogin.cfm?#cgi.query_string#" addtoken="no" />
</cfif> --->

<cfparam name="url.message" default="">
<cfparam name="url.messagecode" default="">

<!--- If the form is submitted --->
<cfif isDefined("form.fieldnames") and ( isDefined("form.section") and form.section eq "resumeUpload") >

	<cfscript>
	// Assume Parsing Is OK --->
	inValidParse = 1;
	uploadedPath = application.sixfj.paths.webroot & "exports\";
	</cfscript>

	<!---Create the resume upload directory if it does not exist already--->
	<cfif not(directoryExists(uploadedPath))>
		<cfdirectory directory="#uploadedPath#" action="create" />
	</cfif>
	
	<!--- If the resume is uploaded --->
	<cfif isDefined("form.section") and form.section is "resumeUpload">
		<cfparam name="shortName" default="" />
		<cfparam name="reNamedFile" default="" />
		<cfparam name="uploadedFile" default="" />
		<cfparam name="sovRenResumeID" default="">
		<cfparam name="parsedResume" default="Could not get the resume from SovRen">
		<cfparam name="parsedAddress" default="">
		
		<cfif len(form.resumeFile)>
			<!--- File Length Is Not OK Size is Over 500,000 Bytes --->
			<cfif cgi.CONTENT_LENGTH gte 153600>
				<cfset url.message = "Uploaded file is too large. Please upload files smaller than 150KB.">
				<cfset url.messagecode = 1>
			<cfelse>
				<cftry>
					<!--- Upload File --->
					<cffile action="upload" destination="#uploadedPath#" filefield="form.resumeFile" nameconflict="makeunique">
					<cfset uploadedFile = uploadedPath & cffile.serverFile />
					<cfset extList = "docx,doc,pdf" />
	
					<cfset shortName = randrange(100,100000) & "." & cffile.clientFileExt>
					<cfset reNamedFile 	= uploadedPath &  shortName>
					<cffile action="rename" destination="#reNamedFile#" source="#uploadedFile#">
					<cfset uploadedFile = reNamedFile />

					<cfset sovConsultantID = application.executive.getStoredResumeID(resumeFile=uploadedFile,resumePath=uploadedPath) />
					<cfset sovRenResumeID = sovConsultantID>
					
					<cfif len(sovRenResumeID) gt 10>
						<cfset url.message = "Issue Uploading the Resume">
						<cfset url.messagecode = 0>
					</cfif>
					
					<cfcatch type="any">
						<cfset url.message = "Issue Uploading the Resume">
						<cfset url.messagecode = 0>
					</cfcatch>
				</cftry>
			</cfif>

			
		</cfif>
	</cfif>
	<!--- //If the resume is uploaded --->
	
	<!--- URL Message Does Not Exists --->
	<cfif not(len(url.message))>

		<!---
		Update the following on the users profile since the intResID is already created for the user
		1. Get the name of the resume that user uploaded during the registration process and update the tblResumes and tblResumeProfiles
		2. Update the form field information
		--->
		<cfif isdefined("uploadedFile") and len(uploadedFile)>
			<!--- Create Folder if Needed --->
			<cftry>
				<cfscript>
				resObj = application.resume;
				resObj.setResumePath(intResid);
				//Files Uploaded Here
				resumeDirectory = resObj.getResumeDir(intResid);
				resumePath = resObj.getResumePath(intResid);
				copyFile =  uploadedPath & shortName;
				</cfscript>

				<cfif fileExists(copyFile)>
					<!--- Copy Source File if Directory Exists --->
					<cfif directoryExists(resumeDirectory)>
						<cffile action="copy" destination="#resumeDirectory#" source="#copyFile#">
					</cfif>

					<cfquery datasource="#application.dsn#">
					update tblResumes set
					resumeFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#" />
					where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
					</cfquery>
				</cfif>

				<cfcatch type="any">
				<!---Log the error to the cflog file--->
				</cfcatch>
			</cftry>
		</cfif>
		<!----End: Upload the initial resume upload--->
		
	
		<!--- Resume Was Parsed, update the resume content --->
		<cfif len(sovRenResumeID)>
			<cfset consultants = application.executive.getParsedConsultants(consultantid=sovRenResumeID) />
			<cfset parsedResume = consultants.resume />
			<cfset parsedAddress = consultants.address1 />
			<cfif len(parsedResume)>
				<!---Update the Username for this intResID as the procedure sp_exec_registration does not update the username--->
				<cfquery name="cfqUpdResume" datasource="#application.dsn#">
					update tblresumes set
						resume=<cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
					where intresid = #intResID#
				</cfquery>
			</cfif>
		</cfif>
		<!--- //Resume Was Parsed, update the resume content --->
	
		<cfquery name="cfqInsRecord" datasource="#application.dsn#">
			delete from tblResumeProfiles where resumeFile is NULL and consIntID is NULL and fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
		
			update tblResumeProfiles 
			   set blnactive = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			  where fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
			
			insert into tblResumeProfiles(fk_intresid, blnactive, dteCreated, dteEdited, title, resumeFile, consIntID)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">, <cfqueryparam cfsqltype="cf_sql_integer" value="1">, getdate(), getdate(),<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.resumeTitle#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#sovRenResumeID#">)
	
			update tblResumeProfiles set
				resume=<cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
			where fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
			and resumefile=<cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">
			and title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.resumeTitle#">
		</cfquery>
		<cfset session.EXEC.dteResumeEdited = now()>
	</cfif>
	<!--- //URL Message Does Not Exists --->	
	
</cfif>


<!--- Start Premium Membership --->
<!--- <cfset qresumes = resObj.getResumes() /> --->
<cfquery name="qresumes" datasource="#application.dsn#">
select resProfile.pk_managerid as resumeid,resProfile.blnactive, resProfile.title,  dbo.udf_FormatDateTime(resProfile.dteEdited,'mm/dd/yyyy') as dateEdited, resProfile.views, resProfile.clicks,resProfile.resumefile,resumes.intPostRecepient
  from dbo.tblresumeprofiles resProfile(nolock)
 right outer join dbo.tblResumes resumes (nolock)
    on resumes.intresid = resProfile.fk_intresid
 where resProfile.fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
 order by resProfile.title
</cfquery>
<div class="page-companies">
	<article class="section companies well">
		<div class="container">
			<!--- If the form is submitted --->
			<table border="0" cellpadding="0" cellspacing="0" width="1000">
				<tr>
					<td>
						<cfif (URLPostingOnly eq 0)> <!--- check the posting status of the job, the first time through the page --->
							<cfquery name="cfqGetAppMeth" datasource="#application.dsn#">
							select intAppMeth from tblJobs (nolock) where intJobID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intJobID)#" null="no" />
							</cfquery>
								
							<cfif cfqGetAppMeth.RecordCount eq 1>
								<cfset URLPostingOnly=cfqGetAppMeth.intAppMeth>
						   </cfif>
						</cfif>
						
						<cfif (URLPostingOnly eq 2)>
							<cfquery name="cfqGetAppMeth" datasource="#application.dsn#">
							select strjobURL from tblJobs (nolock) where intJobID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intJobID)#" null="no" />
							</cfquery>
			
							<cfif len(cfqGetAppMeth.strjobURL)>
								<cfif cfqGetAppMeth.strjobURL does not contain "http://">
									<cfset strJobURL="http://" & cfqGetAppMeth.strjobURL>
								<cfelse>
									<cfset strJobURL=cfqGetAppMeth.strjobURL>
								</cfif>
							<cfelse>
								<cfset strJobURL="">
							</cfif>
							
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr><td><h1 class="PageHeader">Apply to Job</h1></td></tr>
								
								<cfif strjobURL neq "">
									<tr>
										<td>
											<table cellpadding="0" cellspacing="4" border="0" width="100%">
												<tr>
													<td>
														<table cellpadding="0" cellspacing="0" border="0" width="100%">
															<tr>
																<td colspan="2" style="font-size:14px;line-height:18px;">
																The Employer/Recruiter has requested that you apply for this position directly through their career website.<br><br><a href="/job-apply?#application.strAppAddToken#&intJobID=#intJobID#&track=y" style="font-size:16px;line-height:18px;font-weight:bold;" target="_blank" >Visit career site to apply for the job</a>.</span><br>
																</td>
															</tr>
														</table>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								<cfelse>
									<tr>
										<td class="bold">
											<table cellpadding="0" cellspacing="4" border="0" width="100%">
												<tr>
													<td valign="top" rowspan="2"><img src="images/alert_icon.gif"></td>
													<td width="15">&nbsp;</td>
													<td>
														<table cellpadding="0" cellspacing="0" border="0" width="100%">
															<tr>
																<td colspan="2">
																	<b>To apply for this position you must visit the URL listed on the job details page.  The Employer/Recruiter has requested that you apply for this position directly through their website.</b>
																</td>
															</tr>
														</table>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</cfif>
								
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td style="padding-top:30px;">
									
										<cfswitch expression="#strCaller#">
											<cfcase value="ExecJobOfDayDetail">
												11<a href="##" onClick="window.location='ExecJobOfDayDetail.cfm?#application.strAppAddToken#&intJobID=#intJobID#&am=#am#&tm=#tm#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold; padding-right:10px;">BACK TO JOB DESCRIPTION</a>
											</cfcase>
											
											<cfcase value="ExecCorpJobDetail">
												22<a href="##" onClick="window.location='ExecSearchJobsDetail.cfm?#application.strAppAddToken#&strCaller=ExecCorpJobDetail&intCorpID=#intCorpID#&intJobID=#intJobID#&imgLogo=#imgLogo#&am=#am#&tm=#tm#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold;">BACK TO JOB DESCRIPTION</a>
											</cfcase>
											
											<cfcase value="CompanyJobs">
												<cfparam name="intcompanyid" default="0">
												<cfparam name="start" default="0">
												
												<cfif isdefined('url.eid')>
													<cftry>
														<cfset intcompanyid=urldecode(CFusion_decrypt(url.eid,companyjobsencryptkey))>
														<cfcatch type="Any">
															<cfset intcompanyid="0">
														</cfcatch>
													</cftry>
												</cfif>
												
												<cfif isdefined('url.start')>
													<cfset start=url.start>
												</cfif>
												33<a href="##" onClick="window.location='ExecSearchJobsDetail.cfm?#application.strAppAddToken#&strCaller=ExecCorpJobDetail&intCorpID=#intCorpID#&intJobID=#intJobID#&eid=#urlencodedformat(CFusion_Encrypt(intcompanyid,companyjobsencryptkey))#&strcaller=#strcaller#&start=#Start#&imgLogo=#imgLogo#&am=#am#&tm=#tm#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold; padding-right:10px;">BACK TO JOB DESCRIPTION</a>
											</cfcase>
											
											<cfcase value="ExecAutoEmailJob">
												<cfparam name="intcompanyid" default="0">
												<cfparam name="start" default="0">
												<cfif isdefined('url.eid')>
													<cftry>
														<cfset intcompanyid=urldecode(CFusion_decrypt(url.eid,companyjobsencryptkey))>
														<cfcatch type="Any">
															<cfset intcompanyid="0">
														</cfcatch>
													</cftry>
												</cfif>
												
												<cfif isdefined('url.start')>
													<cfset start=url.start>
												</cfif>
												
												44<a href="##" class="executive_button" onClick="window.location='ExecViewJob.cfm?#application.strAppAddToken#&ID=#intJobID#&eid=#urlencodedformat(CFusion_Encrypt(intcompanyid,companyjobsencryptkey))#&strcaller=#strcaller#&start=#Start#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold; padding-right:10px;">BACK TO JOB DESCRIPTION</a>
											</cfcase>
			 
											<cfcase value="ExecSearchAgent">
												55<a href="##" onClick="window.location='ExecSearchAgent.cfm?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&strTitle=#URLEncodedFormat(strTitle)#&strMode=JobDetail&strCaller=ExecSearchAgent&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold; padding-right:10px;">BACK TO JOB DESCRIPTION</a>
											</cfcase>
											
											<cfcase value="ExecMyJobsDetail">
												66<a href="##" onClick="window.location='ExecMyJobsDetail.cfm?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&strCaller=#strCaller#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold;">BACK TO JOB DESCRIPTION</a>
											</cfcase>
											
											<cfdefaultcase>
												<cfquery name="cfqGetSEOJobURL" datasource="#application.dsn#">
												select seoJobURL from tblJobs (nolock) where intJobID=#intJobID#
												</cfquery>
												
												<!--- <a href="##" onclick="window.location='ExecSearchJobsDetail.cfm?#application.strAppAddToken#&intPageNo=#intPageNo#&intJobID=#intJobID#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold;">BACK TO JOB DESCRIPTION</a> --->
												<a href="##" onClick="window.location='#cfqGetSEOJobURL.seoJobURL#';"  role="button" class="btn btn-primary btn-small">BACK TO JOB DESCRIPTION</a>
												&nbsp;&nbsp;<a href="##" onClick="window.location='/jobs/?start1=#url.start1#&pgNo=#url.pgNo#';"  class="btn btn-primary btn-small">BACK TO JOB SEARCH RESULTS</a>
											</cfdefaultcase>
										</cfswitch>  
									</td>
								</tr>
							</table>
						<cfelse>
							<cfif isDefined("session.exec.intResAdmCode") and session.exec.intResAdmCode eq 1>        
								<cfparam name="form.resumetype"  default="" />
								<!--- get job info from db --->
								<cfquery name="cfqJob" datasource="#application.dsn#">
								select distinct jobs.intJobID, jobs.title, jobs.jcode, jobs.jpname, jobs.email, jobs.date_submitted, jobs.intEmployerID, emp.intAcctType, jobs.state, jobs.location, jobs.blnEmailREyes,
									   acctMngr.strFirstName, acctMngr.strLastName, acctMngr.strEmail, acctMngr.strPhoneExt
								  from tblJobs jobs (NOLOCK)
								inner join tblEmployers emp (NOLOCK)
								on emp.intEmployerID = jobs.intEmployerID
								inner join tblAcctMngr acctMngr (NOLOCK)
								on emp.intAcctMngrID = acctMngr.intAcctMngrID
								where jobs.intJobID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intJobID)#" null="no" />
								</cfquery>
								
								<!---Start: iCandidate--->		
								<cfset intAcctType = #cfqJob.intAcctType#>
								<cfset strAcctMngrFName = #cfqJob.strFirstName#>
								<cfset strAcctMngrLName = #cfqJob.strLastName#>
								<cfset strAcctMngrEmail = #cfqJob.strEmail#>
								<cfset strAcctMngrPhoneExt = #cfqJob.strPhoneExt#>
								<!---End: iCandidate--->
								
								<cfset intJobEmployerID=#cfqJob.intEmployerID#>
								<cfset jcode=#cfqJob.jcode#>
								<cfset jpname=#cfqJob.jpname#>
								
								<cfset title=#cfqJob.title#>
			
								<cfif findnocase("$$DQ$$",title,1) gt 0>
									<cfset title=replace(title,"$$DQ$$","&quot;","all")>
								</cfif>
			
								<cfset location=#cfqJob.location#>
								<cfset state=#cfqJob.state#>
								<cfset jobemail=#cfqJob.email#>
								<cfset date_submitted=#cfqJob.date_submitted#>
								<cfset receive_from_REyes=#cfqJob.blnEmailREyes#>
								
								<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
									<cfif state eq arrStates[intIndexNo][1]>
										<cfset strState=#arrStates[intIndexNo][2]#>
										<cfbreak>
									</cfif>
								</cfloop>
							
								<cfquery name="cfqGetCoverLetters" datasource="#application.dsn#">
								select intLetterID, strCoverName,dteSubmit
								from tblCoverLetters (NOLOCK)
								where intresid=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" />
								order by dteSubmit DESC
								</cfquery>
										
															  
								<!---Start: Count Job Applications--->
								<!---If new member waiting to be approved for the Membership, count the jobs applied from the Job Application Queue--->
								<cfif intResAdmcode eq 2>
									<cfquery name="qApplyCount" datasource="#application.dsn#">
									select count(*) as totalSubmissions
									from tblJobApplicationQueue (NOLOCK)
									where intresid=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" />
									and intJobid = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intJobID)#" null="no" /> 
									and dteApplied > getdate()-14
									</cfquery>
								<!---If already approved member --->
								<cfelse>         
									<cfquery name="qApplyCount" datasource="#application.dsn#">
									select count(*) as totalSubmissions
									from tblOneClickHist (NOLOCK)
									where intresid=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" />
									and intJobid = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intJobID)#" null="no" /> 
									and dteSubmit > getdate()-14
									</cfquery>
								</cfif>
								<!---End: Count Job Applications--->
																	   
								<table border=0 cellpadding=0 cellspacing=0 width="100%">
									<tr><td><h1 class="PageHeader">Apply to Job</h1></td></tr>
									<tr>
										<td>
											<table border="0" cellpadding=0 cellspacing=0 width="100%">
												<tr><td colspan="2"><img src="/images/spacer.gif" border=0 height=3></td></tr>
												<tr><td valign="top" align="left" colspan="1" style="font-size: 16px; line-height:20px; font-weight:bold;">#title#</td></tr>
												<tr><td valign="top" align="left" colspan="1" style="font-size: 16px; line-height:20px; font-weight:bold;">#jpname#</td></tr>
												<tr><td valign="top" align="left" colspan="1" style="font-size: 14px; line-height:20px; font-weight:bold;"><cfif len(location)>#location#,</cfif> #strState#</td></tr>
												<tr><td>&nbsp;</td></tr>
												<tr><td><span style="font-size:16px; padding-top:40px; padding-bottom:20px; line-height:20px;">You 6FigureJobs application is incomplete, you must complete your application to apply to this job.</span> <br /></td></tr>  
											</table>
										</td>
									</tr>
								</table>
			<!-------------------------------------------------------------------------------------------------------------------------------------------------------------------->                
							<cfelse>
			<!-------------------------------------------------------------------------------------------------------------------------------------------------------------------->
								
								<cfparam name="form.resumetype"  default="" />
								<!--- Stored Resume --->
								<cfif form.resumetype eq "stored">
									<cfif not isdefined("form.resumeid")>
										<cfset errTxt = "<li>Please select a resume to include with your application.</li>">	
									</cfif>                     
								</cfif>           
								
								<cfswitch expression="#strButtonAction#">
									<cfcase value="edit">
										<cfset blnFirstPass=1>
										<cfif not(len(intLetterID))>
											<cfset blnError=1>
										</cfif>
									</cfcase>
						
									<cfcase value="Apply1">
										<cfif len(intLetterID)>
											<cfquery name="cfqCoverLetter" datasource="#application.dsn#">
											select strCoverLetter
											from tblCoverLetters (NOLOCK)
											where intLetterID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intLetterID)#" null="no" />
											</cfquery>
											<cfset strCoverLetter=cfqCoverLetter.strCoverLetter>
											<cfif len(strCoverLetter)>
												<!--- add the quotes --->
												<!--- <cf_ct_removeQuotes strstrip="#strCoverLetter#" blnremove="0"> --->
												<cfset strstrip = application.util.getRemoveQuotes(strStrip="#strCoverLetter#",  blnRemove="0")>
												<cfset strCoverLetter=strStrip>
											</cfif>
										</cfif>
										<cfset blnFirstPass=0>
									</cfcase>
									
									<cfcase value="Apply2">			
										<cfset blnFirstPass=0>
									</cfcase>
						
									<cfcase value="Back">
										<cfif strCaller eq "ExecCorpJobDetail">
											<cflocation url="/job-apply?#application.strAppAddToken#&intJobID=#intJobID#&strCaller=ExecCorpJobDetail&intCorpID=#intCorpID#&intPageNo=#intPageNo#&am=#am#&tm=#tm#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
										<cfelseif strCaller eq "ExecSearchAgent">
											<cflocation url="/job-apply?#application.strAppAddToken#&intJobID=#intJobID#&strMode=run&strTitle=#strTitle#&strcaller=ExecSearchAgent&intPageNo=#intPageNo#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
										<cfelseif strCaller eq "CompanyJobs">
											<cfparam name="intJobEmployerID" default="0">
											<cfif isdefined('form.intJobEmployerID')>
												<cfset intJobEmployerID=form.intJobEmployerID>
											</cfif>
											<cfparam name="start" default="0">
											<cfif isdefined('url.start')>
												<cfset start=url.start>
											</cfif>
											<cflocation url="/job-apply?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&eid=#urlencodedformat(CFusion_Encrypt(intJobEmployerID,companyjobsencryptkey))#&strcaller=#strcaller#&start=#Start#&am=#am#&tm=#tm#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
										<cfelseif strCaller eq "ExecAutoEmailJob">
											<cfparam name="intJobEmployerID" default="0">
											<cfif isdefined('form.intJobEmployerID')>
												<cfset intJobEmployerID=form.intJobEmployerID>
											</cfif>
											<cfparam name="start" default="0">
											<cfif isdefined('url.start')>
												<cfset start=url.start>
											</cfif>
											<cflocation url="/job-apply?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&eid=#urlencodedformat(CFusion_Encrypt(intJobEmployerID,companyjobsencryptkey))#&strcaller=#strcaller#&start=#Start#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
										<cfelse>
											<cflocation url="/job-apply?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
										</cfif>
									</cfcase>
						
									<cfcase value="rtjd">			
										<cfswitch expression="#strCaller#">
											<cfcase value="ExecJobOfDayDetail">
												<cflocation url="ExecJobOfDayDetail.cfm?#application.strAppAddToken#&intJobID=#intJobID#&am=#am#&tm=#tm#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
											</cfcase>
									
											<cfcase value="CompanyJobs">
												<cfparam name="intJobEmployerID" default="0">
												<cfif isdefined('form.intJobEmployerID')>
													<cfset intJobEmployerID=form.intJobEmployerID>
												</cfif>
												<cfparam name="start" default="0">
												<cfif isdefined('url.start')>
													<cfset start=url.start>
												</cfif>
												<cflocation url="ExecSearchJobsDetail.cfm?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&eid=#urlencodedformat(CFusion_Encrypt(intJobEmployerID,companyjobsencryptkey))#&strcaller=#strcaller#&start=#Start#&am=#am#&tm=#tm#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
											</cfcase>
											<cfcase value="ExecAutoEmailJob">
												<cfparam name="intJobEmployerID" default="0">
												<cfif isdefined('form.intJobEmployerID')>
													<cfset intJobEmployerID=form.intJobEmployerID>
												</cfif>
												<cfparam name="start" default="0">
												<cfif isdefined('url.start')>
													<cfset start=url.start>
												</cfif>
												<cflocation url="ExecViewJob.cfm?#application.strAppAddToken#&ID=#intJobID#&eid=#urlencodedformat(CFusion_Encrypt(intJobEmployerID,companyjobsencryptkey))#&strcaller=#strcaller#&start=#Start#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
											</cfcase>
									
											<cfcase value="ExecCorpJobDetail">
												<cflocation url="ExecSearchJobsDetail.cfm?#application.strAppAddToken#&strCaller=ExecCorpJobDetail&intCorpID=#intCorpID#&intJobID=#intJobID#&imgLogo=#imgLogo#&am=#am#&tm=#tm#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
											</cfcase>
									
											<cfcase value="ExecSearchAgent">
												<cflocation url="ExecSearchAgent.cfm?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&strTitle=#URLEncodedFormat(strTitle)#&strMode=JobDetail&strCaller=ExecSearchAgent&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
											</cfcase>
									
											<cfcase value="ExecMyJobsDetail">
												<cflocation url="ExecMyJobsDetail.cfm?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&strCaller=#strCaller#&am=#am#&tm=#tm#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
											</cfcase>
									
											<cfdefaultcase>
												<cflocation url="ExecSearchJobsDetail.cfm?#application.strAppAddToken#&intPageNo=#intPageNo#&intJobID=#intJobID#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&start1=#url.start1#&pgNo=#url.pgNo#" addtoken="No">
											</cfdefaultcase>
										</cfswitch>   
									</cfcase>
						
									<cfdefaultcase>
										<cfset blnFirstPass=1>				
									</cfdefaultcase>
								</cfswitch>
				
								
								<!--- If Error Exists ---> 
								<cfparam name="errTxt" default="" />
								<cfif len(errTxt)>
									<cfset blnError = 1 />
									<cfset blnFirstPass = 1 />
								</cfif>
								
								<!--- first time through --->
								<cfif blnFirstPass eq 1> 
									<cfif not(len(intLetterID))> 
										<!--- get job info from db --->
										<cfquery name="cfqJob" datasource="#application.dsn#">
										select distinct jobs.intJobID, jobs.title, jobs.jcode, jobs.jpname, jobs.email, jobs.date_submitted, jobs.intEmployerID, emp.intAcctType, jobs.state, jobs.location, jobs.blnEmailREyes,
											   acctMngr.strFirstName, acctMngr.strLastName, acctMngr.strEmail, acctMngr.strPhoneExt
										  from tblJobs jobs (NOLOCK)
										inner join tblEmployers emp (NOLOCK)
										on emp.intEmployerID = jobs.intEmployerID
										inner join tblAcctMngr acctMngr (NOLOCK)
										on emp.intAcctMngrID = acctMngr.intAcctMngrID
										where jobs.intJobID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intJobID)#" null="no" />
										</cfquery>
										
										<!---Start: iCandidate--->		
										<cfset intAcctType = #cfqJob.intAcctType#>
										<cfset strAcctMngrFName = #cfqJob.strFirstName#>
										<cfset strAcctMngrLName = #cfqJob.strLastName#>
										<cfset strAcctMngrEmail = #cfqJob.strEmail#>
										<cfset strAcctMngrPhoneExt = #cfqJob.strPhoneExt#>
										<!---End: iCandidate--->
										
										<cfset intJobEmployerID=#cfqJob.intEmployerID#>
										<cfset jcode=#cfqJob.jcode#>
										<cfset jpname=#cfqJob.jpname#>
										
										<cfset title=#cfqJob.title#>
				
										<cfif findnocase("$$DQ$$",title,1) gt 0>
											<cfset title=replace(title,"$$DQ$$","&quot;","all")>
										</cfif>
				
										<cfset location=#cfqJob.location#>
										<cfset state=#cfqJob.state#>
										<cfset jobemail=#cfqJob.email#>
										<cfset date_submitted=#cfqJob.date_submitted#>
										<cfset receive_from_REyes=#cfqJob.blnEmailREyes#>
										
										<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
											<cfif state eq arrStates[intIndexNo][1]>
												<cfset strState=#arrStates[intIndexNo][2]#>
												<cfbreak>
											</cfif>
										</cfloop>
									
										<cfquery name="cfqGetCoverLetters" datasource="#application.dsn#">
										select intLetterID, strCoverName,dteSubmit
										from tblCoverLetters (NOLOCK)
										where intresid=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" />
										order by dteSubmit DESC
										</cfquery>
										
										<cfset intCount=cfqGetCoverLetters.RecordCount>
									</cfif>
									
									<!---Start: Count Job Applications--->
									<!---If new member waiting to be approved for the Membership, count the jobs applied from the Job Application Queue--->
									<cfif intResAdmcode eq 2>
										<cfquery name="qApplyCount" datasource="#application.dsn#">
										select count(*) as totalSubmissions
										from tblJobApplicationQueue (NOLOCK)
										where intresid=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" />
										and intJobid = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intJobID)#" null="no" /> 
										and dteApplied > getdate()-14
										</cfquery>
									<!---If already approved member --->
									<cfelse>         
										<cfquery name="qApplyCount" datasource="#application.dsn#">
										select count(*) as totalSubmissions
										from tblOneClickHist (NOLOCK)
										where intresid=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" />
										and intJobid = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intJobID)#" null="no" /> 
										and dteSubmit > getdate()-14
										</cfquery>
									</cfif>
									<!---End: Count Job Applications--->
									
									<!---
									<span id="FormDisplay" class="On">
									<form name="applyNow" id="applyNow" action="ExecOneClickApply.cfm?#application.strAppAddToken#&am=#am#&tm=#tm#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#" method="post" enctype="multipart/form-data" <cfif qresumes.recordcount gt 1> onsubmit="return checkFormResume(this);" </cfif>>
									<input type="Hidden" name="intJobID" value="#intJobID#">
									<input type="Hidden" name="intJobEmployerID" value="#intJobEmployerID#">
									<input type="Hidden" name="jcode" value="#jcode#">
									<input type="Hidden" name="jpname" value="#jpname#">
									<input type="Hidden" name="title" value="#title#">
									<input type="Hidden" name="location" value="#location#">
									<input type="Hidden" name="strState" value="#strState#">
									<input type="Hidden" name="jobemail" value="#jobemail#">
									<input type="Hidden" name="date_submitted" value="#date_submitted#">
									<input type="Hidden" name="blnFirstPass" value="#blnFirstPass#">
									<input type="Hidden" name="strCaller" value="#strCaller#">
									<input type="Hidden" name="intJOD" value="#intJOD#">
									<input type="Hidden" name="intPageNo" value="#intPageNo#">
									<input type="Hidden" name="intResID" value="#intResID#">
									<input type="Hidden" name="strTitle" value="#strTitle#">
									<input type="Hidden" name="intLetterID" value="#intLetterID#">
									<input type="Hidden" name="imgLogo" value="#imgLogo#">
									<input type="Hidden" name="receive_from_REyes" value="#receive_from_REyes#">
									<input type="Hidden" name="URLPostingOnly" value="#URLPostingOnly#">
									<input type="Hidden" name="intCorpID" value="#intCorpID#">
									<input type="Hidden" name="strButtonAction" value="">
									<input type="Hidden" name="sort" value="#sort#">
									<input type="Hidden" name="sortorder" value="#sortorder#">
									
									<!---Start: iCanididate--->
									<input type="hidden" name="intAcctType" value="#intAcctType#" />
									<input type="hidden" name="strAcctMngrFName" value="#strAcctMngrFName#" />
									<input type="hidden" name="strAcctMngrLName" value="#strAcctMngrLName#" />
									<input type="hidden" name="strAcctMngrEmail" value="#strAcctMngrEmail#" />
									<input type="hidden" name="strAcctMngrPhoneExt" value="#strAcctMngrPhoneExt#" />
									<!---End: iCanididate--->                        
									
									
									<cfif isdefined('url.start')>
										<input type="Hidden" name="start" value="#url.start#">
									<cfelseif isdefined('form.start')>
										<input type="Hidden" name="start" value="#form.start#">
									</cfif>
									<input type="Hidden" name="resumetype" id="resumetype" value="stored" />
							
							
									<!--- Used For Resume Editing purposes only --->
									<cfif isdefined("form.strButtonAction") and form.strButtonAction eq "Edit">
										<cfif isdefined("form.resumeid") and form.resumeid neq 0>
											<input type="Hidden" name="resumeid" id="resumeid" value="#form.resumeid#" />                   
										</cfif>
									</cfif>
									--->                
									<table border=0 cellpadding=0 cellspacing=0 width="100%">
										<cfif not(len(intLetterID))>
											<cfif isdefined('url.clID')>
												<script language="JavaScript">
												function GotoEdit(){
													document.applyNow.intLetterID.value=#url.clID#;
													document.applyNow.strButtonAction.value =  'Edit' ;
													document.applyNow.submit();
												}
												GotoEdit();
												</script>
											</cfif>
											<tr><td><h1 class="PageHeader">Apply to Job</h1></td></tr>
											<tr>
												<td>
													<table border="0" cellpadding=0 cellspacing=0 width="100%">
														<tr><td colspan="2"><img src="/images/spacer.gif" border=0 height=3></td></tr>
														<tr><td valign="top" align="left" colspan="1" style="font-size: 16px; line-height:20px; font-weight:bold;">#title#</td></tr>
														<tr><td valign="top" align="left" colspan="1" style="font-size: 16px; line-height:20px; font-weight:bold;">#jpname#</td></tr>
														<tr><td valign="top" align="left" colspan="1" style="font-size: 14px; line-height:20px; font-weight:bold;"><cfif len(location)>#location#,</cfif> <cfif len(strState)>#strState#,</cfif></td></tr>
														<tr><td>&nbsp;</td></tr>                                                                          
														
														<!--- Premium Member and totalsubmission eq 0 isboolean(session.exec.isPremium) and isboolean(session.exec.isPremium) and --->  
														<cfif qApplyCount.totalSubmissions eq 0>
															<!--- If Premium Member --->           
															<script language="JavaScript" src="/v16fj/js/fileUpload.js" type="text/javascript"></script> 
															<script language="JavaScript" src="/v16fj/js/onClickApply.js" type="text/javascript"></script> 
															
															
															<!---LinkedIn Registration--->
															<cfif session.exec.strRegistrationMethod is "LinkedIn">
																
																<cfif qResumes.RecordCount gt 1>
																	<cfset showResumeUpload = 0>
																	<cfset showResumeSelect = 1>
																<cfelse>
																	<cfset showResumeUpload = 1>
																	<cfset showResumeSelect = 1>
																</cfif>
															<!---6FJ Registration (People can register via 6FJ and login via LinkedIn--->
															<cfelse>
																<!---
																<cfif qResumes.RecordCount gt 0 and len(qResumes.resumeFile)>
																	<cfset showResumeUpload = 0>
																	<cfset showResumeSelect = 1>
																<cfelse>
																	<cfset showResumeUpload = 1>
																	<cfset showResumeSelect = 0>
																</cfif>
																--->
																<cfset liResumeTitle = "#trim(session.exec.strFirstName)##trim(session.exec.strLastName)#-LinkedInProfile">
																
																<cfif qResumes.RecordCount is 1 and len(qResumes.resumeFile)>
																	<cfif qResumes.title is liResumeTitle>						
																		<cfset showResumeUpload = 1>
																		<cfset showResumeSelect = 1>
																	<cfelse>
																		<cfset showResumeUpload = 0>
																		<cfset showResumeSelect = 1>
																	</cfif>
																<cfelseif qResumes.RecordCount is 0>
																	<cfset showResumeUpload = 1>
																	<cfset showResumeSelect = 0>
																<cfelse>
																	<cfset showResumeUpload = 0>
																	<cfset showResumeSelect = 1>														
																</cfif>
																
															</cfif>
															
															<!--- Show the Resume Upload Option --->
															<cfif showResumeUpload is 1 and showResumeSelect is 1>
															
																<cfif url.messagecode is 1>
																	<tr>
																		<td>
																		<span class="redalert">
																		<strong>
																		Woops! We could not process the information submitted. Please try again.
																		<br />
																		#URL.message#
																		</strong>
																		</span>
																		</td>
																	</tr>
																<cfelseif url.messagecode is 0>
																	<tr><td><span class="redalert"><strong>Woops! We could not process the information submitted. Please try again.</strong></span></td></tr>
																</cfif>
															
																<tr>
																	<td valign="top" colspan="2">
																		<table border="0" cellpadding="10" cellspacing="5">
																			<tr>
																				<td align="left" colspan="5" valign="top" style="font-size:12px"><strong>We strongly recommend you upload your official resume to attract recruiters who search our system.</strong></td>
																			</tr>
																			<tr>
																				<td bgcolor="##ea9999">
																					<form name="myAccountResumeUpload" id="myAccountResumeUpload"  action="/job-apply" method="post" enctype="multipart/form-data">
																					<input type="hidden" name="section" value="resumeUpload" />
																					<input type="hidden" name="intJobID" value="#intJobID#" />
																					<div>
																						<strong>Resume Title</strong>&nbsp;<input type="text"  name="resumeTitle" value="" id="resumeTitle" placeholder="Name your resume" size="30"  maxlength="35"  />
																						<div class="spacer"></div>
																						<strong>Microsoft Word or PDF files only.</strong>
																						<div class="spacer"></div>
																						<input name="resumeFile" value="" type="file" size="30" id="resumeFile"  />
																						<div id="resumeUploadDiv" style="color:##F00; display:none;"><strong>Please select a resume to upload to continue.</strong></div>
																						
																						<div class="spacer"></div>
																						<input type="button" name="validate" id="resUploadSubmitBtn" value="Upload Resume" onClick="return checkResumeUpload();">
																					</div>
																					</form>
																				</td>
																			</tr>
																		</table>
																	</td>
																</tr>
															<cfelseif showResumeUpload is 1 and showResumeSelect is 0>
																
																<cfif url.messagecode is 1>
																	<tr>
																		<td>
																		<span class="redalert">
																		<strong>
																		Woops! We could not process the information submitted. Please try again.
																		<br />
																		#URL.message#
																		</strong>
																		</span>
																		</td>
																	</tr>
																<cfelseif url.messagecode is 0>
																	<tr><td><span class="redalert"><strong>Woops! We could not process the information submitted. Please try again.</strong></span></td></tr>
																</cfif>
																
																<tr>
																	<td valign="top" colspan="2">
																		<table border="0" cellpadding="10" cellspacing="5">
																			<tr>
																				<td align="left" colspan="5" valign="top" style="font-size:12px"><strong>A resume is required if you want recruiters to search for you and if you want to apply to jobs.</strong></td>
																			</tr>
																			<tr>
																				<td bgcolor="##ea9999">
																					
																					<form name="myAccountResumeUpload" id="myAccountResumeUpload"  action="/job-apply" method="post" enctype="multipart/form-data">
																					<input type="hidden" name="section" value="resumeUpload" />
																					<input type="hidden" name="intJobID" value="#intJobID#" />
																					<div>
																						<strong>Resume Title</strong>&nbsp;<input type="text"  name="resumeTitle" value="" id="resumeTitle" placeholder="Name your resume" size="30" maxlength="35"  />
																						<div class="spacer"></div>
																						<strong>Microsoft Word or PDF files only.</strong>
																						<div class="spacer"></div>
																						<input name="resumeFile" value="" type="file" size="30" id="resumeFile"  />
																						<div id="resumeUploadDiv" style="color:##F00; display:none;"><strong>Please select a resume to upload to continue.</strong></div>
																						<div class="spacer"></div>
																						<input type="button" name="validate" id="resUploadSubmitBtn" value="Upload Resume" onClick="return checkResumeUpload();">
																					</div>
																					</form>
																				</td>
																			</tr>
																		</table>
																	</td>
																</tr>
															</cfif>
															<!--- //Show the Resume Upload Option --->
															
															<cfif showResumeSelect is 1>
																<form name="applyNow" id="applyNow" action="/job-apply?#application.strAppAddToken#&am=#am#&tm=#tm#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#" method="post" enctype="multipart/form-data" <cfif qresumes.recordcount gt 1> onsubmit="return checkFormResume(this);" </cfif>>
																<input type="Hidden" name="intJobID" value="#intJobID#">
																<input type="Hidden" name="intJobEmployerID" value="#intJobEmployerID#">
																<input type="Hidden" name="jcode" value="#jcode#">
																<input type="Hidden" name="jpname" value="#jpname#">
																<input type="Hidden" name="title" value="#title#">
																<input type="Hidden" name="location" value="#location#">
																<input type="Hidden" name="strState" value="#strState#">
																<input type="Hidden" name="jobemail" value="#jobemail#">
																<input type="Hidden" name="date_submitted" value="#date_submitted#">
																<input type="Hidden" name="blnFirstPass" value="#blnFirstPass#">
																<input type="Hidden" name="strCaller" value="#strCaller#">
																<input type="Hidden" name="intJOD" value="#intJOD#">
																<input type="Hidden" name="intPageNo" value="#intPageNo#">
																<input type="Hidden" name="intResID" value="#intResID#">
																<input type="Hidden" name="strTitle" value="#strTitle#">
																<input type="Hidden" name="intLetterID" value="#intLetterID#">
																<input type="Hidden" name="imgLogo" value="#imgLogo#">
																<input type="Hidden" name="receive_from_REyes" value="#receive_from_REyes#">
																<input type="Hidden" name="URLPostingOnly" value="#URLPostingOnly#">
																<input type="Hidden" name="intCorpID" value="#intCorpID#">
																<input type="Hidden" name="strButtonAction" value="">
																<input type="Hidden" name="sort" value="#sort#">
																<input type="Hidden" name="sortorder" value="#sortorder#">
												
																<!---Start: iCanididate--->
															   <input type="hidden" name="intAcctType" value="#intAcctType#" />
																<input type="hidden" name="strAcctMngrFName" value="#strAcctMngrFName#" />
																<input type="hidden" name="strAcctMngrLName" value="#strAcctMngrLName#" />
																<input type="hidden" name="strAcctMngrEmail" value="#strAcctMngrEmail#" />
																<input type="hidden" name="strAcctMngrPhoneExt" value="#strAcctMngrPhoneExt#" />
																<!---End: iCanididate--->                        
									
									
																<cfif isdefined('url.start')>
																<input type="Hidden" name="start" value="#url.start#">
																<cfelseif isdefined('form.start')>
																<input type="Hidden" name="start" value="#form.start#">
																</cfif>
																<input type="Hidden" name="resumetype" id="resumetype" value="stored" />
							
							
																 <!--- Used For Resume Editing purposes only --->
																<cfif isdefined("form.strButtonAction") and form.strButtonAction eq "Edit">
																	<cfif isdefined("form.resumeid") and form.resumeid neq 0>
																	<input type="Hidden" name="resumeid" id="resumeid" value="#form.resumeid#" />                   
																	</cfif>
																</cfif>
																
																<tr>
																	<td valign="top" colspan="2">
																		<table border="0">
																			<tr>
																				<div class="spacer"></div>
																				<div class="spacer"></div>
																				<div class="spacer"></div>
																				<div class="spacer"></div>
																			</tr>
																		</table>
																	</td>
																</tr>
																
																<tr>
																	<td valign="top" colspan="2">
																		<table border="0">
																			<tr>
																				<td align="left" colspan="5" valign="top"><h3>Select a Resume</h3></td>
																			</tr>
																		</table>
																	</td>
																</tr>
																	
																<tr>
																	<td align="left" colspan=2> 
																		<!--- My Resumes --->
																		<span id="storedResume" class="on">
																		
																					<!--- Start Resume Profile --->
																					<table cellpadding="4" cellspacing="0" border="0" width="100%" class="table">
																						<tr>
																							<th>Select</th>
																							<th>Resume Title</th>
																							
																							<th>Last Edit</th>
																							<th></th>
																						</tr> 
																						<cfloop query="qresumes">
																						<tr>
																							<td  id="row#resumeid#"> 
																								<input 
																								#iif((qresumes.recordcount eq 0),de('checked'),de(''))# 
																								#iif((isboolean(form.resumeid) and form.resumeid),de('checked'),de(''))#  
																								#iif((isboolean(blnactive) and blnactive),de('checked'),de(''))#  name="resumeid" type="radio" id="resumeid" value="#resumeid#">
																							</td>
																							<td >#title#&nbsp;<cfif resumefile neq "">(#resumefile#)</cfif></td>
																							<td >#ltrim(rtrim(dateEdited))#</td>
																							<td ><a target="_parent" href="/member-resume-edit?#application.strAppAddToken#&resumeid=#resumeid#&blnapplytojob=1" role="button" class="btn btn-primary btn-small">Edit</a>&nbsp;&nbsp;<a target="_parent" href="/member-resume-preview?#application.strAppAddToken#&resumeid=#resumeid#&blnapplytojob=1" role="button" class="btn btn-primary btn-small">View</a></td>
																							
																						</tr>
																						</cfloop>
																					</table>		
																					<!--- C4DDBF End Resume Profile --->
																				
																		</span>  
																		<br />
																	</td>
																</tr>
															</cfif>
																
														</cfif>     
													</table>
												</td>
											</tr>
											<tr>
												<td align="left" style="font-size:13px; font-weight:bold;">                            
													<cfif qApplyCount.totalSubmissions gt 0>    
														<p align="left" style="color:##CC0000;">
														 You already applied for this position within the last 14 days.
														 <div class="spacer" style="padding-bottom:20px;"></div>
														 <a href="##" onClick="window.location='ExecSearchJobsDetail.cfm?#application.strAppAddToken#&intPageNo=#intPageNo#&intJobID=#intJobID#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold; margin-right:20px;">BACK TO JOB DESCRIPTION</a>
														 <a href="##" onClick="window.location='/jobs/?start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold;">BACK TO JOB SEARCH RESULTS</a>
														</p>
													<!--- if there are cover letters, display them --->                  
													<cfelseif intCount neq 0 and showResumeSelect is 1>						
														<!--- Start Cover Letter --->
														<!--- <table border=0 cellpadding=1 cellspacing=1 width="100%">
															<tr><td colspan="4">&nbsp;</td></tr>
															<tr>
																<td colspan="4"> --->
																	<table width="100%">
																		<tr>
																		
																			<td align="left" valign="top" width="130"><h3>Select a Cover Letter</h3></td>
																			<td width="50%" align="right">
																				<cfif cfqGetCoverLetters.recordcount lt 3>
																					<a target="_parent" href="/execs/resbuilder/execrescover.cfm?#application.strAppAddToken#&blnapplytojob=1">Create a New Cover Letter</a>
																				</cfif>
																			</td>
																		</tr>
																	</table>
																<!--- </td>
															</tr>
				
															<tr>
																<td> --->
																	<table cellpadding="4" cellspacing="0" border="0" width="100%" class="table">
																		<tr>
																			<th>Select</th>
																			<th>Cover Letter Name</th>
																			<th>Last Edit</th>
																			<th>&nbsp;</th>                                                    
																		</tr>
																		<cfloop query="cfqGetCoverLetters">
																		<cfset strCoverName1=Replace(cfqGetCoverLetters.strCoverName, "$$SQ$$", chr(39), "ALL")>
																		<cfif (currentRow mod 2 eq 0)>
																			<cfset lcl_class="exec_lite_gry">
																		<cfelse>
																			<cfset lcl_class="exec_dark_gry">
																		</cfif>
																		<tr>
																			<td><input type="radio" name="intLetterID" value="#intLetterID#"></td>
																			<td>#strCoverName1#</td>
																			<td>#DateFormat(dteSubmit, 'mm/dd/yyyy')#</td>
																			<td><a target="_parent" href="/member-letter-edit?#application.strAppAddToken#&letterid=#intLetterID#&blnapplytojob=1" role="button" class="btn btn-primary btn-small">Edit</a>&nbsp;&nbsp;<a target="_parent" href="/member-letter-preview?#application.strAppAddToken#&letterid=#intLetterID#&blnapplytojob=1" role="button" class="btn btn-primary btn-small">View</a></td>
																			
																		</tr>
																		</cfloop>
																	</table>
																<!--- </td>
															</tr>
															<tr>
																<td> --->
																	<span id="AppplyJobSubmitBtn" style="visibility:visible;">
																	<table border="0">
																		<tr><td align="center" colspan="3"><a href="##" id="ApplyToJobbutton" onClick="document.applyNow.strButtonAction.value='Apply1'; apply('Apply1'); document.applyNow.submit();" role="button" class="btn btn-primary btn-small">APPLY TO JOB</a></td></tr>
																	</table>
																	</span>
																	<!---Processing span--->
																	<span id="Processing" style="visibility:hidden;">
																	<table border=0 cellpadding=0 cellspacing=0 width="100%">
																		<tr><td align="center" class="er_bld_blue"><img style="vertical-align:middle" src="/images/icon_hourglass.gif">&nbsp;&nbsp;Processing your request...Please wait</td></tr>
																	</table>
																	</span>
																<!--- </td>
															</tr>
														</table> --->
														<!--- End Cover Letter --->	
													<cfelseif intCount eq 0 and showResumeSelect is 1>
														<table border=0 cellpadding=0 cellspacing=0 width="90%">
															<tr>
																<td align="left" valign="top" width="130" style="font-size:12px; padding-bottom:6px;"><strong>Want to include a Cover Letter?</strong></td>
															</tr>
				
															<tr>
																<td align="left" style="padding-bottom:6px;">
																	<span style="color:red"><b>NOTE:</b>
																	The cover letter you enter here will not be saved. It will only be appended to this job application.<br>
																	If you would like to store a permanent cover letter, <a href="/member-resume?activeTab=letters&100k=1?#application.strAppAddToken#&clID=0&mode=e&intJobID=#intJobID#&imgLog=#imgLogo#&strCaller=#strCaller#&intJOD=#intJOD#&intPageNo=#intPageNo#&blnEditApplyNow=1&am=#am#&tm=#tm#">click here</a>.
																	</span>
																</td>
															</tr>
															<tr>
																<td align="left">
																	<table border=0 cellpadding=2 cellspacing=0>
																		<tr><td colspan="2"><textarea name="strCoverLetter" rows=20 cols="81" style="width:650px; max-width:650px; noresize:noresize;" wrap="virtual">#strCoverLetter#</textarea></td></tr>
																		<tr>			
																			<td>
																				<span id="AppplyJobSubmitBtn" style="visibility:visible;">
																				<table  border="0" cellspacing="10" width="100%">
																					<tr>
																						<td>
																							<input type="submit" onClick="return apply('Apply2');" border="0" id="ApplyToJobbutton" class="btn btn-primary btn-large" value="APPLY NOW">
																						</td>                                                                    
																						<td align="right" valign="middle"><a href="##" onClick="window.location='ExecSearchJobsDetail.cfm?#application.strAppAddToken#&intPageNo=#intPageNo#&intJobID=#intJobID#&am=#am#&tm=#tm#&sort=#sort#&sortorder=#sortorder#&jrl=1&start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold;">BACK TO JOB DESCRIPTION</a></td>
																					</tr>
																				</table>
																				</span>
																				<!---Processing span--->
																				<span id="Processing" style="visibility:hidden;">
																				<table border=0 cellpadding=0 cellspacing=0 width="100%">
																					<tr><td align="center" class="er_bld_blue"><img style="vertical-align:middle" src="/images/icon_hourglass.gif">&nbsp;&nbsp;Processing your request...Please wait</td></tr>
																				</table>
																				</span>
																				
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</cfif>
												</td>
											</tr>
										<!--- a cover letter was selected, now edit it --->    
										<cfelse>
											<cfquery name="cfqCoverLetter" datasource="#application.dsn#">
											select strCoverLetter
											from tblCoverLetters (NOLOCK)
											where intLetterID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intLetterID)#" null="no" />
											</cfquery>
											<cfset strCoverLetter=cfqCoverLetter.strCoverLetter>
											<cfif strCoverLetter neq "">
												<!--- add the quotes --->
											   <cfset strstrip = application.util.getRemoveQuotes(strStrip="#strCoverLetter#",  blnRemove="0")>
											   <!---  <cf_ct_removeQuotes strstrip="#strCoverLetter#" blnremove="0"> --->
												<cfset strCoverLetter=strStrip>
											</cfif>
									
											<tr>
												<td align="left" colspan="2">
													<table border=0 cellpadding=0 cellspacing=0 width="100%">
														<tr><td><h1 class="PageHeader">Apply to Job</h1></td></tr>
														<tr><td style="font-size:13px; font-weight:bold;">When Editing Your Cover Letter...</td></tr>
														<tr><td>&nbsp;</td></tr>
														<tr>
															<td>
																<span style="color:##CC0000;"><b>PLEASE NOTE:</b><br>
																Changes in this text box will only apply to the cover letter attached to this particular application.  To store permanent changes to this cover letter, 
																<a href="ExecEditCoverLetters.cfm?#application.strAppAddToken#&clID=#intLetterID#&mode=e&intJobID=#intJobID#&imgLog=#imgLogo#&strCaller=#strCaller#&intJOD=#intJOD#&INTJOBEMPLOYERID=#INTJOBEMPLOYERID#&JCODE=#JCODE#&intPageNo=#intPageNo#&blnEditApplyNow=1&am=#am#&tm=#tm#">click here</a>.
																</span>
															</td>
														</tr>
														<tr>
															<td>
																<table border=0 cellpadding=0 cellspacing=0>
																	<tr><td colspan="2">&nbsp;</td></tr>
																	<tr><td colspan="2" align=""><textarea name="strCoverLetter" rows=20 cols=61 wrap="virtual" style="width:650px; max-width:650px; noresize:noresize;">#strCoverLetter#</textarea></td></tr>
																	<tr><td colspan="2">&nbsp;</td></tr>
																	<tr>
																		<td>
																			<span id="AppplyJobSubmitBtn" style="visibility:visible;">
																			<table border=5>
																				<tr>
																					<td width="10%"><input type="submit" onClick="return apply('Apply2');" border="0" id="ApplyToJobbutton" style="outline:none" value=" "></td>
																					<td width="90%"><a href="##" onClick="return apply('rtjd');" style="font-size:13px; font-weight:bold; margin-top:12px;">BACK TO JOB DESCRIPTION</a></td>
																				</tr>
																			</table>
																			</span>
																			<!---Processing span--->
																			<span id="Processing" style="visibility:hidden;">
																			<table border=0 cellpadding=0 cellspacing=0 width="100%">
																				<tr><td align="center" class="er_bld_blue"><img style="vertical-align:middle" src="/images/icon_hourglass.gif">&nbsp;&nbsp;Processing your request...Please wait</td></tr>
																			</table>
																			</span>
																			
																		</td>
																   </tr>
																</table>
															</td>
														</tr>								
													</table>
												</td>
											</tr>
										</cfif>
										<tr><td>&nbsp;</td></tr>
										<tr><td>&nbsp;</td></tr>
									</table>
									</form>
									</span>
									
									
								
								<!--- kick off the email --->    
								<cfelse>
									<cfset blnSendEmail=1>
									<cfset blnNoEmailOnlyUpdCnt=1>                   
									
									<!--- 06/01/2011 - Record the Job in the Job Application Queue, if the member is a new register member waiting for approval of the membership --->
									<cfif intResAdmcode eq 2>
										<!--- Do not send the confirmation email to the client and the exec--->
										<cfset blnSendEmail=0>
										<cfset blnNoEmailOnlyUpdCnt=0>
										
										<!--- Record the Job Application in the Job Application Queue--->
										<!---Start: 06/01/2011 - Insert the Job Application in the Job Application Queue--->
										<cfif isDefined("intJobID") and len(intJobID)>
											
											<cfif isDefined("intLetterID") and len(intLetterID)>
												<cfset intLetterID = replace(intLetterID, ",","", "ALL")>
											<cfelse>
												<cfset intLetterID = "-1">
											</cfif>
											<!--- ISR review this CFC --->
											<!--- <cfscript>
											jobAppQueueObj 	= createObject("component","/v16fj/execs/resbuilder/components/executive2");
											jobAppQueueObj.addJobAppQueueRecord(#intJobID#, #session.exec.intResID#, #resumeID#, #intLetterID#, '#strCoverLetter#');
											</cfscript> --->
											<cfquery name="cfqCheckJobApp" datasource="#application.dsn#">
											select count(*) appCnt from tblJobApplicationQueue (nolock) where intResID = #session.exec.intResID# and intJobID = #intJobID#
											</cfquery>
											
											<cfif cfqCheckJobApp.appCnt is 0>
												<cfquery name="cfqCheckJobApp" datasource="#application.dsn#">
												insert into tblJobApplicationQueue (intJobID, intResID, intResumeID, intCoverLetterID, strCoverLetter) values (#intJobID#, #session.exec.intResID#, #resumeID#, #intLetterID#, '#strCoverLetter#')
												</cfquery>
											</cfif>
										</cfif>
										<!---End: 06/01/2011 - Insert the Job Application in the Job Application Queue--->
				
										<table border="0" cellpadding="0" cellspacing="0" width="100%">
											<tr><td><h1 class="PageHeader">Thank You</h1></td></tr>
											<tr>
												<td style="font-size:13px; line-height:18px;">
													<b>You have successfully applied for this position.</b><br>
													Your resume <cfif strCoverLetter neq "">and cover letter have<cfelse>has</cfif> been submitted to this employer.<br>
													<!--- The #title# position will appear in your <a href="ExecOneClickHistory.cfm?#application.strAppAddToken#">Application History</a>. --->
													In here1
												</td>
											</tr>
											
											<tr>
												<td>
													<div class="page-spacer"></div>
													<div class="page-spacer"></div>
													<div class="page-spacer"></div>
													<div class="span5">
														<cfinclude template="../member/matchingjobs.cfm">
													</div>
												</td>
											</tr>
											
											<tr><td>&nbsp;</td></tr>		 
											
											<tr>
												<td>
													<div style="clear:both; padding-bottom:20px;"></div>
													<a href="##" onClick="window.location='/jobs/?start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold;">BACK TO JOB SEARCH RESULTS</a>
												</td>
											</tr>
										</table>
									<cfelse>    
										<!--- should the ER NOT receive an email from a RE member ? --->
										<cfif ((receive_from_REyes neq 1) AND (intResAdmcode eq 4))> 
											<cfset blnNoEmailOnlyUpdCnt=0>
										</cfif>
									</cfif>
									
									<!--- OK To Send Resume, or Even Resume File --->
									<cfif blnSendEmail neq 0>
										<cfset dteSubmit=DateFormat(Now(), "mm/dd/yy")>
										<cfset dteTimeStamp=DateFormat(Now(),'yyyy-mm-dd') & TimeFormat(Now(), "HH:mm:ss")>
										<!--- get executive info from db --->
										<!---
										<cfquery name="cfqRes" datasource="#application.dsn#">
										select r.blnSearchable, r.intPostRecepient, r.fname, r.lname, r.email, r.description, r.resume, r.blnResumeManager, r.memosalary_desired, r.memosalary_current, r.blnFulltime, r.blnContract, r.blnStartup, r.relocate, r.how_contact, r.address, r.city, r.state, r.zip, r.home_phone, r.work_phone, r.mobile_phone, r.showAddress, r.showCity, r.showState, r.showZip, r.showfname, r.showlname, r.showhomephone, r.showworkphone, r.showemail, r.degrees, r.strHighestDegree, v.intVerificationID,r.showCompensation
										from tblResumes r
										left join tblVerifications v on r.intResID=v.intResID and v.blnActive=1 and v.intStatusCode=2
										where r.intResID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" />
										</cfquery>
										--->
										
										<!--- get executive info from db --->
										<cfquery name="cfqRes" datasource="#application.dsn#">
										select r.blnSearchable, r.intPostRecepient, r.fname, r.lname, r.email, r.description, r.resume, r.blnResumeManager, r.memosalary_desired, r.memosalary_current, r.blnFulltime, r.blnContract, 
											   r.blnStartup, r.relocate, r.how_contact, r.address, r.city, r.state, r.zip, r.home_phone, r.work_phone, r.mobile_phone, r.showAddress, r.showCity, r.showState, r.showZip, r.showfname, 
											   r.showlname, r.showhomephone, r.showworkphone, r.showemail, r.degrees, r.strHighestDegree,r.showCompensation, r.strExecJOBTitle_1, r.strExecJOBTitle_2, r.strExecJOBCompany_1, 
											   r.strExecJOBCompany_2, r.strCats, r.strFuncs
										  from tblResumes r
										  where 1=1
											and r.intResID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" />
										</cfquery>
																	  
										<!--- Set Resume File here --->   
										<cfscript>
										fname=cfqRes.fname;
										lname=cfqRes.lname;
										description=cfqRes.description;
										resume=cfqRes.resume;		//Standard Resume
										tempBGChk="";
										if (isdefined("form.resumeid") and form.resumeid neq 0){
											 qgetResume = resobj.getResume(form.resumeid);
											 if (qgetResume.recordcount){
												  resumeDirectory = resobj.getResumeDir(session.exec.intresid);
												  resumeFile = resumeDirectory & qgetResume.resumefile;
												  //Use File Attachement, if Available
												  if(fileExists(resumeFile)){
														session.exec.resumefile = 1;
														session.exec.resumefile = resumeFile;
												  }
												  //Use Text Resume
												  else if (len(qgetResume.resume)){
													resume = qgetResume.resume;
												  }
											 }	 
										}	 
										</cfscript>
				
									   
										<cfif cfqRes.blnResumeManager neq 0><cfinclude template="t_RemoveHTML.cfm"></cfif>
					
										<cfif len(description)>
											<!--- add the quotes --->
											<!--- <cf_ct_removeQuotes strstrip="#description#" blnremove="0"> --->
											<cfset strstrip = application.util.getRemoveQuotes(strStrip="#description#",  blnRemove="0")>
											<cfset description=strStrip>
										</cfif>
									
										<cfif len(resume)>
											<!--- add the quotes --->
											<!--- <cf_ct_removeQuotes strstrip="#resume#" blnremove="0"> --->
											<cfset strstrip = application.util.getRemoveQuotes(strStrip="#resume#",  blnRemove="0")>
											<cfset resume=strStrip>
										</cfif>
										
										<cfif cfqRes.memosalary_desired neq "">
											<!--- add the quotes --->
										   <!---  <cf_ct_removeQuotes strstrip="#cfqRes.memosalary_desired#" blnremove="0"> --->
										   <cfset strstrip = application.util.getRemoveQuotes(strStrip="#cfqRes.memosalary_desired#",  blnRemove="0")>
											<cfset memosalary_desired=strStrip> 
										<cfelse>
											<cfset memosalary_desired=cfqRes.memosalary_desired>
										</cfif>
				
										<cfif cfqRes.memosalary_current neq "">
											<!--- add the quotes --->
										   <!---  <cf_ct_removeQuotes strstrip="#cfqRes.memosalary_current#" blnremove="0"> --->
										   <cfset strstrip = application.util.getRemoveQuotes(strStrip="#cfqRes.memosalary_current#",  blnRemove="0")>
											<cfset memosalary_current=strStrip>  
										<cfelse>
											<cfset memosalary_current=cfqRes.memosalary_current>
										</cfif>
					
										<cfparam name="strOppPreference" default="">
									   
										<cfif (cfqRes.blnFulltime eq 1) or (cfqRes.blnContract eq 1) or (cfqRes.blnStartup eq 1)>
											<cfif cfqRes.blnFulltime eq 1><cfset strOppPreference=strOppPreference & "full-time"></cfif>
											<cfif cfqRes.blnContract eq 1>
												<cfif cfqRes.blnFulltime eq 1><cfset strOppPreference=strOppPreference & ", "></cfif>
												<cfset strOppPreference=strOppPreference & "contract">
											</cfif>
											<cfif cfqRes.blnStartup eq 1>
												<cfif cfqRes.blnContract eq 1 or cfqRes.blnFulltime eq 1><cfset strOppPreference=strOppPreference & ", "></cfif>
												<cfset strOppPreference=strOppPreference & "startup">
											</cfif>
										</cfif>
								
										<!--- get Res atts --->
										<cfset listintAttIDs="">
										<cfset listIndIDs="">
										<cfset intsFuncIDs="">
										<cfset listStateIDs="">
										<cfset liststrIndIDs="">
										<cfset liststrFuncIDs="">
										<cfset liststrStateIDs="">
						
										<cfquery name="cfqResAtts" datasource="#application.dsn#">
										select intAttID from tblResAtt (NOLOCK) where intresid=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(intResID)#" null="no" /> order by intAttID
										</cfquery>
				
										<cfif cfqResAtts.RecordCount gt 0>
											<!--- build Res Att list --->
											<cfset listintAttIDs=#ValueList(cfqResAtts.intAttID)#>
											
											<!--- build Industry Att list --->
											<cfloop list="#listintAttIDs#" index="ListElement">
												<cfloop index="intIndexNo" from="1" to="#intIndsArrLen#">
													<cfif ListElement is arrInds[intIndexNo][1]>
														<cfset liststrIndIDs=ListAppend(liststrIndIDs, #arrInds[intIndexNo][2]#)>
													</cfif>
												</cfloop>
											</cfloop>
											
											<cfif ListLen(liststrIndIDs) gt 1>
												<cfset liststrIndIDs=#Replace(liststrIndIDs, ",", ", ", "ALL")#>
											</cfif>
							 
											<!--- build Function Att list --->
											<cfloop list="#listintAttIDs#" index="ListElement">
												<cfloop index="intIndexNo" from="1" to="#intFuncsArrLen#">
													<cfif ListElement is arrFuncs[intIndexNo][1]>
														<cfset liststrFuncIDs=ListAppend(liststrFuncIDs, #arrFuncs[intIndexNo][2]#)>
													</cfif>
												</cfloop>
											</cfloop>
											<cfif ListLen(liststrFuncIDs) gt 1>
												<cfset liststrFuncIDs=#Replace(liststrFuncIDs, ",", ", ", "ALL")#>
											</cfif>
						
											<!--- build State Att list --->
											<cfloop list="#listintAttIDs#" index="ListElement">
												<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
													<cfif #ListElement# is #arrStates[intIndexNo][1]#>
														<cfset listStateIDs=ListAppend(listStateIDs, #arrStates[intIndexNo][1]#)>
														<cfset liststrStateIDs=ListAppend(liststrStateIDs, #arrStates[intIndexNo][2]#)>
													</cfif>
												</cfloop>
											</cfloop>
											<cfif ListLen(liststrStateIDs) gt 1>
												<cfset liststrStateIDs=#Replace(liststrStateIDs, ",", ", ", "ALL")#>
											</cfif>		 
										</cfif>
					
										<cfset lcl_relocation="">
										<cfif cfqRes.relocate neq 0>		 
											<cfif ListLen(liststrStateIDs) gt 0>
												<cfif liststrStateIDs eq "All Locations">
													<cfset lcl_relocation="Candidate will relocate to any location.">
												<cfelse>
													<cfset lcl_relocation="Candidate will relocate to " & liststrStateIDs & ".">
												</cfif>
											<cfelse>
												<cfset lcl_relocation="This executive is not willing to relocate.">
											</cfif>
										<cfelse>
											<cfset lcl_relocation="This executive is not willing to relocate.">
										</cfif>
				
										<cfswitch expression="#cfqRes.how_contact#">
											<cfcase value="1"><cfset lcl_howContact="work phone"></cfcase>
											<cfcase value="2"><cfset lcl_howContact="home phone"></cfcase>
											<cfcase value="3"><cfset lcl_howContact="email"></cfcase>
										</cfswitch>
									</cfif>
								</cfif>
								<!--- end: kicking off the email --->
							</cfif>
							
							<!--- end: do you belong here?!?!?! --->
								   
			<!-------------------------------------------------------------------------------------------------------------------------------------------------------------------->
						</cfif>
						   
							
							
						<!-- send email to exec and employer  -->
						<cfif blnSendEmail neq 0>
							<cfparam name="ExecConfEmail" default="">
							<cfset ExecConfEmail=session.exec.stremail>
							
							<cfif len(ExecConfEmail)>
								<cfinclude template="confirmationEmail.cfm">
							</cfif>
						   
							
							<cfif blnNoEmailOnlyUpdCnt neq 0> 
								<!--- do not send the email, but update the application counter --->
								<cfset resumedisplay="#trim(REReplace(resume, "<p>", "#chr(10)##chr(13)##chr(10)##chr(13)#", "All"))#">
								<cfset resumedisplay="#trim(REReplace(resumedisplay, "<br>", "#chr(10)##chr(13)#", "All"))#">
								<cfset resumedisplay="#trim(REReplace(resumedisplay, "<[^>]*>", "", "All"))#">
								
								<!---iCandidate Account type--->
								<cfif intAcctType eq 0>
								   <cfinclude template="eriCandJobApplEmail.cfm">   <!---ISR  --->                  
								<!---End: iCandidate ---->
								
								<!---Regular account email---->
								<cfelse>
									<cfinclude template="erJobApplEmail.cfm"><!---ISR  --->
								</cfif>
								<!---End: Regular account email---->
			
			   
								<!--- Kill Session Variable --->
								<cfif isdefined("session.exec.resumefile") and fileExists(session.exec.resumefile)>
									<cfset session.exec.resumefile = "" />
								</cfif>     
							</cfif>
			
							<cfstoredproc procedure="sp_UpdtExecOneClick" datasource="#application.dsn#" returncode="Yes">
								<cfprocparam type="IN" dbvarname="@intResID" value="#val(intResID)#" cfsqltype="CF_SQL_INTEGER">
								<cfprocparam type="IN" dbvarname="@intJobID" value="#val(intJobID)#" cfsqltype="CF_SQL_INTEGER">
								<cfprocparam type="IN" dbvarname="@intEmployerID" value="#val(intJobEmployerID)#" cfsqltype="CF_SQL_INTEGER">
							</cfstoredproc>
					
							
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr><td><h1 class="PageHeader">Thank You</h1></td></tr>
								<tr>
									<td style="font-size:13px; line-height:18px; font-weight:bold;">
										<b>You have successfully applied for this position.</b><br>
										Your resume <cfif strCoverLetter neq "">and cover letter have<cfelse>has</cfif> been submitted to this employer. <br>
										The #title# position will appear in your <a href="/member-job-history?#application.strAppAddToken#">Application History</a>.
									</td>
								</tr>
								
								<tr>
									<td>
										<div class="page-spacer"></div>
										<div class="page-spacer"></div>
										<div class="page-spacer"></div>
										<div class="span5">
										<cfinclude template="../member/matchingjobs.cfm">
										</div>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>		 
								
								<!--- begin Todd S. 06.25.01 --->
								<cfswitch expression="#strCaller#">
									<cfcase value="ExecJobOfDayDetail">
										<cfset returnToLink="ExecJobOfDayDetail.cfm?#application.strAppAddToken#&intJobID=#intJobID#">
										<cfset returnToText="Back to Job Description1">
									</cfcase>
									
									<cfcase value="ExecCorpJobDetail">
										<cfset returnToLink="ExecSearchJobsDetail.cfm?#application.strAppAddToken#&strCaller=ExecCorpJobDetail&intCorpID=#intCorpID#&intJobID=#intJobID#&imgLogo=#imgLogo#&am=#am#&tm=#tm#&jrl=1">
										<cfset returnToText="Back to Job Description2">
									</cfcase>
									
									<cfcase value="ExecAutoEmailJob">
										<cfset returnToLink="ExecViewJob.cfm?#application.strAppAddToken#&jobid=#intJobID#&sort=#sort#&sortorder=#sortorder#">
										<cfset returnToText="Back to Job Description3">
									</cfcase>
									
									<cfcase value="ExecSearchAgent">
										<cfset returnToLink="ExecSearchAgent.cfm?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&strTitle=#URLEncodedFormat(strTitle)#&strMode=JobDetail&strCaller=#strCaller#&sort=#sort#&sortorder=#sortorder#">
										<cfset returnToText="Back to Job Description4">
									</cfcase>
									
									<cfcase value="ExecMyJobsDetail">
										<cfset returnToLink="ExecMyJobsDetail.cfm?#application.strAppAddToken#&intJobID=#intJobID#&intPageNo=#intPageNo#&strCaller=#strCaller#">
										<cfset returnToText="Back to Job Description5">
									</cfcase>
									
									<cfdefaultcase>
										<cfset returnToLink="ExecSearchJobsDetail.cfm?#application.strAppAddToken#&intPageNo=#intPageNo#&intJobID=#intJobID#&sort=#sort#&sortorder=#sortorder#">
										<cfset returnToText="Back to Job Description6">
									</cfdefaultcase>
								</cfswitch>
								</td>
								</tr>
								
								<tr>
									<td>
										<!--- <cf_ct_cplpartner formid=1 enforcerules=1 targetid=4 loggedin=1 displaymsg=0 activeleftnav=#m# activeleftsubnav=#am# datasource="#application.dsn#" cfidtoken="#application.strAppAddToken#" locktimeout="#strLockTimeOut#" returnlink="#returnToLink#" returntext="#returnToText#" targetlocation=4> --->
										<div style="clear:both; padding-bottom:20px;"></div>
										<a href="##" onClick="window.location='/jobs/?start1=#url.start1#&pgNo=#url.pgNo#';" style="font-size:13px; font-weight:bold;">BACK TO JOB SEARCH RESULTS</a>
									</td>
								</tr>
							</table>
										   
						</cfif>
					</td>
				</tr>
			</table>
</div>
</article>
</div>
</cfoutput>
<!--- 12/01/2013 - Load scripts --->
<!--- <script src="/recruitment/search/js/vendor/bootstrap.min.js"></script> --->
<!--- Error Div --->
<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/errorBox.cfm" /> --->