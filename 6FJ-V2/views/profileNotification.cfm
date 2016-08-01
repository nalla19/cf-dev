<cflock scope="session" timeout="10" type="Exclusive">
	<cfset session.strSection="Exec" />
	<cfset strSection=session.strSection />
	<cfparam name="session.EXEC.intResAdmCode" default="0">
	<cfset lcl_intResAdmCode=session.EXEC.intResAdmCode />
	<cfset lcl_intResStatusCode=session.EXEC.intResStatusCode />
	<cfset intResID = session.exec.intResID />
	<cfset dteRERejected=session.EXEC.dteReject>
</cflock>
<cfset encryptedResID=encrypt(session.EXEC.intResID, generateSecretKey('AES'), 'AES', 'Base64') />
<cfset blnAlertOn=0>
<cfset blnAlertOn=0>
<cfparam name="pageLink" default="/ExecEditProfile.cfm" />
<cfif isdefined("session.EXEC.dteSubmitted") and session.EXEC.dteSubmitted gt "10/23/2007">
	<!---Get the listcompletedsteps for the user--->
    <cfquery name="cfqGetListcomplSteps" datasource="#application.dsn#">
    select city, state,zip,home_phone,mobile_phone,blnsearchable,strExecJOBTitle_1,strExecJOBCompany_1,strExecJOBTitle_2,strExecJOBCompany_2,
           fltCompensation_package,strCats,strFuncs,intYearsExperience,blnNewsletter,blnSpecialOffer,blnEvents
      from tblResumes (nolock)
     where 1=1
       and intResID = #session.exec.intResID#
    </cfquery>
    
       
   	<cfif cfqGetListcomplSteps.city is "" or cfqGetListcomplSteps.state is "" or cfqGetListcomplSteps.zip is "" or cfqGetListcomplSteps.home_phone is "" or cfqGetListcomplSteps.mobile_phone is "" or 
          cfqGetListcomplSteps.blnsearchable is "" or cfqGetListcomplSteps.strExecJOBTitle_1 is "" or cfqGetListcomplSteps.strExecJOBCompany_1 is "" or cfqGetListcomplSteps.strExecJOBTitle_2 is "" or 
		  cfqGetListcomplSteps.strExecJOBCompany_2 is "" or cfqGetListcomplSteps.fltCompensation_package is "" or cfqGetListcomplSteps.strCats is "" or cfqGetListcomplSteps.strFuncs is "" or 
		  cfqGetListcomplSteps.intYearsExperience is "" or cfqGetListcomplSteps.blnNewsletter is "" or cfqGetListcomplSteps.blnSpecialOffer is "" or cfqGetListcomplSteps.blnEvents is "">
		  <cfset listcompletedSteps = "1">
   	<cfelseif cfqGetListcomplSteps.city neq "" and cfqGetListcomplSteps.state neq "" and cfqGetListcomplSteps.zip neq "" and cfqGetListcomplSteps.home_phone neq "" and cfqGetListcomplSteps.mobile_phone neq "" and 
			  cfqGetListcomplSteps.blnsearchable neq "" and cfqGetListcomplSteps.strExecJOBTitle_1 neq "" and cfqGetListcomplSteps.strExecJOBCompany_1 neq "" and cfqGetListcomplSteps.strExecJOBTitle_2 neq "" and 
			  cfqGetListcomplSteps.strExecJOBCompany_2 neq "" and cfqGetListcomplSteps.fltCompensation_package neq "" and cfqGetListcomplSteps.strCats neq "" and cfqGetListcomplSteps.strFuncs neq "" and 
			  cfqGetListcomplSteps.intYearsExperience neq "" and cfqGetListcomplSteps.blnNewsletter neq "" and cfqGetListcomplSteps.blnSpecialOffer neq "" and cfqGetListcomplSteps.blnEvents neq "">
   		  <cfset listcompletedSteps = "1,2">
    </cfif>

	
	
	
     <cfif listcompletedSteps eq "1">
   		<cfset pageLink = "/join/step2.cfm?Fy4ZT9ZUv=#URLEncodedFormat(encryptedResID)#" />
    <cfelseif listcompletedSteps eq "1,2">
    	<cfset pageLink = "/join/step3.cfm?Fy4ZT9ZUv=#URLEncodedFormat(encryptedResID)#" />
   	<cfelse>
    	<cfset pageLink = "/execs/resbuilder/execResBuilder.cfm" />
    </cfif>
</cfif>

<cfoutput>
<div id="page-dashboard">
	<!--- <article class="section"> --->
		 <div class="container">	
<!--- BEGIN: INCOMPLETE RESUME NOTIFICATION --->
<cfif ((lcl_intResAdmCode eq 1) OR (lcl_intResAdmCode eq 2) OR (lcl_intResAdmCode eq 20))> <!--- incomplete or "in-review" profile --->
	<cfif (lcl_intResAdmCode eq 1)>
    	<cfset blnAlertOn=1>
		<div class=" row">
			
			<div style="font-size:18px; line-height:18px;" class="alert alert-error span12">
  			<strong>Welcome Back!</strong>
			<br />
			<br />
			It looks like you didn't complete our registration.
			<br><br>
			<a href="#pageLink#"><div class="btn btn-primary">Click here to complete the registration process</div></a>
			<br>
			</div>
		</div>
	<!--- new member message --->
    <cfelse> 
    	<div class="alert alert-info">
			<div style="font-size:13px; margin: 5px 0px 5px 0px; padding:5px 0px 5px 0px; font-weight:bold;">
			Your 6FigureJobs application is currently under review.<br />
			Please expect a response within 1 business day. If it is approved, we will notify you via email that it is active and you will have access to all features available on 6FigureJobs.<br />
    		<div style="padding-bottom:8px;"></div>
            PLEASE NOTE: Be sure to check either your inbox or spam folder for our confirmation emails.<br />
			</div>
		</div>	
	</cfif>
<!--- BEGIN: 6FigureOnTrack NOTIFICATION --->
<cfelseif lcl_intResAdmCode eq "4">

    <cfif lcl_intResStatusCode eq "1">
	
		<cfset lcl_daysLeft=0>
		<!--- determine if the candidate can reapply or not --->
        <cfif dteRERejected neq "">
	    	<cfset lcl_daysLeft=dateDiff("d", dateAdd("d", -91, now()), dteRERejected)>
       	</cfif>
		
		<div class="alert alert-info">
			<button type="button" class="close" data-dismiss="alert">&times;</button>
			<div style="font-size:13px; margin: 5px 0px 5px 0px; padding:5px 0px 5px 0px; font-weight:bold;">
				<cfif lcl_daysLeft gt 0> 
					As a 6FigureOnTrack Member, you will be eligible to reapply for 6FigureJobs Membership in:&nbsp;&nbsp;#lcl_daysLeft# <cfif lcl_daysLeft neq 1>days<cfelse>day</cfif></span><br>
				<cfelse>
					Want To Reapply for Executive Membership?<br>
	                Has your experience or profile changed?<br>
	                It has been over 90 days - so you are eligible to apply again!<br>
	              	<!---ISR <a href="ExecEditProfile.cfm?#strAppAddToken#" style="font-weight:bold;font-size:12px;">Reapply Now!</a> --->							
	                <br />                                                    
				</cfif>
			</div>
		</div>
   					
                   
	<cfelseif lcl_intResStatusCode eq "2">
		
		<div class="alert alert-info">
			<div style="font-size:13px; margin: 5px 0px 5px 0px; padding:5px 0px 5px 0px; font-weight:bold;">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				Your profile and resume have been resubmitted for review.<br>
				We will contact you within 2 business days to notify you if you have been accepted as a 6FigureJobs Executive Member. In the meantime, you may continue to search and apply for jobs using your 6FigureOnTrack Account.<br />
			</div>
		</div>

	</cfif>


<!--- Begin: 6FigureJobs Full Member Notification --->    
<cfelse>

	<cfquery name="cfqGetLastRefresh" datasource="#application.dsn#">
	select dteEdited
	  from tblResumes (NOLOCK)
	 where intresid=#intResID#
	</cfquery>
    
    <cfset resumedate=DateFormat(cfqGetLastRefresh.dteEdited,'mm/dd/yyyy')>
	<cfset now=DateFormat(now(),'mm/dd/yyyy')>
	
	<cfif DateDiff('d',resumedate,now) gte 90>
		<div class="alert alert-info">
			<button type="button" class="close" data-dismiss="alert">&times;</button>
			<div style="font-size:13px; margin: 5px 0px 5px 0px; padding:5px 0px 5px 0px; font-weight:bold;">
				You have not refreshed your resume in the past 90 days.</span> <br>
				<div style="padding-bottom:6px;"></div>
				<strong>TIP:</strong> Keeping your resume refreshed will improve your chances of being seen by Employers and/or Recruiters. Use the "Refresh Resume" whenever you log into your account to stay near the top of recruiters' candidate searches.
				<div style="padding-bottom:8px;"></div>
				<a href="/click.cfm?l=2515" title="Refresh your resume" class="resumerefresh_button" style="color:##990000;"></a>
				<br clear="all"/>
			
			</div>
		</div>
		
	<cfelse>
    	<!--- Include An Option Here To Complete Resume --->
    	<!--- JSA Only Option --->
  		<cfif lcl_intResAdmCode eq 6>
			<div class="alert alert-info">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				<div style="font-size:13px; margin: 5px 0px 5px 0px; padding:5px 0px 5px 0px; font-weight:bold;">
					<strong>Become a 6FigureJobs Member?  It's FREE!</strong><br />
	                <div style="padding-bottom:6px;"></div>
					
                	For membership approval, you must:<br />
	                1) Have a valid resume<br />
	                2) Have earned a $100k+ compensation in a previous postion<br />
		            3) Complete a membership profile 
					<div style="padding-bottom:6px;"></div>
	                <!---ISR <strong><a href="/execs/resbuilder/execResBuilder.cfm?#strAppAddToken#" title="Click here to complete your application">Complete your application</a> for full membership access.</strong> --->
				</div>
			</div>		
  		</cfif>
        
	</cfif>
	
</cfif>
</div>
<!--- </article> --->
</div>
<!------>
   </cfoutput>