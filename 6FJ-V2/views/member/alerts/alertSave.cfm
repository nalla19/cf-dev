<cfoutput>
<cfparam name="blnFulltime" default="0">
<cfparam name="blnContract" default="0">
<cfparam name="blnStartup" default="0">
<cfparam name="strKeyWords" default="">
<cfparam name="strTitle" default="">
<cfparam name="strOrigTitle" default="">
<cfparam name="strTitleOrg" default="">

<!---New variables for the new job search--->
<cfparam name="jobTitleSearch" default="0">
<cfparam name="strJobTitle" default="">
<cfparam name="strSkills" default="">
<cfparam name="strLocation" default="">
<cfparam name="strSalary" default="">

<cfif isDefined("form.sa_jobTitleSearch") and form.sa_jobTitleSearch neq "">
	<cfset jobTitleSearch = form.sa_jobTitleSearch>
</cfif>

<!---If it is job title search--->
<cfif jobTitleSearch>
	<cfset strJobTitle="#form.strTitle1#">
	<cfset strSkills="#form.strSkills1#">
	<cfset strLocation="#form.strLocation1#">
<!---If standard keyword search--->
<cfelse>
	<cfset strSkills="#form.strSkills2#">
	<cfset strLocation="#form.strLocation2#">
</cfif>

<cfif strTitle neq "">
 	<cfset strTitle=Replace(strTitle, chr(34), "$$SQ$$", "ALL")>
 	<cfset strTitle=Replace(strTitle, chr(39), "$$SQ$$", "ALL")>
 	<cfif findNoCase("&", strTitle, 1) gt 0>
  		<cfset strTitle=Replace(strTitle, "&", " and ", "ALL")>
 	</cfif> 
 	<cfif findNoCase("+", strTitle, 1) gt 0>
  		<cfset strTitle=Replace(strTitle, "+", "and", "ALL")>
 	</cfif> 
 	<cfset strOrigTitle=strTitle>
</cfif>

<cfif strTitleOrg neq "">
 	<cfset strTitleOrg=Replace(strTitleOrg, chr(34), "$$SQ$$", "ALL")>
 	<cfset strTitleOrg=Replace(strTitleOrg, chr(39), "$$SQ$$", "ALL")>
 	<cfif findNoCase("&", strTitleOrg, 1) gt 0>
  		<cfset strTitleOrg=Replace(strTitleOrg, "&", " and ", "ALL")>
 	</cfif> 
 	<cfif findNoCase("+", strTitleOrg, 1) gt 0>
  		<cfset strTitleOrg=Replace(strTitleOrg, "+", "and", "ALL")>
 	</cfif> 
</cfif>

<cfif strKeyWords neq "">
 	<cfset strKeyWords=Replace(strKeyWords, chr(34), "$$SQ$$", "ALL")>
 	<cfset strKeyWords=Replace(strKeyWords, chr(39), "$$SQ$$", "ALL")>
</cfif>

<cfparam name="blnForm" default=0>
<cfparam name="blnBigs" default=0>
<cfparam name="intPageNo" default=0>
<cfparam name="MaxRows" default=20>
<cfparam name="intMaxRecords" default=0>
<cfparam name="StartRow" default=1>
<cfparam name="intRecordsFound" default=0>
<cfparam name="form.strKeyWords" default="">
<cfparam name="form.intsIndIDs" default="">
<cfparam name="form.intsFuncIDs" default="">
<cfparam name="form.listStateIDs" default="">
<cfparam name="form.strSearchType" default="0">
<cfparam name="form.blnFulltime" default="0">
<cfparam name="form.blnContract" default="0">
<cfparam name="form.blnstartup" default="0">
<cfparam name="form.blnEmailAgent" default="0">
<cfparam name="expid" default="0">

<!--- Do not allow blank keywords or wildcards - prevents job skimming --->
<cfif form.SubmitAction does not contain "Delete">
	<cfif trim(form.strKeyWords) neq "">
		<cfif form.strKeywords contains "#chr(37)#">
			<cfif blnNewRcrd eq "1">
				<cflocation url="/member-job-alerts?#strAppAddToken#&blnEmailAgent=#form.blnEmailAgent#&intsIndIDs=#form.intsIndIDs#&intsFuncIDs=#form.intsFuncIDs#&listStateIDs=#form.listStateIDs#&blncontract=#form.blncontract#&blnform=#blnform#&blnfulltime=#form.blnfulltime#&blnstartup=#form.blnstartup#&strsearchtype=#form.strsearchtype#&strMode=new&strTitle=#URLEncodedFormat(strTitle)#&strkeywords=#URLEncodedFormat(form.strkeywords)#&am=#am#&tm=#tm#&keyworderror=wild&expid=#form.expid#" addtoken="No">
			<cfelse>
				<cflocation url="/member-job-alerts?#strAppAddToken#&blnEmailAgent=#form.blnEmailAgent#&intsIndIDs=#form.intsIndIDs#&intsFuncIDs=#form.intsFuncIDs#&listStateIDs=#form.listStateIDs#&blncontract=#form.blncontract#&blnform=#blnform#&blnfulltime=#form.blnfulltime#&blnstartup=#form.blnstartup#&strsearchtype=#form.strsearchtype#&strMode=edit&strTitle=#URLEncodedFormat(strOrigTitle)#&strkeywords=#URLEncodedFormat(form.strkeywords)#&am=#am#&tm=#tm#&keyworderror=wild&expid=#form.expid#" addtoken="No">
			</cfif>
		<cfelseif form.strKeywords contains "#chr(42)#">
			<cfif blnNewRcrd eq "1">
				<cflocation url="/member-job-alerts?#strAppAddToken#&blnEmailAgent=#form.blnEmailAgent#&intsIndIDs=#form.intsIndIDs#&intsFuncIDs=#form.intsFuncIDs#&listStateIDs=#form.listStateIDs#&blncontract=#form.blncontract#&blnform=#blnform#&blnfulltime=#form.blnfulltime#&blnstartup=#form.blnstartup#&strsearchtype=#form.strsearchtype#&strMode=new&strTitle=#URLEncodedFormat(strTitle)#&strkeywords=#URLEncodedFormat(form.strkeywords)#&am=#am#&tm=#tm#&keyworderror=wild&expid=#form.expid#" addtoken="No">
			<cfelse>
				<cflocation url="/member-job-alerts?#strAppAddToken#&blnEmailAgent=#form.blnEmailAgent#&intsIndIDs=#form.intsIndIDs#&intsFuncIDs=#form.intsFuncIDs#&listStateIDs=#form.listStateIDs#&blncontract=#form.blncontract#&blnform=#blnform#&blnfulltime=#form.blnfulltime#&blnstartup=#form.blnstartup#&strsearchtype=#form.strsearchtype#&strMode=edit&strTitle=#URLEncodedFormat(strOrigTitle)#&strkeywords=#URLEncodedFormat(form.strkeywords)#&am=#am#&tm=#tm#&keyworderror=wild&expid=#form.expid#" addtoken="No">
			</cfif>
		<cfelse>
			 <cfset strKeyWords=Replace(strKeyWords, chr(34), "$$SQ$$", "ALL")>
	 	   	 <cfset strKeyWords=Replace(strKeyWords, chr(39), "$$SQ$$", "ALL")>
		</cfif>
	</cfif>
	
	<cfif trim(form.strTitle) neq "">
		<cfif form.strTitle contains "#chr(35)#">
			<cfif blnNewRcrd eq "1">
				<cflocation url="/member-job-alerts?#strAppAddToken#&blnEmailAgent=#form.blnEmailAgent#&intsIndIDs=#form.intsIndIDs#&intsFuncIDs=#form.intsFuncIDs#&listStateIDs=#form.listStateIDs#&blncontract=#form.blncontract#&blnform=#blnform#&blnfulltime=#form.blnfulltime#&blnstartup=#form.blnstartup#&strsearchtype=#form.strsearchtype#&strMode=new&strTitle=#URLEncodedFormat(strTitle)#&strTitleOrg=#URLEncodedFormat(strTitleOrg)#&strkeywords=#URLEncodedFormat(form.strkeywords)#&am=#am#&tm=#tm#&titleerror=wild&expid=#form.expid#" addtoken="No">
			<cfelse>
				<cflocation url="/member-job-alerts?#strAppAddToken#&blnEmailAgent=#form.blnEmailAgent#&intsIndIDs=#form.intsIndIDs#&intsFuncIDs=#form.intsFuncIDs#&listStateIDs=#form.listStateIDs#&blncontract=#form.blncontract#&blnform=#blnform#&blnfulltime=#form.blnfulltime#&blnstartup=#form.blnstartup#&strsearchtype=#form.strsearchtype#&strMode=edit&strTitle=#URLEncodedFormat(strOrigTitle)#&strTitleOrg=#URLEncodedFormat(strTitleOrg)#&strkeywords=#URLEncodedFormat(form.strkeywords)#&am=#am#&tm=#tm#&titleerror=wild&expid=#form.expid#" addtoken="No">
			</cfif>
		</cfif>
	</cfif>	
</cfif>
<!--- /END/ Do not allow blank keywords or wildcards - prevents job skimming --->

<cfif ListLen(listStateIDs) gt 1>
 	<cfset listStIds=listStateIDs>
 	<cfset listStateIDs="">
 	<cfloop list="#listStIds#" index="ListEl">
  		<cfif ListEl neq 300>
 			<cfset listStateIDs=ListAppend(listStateIDs, #ListEl#)>
  		</cfif>
 	</cfloop>
</cfif>

<cfset strAtts="">

<cfif isDefined("form_q_nsc")>
	<!---Replace the double quotes with single quotes--->
    <cfset strIndNames=replace(form_q_nsc, chr(34), "", "ALL")>
    <cfset intsIndIDs="">
    <cfloop list="#strIndNames#" index="indName">
        <cfquery name="cfqGetIndID" datasource="#application.dsn#">
        select intOldIndID from tblIndustries (nolock) where strIndName = '#indName#'
        </cfquery>
        <cfset intsIndIDs = listAppend(intsIndIDs, cfqGetIndID.intOldIndID)>
    </cfloop>        			
</cfif>

<cfif isDefined("form_q_nsf")>
    <!---Replace the double quotes with single quotes--->
    <cfset strFuncNames=replace(form_q_nsf, chr(34), "", "ALL")>    
    <cfset intsFuncIDs="">
    <cfloop list="#strFuncNames#" index="funcName">
        <cfquery name="cfqGetFuncID" datasource="#application.dsn#">
        select intOldFunctionID from tblFunctions (nolock) where strFunctionName = '#funcName#'
        </cfquery>
        <cfset intsFuncIDs = listAppend(intsFuncIDs, cfqGetFuncID.intOldFunctionID)>
    </cfloop>
</cfif>

<cfif isDefined("form_q_nst")>
    <!---Replace the double quotes with single quotes--->
    <cfset strStateNames=replace(form_q_nst, chr(34), "", "ALL")>    
    <cfset listStateIDs="">
    <cfloop list="#strStateNames#" index="stateName">
        <cfquery name="cfqGetStateID" datasource="#application.dsn#">
        select intOldID from tblStates (nolock) where strName = '#stateName#'
        </cfquery>
        <cfset listStateIDs = listAppend(listStateIDs, cfqGetStateID.intOldID)>
    </cfloop>
</cfif>

<cfif isDefined("form_q_fsd")>
    <!---Replace the double quotes with single quotes--->
    <cfset strSalary=replace(form_q_fsd, chr(34), "", "ALL")>    
</cfif>

<cfif ListLen(intsIndIDs) gt 0><cfset strAtts=ListAppend(strAtts, #intsIndIDs#)></cfif>
<cfif ListLen(intsFuncIDs) gt 0><cfset strAtts=ListAppend(strAtts, #intsFuncIDs#)></cfif>
<cfif ListLen(listStateIDs) gt 0><cfset strAtts=ListAppend(strAtts, #listStateIDs#)></cfif>
<!---
jobTitleSearch=#jobTitleSearch#<br />
strJobTitle=#strJobTitle#<br />
strSkills=#strSkills#<br />
strLocation=#strLocation#<br />
strSalary=#strSalary#<br />
<cfabort>
--->

<!--- Make sure we won't get a truncation error --->
<cfif form.SubmitAction does not contain "Delete">
	<cfif listLen(strAtts) gt 85>
		<cfif blnNewRcrd eq "1">
			<cflocation url="/member-job-alerts?#strAppAddToken#&blnEmailAgent=#form.blnEmailAgent#&intsIndIDs=#form.intsIndIDs#&intsFuncIDs=#form.intsFuncIDs#&listStateIDs=#form.listStateIDs#&blncontract=#form.blncontract#&blnform=#blnform#&blnfulltime=#form.blnfulltime#&blnstartup=#form.blnstartup#&strsearchtype=#form.strsearchtype#&strMode=new&strTitle=#URLEncodedFormat(strTitle)#&bnlattserror=1&strkeywords=#form.strkeywords#&am=#am#&tm=#tm#&expid=#form.expid#" addtoken="No">
		<cfelse>
			<cflocation url="/member-job-alerts?#strAppAddToken#&blnEmailAgent=#form.blnEmailAgent#&intsIndIDs=#form.intsIndIDs#&intsFuncIDs=#form.intsFuncIDs#&listStateIDs=#form.listStateIDs#&blncontract=#form.blncontract#&blnform=#blnform#&blnfulltime=#form.blnfulltime#&blnstartup=#form.blnstartup#&strsearchtype=#form.strsearchtype#&strMode=edit&strTitle=#URLEncodedFormat(strOrigTitle)#&bnlattserror=1&strkeywords=#form.strkeywords#&am=#am#&tm=#tm#&expid=#form.expid#" addtoken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Date_Time=Now()>

<!---DaveP new code for unique strTitles--->
<cfset strCond="Start">
<cfset strTitleLocal=strTitle>
<cfset intNoRecordsTotal=1>
<cfset blnDeleteAgent=0>

<cfloop condition="strCond neq 'End'">
  	<cfquery name="cfqAgentExist" datasource="#application.dsn#">
    select *
      from tblSearchAgent (NOLOCK)
     where intresid=#intResID# and strTitle='#strTitleLocal#'
	 <cfif strTitleLocal eq strTitleOrg>
	   and dteCreated <> '#dteCrt#'
	 </cfif>
    </cfquery>
   	
	<cfset intNoRecords=cfqAgentExist.RecordCount>
   	<cfif intNoRecords eq 0>
   		<cfset strCond="End">
   	<cfelseif intNoRecords gt 0> 
    	<cfset intNoRecordsTotal=intNoRecordsTotal + 1>
    	<cfset strTitleLocal=strTitle & "_" & #intNoRecordsTotal#>		
   	</cfif>
</cfloop>
<!---DaveP End strTitle: #strTitle#, blnNewRcrd: #blnNewRcrd#, strTitleLocal: #strTitleLocal# <cfabort>--->

<cfif strKeywords is "">
	<cfif jobTitleSearch is 1>
        <cfset strKeywords = strJobTitle>
    <cfelseif jobTitleSearch is 0>
        <cfset strKeywords = strSkills>
    </cfif>
</cfif>

<cfif blnNewRcrd eq 0>
 	<cfif form.SubmitAction is "Save Search Alert"> 
  		<cfquery datasource="#application.dsn#">
 		update tblSearchAgent
  		   set strTitle='#left(strTitleLocal,50)#',
               strKeywords='#strKeywords#',
               strAtts='#strAtts#',
               blnFulltime='#blnFulltime#',
               blnContract='#blnContract#',
               blnStartup='#blnStartup#',
               strSearchType='#strSearchType#',
               dteEdited=#Date_Time#
  			   <!--- Remove blnemailagent logic once weekly functionality is launched --->
  			   <!--- 
			   <cfif isdefined('blnEmailAgent') and blnEmailAgent eq "1">
  			   , blnEmailagent=1
  			   <cfelse> 
			   --->
  			   <cfif isdefined('strEmailAgentFreq')>
					<cfif strEmailAgentFreq eq "d">
					, blnEmailagent=1
					, blnweekly=0
					<cfelseif strEmailAgentFreq eq "w">
					, blnEmailagent=1
					, blnweekly=1
					<cfelseif strEmailAgentFreq eq "n">
					, blnEmailagent=0
					, blnweekly=0
					</cfif>
				<cfelse>
  					, blnEmailagent=0
					, blnweekly=0
				</cfif>
                ,intJobTitleSearch=#sa_jobTitleSearch#
                <cfif strJobTitle neq "">,strJobTitle='#strJobTitle#'</cfif> 
				<cfif strSkills neq "">,strSkills='#strSkills#'</cfif> 
				<cfif strLocation neq "">,strLocation='#strLocation#'</cfif> 
				<cfif strSalary neq "">,strSalary='#strSalary#'</cfif>
  		 where (intResID=#intResID#) and (strTitle='#strTitleOrg#')<!--- strTitleOrg --->
  		</cfquery>
	<cfelseif form.SubmitAction is "Delete Search Alert">
  		<cfset blnDeleteAgent=1>
  		<cfquery datasource="#application.dsn#">
  		delete from tblSearchAgent
  		 where (intResID=#intResID#) and (strTitle='#strTitleOrg#')
  		</cfquery>
		
        <cflock scope="session" timeout="10" type="Exclusive">
			<cfparam name="session.SearchJobs.NbrSearchAss" default="0">
			<cfif session.SearchJobs.NbrSearchAss gt 0>
				<cfset session.SearchJobs.NbrSearchAss=session.SearchJobs.NbrSearchAss - 1>
			</cfif>
		</cflock>  
 	</cfif>
<cfelseif blnNewRcrd eq 1>
	<cfquery name="cfqSearchAss" datasource="#application.dsn#">
	select count(intResID) as cnt from tblSearchAgent (NOLOCK) where intresid=#intResID#
	</cfquery>
	
	<cfif cfqSearchAss.cnt lt 3>
		<cfif strTitleLocal eq "">
			<cfset strTitleLocal="[no name saved]">
		</cfif>
		        
        <cfquery datasource="#application.dsn#">
		insert into tblSearchAgent(intResID, strTitle, dteCreated, strKeywords, strAtts, blnFulltime, blnContract, blnStartup, strSearchType, dteEdited, blnEmailAgent 
								   <cfif isdefined('strEmailAgentFreq') and strEmailAgentFreq eq "w">, blnWeekly</cfif>
                                    ,intJobTitleSearch <cfif strJobTitle neq "">,strJobTitle</cfif> <cfif strSkills neq "">,strSkills</cfif> <cfif strLocation neq "">,strLocation</cfif> <cfif strSalary neq "">,strSalary</cfif>
                          ) values(#intResID#, '#left(strTitleLocal,50)#', #Date_Time#, '#strKeywords#', '#strAtts#', '#blnFulltime#', '#blnContract#', '#blnStartup#', '#strSearchType#', #Date_Time#
					   		  	   <cfif isdefined('strEmailAgentFreq')>
								   		<cfif strEmailAgentFreq eq "d">
                                        	, 1<!--- blnEmailagent --->
										<cfelseif strEmailAgentFreq eq "w">
											, 1<!--- blnEmailagent --->
											, 1<!--- blnWeekly --->
										<cfelseif strEmailAgentFreq eq "n">
											, 0<!--- blnEmailagent --->
										</cfif>
								   <cfelse>
		  								, 0<!--- blnEmailagent --->
									</cfif>
                                    ,#jobTitleSearch# <cfif strJobTitle neq "">,'#strJobTitle#'</cfif> <cfif strSkills neq "">,'#strSkills#'</cfif> <cfif strLocation neq "">,'#strLocation#'</cfif> <cfif strSalary neq "">,'#strSalary#'</cfif>
                         	)
		</cfquery>
		
        <cfquery name="cfqSearchAssTtl" datasource="#application.dsn#">
		select count(intResID) as cnt from tblSearchAgent (NOLOCK) where intresid=#intResID#
		</cfquery>
		
        <cflock scope="session" timeout="10" type="Exclusive">
			<cfset session.SearchJobs.NbrSearchAss=cfqSearchAssTtl.cnt>
		</cflock>
	<cfelse>
		<cflock scope="session" timeout="10" type="Exclusive">
			<cfparam name="session.SearchJobs.NbrSearchAss" default="0">
			<cfif session.SearchJobs.NbrSearchAss gte 0 AND session.SearchJobs.NbrSearchAss lt 3>
				<cfset session.SearchJobs.NbrSearchAss=3>
			</cfif>
		</cflock>
	</cfif>
</cfif>
</cfoutput>

<cfoutput>
<h1 class="page-title">Job Search Alerts</h1>
	<div class="row">
		<div class="span12">
			<div class="page-spacer"></div>
<cfif expid eq 1>
	<cfparam name="sort" default="date_submitted">
	<cfparam name="sortorder" default="desc">
	<cfparam name="intpageno" default="0">
	
				<div>Your search alert has been successfully <cfif blnDeleteAgent neq 0>deleted<cfelse>stored</cfif>.</div>
				<div class="page-spacer"></div>
				<div>
	            <a href="##" style="font-size:13px; font-weight:bold;" onclick="window.location='/jobs/?start1=#sa_start#&pgNo=#sa_pgNo#';">BACK TO JOB SEARCH</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="##" style="font-size:13px; font-weight:bold;" onclick="window.location='/member-job-alerts?#strAppAddToken#&bp=1&tm=#tm#&jrl=1';">BACK TO JOB SEARCH ALERTS</a>
				</div>
			
<cfelse>	
	
				<div>Your search alert has been successfully <cfif blnDeleteAgent neq 0>deleted<cfelse>stored</cfif>.</div>
				<div class="page-spacer"></div>
				<div>
                <a href="##" style="font-size:13px; font-weight:bold;" onclick="window.location='/member-job-alerts?#strAppAddToken#&am=#am#&bp=1&tm=#tm#&jrl=1';">BACK TO JOB SEARCH ALERTS</a>
				</div>
			
</cfif>
</div>
</div>
</cfoutput>