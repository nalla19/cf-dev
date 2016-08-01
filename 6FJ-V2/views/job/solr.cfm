<!--- -----------------------------below taken from jobs/t_index.cfm and revised -------------------------------------------->

<cfparam name="request.strLocation" default="">
<cfparam name="request.strSkills" default="">

<cfif isDefined("request.strTitle")>
	<cfparam name="request.jobtitlesearch" default="1">
<cfelse>
	<cfparam name="request.jobtitlesearch" default="0">
	<cfparam name="request.strTitle" default="">
</cfif>


<cfif !len(request.strLocation)>
	<cfset request.strLocation = "Any Location" />
</cfif>


<cfscript>
	request.strLocation = trim(request.strLocation);
	request.strSkills = trim(request.strSkills);
	request.strTitle = trim(request.strTitle);
</cfscript>




<!---01/11/2012 - Delete the session variable from the Category Specific Job Listing (Site Map Industry/Function Links)--->
<cfif isDefined("session.exec.categoryJobsBackLink")>
	<cfset StructDelete(session.exec,"categoryJobsBackLink")>
</cfif>

<!---01/11/2012 Delete the Corp Jobs links--->
<cfif isDefined("session.exec.corpJobsBackLink")>
	<cfset StructDelete(session.exec,"corpJobsBackLink")>
</cfif>

<!---01/11/2012 Delete the JSA links--->
<cfif isDefined("session.exec.JSABackLink")>
	<cfset StructDelete(session.exec,"JSABackLink")>
</cfif>


<cfif isdefined("session.exec.blnValidLogin")>
	<cfparam name="blnValidLogin" default="#session.exec.blnValidLogin#">
<cfelse>
	<cfparam name="blnValidLogin" default="0">
</cfif>


<cfif isdefined("session.exec.intResID")>
	<cfparam name="intResID" default="#session.exec.intResID#">
<cfelse>
	<cfparam name="intResID" default="">
</cfif>


<cfparam name="start1" default="0">
<cfparam name="pgNo" default="1">




<!--- Session variable to fq_njp used in include/exclude on nav page ------->
<cflock scope="session" timeout="8">
	<cfparam name="session.exec.fq_njp" default="">
	<cfparam name="session.exec.fq_nsc" default="">
	<cfparam name="session.exec.fq_nst" default="">
	<cfparam name="session.exec.fq_fsd" default="">
	<cfparam name="session.exec.fq_nl" default="">
	<cfparam name="session.exec.fq_nfs" default="">
	<cfparam name="session.exec.excluding" default="">
	<cfparam name="session.exec.queryParams" default="">
	<cfparam name="session.exec.searchAgentParams" default="">
</cflock>




<!--------------------------------------------------------------------->
<!------------Start: Retain the search criteria on this page----------->
<!--------------------------------------------------------------------->
<cfparam name="srchTitle1" default="Any Job Title">
<cfparam name="srchSkills1" default="Any Skills">
<cfparam name="srchLocation1" default="Any Location">
<cfparam name="srchSkills2" default="Any Skills">
<cfparam name="srchLocation2" default="Any Location">


<cflock scope="session" timeout="8">
	<cfparam name="session.exec.srchTitle1" default="Any Job Title">
	<cfparam name="session.exec.srchSkills1" default="Any Skills">
	<cfparam name="session.exec.srchLocation1" default="Any Location">
	<cfparam name="session.exec.srchSkills2" default="Any Skills">
	<cfparam name="session.exec.srchLocation2" default="Any Location">


	<!---Standard Keyword search--->
	<cfif request.jobtitlesearch EQ 0>
		<cfset session.exec.srchSkills2 = request.strSkills>
	    <cfset session.exec.srchLocation2 = request.strLocation>

	    <cfset session.exec.srchTitle1 = "Any Job Title">
		<cfset session.exec.srchSkills1 = "Any Skills">
	    <cfset session.exec.srchLocation1 = "Any Location">

	<!---Job Title Search--->
	<cfelseif request.jobtitlesearch EQ 1>
		<cfset session.exec.srchTitle1 = request.strTitle>
		<cfset session.exec.srchSkills1 = request.strSkills>
	    <cfset session.exec.srchLocation1 = request.strLocation>

	    <cfset session.exec.srchSkills2 = "Any Skills">
	    <cfset session.exec.srchLocation2 = "Any Location">
	</cfif>
</cflock>
<!--------------------------------------------------------------------->
<!-------------End: Retain the search criteria on this page------------>
<!--------------------------------------------------------------------->



<cfif isdefined("fieldnames")>
	<cflock scope="session" timeout="8">
		<cfset session.exec.fq_njp="">
		<cfset session.exec.fq_nsc="">
		<cfset session.exec.fq_nst="">
		<cfset session.exec.fq_fsd="">
		<cfset session.exec.fq_nl="">
		<cfset session.exec.fq_nfs="">
		<cfset session.exec.excluding="">
		<cfset session.exec.queryParams="">
		<cfset session.exec.searchAgentParams="">
	</cflock>
<cfelseif isDefined("url.cat") OR isDefined("url.func")>
	<cflock scope="session" timeout="8">
		<cfset session.exec.fq_njp="">
		<cfset session.exec.fq_nsc="">
		<cfset session.exec.fq_nst="">
		<cfset session.exec.fq_fsd="">
		<cfset session.exec.fq_nl="">
		<cfset session.exec.fq_nfs="">
	    <cfset session.exec.excluding="">
		<cfset session.exec.queryParams="">
	    <cfset session.exec.searchAgentParams="">

	    <cfset session.exec.jobtitlesearch=0>
		<cfset session.exec.strTitle="">
		<cfset session.exec.strSkills="">
		<cfset session.exec.strLocation=""/>
	    <cfset session.exec.navLinks1="">

	    <cfset session.exec.srchSkills2 = "Any Skills">
	    <cfset session.exec.srchLocation2 = "Any Location">
	    <cfset session.exec.srchTitle1 = "Any Job Title">
		<cfset session.exec.srchSkills1 = "Any Skills">
	    <cfset session.exec.srchLocation1 = "Any Location">
	</cflock>
</cfif>





<cflock scope="session" timeout="8">
	<cfset srchTitle1 = session.exec.srchTitle1>
	<cfset srchSkills1 = session.exec.srchSkills1>
	<cfset srchLocation1 = session.exec.srchLocation1>
	<cfset srchSkills2 = session.exec.srchSkills2>
	<cfset srchLocation2 = session.exec.srchLocation2>
</cflock>





<cfif isDefined("url.cat") AND url.cat NEQ "">
	
	<!---Get the actual Industry/Category Name and set the variables--->
	<cfquery name="cfqGetCatName" datasource="#application.dsn#">
		select intOldIndid, strIndName
		from tblIndustries (nolock)
		where seoIndName = <cfqueryparam value="#url.cat#" cfsqltype="cf_sql_varchar" />
	</cfquery>
	
	<cfset form_q_nsc = '"#cfqGetCatName.strIndName#"' />
	
	<cfset fq_nsc = '"' & cfqGetCatName.strIndName & '"'>
	
	<!--- <cfset strkeywords = "strCats:(" & cfqGetCatName.strIndName & ")"> --->
	<cfset strkeywords = cfqGetCatName.strIndName>
	<cfset intsIndIDs = cfqGetCatName.intOldIndid>
	<cfset session.SearchResults.intsIndIDs=intsIndIDs>
</cfif>



<cfif isDefined("url.func") AND url.func NEQ "">
	<cfset strFuncName=url.func>
	<!---Get the actual Function Name AND set the variables--->
	<cfquery name="cfqGetFuncName" datasource="#application.dsn#">
		select intOldFunctionID, strFunctionName
		from tblFunctions (nolock)
		where seoFunctionName = <cfqueryparam value="#strFuncName#" cfsqltype="cf_sql_varchar" />
	</cfquery>
	<cfset fq_nsf = '"' & cfqGetFuncName.strFunctionName & '"'>
	<!--- <cfset strkeywords = "strFuncs:(" & cfqGetFuncName.strFunctionName & ")"> --->
	<cfset strkeywords = cfqGetFuncName.strFunctionName>
	<cfset intsFuncIDs = cfqGetFuncName.intOldFunctionID>
	<cfset session.SearchResults.intsFuncIDs=intsFuncIDs>
</cfif>




<!---Start: Variables --->
<cfparam name="selectPage" default="0">
<cfparam name="strkeywords" default="">
<cfparam name="intsIndIDs" default="">
<cfparam name="intsFuncIDs" default="">
<cfparam name="listStateIDs" default="">
<cfparam name="blnEmailAgent" default="">



<!---For the job results navigation--->
<cfparam name="session.exec.navLinks" default="">
<cfparam name="session.exec.navLinks1" default="">


<cflock scope="SESSION" type="EXCLUSIVE" timeout="10">
    <cfset session.exec.SHKeywordString="">
    <cfset session.Searchjobs.SHstrTitle="">
    <cfset session.Searchjobs.SHlocation="">
    <cfset session.Searchjobs.SHstrKeywordExactPhrase="">
    <cfset session.Searchjobs.SHstrKeywordNotPhrase="">
    <cfset session.Searchjobs.SHintDatescope="">
    <cfset session.Searchjobs.SHintMiles="">
    <cfset session.Searchjobs.SHJobType="">
    <cfset session.Searchjobs.SHSearchForm="">
    <cfset session.Searchjobs.SHIsSearchAgent="">
</cflock>



<cfif request.jobTitleSearch NEQ "">
    <cfset session.SearchResults.strKeyWords="">
    <cfset session.SearchResults.intsIndIDs="">
    <cfset session.SearchResults.intsFuncIDs="">
    <cfset session.SearchResults.intsStateIDs="">
	<cfset session.SearchResults.fq_njp="">
	
    <!--- Job Title Search --->
    <cfif request.jobTitleSearch EQ 1>
        <cfset strKeyWords="">
		<cfset session.SearchResults.strTitle="">
        <cfset session.SearchResults.strSkills="">
        <cfset session.SearchResults.strKeyWords="">

    	<cfif len(request.strTitle) AND request.strTitle NEQ "Any Job Title">
       		<cfset session.SearchResults.strTitle=request.strTitle>
		</cfif>

		<cfif len(request.strSkills) AND request.strSkills NEQ "Any Skills">
   			<cfset session.SearchResults.strSkills=request.strSkills>
		</cfif>

		<cfif isDefined("navForm")>
			<cfif isDefined("fq_njp")>

				<cfset fq_njp = fq_njp>
				<cfset session.SearchResults.fq_njp=fq_njp/>
			</cfif>
		</cfif>

		<cfif request.strTitle NEQ "" AND request.strSkills NEQ "">
			<cfset strKeyWords=request.strTitle & " AND " & request.strSkills>
            <cfset session.SearchResults.strKeyWords=strKeyWords>
        <cfelseif request.strTitle NEQ "" AND request.strSkills EQ "">
        	<cfset strKeyWords=request.strTitle>
            <cfset session.SearchResults.strKeyWords=strKeyWords>
        <cfelseif request.strTitle EQ "" AND request.strSkills NEQ "">
        	<cfset strKeyWords=request.strSkills>
    		<cfset session.SearchResults.strKeyWords=strKeyWords>
		</cfif>

        <cfif isDefined("request.strLocation")>
			<cfset session.SearchResults.strLocation=request.strLocation>
		</cfif>

		<cfif isDefined("form_q_nsc")>
			<!---Replace the double quotes with single quotes--->
			<cfset strIndNames=replace(form_q_nsc, chr(34), "", "ALL")>
			<cfset intsIndIDs="">
			<cfloop list="#strIndNames#" index="indName">
				<cfquery name="cfqGetIndID" datasource="#application.dsn#">
					select intOldIndID
					from tblIndustries (nolock)
					where strIndName = '#indName#'
				</cfquery>
				<cfset intsIndIDs = listAppend(intsIndIDs, cfqGetIndID.intOldIndID)>
			</cfloop>
			<cfset session.SearchResults.intsIndIDs=intsIndIDs>
		</cfif>

		<cfif isDefined("form_q_nsf")>
		<!---Replace the double quotes with single quotes--->
			<cfset strFuncNames=replace(form_q_nsf, chr(34), "", "ALL")>
			<cfset intsFuncIDs="">
			<cfloop list="#strFuncNames#" index="funcName">
				<cfquery name="cfqGetFuncID" datasource="#application.dsn#">
					select intOldFunctionID
					from tblFunctions (nolock)
					where strFunctionName = '#funcName#'
				</cfquery>
				<cfset intsFuncIDs = listAppend(intsFuncIDs, cfqGetFuncID.intOldFunctionID)>
			</cfloop>
			<cfset session.SearchResults.intsFuncIDs=intsFuncIDs>
		</cfif>

		<cfif isDefined("form_q_nst")>
			<!---Replace the double quotes with single quotes--->
			<cfset strStateNames=replace(form_q_nst, chr(34), "", "ALL")>
			<cfset listStateIDs="">
			<cfloop list="#strStateNames#" index="stateName">
				<cfquery name="cfqGetStateID" datasource="#application.dsn#">
					select intOldID
					from tblStates (nolock)
					where strName = '#stateName#'
				</cfquery>
				<cfset listStateIDs = listAppend(listStateIDs, cfqGetStateID.intOldID)>
			</cfloop>
			<cfset session.SearchResults.intsStateIDs=listStateIDs>
		</cfif>
		
	<cfelse>
	
        <cfset strKeyWords="">
		<cfset session.SearchResults.strSkills="">
        <cfset session.SearchResults.strKeyWords="">

		<cfif request.strSkills NEQ "Any Skills">
   			<cfset strKeyWords=request.strSkills>
			<cfset session.SearchResults.strSkills=request.strSkills>
            <cfset session.SearchResults.strKeyWords=request.strSkills>
		</cfif>

        <cfif len(request.strLocation)>
			<cfset session.SearchResults.strLocation=request.strLocation>
		</cfif>

		<cfif isDefined("form_q_nsc")>
			<!---Replace the double quotes with single quotes--->
			<cfset strIndNames=replace(form_q_nsc, chr(34), "", "ALL")>
			<cfset intsIndIDs="">
			<cfloop list="#strIndNames#" index="indName">
				<cfquery name="cfqGetIndID" datasource="#application.dsn#">
					select intOldIndID
					from tblIndustries (nolock)
					where strIndName = '#indName#'
				</cfquery>
				<cfset intsIndIDs = listAppend(intsIndIDs, cfqGetIndID.intOldIndID)>
			</cfloop>
			<cfset session.SearchResults.intsIndIDs=intsIndIDs>
		</cfif>

		<cfif isDefined("form_q_nsf")>
			<!---Replace the double quotes with single quotes--->
			<cfset strFuncNames=replace(form_q_nsf, chr(34), "", "ALL")>
			<cfset intsFuncIDs="">
			<cfloop list="#strFuncNames#" index="funcName">
				<cfquery name="cfqGetFuncID" datasource="#application.dsn#">
					select intOldFunctionID
					from tblFunctions (nolock)
					where strFunctionName = '#funcName#'
				</cfquery>
				<cfset intsFuncIDs = listAppend(intsFuncIDs, cfqGetFuncID.intOldFunctionID)>
			</cfloop>
			<cfset session.SearchResults.intsFuncIDs=intsFuncIDs>
		</cfif>

		<cfif isDefined("form_q_nst")>
			<!---Replace the double quotes with single quotes--->
			<cfset strStateNames=replace(form_q_nst, chr(34), "", "ALL")>
			<cfset listStateIDs="">
			<cfloop list="#strStateNames#" index="stateName">
				<cfquery name="cfqGetStateID" datasource="#application.dsn#">
					select intOldID
					from tblStates (nolock)
					where strName = '#stateName#'
				</cfquery>
				<cfset listStateIDs = listAppend(listStateIDs, cfqGetStateID.intOldID)>
			</cfloop>
			<cfset session.SearchResults.intsStateIDs=listStateIDs>
		</cfif>
    </cfif>
</cfif>



<cftry>
    <cfif isdefined('url.blnEmailAgent')>
        <cfset blnEmailAgent=url.blnEmailAgent>
    <cfelseif isdefined('blnEmailAgent')>
        <cfset blnEmailAgent=blnEmailAgent>
    <cfelseif isdefined('session.SearchResults.blnEmailAgent')>
        <cfset blnEmailAgent=session.SearchResults.blnEmailAgent>
    <cfelse>
        <cfset blnEmailAgent=''>
    </cfif>
    <cfset session.SearchJobs.blnEmailAgent=blnEmailAgent>

    <cfcatch type="Any"></cfcatch>
</cftry>



<!---If the strKeywords is not set, (fix for the JobSweeper not having the keywords--->
<cfif strKeyWords eq "">
	<!---Grab the Job Title or the strSkills from the URL--->
    <cfif isdefined("request.jobtitlesearch") AND request.jobtitlesearch is 1 AND isdefined("request.strTitle") AND request.strTitle NEQ "Any Job Title">
    	<cfset strKeyWords = request.strTitle>
    <cfelseif isdefined("request.jobtitlesearch") AND request.jobtitlesearch is 1 AND isdefined("request.strTitle") AND request.strTitle eq "Any Job Title" AND request.strSkills NEQ "Any Skills">
    	<cfset strKeyWords = request.strSkills>
    <cfelseif isdefined("request.jobtitlesearch") AND request.jobtitlesearch is 0 AND isdefined("request.strSkills") AND request.strSkills NEQ "Any Skills">
    	<cfset strKeyWords = request.strSkills>
   	</cfif>
</cfif>



<!---Reset the Keywords from *:* to the value from strTitle
<cfif not isdefined("advancedSearch") AND isDefined("session.exec.searchAgentParams")>
    <cfif isDefined("session.exec.searchAgentParams.JobTitleSearch") AND session.exec.searchAgentParams.JobTitleSearch is 1>
		<cfif isDefined("session.exec.searchAgentParams.strTitle") AND  session.exec.searchAgentParams.strTitle NEQ "">
    		<cfset strKeyWords = session.exec.searchAgentParams.strTitle>
        <cfelseif isDefined("session.exec.searchAgentParams.strTitle") AND session.exec.searchAgentParams.strTitle eq "" AND session.exec.searchAgentParams.strSkills NEQ "">
        	<cfset strKeyWords = session.exec.searchAgentParams.strSkills>
		</cfif>
    </cfif>
</cfif>--->


<cfparam name="blnDisplayJobSweeper" default="0">








<!--- ----------------------------------------------------start t_attributes.cfm---------------------------------------------------- ---->


<!--->
<cflock scope="Application" timeout="10" type="readonly">
	<cfscript>
		//Multiple If for Code Readability
		if (isDefined("Application.sixfj.query.Industries") or isDefined("Application.sixfj.query.Functions") or isDefined("Application.sixfj.query.States")){
			tempSetApp = 0;
		} else {
			tempSetApp = 1;
		}

		strSixFigData="6Figs";
		Attributes="Exec";

		//Set Array Variables
		if (not(tempSetApp)){
			//Categories
			arrInds=Application.sixfj.query.Industries;
			intIndsArrLen=ArrayLen(arrInds);

			//Functions
			arrFuncs=Application.sixfj.query.Functions;
			intFuncsArrLen=ArrayLen(arrFuncs);

			//States
			arrStates=Application.sixfj.query.States;
			intStatesArrLen=ArrayLen(arrStates);
		}
	</cfscript>
</cflock>


<!--- Check Wheather To Process Arrays --->
<cfif tempSetApp>
	<cflock scope="Application" timeout="10" type="exclusive">

		<!--- CATEGORIES --->
		<cfset arrInds=ArrayNew(2)>

		<cfquery name="cfqGetIndustries" datasource="#application.dsn#"><!--- cachedwithin="#CreateTimeSpan(0,1,0,0)#">--->
			select intOldIndId,strIndName,intSHKeywordID
			from tblIndustries
			order by intindid
		</cfquery>

		<cfloop from="1" to="#cfqGetIndustries.RecordCount#" index="i">
			<cfset arrInds[i][1] = cfqGetIndustries.intOldIndId[i]>
			<cfset arrInds[i][2] = cfqGetIndustries.strIndName[i]>
			<cfset arrInds[i][3] = cfqGetIndustries.intSHKeywordID[i]>
		</cfloop>

		<cfset intIndsArrLen=ArrayLen(arrInds)>

		<!--- FUNCTIONS --->
		<cfset arrFuncs=ArrayNew(2)>

		<!---Do not pull the All Functions option--->
		<cfquery name="cfqGetFunctions" datasource="#application.dsn#"><!--- cachedwithin="#CreateTimeSpan(0,1,0,0)#">--->
			select intOldFunctionId,strFunctionName,intSHKeywordID
			from tblFunctions (nolock)
			where 1=1
			AND intOldFunctionId != 800
			order by strFunctionName
		</cfquery>

		<!---Set the All Functions to be the first in the array--->
		<cfset arrFuncs[1][1] = 800>
		<cfset arrFuncs[1][2] = "All Functions">
		<cfset arrFuncs[1][3] = "">

		<cfloop from="1" to="#cfqGetFunctions.RecordCount#" index="f">
			<cfset k=f+1>
			<cfset arrFuncs[k][1] = cfqGetFunctions.intOldFunctionId[f]>
			<cfset arrFuncs[k][2] = cfqGetFunctions.strFunctionName[f]>
			<cfset arrFuncs[k][3] = cfqGetFunctions.intSHKeywordID[f]>
		</cfloop>

		<cfset intFuncsArrLen=ArrayLen(arrFuncs)>

		<!--- STATES --->
		<cfset arrStates=ArrayNew(2)>

		<cfquery name="cfqGetStates" datasource="#application.dsn#"><!---  cachedwithin="#CreateTimeSpan(0,1,0,0)#" --->
			select strName,strshortname, intOldId,strAbbrev,strCountry
			from tblstates(nolock)
			order by intStateID
		</cfquery>

		<cfloop from="1" to="#cfqGetStates.RecordCount#" index="s">
			<cfset arrStates[s][1] = cfqGetStates.intOldId[s]>
			<cfset arrStates[s][2] = cfqGetStates.strName[s]>
			<cfset arrStates[s][3] = cfqGetStates.strAbbrev[s]>
			<cfset arrStates[s][4] = cfqGetStates.strCountry[s]>
			<cfset arrStates[s][5] = cfqGetStates.strShortName[s]>
		</cfloop>

		<cfset intStatesArrLen=ArrayLen(arrStates)>

		<cfscript>
			Application.sixfj.query.Industries = arrInds;
			Application.sixfj.query.Functions =  arrFuncs;
			Application.sixfj.query.States = arrStates;
		</cfscript>
	</cflock>
</cfif>
--->

<!--- ----------------------------------------------------end t_attribtues.cfm---------------------------------------------------- --->







<!---
01/31/2013 : Do not display Job Sweeper Results
<cfinclude template="t_searchJobs_simplyhired.cfm">

<cfif isdefined ("newfeed") AND newfeed eq "1">
	<cfif isdefined("resultsarr") AND arraylen(resultsarr) gt 0>
		<cfset blnDisplayJobSweeper="1">
	</cfif>
<cfelse>
	<cfif isdefined("resultsarr") AND arraylen(resultsarr) gt 1>
		<cfset blnDisplayJobSweeper="1">
	</cfif>
</cfif>
--->

<!----End: Variables --->


<!---Solr Query--->
<cffunction name="arrayFindCustom" access="public" hint="returns the index number of an item if it is in the array" output="false" returntype="numeric">
	<cfargument name="array" required="true" type="array">
	<cfargument name="valueToFind" required="true" type="string">
	<cfreturn (arguments.array.indexOf(arguments.valueToFind)) + 1>
</cffunction>



<cfif isdefined('form_q_njp')>
	<cfset session.exec.fq_njp=form_q_njp>
<cfelseif isdefined("form.form_q_njp")>
	<cfset session.exec.fq_njp=form.form_q_njp>
</cfif>

<cfif isdefined('form_q_nsc')>
	<cfset session.exec.fq_nsc=form_q_nsc>
</cfif>

<cfif isdefined('form_q_nst')>
	<cfset session.exec.fq_nst=form_q_nst>
</cfif>

<cfif isdefined('form_q_fsd')>
	<cfset session.exec.fq_fsd=form_q_fsd>
</cfif>

<cfif isdefined('form_q_nl')>
	<cfset session.exec.fq_nl=form_q_nl>
</cfif>

<cfif isdefined('form_q_nsf')>
	<cfset session.exec.fq_nsf=form_q_nsf>
</cfif>








<!--- --------------------------------------below taken from jobs/t_solrQuery.cfm and revised------------------------------------ --->



<cfparam name="start" default="0" />
<cfparam name="jobsPerPage" default="10" />
<cfparam name="request.strTitle" Default=""/>
<cfparam name="request.strSkills" Default=""/>
<cfparam name="request.strLocation" Default=""/>
<cfparam name="request.jobTitleSearch" Default="0"/>



<cflock scope="session" timeout="8">
	<cfparam name="session.exec.jobtitlesearch" Default="0"/>
	<cfparam name="session.exec.strTitle" Default="0"/>
	<cfparam name="session.exec.strSkills" Default="0"/>
	<cfparam name="session.exec.strLocation" Default="0"/>
</cflock>




<cfset session.exec.jobtitlesearch=0>
<cfset session.exec.strTitle="">
<cfset session.exec.strSkills="">
<cfset session.exec.strLocation=""/>
<cfset session.exec.navLinks1="">



<cfset solr = createObject('component', 'v16fj.com.solr.SolColdfusion').init(application.SOLRjobServer,application.SOLRjobServerPort,application.SOLRpath) />


<cfset params = StructNew() />
<cfset searchAgentParams = StructNew() />



<cfif NOT isdefined("url.start1") OR (isDefined("session.exec.searchAgentParams") AND NOT isStruct(session.exec.searchAgentParams))>


	<cfset StructInsert(params, "start", start1) />
	<cfset StructInsert(params, "indent", "on") />
	<cfset StructInsert(params, "fl", "*,score") />
	<cfset StructInsert(params, "sort", "score desc") />
	<cfset StructInsert(params, "hl", "true") />
	<cfset StructInsert(params, "hl.fragsize", "250")/>
	<cfset StructInsert(params, "hl.fl", "jpname,description,location,state,strName,intEmployerID") />
	<cfset StructInsert(params, "facet", "on") />
	<cfset StructInsert(params, "facet.sort", "count")/>
	<cfset StructInsert(params, "facet.limit", "10") />
	<cfset StructInsert(params, "facet.mincount", "1") />
	<cfset StructInsert(params, "facet_fields", "{!ex=njp}nav_jpname,nav_strCats,nav_strFuncs,nav_location,nav_strNames,fltSalary_desiredLow" ) />



	<!-------------------------------------------------------------------------------------------------------->
	<!------------------------------------Start: Set the JSA session variables-------------------------------->
	<!-------------------------------------------------------------------------------------------------------->
	<cfset StructInsert(searchAgentParams, "start", "0")/>
	<cfset StructInsert(searchAgentParams, "pgNo", pgNo)/>

	<cfif len(request.jobtitlesearch)>
	    <cfset StructInsert(searchAgentParams, "jobtitlesearch", request.jobtitlesearch)/>
	    <cfset session.exec.jobtitlesearch = request.jobtitlesearch>
	<cfelse>
	    <cfset StructInsert(searchAgentParams, "jobtitlesearch", session.exec.jobtitlesearch)/>
	</cfif>

	<cfif len(request.strLocation)>
	    <cfif request.strLocation EQ "Any Location">
	        <cfif StructKeyExists(searchAgentParams, "strLocation")>
	            <cfset StructDelete(searchAgentParams, "strLocation")>
	            <cfset session.exec.strLocation = "">
	        </cfif>
	    <cfelse>
	        <cfset StructInsert(searchAgentParams, "strLocation", request.strLocation)/>
	        <cfset session.exec.strLocation = request.strLocation>
	    </cfif>
	<cfelse>
	    <cfset StructInsert(searchAgentParams, "strLocation", session.exec.strLocation)/>
	</cfif>

	<cfif len(request.strTitle)>
	    <cfif request.strTitle EQ "Any Job Title">
	        <cfif StructKeyExists(searchAgentParams, "strTitle")>
	            <cfset StructDelete(searchAgentParams, "strTitle")>
	            <cfset session.exec.strTitle = "">
	        </cfif>
	    <cfelse>
	        <cfset StructInsert(searchAgentParams, "strTitle", request.strTitle)/>
	        <cfset session.exec.strTitle = request.strTitle>
	    </cfif>
	<cfelse>
	    <cfset StructInsert(searchAgentParams, "strTitle", session.exec.strTitle)/>
	</cfif>

	<cfif len(request.strSkills)>
	    <cfset StructInsert(searchAgentParams, "strSkills", request.strSkills)/>
	    <cfset session.exec.strSkills = request.strSkills>
	<cfelse>
	    <cfset StructInsert(searchAgentParams, "strSkills", session.exec.strSkills)/>
	</cfif>
    <!-------------------------------------------------------------------------------------------------------->
    <!-------------------------------------End: Set the JSA session variables--------------------------------->
    <!-------------------------------------------------------------------------------------------------------->



	<cfif isdefined('strOpportunity')>
	    <!--- cfdump var="Is Defined"/ --->
	    <cfif listLen(strOpportunity) gt 0>
	        <cfset optArray=ListToArray(strOpportunity)/>

	        <cfset opt="strOpportunity:("/>
	        <cfloop from="1" to="#arrayLen(optArray)#" index="i">
	            <cfif i eq 1>
	                <cfset opt &= "#optArray[i]#"/>
	            <cfelseif i lte arrayLen(optArray) >
	                <cfset opt &= "OR #optArray[i]#"/>
	            </cfif>
	        </cfloop>
	        <cfset opt &= ")"/>

	        <cfset StructInsert(params, "fq_bft", "#opt#")/>
	        <cfset StructInsert(searchAgentParams, "fq_bft", "#strOpportunity#")/>
	    </cfif>
	</cfif>

    <cfif request.strTitle NEQ "Any Job Title" AND request.strTitle NEQ "">
        <cfset StructInsert(params, 'fq', 'title_syn:("#request.strTitle#")')/>
    </cfif>

    <cfif request.strLocation NEQ "Any Location" AND request.strLocation NEQ "">
        <cfif find(",", request.strLocation,0)>
            <cfset location="">
            <cfset state="">
            <cfset i=1>
            <cfloop list="#request.strLocation#" index="loc">
                <cfif i is 1>
                    <cfset location=loc>
                <cfelse>
                    <cfset state=loc>
                </cfif>
                <cfset i = i+1>
            </cfloop>
            <cfset StructInsert(params, 'fq_stl', 'location:("National" OR "#Trim(location)#") strName:("National" OR "#Trim(state)#")')/>
        <cfelse>
            <cfset StructInsert(params, 'fq_stl', 'location:("National" OR "#request.strLocation#") strName:("National" OR "#request.strLocation#")')/>
        </cfif>
    </cfif>

    <cfif request.strSkills EQ "Any Skills" OR request.strSkills EQ "">
        <cfset StructInsert(params, 'defType', "dismax")/>
        <cfset StructInsert(params, 'qf', "title^10 description jpname^9 location^8 strName strCats")/>
        <cfset StructInsert(params, "Q", "")/>
        <cfset StructInsert(params, "q_alt", "*:*") />
        <cfset strKeyWords = "*:*"/>
    <cfelse>
		<cfset searchTerm = lcase(request.strSkills)>
		<cfset searchTerm = Replace(searchTerm, chr(40), "", "ALL")>
		<cfset searchTerm = Replace(searchTerm, chr(41), "", "ALL")>
        <cfset StructInsert(params, 'defType', "dismax")/>
		<cfset StructInsert(params, "Q", "#request.strSkills#")/>
        <cfset StructInsert(params, 'qf', "title^10 description jpname^9 location^8 strName strCats")/>
		<cfset StructInsert(params, "fq", "title_syn:(#searchTerm#) title_syn:(#searchTerm#~) description_syn:(#searchTerm#)") />
		<cfset StructInsert(params, "q_alt", "*:*") />
        <cfset strKeyWords = "#request.strSkills#"/>
    </cfif>
    <cfset StructInsert(searchAgentParams, "strKeyWords", "#strKeyWords#")/>


	<cfif isdefined('form_q_njp')>
	    <cfset matches=reMatch('\".*?\"',form_q_njp)/>
	    <cfset fquery = "{!tag=njp}nav_jpname:(" />
	    <!---<cfset fquery = "{!tag=njp}nav_jpname:(" /> --->
	    <cfloop from="1" to="#arraylen(matches)#" index="i">
	        <cfif i eq 1>
	            <cfset fquery &= "#matches[i]#"/>
	        <cfelseif i lte arraylen(matches)>
	            <cfset fquery &= " OR #matches[i]#"/>
	        </cfif>
	    </cfloop>

	    <cfset fquery &= ")"/>
	    <cfif StructKeyExists(params, 'fq_njp') >
	        <cfset StructDelete(params, "fq_njp")/>
	    </cfif>
	    <cfset StructInsert(params, "fq_njp", fquery)/>
	<cfelse>
	    <cfset session.exec.fq_njp="">
	</cfif>


	<cfif isdefined('form_q_nsf')>
	    <cfset matches=reMatch('\".*?\"',form_q_nsf)/>

	    <cfset fquery = "nav_strFuncs:(" />
	    <!--- <cfset fquery = "{!tag=nsf}nav_strFuncs:(" /> --->
	    <cfloop from="1" to="#arraylen(matches)#" index="i">
	        <cfif i eq 1>
	            <cfset fquery &= "#matches[i]#"/>
	        <cfelseif i lte arraylen(matches)>
	            <cfset fquery &= " OR #matches[i]#"/>
	        </cfif>
	    </cfloop>
	    <cfset fquery &= ")"/>
	    <cfset StructInsert(params, "fq_nsf", fquery) />
	    <cfset StructInsert(searchAgentParams, "form_q_nsf", form_q_nsf)/>
	<cfelse>
	    <cfset session.exec.fq_nsf="">
	    <cfset StructInsert(searchAgentParams, "form_q_nsf", "")/>
	</cfif>

	<cfif isdefined('form_q_fsd')>
	    <cfset matches=reMatch('\".*?\"',form_q_fsd)/>
	    <!--- <cfset fquery = "{!tag=fsd}fltSalary_desiredLow:(" /> --->
	    <cfset fquery = "fltSalary_desiredLow:(" />
	    <cfloop from="1" to="#arraylen(matches)#" index="i">
	        <cfif i eq 1>
	            <cfset fquery &= "#matches[i]#"/>
	        <cfelseif i lte arraylen(matches)>
	            <cfset fquery &= " OR #matches[i]#"/>
	        </cfif>
	    </cfloop>
	    <cfset fquery &= ")"/>
	    <cfset StructInsert(params, "fq_fsd", fquery) />
	    <cfset StructInsert(searchAgentParams, "form_q_fsd", form_q_fsd)/>
	<cfelse>
	    <cfset session.exec.fq_fsd="">
	    <cfset StructInsert(searchAgentParams, "form_q_fsd", "")/>
	</cfif>

	<cfif isdefined('form_q_nst')>
	    <cfset matches=reMatch('\".*?\"',form_q_nst)/>
	    <!--- <cfset fquery = "{!tag=nst}nav_strNames:(" /> --->
	    <cfset fquery = 'nav_strNames:("National" OR ' />
	    <cfloop from="1" to="#arraylen(matches)#" index="i">
	        <cfif i eq 1>
	            <cfset fquery &= "#matches[i]#"/>
	        <cfelseif i lte arraylen(matches)>
	            <cfset fquery &= " OR #matches[i]#"/>
	        </cfif>
	    </cfloop>
	    <cfset fquery &= ')'/>
	    <cfset StructInsert(params, "fq_nst", fquery) />
	    <cfset StructInsert(searchAgentParams, "form_q_nst", form_q_nst)/>
	<cfelse>
	    <!--- 12/28/2011 Added these two statements to exclude UK jobs if no state/country is selected
		<cfset fquery = '-nav_strNames:("United Kingdom")'/>
		<cfset StructInsert(params, "fq_nst", #fquery#) />--->

		<cfset session.exec.fq_nst="">
	    <cfset StructInsert(searchAgentParams, "form_q_nst", "")/>
	</cfif>

	<cfif isdefined('form_q_nsc')>
	    <cfset matches=reMatch('\".*?\"',form_q_nsc)/>

	    <cfset fquery = "nav_strCats:(" />
	    <!--- <cfset fquery = "{!tag=nsc}nav_strCats:(" />--->
	    <cfloop from="1" to="#arraylen(matches)#" index="i">
	        <cfif i eq 1>
	            <cfset fquery &= "#matches[i]#"/>
	        <cfelseif i lte arraylen(matches)>
	            <cfset fquery &= " OR #matches[i]#"/>
	        </cfif>
	    </cfloop>
	    <cfset fquery &= ")"/>

	    <cfif StructKeyExists(params, 'fq_nsc') >
	        <cfset StructDelete(params, "fq_nsc")/>
	    </cfif>
	    <cfset StructInsert(params, "fq_nsc", fquery)/>
	    <cfset StructInsert(searchAgentParams, "form_q_nsc", form_q_nsc)/>
	<cfelse>
	    <cfset session.exec.fq_nsc="">
	    <cfset StructInsert(searchAgentParams, "form_q_nsc", "")/>
	</cfif>

	<cfif isdefined('form_q_nl')>
	    <cfset matches=reMatch('\".*?\"',form_q_nl)/>
	    <!---   <cfset fquery = "{!tag=nl}nav_location:(" /> --->
	    <cfset fquery = "nav_location:(" />
	    <cfloop from="1" to="#arraylen(matches)#" index="i">
	        <cfif i eq 1>
	            <cfset fquery &= "#matches[i]#"/>
	        <cfelseif i lte arraylen(matches)>
	            <cfset fquery &= " OR #matches[i]#"/>
	        </cfif>
	    </cfloop>
	    <cfset fquery &= ")"/>
	    <cfset StructInsert(params, "fq_nl", fquery) />
	    <cfset StructInsert(searchAgentParams, "form_q_nl", form_q_nl)/>
	<cfelse>
	    <cfset session.exec.fq_nl="">
	    <cfset StructInsert(searchAgentParams, "form_q_nl", "")/>
	</cfif>
	<!--- cfset session.exec.queryParams = StructNew() / ---->
	<cfset session.exec.queryParams= params>
	<cfset session.exec.searchAgentParams = searchAgentParams>

<cfelse>

	<cfif isDefined('session.exec.fq_njp') AND len(session.exec.fq_njp)>
	    <cfset form_q_njp=session.exec.fq_njp>
	</cfif>

	<cfif isDefined('session.exec.fq_njp') AND len(session.exec.fq_njp)>
	    <cfset form_q_njp=session.exec.fq_njp>
	</cfif>

	<cfif isDefined('session.exec.fq_nsc') AND len(session.exec.fq_nsc)>
	    <cfset form_q_nsc=session.exec.fq_nsc>
	</cfif>

	<cfif isDefined('session.exec.fq_nst') AND len(session.exec.fq_nst)>
	    <cfset form_q_nst=session.exec.fq_nst>
	</cfif>

	<cfif isDefined('session.exec.fq_fsd') AND len(session.exec.fq_fsd)>
	    <cfset form_q_fsd=session.exec.fq_fsd>
	</cfif>

	<cfif isDefined('session.exec.fq_nl') AND len(session.exec.fq_nl)>
	    <cfset form_q_nl=session.exec.fq_nl>
	</cfif>

	<cfif isDefined('session.exec.fq_nsf') AND len(session.exec.fq_nsf)>
	    <cfset form_q_nsf=session.exec.fq_nsf>
	</cfif>

	<cfset params = session.exec.queryParams>

	<cfif StructKeyExists(session.exec.searchAgentParams, 'start')>
	    <cfset StructDelete(session.exec.searchAgentParams,'start')>
	    <cfset StructInsert(session.exec.searchAgentParams, 'start', url.start1)>
	</cfif>

	<cfif StructKeyExists(session.exec.searchAgentParams, 'pgNo')>
	 <cfset StructDelete(session.exec.searchAgentParams,'pgNo')>
	<cfset StructInsert(session.exec.searchAgentParams, 'pgNo', url.pgNo)>
	</cfif>

	<cfif StructKeyExists(params, 'start')>
	    <cfset StructDelete(params, 'start')>
	    <cfset StructInsert(params, 'start', url.start1)>
	</cfif>
</cfif>


<cfif isDefined('url.including')>
	<!--- REMOVE FROM PARAMS --->
	<cfif StructKeyExists(session.exec.queryParams, 'exclude')>
	    <cfset in=session.exec.queryParams.exclude>
	    <cfset indexVal=in.indexOf(url.including) +1>

	    <cfif indexVal GT 0>
	        <cfset a = ArrayDeleteAt(in,indexVal)>
	    </cfif>

	    <cfset StructDelete(session.exec.queryParams, 'exclude')>

	    <cfif StructKeyExists(session.exec.queryParams, 'fq_njp_ex')>
	        <cfset StructDelete(session.exec.queryParams, 'fq_njp_ex')>
	    </cfif>

	    <cfif arraylen(in) GT 0>
	        <cfset StructInsert(session.exec.queryParams, 'exclude', in)>
	        <cfset fquery = "{!tag=njp}nav_jpname:(" />
	        <!--- <cfset fquery = "{!tag=njp}nav_jpname:(" /> --->
	        <cfloop from='1' to='#arraylen(in)#' index='xVal'>
	            <cfset fquery &= "-#chr(34)##in[xVal]##chr(34)# "/>
	        </cfloop>
	        <cfset fquery &= ")"/>
	        <cfset StructInsert(session.exec.queryParams, "fq_njp_ex", fquery) />
	    </cfif>
	</cfif>
</cfif>


<cfif isDefined('url.excluding')>
	<cfset exArray = []>
	<cfif StructKeyExists(session.exec.queryParams, 'exclude')>
	    <cfset exArray = session.exec.queryParams.exclude>
	    <cfset indexVal=exArray.indexOf(url.excluding) +1>
	    <cfif indexVal EQ "0">
	        <cfset a = ArrayAppend(exArray, url.excluding)>
	    </cfif>

	    <cfset StructDelete(session.exec.queryParams, 'exclude')>
	    <cfset StructInsert(session.exec.queryParams, 'exclude', exArray)>
	<cfelse>
	    <cfset ArrayAppend(exArray, url.excluding)>
	    <cfset StructInsert(session.exec.queryParams, 'exclude', exArray)>
	</cfif>

	<!--- --->
	<!--- <cfset fquery = "{!tag=njp}nav_jpname:(" /> --->
	<cfset fquery = "{!tag=njp}nav_jpname:(" />
	<cfloop from='1' to='#arraylen(exArray)#' index='xVal'>
	    <cfset fquery &= "-#chr(34)##exArray[xVal]##chr(34)# "/>
	</cfloop>
	<cfset fquery &= ")"/>

	<cfif StructKeyExists(session.exec.queryParams, 'fq_njp_ex')>
	    <cfset StructDelete(session.exec.queryParams, 'fq_njp_ex')>
	</cfif>
	<cfset StructInsert(session.exec.queryParams, "fq_njp_ex", fquery) />
</cfif>

<cfset params.fq_sourceApp = 'sourceApp:("#application.sourceApp#", "Both")' />

<cfset request.solrXML = solr.search(params) />


<cfif NOT isXML(request.solrXML)>
	<div>Search Error..</div>
	<div>Our technical team has been notified of the details of exactly what went wrong.  In the meantime, <br /><a href="#" onclick="history.back(); return false;">click here</a> to go back.</div>

	<!--->
	<cfmail to="#application.errorEmails#"
							from="#application.defaultEmail#"
							subject="CFERROR: [#application.machine#] [#cgi.server_name#] #application.sourecApp#"
							type="html">
		Connection to SOLR returning invalid XML.<br><br>
		jobs/t_solrQuery.cfm<br><br>

		<cfdump var="#request.solrXML#">
	</cfmail>
	--->

	<cfabort>
</cfif>


<cfset result = XmlParse(request.solrXML) />
<cfset results=xmlSearch(result,"/response/result") />

<!---
<cfdump var="#params#">
<cfdump var="#results#">
<cfabort>
--->


<cfparam name="numFound" default="0"/>
<cfif arrayLen(results) GT 0>
    <cfset nav=xmlSearch(result,"/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst") />
    <cfset hl=xmlSearch(result, "/response/lst[@name='highlighting']") />
    <cfset start="#results[1].XmlAttributes['start']#" />
    <cfset numFound="results[1].XmlAttributes['numFound']"/>
    <cfset next=(start + jobsPerPage)/>
<cfelse>
    <cfset nav=[]/>
    <cfset hl=[]/>
    <cfset start="0"/>
    <cfset next="0"/>
</cfif>