<cfoutput>

<!---// US State Names List --->
<cfquery name="cfqGetStates" datasource="#application.dsn#">
select strName from tblStates (nolock) where strCountry = 'US'
</cfquery>
<cfset usStateNameList = valuelist(cfqGetStates.strName)>
<!---// US State Names List --->

<!---Get the details for the account --->
<cfif isdefined("intresid") and len(intresid)> 
	<cfstoredproc procedure="sp_exec_stepone_new" datasource="#application.dsn#" returncode="Yes">
    	<cfprocparam type="IN" variable="@intProcType" value="1" cfsqltype="CF_SQL_INTEGER">
    	<cfprocparam type="IN" variable="@intResID" value="#intresid#" cfsqltype="CF_SQL_INTEGER">
    	<cfprocresult resultset="1" name="qgetAccountInfo">
  	</cfstoredproc>
    <!--- Set the state for now and set any other required variables later --->
	<cfset state = qgetAccountInfo.state>
</cfif>

<!---
state=#state#<br />
intCPLListNeedAnswering1=#intCPLListNeedAnswering#<br />
--->

<!--- Allstate - Texas CPL, 109 --->
<cfif  state neq "Texas" and listfind(intCPLListNeedAnswering, 109)>
	<!--- Remove the Allstate from the list of CPL's that need answering if the candidates state is not Texas --->
	<cfset allstateTXPos = listfind(intCPLListNeedAnswering, 109, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, allstateTXPos, ",")>
    
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (109, 0, #intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
</cfif>

<!--- Allstate - Ohio :CPL 110 --->
<cfif state neq "Ohio" and listfind(intCPLListNeedAnswering, 110)>
	<!--- Remove the Allstate from the list of CPL's that need answering if the candidates state is not Ohio --->
	<cfset allstateOHPos = listfind(intCPLListNeedAnswering, 110, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, allstateOHPos, ",")>
    
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (110, 0, #intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
</cfif>

<!--- Allstate - Michigan :CPL 111 --->
<cfif state neq "Michigan" and listfind(intCPLListNeedAnswering, 111)>
	<!--- Remove the Allstate from the list of CPL's that need answering if the candidates state is not Michigan --->
	<cfset allstateMIPos = listfind(intCPLListNeedAnswering, 111, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, allstateMIPos, ",")>
    
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (111, 0, #session.exec.intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
</cfif>

<!--- Allstate - Indiana :CPL 112 --->
<cfif state neq "Indiana" and listfind(intCPLListNeedAnswering, 112)>
	<!--- Remove the Allstate from the list of CPL's that need answering if the candidates state is not Indiana --->
	<cfset allstateINPos = listfind(intCPLListNeedAnswering, 112, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, allstateINPos, ",")>
    
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (112, 0, #intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
</cfif>

<!--- Allstate - AR, LA, MS  :CPL 113 --->
<cfif (state neq "Arkansas" and state neq "Louisiana" and state neq "Mississippi") and listfind(intCPLListNeedAnswering, 113)>
	<!--- Remove the Allstate from the list of CPL's that need answering if the candidates state is not AR, LA, MS --->
	<cfset allstateARLAMSPos = listfind(intCPLListNeedAnswering, 113, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, allstateARLAMSPos, ",")>
    
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (113, 0, #intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
</cfif>

<!--- Allstate - TN, KY  :CPL 114 --->
<cfif (state neq "Tennessee" and state neq "Kentucky") and listfind(intCPLListNeedAnswering, 114)>
	<!--- Remove the Allstate from the list of CPL's that need answering if the candidates state is not TN, KY --->
	<cfset allstateTNKYSPos = listfind(intCPLListNeedAnswering, 114, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, allstateTNKYSPos, ",")>
    
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (114, 0, #intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
</cfif>

<!--- Allstate - IL, WI, MN :CPL 119 --->
<cfif (state neq "Illinois" and state neq "Wisconsin" and state neq "Minnesota") and listfind(intCPLListNeedAnswering, 119)>
	<!--- Remove the Allstate from the list of CPL's that need answering if the candidates state is not IL, WI, MN --->
	<cfset allstateILWIMNPos = listfind(intCPLListNeedAnswering, 119, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, allstateILWIMNPos, ",")>
    
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (119, 0, #intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
</cfif>

<!--- UBS Financial - VA, MD, Washington-DC, NJ, DE, PA :CPL 116 --->
<cfif (state neq "Virginia" and state neq "Maryland" and state neq "District of Columbia" and state neq "New Jersey" and state neq "Delaware" and state neq "Pennsylvania") and listfind(intCPLListNeedAnswering, 116)>
	<!--- Remove the Allstate from the list of CPL's that need answering if the candidates state is not  VA, MD, Washington-DC, NJ, DE, PA--->
	<cfset ubsVAMBDCNJDEPAPos = listfind(intCPLListNeedAnswering, 116, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, ubsVAMBDCNJDEPAPos, ",")>
    
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (116, 0, #intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
</cfif>

<!--- The Junkluggers -  PA, NJ, MA :CPL 146 --->
<cfif (state neq "Pennsylvania" and state neq "New Jersey" and state neq "Massachusetts" ) and listfind(intCPLListNeedAnswering, 146)>
	<!--- Remove the The Junkluggers from the list of CPL's that need answering if the candidates state is not PA, NJ, MA--->
	<cfset junkJugglersPANJMAPos = listfind(intCPLListNeedAnswering, 146, ",")>
	<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, junkJugglersPANJMAPos, ",")>
    
	<!---
    <!---Insert the lead as if it is opted out--->
    <cfquery name="cfqInsLead" datasource="#application.dsn#">
	insert into tblCPLLeadInfo(intMemberID, intTargetID, intResID, strEmail, strFName, strLName, strAddress, strCity, strState, strCntry, strZip, strHowFind, dteSubmitted, blnProcessed, blnInternational, blnDelete, intTargetLocation, blnOptedOut, ipaddress) 
                       values (146, 0, #intresid#, '#qgetAccountInfo.email#', '#qgetAccountInfo.fname#', '#qgetAccountInfo.lname#', '#qgetAccountInfo.address#','#qgetAccountInfo.city#', '#qgetAccountInfo.state#', 'US', '#qgetAccountInfo.zip#', '6FigureJobs.com', '#dateformat(now(),'yyyy-mm-dd hh:mm:ss')#', 0, 0, 1, 0, 1, '#cgi.remote_addr#')
    </cfquery>
	--->
</cfif>

<!--- //FranchisePathways - Exclude if not US :CPL 130--->
<cfif ListFind(intCPLListNeedAnswering, 130)>
	<!--- //FranchisePathways - Exclude if not US :CPL 130--->
	<cfif ListFind(usStateNameList, state)>
		<!--- Candidate is from one of the US States --->
	<cfelse>
		<!--- Remove the Franchise Pathways CPL from the list and do not present it to the candidate --->
	    <cfset franchisePathwaysPos = listfind(intCPLListNeedAnswering, 130, ",")>
	    <cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, franchisePathwaysPos, ",")>
	</cfif>
</cfif>
<!--- //FranchisePathways - Exclude if not US :CPL 130--->

<!------------------------------------------------------------------------------------------------------------------------------->
<!---//Custom Coding for the MSU CPL (136) and (140) Get the Highest Degree of Eduction and the Number of Years of Experience --->
<!------------------------------------------------------------------------------------------------------------------------------->
<!---
1. Juris Doctorate
2. Doctorate
3. Masters
4. BS/BA
5. Associates Degree
6. Some College
7. High School/GED
--->
<cfset showMSUCPL = 0>
<cfset acceptedLOE = "Juris Doctorate,Doctorate,Masters,BS/BA,Associates Degree">

<cfquery name="cfqGetEdu" datasource="#application.dsn#">
select * from dbo.tblResDegreeUniversity (nolock)  where intResid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#intResID#" />
</cfquery>

<cfset strHighest_Degree="">

<cfif cfqGetEdu.Recordcount gt 0>
	<!---If there is only one degree make that as the Education Level --->
	<cfif cfqGetEdu.Recordcount is 1>
		<cfset strHighest_Degree = cfqGetEdu.strDegree>
	<!---If there is more than one Record check for each degree and assign the highest level--->
	<cfelse>
		<cfset DegreeValueList = valueList(cfqGetEdu.strDegree, ",")>
		
		<cfif ListFind(DegreeValueList, "Juris Doctorate")>
			<cfset strHighest_Degree = "Juris Doctorate">
		<cfelseif ListFind(DegreeValueList, "Doctorate")>
			<cfset strHighest_Degree = "Doctorate">
		<cfelseif ListFind(DegreeValueList, "Masters")>
			<cfset strHighest_Degree = "Masters">
		<cfelseif ListFind(DegreeValueList, "BS/BA")>
			<cfset strHighest_Degree = "BS/BA">
		<cfelseif ListFind(DegreeValueList, "Associates Degree")>
			<cfset strHighest_Degree = "Associates Degree">
		<cfelseif ListFind(DegreeValueList, "Some College")>
			<cfset strHighest_Degree = "Some College">
		<cfelseif ListFind(DegreeValueList, "High School/GED")>
			<cfset strHighest_Degree = "High School/GED">
		</cfif>
		
	</cfif>
<cfelse>
	<cfset strHighest_Degree = "N/A">
</cfif>
<cfset strHighestDegree=strHighest_Degree>

<cfset intMaxYearsExperience = 0>
<cfquery name="cfqGetExp" datasource="#application.dsn#">
select intYearsExperience from tblResumes (nolock) where intresid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#intResID#" />
</cfquery>
<cfset intMaxYearsExperience = cfqGetExp.intYearsExperience>

<cfif ListFind(acceptedLOE, strHighest_Degree) and intMaxYearsExperience gte 3>
	<cfset showMSUCPL = 1>
</cfif>

<cfif showMSUCPL is 0>

	<cfif ListFind(intCPLListNeedAnswering, 136)>
    	<cfset MSUPos = listfind(intCPLListNeedAnswering, 136, ",")>
		<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, MSUPos, ",")>
    </cfif>
	
	<cfif ListFind(intCPLListNeedAnswering, 140)>
    	<cfset MSUPos2 = listfind(intCPLListNeedAnswering, 140, ",")>
		<cfset intCPLListNeedAnswering = listdeleteat(intCPLListNeedAnswering, MSUPos2, ",")>
    </cfif>
	
</cfif>
<!------------------------------------------------------------------------------------------------------------------------------->
<!---//Custom Coding for the MSU CPL (136) and (140) Get the Highest Degree of Eduction and the Number of Years of Experience --->
<!------------------------------------------------------------------------------------------------------------------------------->

</cfoutput>