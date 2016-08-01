<cfset strTitle=URLDecode(strTitle)>
<cfparam name="queryString" default="">
<cfparam name="sa_attr" default="">
<cfparam name="sa_form_q_fsd" default="">
<cfparam name="sa_form_q_nl" default="">
<cfparam name="sa_form_q_nsc" default="">
<cfparam name="sa_form_q_nsf" default="">
<cfparam name="sa_form_q_nst" default="">
<cfparam name="sa_jobTitleSearch" default="0">
<cfparam name="sa_strKeyWords" default="Any Skills">
<cfparam name="sa_strSkills" default="Any Skills">
<cfparam name="sa_strTitle" default="Any Job Title">

<cfparam name="srchTitle1" default="Any Job Title">
<cfparam name="srchSkills1" default="Any Skills">
<cfparam name="srchLocation1" default="Any Location">
<cfparam name="srchSkills2" default="Any Skills">
<cfparam name="srchLocation2" default="Any Location">

<cfoutput>
<!--- INCLUDE FILE: alertGet.cfm --->
<cfinclude template="alertGet.cfm">

<cfset sa_attr = cfqAgent.strAtts>              
<cfif len(sa_attr) gt 0>
	
    <cfset sa_attr = replace(sa_attr, ",,", ",", "ALL")>
    <cfset sa_attr = replace(sa_attr, ", ,", ", ", "ALL")>
   
	<cfquery name="cfqGetIndustries" datasource="#application.dsn#">
	select '"' + strIndName + '"' strIndName from tblIndustries (nolock) where intOldIndID in (#sa_attr#)
	</cfquery>
	<cfif cfqGetIndustries.recordcount gt 0>
		<cfset sa_form_q_nsc = valuelist(cfqGetIndustries.strIndName)>
	</cfif>
	
	<cfquery name="cfqGetFunctions" datasource="#application.dsn#">
	select '"' + strFunctionName + '"' strFunctionName from tblFunctions (nolock) where intOldFunctionID in (#sa_attr#)
	</cfquery>
	<cfif cfqGetFunctions.recordcount gt 0>
		<cfset sa_form_q_nsf = valuelist(cfqGetFunctions.strFunctionName)>
	</cfif>
	
	<cfquery name="cfqGetStates" datasource="#application.dsn#">
	select '"' + strName + '"' strName from tblStates (nolock) where intOldID in (#sa_attr#)
	</cfquery>
	<cfif cfqGetStates.recordcount gt 0>
		<cfset sa_form_q_nst = valuelist(cfqGetStates.strName)>
	</cfif>			                
</cfif>

<cfset sa_form_q_fsd = cfqAgent.strSalary>
<cfif listlen(sa_form_q_fsd)  is 1>
	<cfset sa_form_q_fsd = '"#sa_form_q_fsd#"' >
<cfelseif listlen(sa_form_q_fsd) gt 1>
	<cfset sa_form_q_fsd = replace(sa_form_q_fsd, ',' , '","', "ALL")>
	<cfset sa_form_q_fsd = '"' & sa_form_q_fsd & '"'>
</cfif>


<cfset sa_form_q_nl = cfqAgent.strLocation>
<cfset sa_jobTitleSearch = cfqAgent.intJobTitleSearch>
<cfset sa_strKeyWords = cfqAgent.strKeyWords>
<cfset sa_strSkills = cfqAgent.strSkills>
<cfset sa_strTitle = cfqAgent.strJobTitle>

<cfif isDefined("sa_jobTitleSearch") and sa_jobTitleSearch is 1>
	<cfif isDefined("sa_strTitle") and sa_strTitle neq "">
		<cfset srchTitle1 = sa_strTitle>
	</cfif>
	
	<cfif isDefined("sa_strSkills") and sa_strSkills neq "">
		<cfset srchSkills1 = sa_strSkills>
	</cfif>
	
	<cfif isDefined("sa_form_q_nl") and sa_form_q_nl neq "">
		<cfset srchLocation1 = sa_form_q_nl>
	</cfif>
<cfelseif isDefined("sa_jobTitleSearch") and sa_jobTitleSearch is 0>    
	<cfif isDefined("sa_strSkills") and sa_strSkills neq "">
		<cfset srchSkills2 = sa_strSkills>
	</cfif>
	
	<cfif isDefined("sa_form_q_nl") and sa_form_q_nl neq "">
		<cfset srchLocation2 = sa_form_q_nl>
	</cfif>
<cfelseif isDefined("sa_jobTitleSearch") and sa_jobTitleSearch is "">
	<cfset sa_jobTitleSearch = 0>
    <cfif sa_strKeyWords neq "">
		<!--- <cf_ct_removeQuotes strStrip="#sa_strKeyWords#" blnRemove="0"> --->
		<cfset strstrip = application.util.getRemoveQuotes(strStrip="#sa_strKeyWords#",  blnRemove="0")>
		<cfset srchSkills2 = strStrip>
    <cfelse>
    	<cfset srchSkills2 = "Any Skills">
    </cfif>
    
    <cfif isDefined("sa_form_q_nl") and sa_form_q_nl neq "">
		<cfset srchLocation2 = sa_form_q_nl>
	</cfif>
</cfif>

<cfset queryString = "">
<!---JobTitleSearch--->
<cfset queryString = queryString & "jobTitleSearch=#sa_jobTitleSearch#">
<!---6FJ search--->
<cfset queryString = queryString & "&sixfj=1">

<!---If Job Title Search--->
<cfif sa_jobTitleSearch>
	<!---Job Title--->
	<cfset queryString = queryString & "&strTitle=#srchTitle1#">
    <!---Skills--->
	<cfset queryString = queryString & "&strSkills=#srchSkills1#">
    <!---Location--->
	<cfset queryString = queryString & "&strLocation=#srchLocation1#">
<!---If Standard Keyword search--->
<cfelse>
	<!---Skills--->
	<cfset queryString = queryString & "&strSkills=#srchSkills2#">
    <!---Location--->
	<cfset queryString = queryString & "&strLocation=#srchLocation2#">
</cfif>

<!---Advanced search parameter--->
<cfset queryString = queryString & "&advancedSearch=1">

<!---Industries--->
<cfif listlen(sa_form_q_nsc) gt "0">
	<cfloop list="#sa_form_q_nsc#" index="indName">
    	<cfset queryString = queryString & "&form_q_nsc=#indName#">
    </cfloop>
<cfelse>
	<cfset queryString = queryString & "&allIndustries=allIndustries">
</cfif>

<!---Functions--->
<cfif listlen(sa_form_q_nsf) gt "0">
	<cfloop list="#sa_form_q_nsf#" index="funcName">
    	<cfset queryString = queryString & "&form_q_nsf=#funcName#">
    </cfloop>
<cfelse>
	<cfset queryString = queryString & "&allFunctions=allFunctions">
</cfif>

<!---Functions--->
<cfif listlen(sa_form_q_nsf) gt "0">
	<cfloop list="#sa_form_q_nsf#" index="funcName">
    	<cfset queryString = queryString & "&form_q_nsf=#funcName#">
    </cfloop>
<cfelse>
	<cfset queryString = queryString & "&allFunctions=allFunctions">
</cfif>

<!---State--->
<cfif listlen(sa_form_q_nst) lte 1 and sa_form_q_nst eq '"All Locations"'>
	<cfset queryString = queryString & "&allState=allState">
<cfelse>
	<cfloop list="#sa_form_q_nst#" index="stateName">
    	<cfset queryString = queryString & "&form_q_nst=#stateName#">
    </cfloop>
</cfif>

<!---Salary--->
<cfif listlen(sa_form_q_fsd) gt "0">
	<cfloop list="#sa_form_q_fsd#" index="salary">
    	<cfset queryString = queryString & "&sa_form_q_fsd=#salary#">
    </cfloop>
<cfelse>
	<cfset queryString = queryString & "&allSalaries=allSalaries">
</cfif>

<!---Just to indicate that we are coming from the link to Run the Search Agent--->
<cfset queryString = queryString & "&saAgent=Run">

<!--- queryString=#queryString# --->

<cflocation url="/search?#queryString#" addtoken="no">

</cfoutput>

<cfabort>
<!---
<cfoutput>
 <cfset blnForm=1> 
<table cellpadding="0" cellspacing="0" width="100%">
	<tr>	
    	<td>
 			<cfinclude template="t_execSearchJobsList.cfm">
		</td>
   	</tr>
</table>
</cfoutput>--->

