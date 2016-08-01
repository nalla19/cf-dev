<!---ExecEditProfileVariables.cfm--->
<cfparam name="strCity" default="">
<cfparam name="strFName" default="">
<cfparam name="strLName" default="">
<cfparam name="strEmail" default="">
<cfparam name="strHomePhone" default="">
<cfparam name="strMobilePhone" default="">
<cfparam name="strState" default="">
<cfparam name="execLocation" default="">
<cfparam name="resumeFile" default="">
<cfparam name="blnSignUpForAAA" default="">
<cfparam name="resumeTitle" default="">
<cfparam name="intPrivacySetting" default="">

<cfparam name="strExecJobTitle_1" default="">
<cfparam name="strExecJobTitle_2" default="">
<cfparam name="strExecJOBCompany_1" default="">
<cfparam name="strExecJOBCompany_2" default="">
<cfparam name="strDesiredJobTitle" default="">
<cfparam name="fltCompensation_package" default="">
<cfparam name="memoSalary_requirement" default="
Examples:
My current base salary is $135K; annual bonus 15% of base.
I'm looking for a minimum of $145K. Salary is negotiable.
Currently out of work, but was making $150K." />
              
<cfparam name="intsIndIDs" default="">
<cfparam name="intsFuncIDs" default="">
<cfparam name="intYrsExp" default="">
<cfparam name="strHighestDegree1" default="">
<cfparam name="strHighestDegree2" default="">
<cfparam name="strHighestDegree3" default="">
<cfparam name="strHighestDegree4" default="">
<cfparam name="strHighestDegree5" default="">

<cfparam name="blnInHouseEmail" default="">
<cfparam name="blnNewsLetter" default="">
<cfparam name="blnEmail" default="">
<cfparam name="blnSpecialOffer" default="">

<cfparam name="blnEvents" default="">
<cfparam name="strSchool" default="">
<cfparam name="strSchool1" default="">
<cfparam name="strSchool2" default="">
<cfparam name="strSchool3" default="">
<cfparam name="strSchool4" default="">
<cfparam name="strSchool5" default="">


<cfscript>
myWebSitesObj = createObject('component', 'v16fj.execs.resbuilder.components.myWebSites');

//Get Website Categories
cfqGetWebSiteCategories = myWebSitesObj.getWebsiteCategories();


//Get the decrypted intResID
registrationObj = createObject('component', 'v16fj.join.components.registration').init(dsn = application.dsn);
resDetails = registrationObj.getResDetails(session.exec.intResID);
</cfscript>
    
<cfset strFName=resDetails.fname>
<cfset strLName=resDetails.lname>
<cfset strEmail=resDetails.email>

<!---Parsing variables--->
<cfparam name="url.message" default="" />
<cfscript>
// Assume Parsing Is OK --->
inValidParse = 1;
//uploadedPath = application.sixfj.paths.webroot & "exports\";
uploadedPath = "C:\webroot\6figurejobs\exports\";
</cfscript>

<!---Create the resume upload directory if it does not exist already--->
<cfif not(directoryExists(uploadedPath))>
    <cfdirectory directory="#uploadedPath#" action="create" />
</cfif>

<!------------------------------------------------------------------------------------------------------------------------------------------------------->
<cfif len(session.exec.intResID)>
    <cfquery name="cfqGetResDetails" datasource="#application.dsn#">
    select * from tblResumes (nolock) where intResID = #session.exec.intResID#
    </cfquery>
    
    <cfset strCity = cfqGetResDetails.city>
    <cfset strState = cfqGetResDetails.state>
    <cfset execLocation = cfqGetResDetails.zip>
    
    <cfset strUsername = cfqGetResDetails.username>
    <cfset strPasswd = cfqGetResDetails.Password>
    
    <cfset strHomePhone = cfqGetResDetails.home_phone>
    <cfset strMobilePhone = cfqGetResDetails.mobile_phone>
    
    <cfset blnRelocate = cfqGetResDetails.relocate>
    
    <cfset relocPreference = cfqGetResDetails.location_preference>
    <cfset strRelocPref = "">
    <cfif len(relocPreference)>
    	<cfquery name="cfqGetStates" datasource="#application.dsn#">
        select strShortName from tblStates (nolock) where 1=1 and intOldID in (#relocPreference#)
        </cfquery>
        <cfset strRelocPref = valueList(cfqGetStates.strShortName)>
    </cfif>
    
    <cfquery name="cfqCheckAAA" datasource="#application.dsn#">
    select * from tblAAABatch (nolock) where intResID = #session.exec.intResID#
    </cfquery>
    <cfif cfqCheckAAA.recordcount gt 0>
        <cfset blnSignUpForAAA = 1>
    </cfif>
    
    <cfquery name="cfqResProfiles" datasource="#application.dsn#">
    select * from tblResumeProfiles (nolock) where fk_intResID = #session.exec.intResID#
    </cfquery>
    <cfset resumeTitle = cfqResProfiles.title>
    
    <cfset intPrivacySetting = cfqGetResDetails.intPostRecepient>
    
    <cfset strExecJobTitle_1 = cfqGetResDetails.strExecJobTitle_1>
    <cfset strExecJobTitle_2 = cfqGetResDetails.strExecJobTitle_2>
    <cfset strExecJOBCompany_1 = cfqGetResDetails.strExecJobCompany_1>
    <cfset strExecJOBCompany_2 = cfqGetResDetails.strExecJobCompany_2>
    <cfset strDesiredJobTitle = cfqGetResDetails.strDesiredJobTitle>
    <cfset fltCompensation_package = cfqGetResDetails.fltCompensation_package>
    
    
    <cfif len(cfqGetResDetails.memoSalary_requirement) gt 0>
        <cfset memoSalary_requirement = cfqGetResDetails.memoSalary_requirement>
    <cfelse>
<cfset memoSalary_requirement = "
Examples:
My current base salary is $135K; annual bonus 15% of base.
I'm looking for a minimum of $145K. Salary is negotiable.
Currently out of work, but was making $150K." />   	
    </cfif>
    
    
    
    <cfquery name="cfqGetInds" datasource="#application.dsn#">
    select intAttID
      from tblResAtt (nolock)
     where 1=1
       and intResID = #session.exec.intResID#
       and intAttID in (select intOldIndID from tblIndustries (nolock))
    </cfquery>
    <cfset intsIndIDs = valuelist(cfqGetInds.intAttID)>
    
    <cfquery name="cfqGetFuncs" datasource="#application.dsn#">
    select intAttID
      from tblResAtt (nolock)
     where 1=1
       and intResID = #session.exec.intResID#
       and intAttID in (select intOldFunctionID from tblFunctions (nolock))
    </cfquery>
    <cfset intsFuncIDs = valuelist(cfqGetFuncs.intAttID)>
    
    
    <cfif cfqGetResDetails.intYearsExperience gt 0>
        <cfset intYrsExp = cfqGetResDetails.intYearsExperience>
    </cfif>
    
    
    <cfset blnEvents = cfqGetResDetails.blnEvents>
	
	<cfif len(cfqGetResDetails.blnInHouseEmail)>
		<cfset blnInHouseEmail = cfqGetResDetails.blnInHouseEmail>
	<cfelse>
		<cfset blnInHouseEmail = 1>
	</cfif>
	
	<cfset blnNewsLetter = cfqGetResDetails.blnNewsLetter>
	
	<cfif len(cfqGetResDetails.blnEmail)>
		<cfset blnEmail = cfqGetResDetails.blnEmail>
	<cfelse>
		<cfset blnEmail = 0>
	</cfif>
	
	<cfset blnSpecialOffer = cfqGetResDetails.blnSpecialOffer>
	
    
    <!---Education--->
    <cfquery name="cfqGetDegreeCollege" datasource="#application.dsn#">
    select * from tblResDegreeUniversity (nolock) where intResID = #session.exec.intResID#
    </cfquery>
	<cfset resDegreeCount = cfqGetDegreeCollege.recordcount>
    
    <cfset strHighestDegree1 = "">
    <cfset strSchool1 = "">

    <cfset strHighestDegree2 = "">
    <cfset strSchool2 = "">

    <cfset strHighestDegree3 = "">
    <cfset strSchool3 = "">

    <cfset strHighestDegree4 = "">
    <cfset strSchool4 = "">

    <cfset strHighestDegree5 = "">
    <cfset strSchool5 = "">
    
    <cfset i=1>
    <cfloop query="cfqGetDegreeCollege" startrow="1" endrow="#cfqGetDegreeCollege.recordcount#">
    	<cfif i is 1>
	        <cfset strHighestDegree1 = cfqGetDegreeCollege.strDegree>
            <cfset strSchool1 = cfqGetDegreeCollege.strUnivCollegeName>
        </cfif>
        
        <cfif i is 2>
	        <cfset strHighestDegree2 = cfqGetDegreeCollege.strDegree>
            <cfset strSchool2 = cfqGetDegreeCollege.strUnivCollegeName>
        </cfif>
        
        <cfif i is 3>
	        <cfset strHighestDegree3 = cfqGetDegreeCollege.strDegree>
            <cfset strSchool3 = cfqGetDegreeCollege.strUnivCollegeName>
        </cfif>
        
        <cfif i is 4>
	        <cfset strHighestDegree4 = cfqGetDegreeCollege.strDegree>
            <cfset strSchool4 = cfqGetDegreeCollege.strUnivCollegeName>
        </cfif>
        
        <cfif i is 5>
	        <cfset strHighestDegree5 = cfqGetDegreeCollege.strDegree>
            <cfset strSchool5 = cfqGetDegreeCollege.strUnivCollegeName>
        </cfif>
        <cfset i=i+1>
    </cfloop>
    
    
    <!---Website Profiles --->
    <cfquery name="cfqGetResWebsites" datasource="#application.dsn#">
    select * from tblResumesWebSites (nolock) where intresid = #session.exec.intResID# order by dteCreated asc
    </cfquery>
    <cfset webSiteProfilesCount = cfqGetResWebsites.recordcount>
    
    <cfset resumeWebSitesCategory1 = "">
	<cfset resumeWebSiteName1 = "">
    <cfset resumeWebSiteURL1 = "">
    
    <cfset resumeWebSitesCategory2 = "">
	<cfset resumeWebSiteName2 = "">
    <cfset resumeWebSiteURL2 = "">
    
    <cfset resumeWebSitesCategory3 = "">
	<cfset resumeWebSiteName3 = "">
    <cfset resumeWebSiteURL3 = "">
    
    <cfset resumeWebSitesCategory4 = "">
	<cfset resumeWebSiteName4 = "">
    <cfset resumeWebSiteURL4 = "">
    
    <cfset resumeWebSitesCategory5 = "">
	<cfset resumeWebSiteName5 = "">
    <cfset resumeWebSiteURL5 = "">
    
    <cfset i=1>
    <cfloop query="cfqGetResWebsites" startrow="1" endrow="#cfqGetResWebsites.recordcount#">
    	<cfif i is 1>
	        <cfset resumeWebSitesCategory1 = cfqGetResWebsites.intWebSiteCategoryID>
            <cfset resumeWebSiteName1 = cfqGetResWebsites.strResumeWebSiteName>
            <cfset resumeWebSiteURL1 = cfqGetResWebsites.strResumeWebSiteURL>
        </cfif>
        
        <cfif i is 2>
	        <cfset resumeWebSitesCategory2 = cfqGetResWebsites.intWebSiteCategoryID>
            <cfset resumeWebSiteName2 = cfqGetResWebsites.strResumeWebSiteName>
            <cfset resumeWebSiteURL2 = cfqGetResWebsites.strResumeWebSiteURL>
        </cfif>
        
        <cfif i is 3>
	        <cfset resumeWebSitesCategory3 = cfqGetResWebsites.intWebSiteCategoryID>
            <cfset resumeWebSiteName3 = cfqGetResWebsites.strResumeWebSiteName>
            <cfset resumeWebSiteURL3 = cfqGetResWebsites.strResumeWebSiteURL>
        </cfif>
        
        <cfif i is 4>
	        <cfset resumeWebSitesCategory4 = cfqGetResWebsites.intWebSiteCategoryID>
            <cfset resumeWebSiteName4 = cfqGetResWebsites.strResumeWebSiteName>
            <cfset resumeWebSiteURL4 = cfqGetResWebsites.strResumeWebSiteURL>
        </cfif>
        
        <cfif i is 5>
	        <cfset resumeWebSitesCategory5 = cfqGetResWebsites.intWebSiteCategoryID>
            <cfset resumeWebSiteName5 = cfqGetResWebsites.strResumeWebSiteName>
            <cfset resumeWebSiteURL5 = cfqGetResWebsites.strResumeWebSiteURL>
        </cfif>
               
    	<cfset i=i+1>
    </cfloop>
    
</cfif>
<!------------------------------------------------------------------------------------------------------------------------------------------------------->