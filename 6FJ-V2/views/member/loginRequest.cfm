<cfparam name="strcaller" default="">
<cfparam name="strUsername" default="">
<cfparam name="blnByPassCPL" default="0">
<cfparam name="strPassword" default="">
<cfparam name="strloginLoc" default="">
<cfparam name="blnValidLogin" default="0">
<cfparam name="intResID" default="">
<cfparam name="l_intResID" default="">
<cfparam name="l_strFname" default="">
<cfparam name="strCaller" default="">
<cfparam name="blnRememberMe" default="">

    			
<!--- define session variables --->

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

<!--- check if entered password --->
<cfparam name="session.EXEC.passwordEntered" default="0">

<cfparam name="session.EXEC.strloginLoc" default="0">

<cfparam name="LocateJobSweeper" default="No">


	<cfset strUsername=trim(URLdecode(strUsername))>
	<cfset strPassword=trim(URLdecode(strPassword))>
	<cfset strloginLoc=trim(URLdecode(strloginLoc))>
	
	<cfif len(trim(URLdecode(blnRememberMe)))>
		<cfset blnRememberMe = trim(URLdecode(blnRememberMe))>
	<cfelse>
		<cfset blnRememberMe = 0>
	</cfif>

<cfoutput>

<cfif (not(len(intResID))) or (blnValidLogin eq 0)> <!--- process login form --->
	
	<cfif isdefined('origination') and origination eq "email">
 		<!--- dc will indicate that the password is encrypted - submitted from a prefilled email header --->
	 	<cfif isdefined('url.dc') and url.dc eq "1">
	 		<!--- This will allow for different encryption keys, should we ever need it. Just change the "v" value in the email login urls --->
			<cfif isdefined('url.v')>
				<!--- #strpassword#<cfabort> --->
				<cfswitch expression="#url.v#">
					<cfcase value="1">
						<cftry>
							<cfset blnByPassCPL="1">
							<cfif isdefined('form.strpassword')>
								<cfset strpassword=form.strpassword>
								<cfset strpassword=CFusion_decrypt(urldecode(strpassword),'Devistation')>
							<cfelseif isdefined('url.strpassword')>
								<cfset strpassword=url.strpassword>
								<cfset strpassword=CFusion_decrypt(strpassword,'Devistation')>
							</cfif>
						
							<cfcatch type="Any">
								<cfset strPassword=trim(URLdecode(strPassword))>
							</cfcatch>
						</cftry>
					</cfcase>
					
                    <cfcase value="2">
						<cftry>
							<cfset blnByPassCPL="1">
							<cfif isdefined('form.strpassword')>
								<cfset strpassword=form.strpassword>
								<cfset strpassword=CFusion_decrypt(urldecode(strpassword),'Upwards')>
							<cfelseif isdefined('url.strpassword')>
								<cfset strpassword=url.strpassword>
								<cfset strpassword=CFusion_decrypt(strpassword,'Upwards')>
							</cfif>
							<cfcatch type="Any">
								<cfset strPassword=trim(URLdecode(strPassword))>
							</cfcatch>
						</cftry>
					</cfcase>
				</cfswitch>
			</cfif>
	 	</cfif>
 	</cfif>
 	<!--- form.origination will do its best to ensure this was submitted from the email form, and not a url hack attempt --->
	 
	
 	<!--- check for existance of username and password, redirect to login if missing --->
 	<cfif (Len(strUsername) lt 1) OR (Len(strPassword) lt 1)>
  		<cfif strcaller contains "jobsweeperjsanav">
  			<cflocation url="JobSweeperJSANav.cfm?&invalidlogin=1" addtoken="no">
  		<cfelse>
			<cflocation url="ExecLogin.cfm?invalidlogin=1&startnewsession=1" addtoken="no">
  		</cfif>
 	</cfif>
 
 	<cftry>
  		<cfstoredproc procedure="sp_exec_login" datasource="#application.dsn#" returncode="Yes">
   			<cfprocparam type="IN" variable="@username" value="#strUsername#" cfsqltype="CF_SQL_VARCHAR">
   			<cfprocparam type="IN" variable="@password" value="#strPassword#" cfsqltype="CF_SQL_VARCHAR">
			<cfprocparam type="IN" variable="@sourceApp" value="#application.sourceApp#" cfsqltype="CF_SQL_VARCHAR">
   			<cfprocparam type="OUT" variable="proc_returnCode" cfsqltype="CF_SQL_INTEGER">
   			<cfprocresult resultset="1" name="cfqExecLogin">
  		</cfstoredproc>
 		<!--- <cfdump var="#sp_exec_login#">
		<cfabort> --->
				
  		<cfswitch expression="#proc_returnCode#">
   			<!--- 
			************************************************************************************************
			*                            successful executive UN and PWD                                   *
			************************************************************************************************
			--->
		   	<cfcase value="1">
				<cfset dteLoginNow=DateFormat(Now(),"mmm dd, yyyy")> 
				<cfif blnRememberMe>
					<!--- create auto login cookie --->
					 <cfset strRememberMe = (
						CreateUUID() & ":" &
						strUsername & ":" &
						strPassword & ":" &
						strloginLoc & ":" &
						CreateUUID()
						) />
	 
					<!--- Encrypt the value. --->
					<cfset strRememberMe = Encrypt(
						strRememberMe,
						application.encryptionKeyRM,
						"AES",
						"hex"
						) />
			 
					<!--- Store the cookie such that it never expires. --->
				   <cfcookie
						name="RememberMe"
						value="#strRememberMe#"
						expires="never"
						/>
    			</cfif>
				
				<cfset session.EXEC.strloginLoc="#strloginLoc#">
				
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

			    <!--- set session variables for this account --->
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
				//session.EXEC.dtePremiumExpires = cfqEXECLogin.dteExpires;
				//session.EXEC.dtePremiumCancelled = cfqEXECLogin.dteCancel;
				//session.EXEC.premiumCancelPeriod = cfqEXECLogin.cancelPeriod;
				
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
				
				<!--- check for learn365 user 
				
				<cfquery name="checkLearn365" datasource="#application.dsn#">
					select blnLearn365
					from tblResumes
					where intresid = #cfqEXECLogin.intResID#
				</cfquery>
				
				<cfif checkLearn365.recordcount GT 0>
					<cfset session.exec.blnLearn365 = checkLearn365.blnLearn365>
					
					<cfquery name="getSSOID" datasource="#application.dsn#">
						select learn365UserId, blnactive from tblLearn365Users
						where intresid = #cfqEXECLogin.intResID#
					</cfquery>
					
					<cfif getSSOID.recordcount GT 0>
						<cfset session.exec.isLearn365Active = getSSOID.blnactive>
					</cfif>
					
				</cfif>
				--->
				
    			<!---08/29/2011 Update the last login date for candidate--->
     			<cfquery name="cfqUpdLastLoginDte" datasource="#application.dsn#">
                update tblresumes set dteLastLogin  = getdate() where intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="CF_SQL_INTEGER" />
                </cfquery>
				
				<!---03/04/2014 Check if the CPL Page was shown to the Job Seeker already--->
     			<cfquery name="request.CPLPageVisited" datasource="#application.dsn#">
                select blnCPLPageVisited from tblResumes where intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="CF_SQL_INTEGER" />
                </cfquery>
				<cfset session.exec.blnCPLPageVisisted = request.CPLPageVisited.blnCPLPageVisited>
								
				<!--- this variable is used for geo-targeting the CPLs --->
				<cfset tempStateID="0">
				
                
				<!---04/15/2011 Hard Code blnSecurityRedirect to 0, to eliminate the security update---->
                <cfset session.EXEC.blnSecurityRedirect = 0>
                <cfset blnSecurityRedirect=0>
				
				
				<cfif strCaller contains "ExecResumeManagerJump">
					<cflocation url="ExecResumeManagerInfo.cfm?" addtoken="no">
				<cfelseif (strcaller contains "JobSweeperLogin" or strcaller contains "ExecSearchJobsExt.cfm")>
                	<cfparam name="SEARCHFORM" default="6FJ">
					<cfif strcaller contains "EmailAgent">
						<cflocation url="ExecSearchJobsExt.cfm?&searchform=#searchform#&login=1&strcaller=EmailAgent" addtoken="no">
					<cfelseif strcaller contains "ExecSearchAgent">
						<cflocation url="ExecSearchJobsExt.cfm?&searchform=#searchform#&login=1&strcaller=ExecSearchAgent" addtoken="no">
					<cfelse>
        				<cfparam name="JobSweeperQueryString" default="">
						<cfif strCaller contains "?">
							<cfif listlen(strCaller,"?") gt 1>
								<cfset JobSweeperQueryString=ListGetAt(strCaller,2,"?")>
							</cfif>
						</cfif>
						
						<cfif JobSweeperQueryString neq "">
							<cfset JobSweeperQueryString=JobSweeperQueryString & "&searchform=#searchform#&login=1">
						<cfelse>
							<cfset JobSweeperQueryString="&searchform=#searchform#&login=1">
						</cfif>
						<cflocation url="ExecSearchJobsExt.cfm?#JobSweeperQueryString#" addtoken="no">
					</cfif>						
				<cfelseif isdefined("cookie.pagecaller")>
					<cfset tmpRedirect = cookie.pagecaller/>
					<!--- Redirect Based on Last Job Viewed From JSA --->					
					<cfcookie name="pagecaller" expires="#now()#" />
					<cfif len(tmpRedirect)>
						<cflocation url="#tmpRedirect#" addtoken="no">
					<cfelse>
						<cflocation url="/" addtoken="no">
					</cfif>						
				<cfelseif (strcaller contains "t_ExecAddDeleteFavorites.cfm")>
					<cfset ResID=session.exec.intresid>
					<cfset strcaller=strcaller & "&ResID=#ResID#">
				 	<cflocation url="#strcaller#" addtoken="no">
				<cfelseif strcaller contains "jobsweeperjsanav">
					<!--- If coming from JobSweeper JSA nav, refresh frame --->
					<cflocation url="JobSweeperJSANav.cfm?" addtoken="No">
				<cfelseif (strcaller contains "ExecSearchJobsDetail") OR (strcaller contains "ExecViewJob") OR (strcaller contains "ExecJobOfDayDetail") OR (strcaller contains "ExecCorpJobDetail") OR (strcaller contains "ConciergeSvc")>
					<cfif strCaller contains ".cfm">
		  				<cflocation url="#strcaller#" addtoken="yes">
		 			<cfelse>
		  				<cflocation url="#strcaller#.cfm?#cgi.query_string#" addtoken="no">
		 			</cfif>
              	<!---03/07/2011, Coming from the ExecLogin via Apply to Job link, redirect the user to the ExecOneClickApply.cfm page--->
                <cfelseif strcaller contains "execOneClickApply">
					<cfquery name="cfqGetSEOURL" datasource="#application.dsn#">
                    select seoJobURL From tblJobs (nolock) where intJobID = <cfqueryparam value="#url.intJobID#" cfsqltype="CF_SQL_INTEGER" />
                    </cfquery>
                    
					<cflocation url="#cfqGetSEOURL.seoJobURL#" addtoken="no">
              	<cfelseif (strcaller contains "execUpdateProfile")>
					<script language="JavaScript">location.href="/profile/execUpdateProfile.cfm?";</script>
                <!--- Promotional Survery --->                                            
              	<cfelseif (strcaller contains "execWhyPremiumSurvey")>
					<script language="JavaScript">location.href="/execs/premium/execpremium.cfm?";</script>
                	<!--- 01-17-2011 Coming from the Upgrade to Premium promotional email --->
              	<cfelseif (strcaller contains "execWhyPremium")>
					<script language="JavaScript">location.href="#request.url#/execs/premium/execWhypremium.cfm?&l=2220&upgrade=1";</script>
                <!--- ---->
                <cfelseif (strcaller contains "HonestyOnline")>
					<script language="javascript">
					window.open("#strcaller#.cfm?", "HonestyOnline");
					location.href="/ExecMyAccount.cfm?";</script> 
					</script>
	    		<cfelse>
               
					<cfif (cfqEXECLogin.blnBigs neq 0)> <!--- only full members get the AD serving --->
				       	<!--- Testing New IP Location Database - hide 'US Only' CPLs if IP is outside of US--->
						<cfparam name="ThisIP" default="">
						<cfif cgi.remote_addr neq "">
							<cfset ThisIP=cgi.remote_addr>
						</cfif>
						
						
						<cfif len(ThisIP)>
							<!--- Break IP into its 4 parts --->
							<cfset IPsegment1=ListGetAt(ThisIP,1,".")>
							<cfset IPsegment2=ListGetAt(ThisIP,2,".")>
							<cfset IPsegment3=ListGetAt(ThisIP,3,".")>
							<cfset IPsegment4=ListGetAt(ThisIP,4,".")>
					
							<!--- calculate numerical value for the IP --->
							<cfset numip=(IPsegment1 * 16777216) + (IPsegment2 * 65536) + (IPsegment3 * 256) + IPsegment4>
					
							<!--- Check if IP is from US --->
                            <cfquery datasource="#application.dsn#" name="checkIP">
                            SELECT country_code FROM tblIPLookup (nolock) WHERE IP_FROM <= #numip# and IP_TO >= #numip#
                            </cfquery>
							
							<cfif checkIP.recordcount gt 0 and checkIP.country_code neq "USA">
								<!--- If not US, set indicator --->
								<cfset blnByPassCPL=1>
							</cfif>
						</cfif>
						
                        <cfif blnByPassCPL neq "1">
							<!---Redirect the user to the CPL page if the CPL page was not presented to the Job Seeker, this is for the Aggregators who do not want the advertising/CPL to be shown during the registration process--->
							<cfif session.exec.blnCPLPageVisisted is 0>
								<cflocation url="#application.url#/member-cpl" addtoken="no">	
								<cfabort>
							<cfelse>
								<cfif isDefined("url.loginType") and url.loginType IS "learn">
									<cfif session.EXEC.blnLearn365>
										<cflocation url="#application.url#/learn365-dashboard" addtoken="no">
									<cfelse>
										<cflocation url="#application.url#/learn365-signup" addtoken="no">
									</cfif>
								<cfelseif isDefined("url.loginType") and url.loginType IS "learnlanding">
									<cflocation url="#application.url#/learn365" addtoken="no">
								<cfelse>
									<cflocation url="#application.url#/member-dashboard" addtoken="no">
								</cfif>
								<cflocation url="#application.url#/member-dashboard" addtoken="no">
								<cfabort>
							</cfif>
                            
						<cfelse>
							<cfif isDefined("url.loginType") and url.loginType IS "learn">
								<cfif session.EXEC.blnLearn365>
									<cflocation url="#application.url#/learn365-dashboard" addtoken="no">
								<cfelse>
									<cflocation url="#application.url#/learn365-signup" addtoken="no">
								</cfif>
							<cfelseif isDefined("url.loginType") and url.loginType IS "learnlanding">
									<cflocation url="#application.url#/learn365" addtoken="no">
							<cfelse>
                        		<cflocation url="#application.url#/member-dashboard" addtoken="no">
							</cfif>
                      	</cfif>
                      
		     		<cfelse>
                  		<cfif isDefined("url.loginType") and url.loginType IS "learn">
							<cfif session.EXEC.blnLearn365>
								<cflocation url="#application.url#/learn365-dashboard" addtoken="no">
							<cfelse>
								<cflocation url="#application.url#/learn365-signup" addtoken="no">
							</cfif>
						<cfelseif isDefined("url.loginType") and url.loginType IS "learnlanding">
							<cflocation url="#application.url#/learn365" addtoken="no">
						<cfelse>
							<cflocation url="#application.url#/member-dashboard" addtoken="no">
						</cfif>
                  	</cfif>
              	</cfif>
                
   			</cfcase>
   
			<!--- 
            ************************************************************************************************
            *                              invalid executive UN and PWD                                    *
            ************************************************************************************************
            --->
           	<cfcase value="2">
				
				<cflocation url="#application.url#/member-invalid-login" addtoken="no">
				<cfabort>
				
   			</cfcase>
   
 			<!--- 
			************************************************************************************************
			*                                  redirect the idiot ER                                       *
			************************************************************************************************
			--->
   			<cfcase value="3">
				<cflocation url="#application.v1URL#/pg_ERLoginProcess.cfm?&strUsername=#strUsername#&strPassword=#strPassword#" addtoken="no">
            	
           	</cfcase>
   
   
			<!--- 
            ************************************************************************************************
            *                              duplicate accounts exist for user                               *
            ************************************************************************************************
            --->
   			<cfcase value="4">
            	<cfif not StructIsEmpty(session)> 
					<cfset strSesionKeys=StructKeyList(session)>
					<cfloop list="#strSesionKeys#" index="ListElement">
						<cfset rc=StructDelete(session, "#ListElement#", "True")>
					</cfloop>
    			</cfif>
			
				<cflocation url="#application.url#/member-invalid-login" addtoken="no">
				
   			</cfcase>
  		</cfswitch>
  
  		<cfcatch type="any">
		   			
			<!--- clear session variables --->
    		<cfif not StructIsEmpty(session)> 
		    	<cfset strSesionKeys=StructKeyList(session)>
      			<cfloop list="#strSesionKeys#" index="ListElement">
       				<cfset rc=StructDelete(session, "#ListElement#", "True")>
      			</cfloop>
    		</cfif>
			
			<cflocation url="#application.url#/member-invalid-login" addtoken="no">
   			
		</cfcatch>
	</cftry> 			
</cfif>
</cfoutput>