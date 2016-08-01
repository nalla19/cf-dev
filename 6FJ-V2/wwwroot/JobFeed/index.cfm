<cfprocessingdirective suppresswhitespace="yes">
<!--- BE SURE TO USE JPNAME COLUMN FROM TBLJOBS FOR COMPANY NAME IN CASE OF CONFIDENTIAL JOB POSTINGS!!!!!! --->
<cfparam name="employerExcludeList" default="">
<cfparam name="tkcd" default="">
<cfset tkcd=url.tkcd>

<cfif len(tkcd)>
	<!---Exclude the Staples Jobs from the JobDotCom Feed 11/09/2010--->
    <cfquery name="cfqGetStaplesIds" datasource="#application.dsn#">
    select intEmployerID from tblEmployers (nolock) where strcompany like '%Staples%'
    </cfquery>
    
    <cfif cfqGetStaplesIds.recordcount gt 0>
        <cfif len(employerExcludeList)>
            <cfset employerExcludeList = employerExcludeList & "," & valueList(cfqGetStaplesIds.intEmployerID)>
        <cfelse>
            <cfset employerExcludeList = valueList(cfqGetStaplesIds.intEmployerID)>
        </cfif>
    </cfif>
    
    
    <cfquery name="cfqGetHeidrickIDs" datasource="#application.dsn#">
    select intEmployerID from tblEmployers (nolock) where strcompany like '%Heidrick%'
    </cfquery>
    
    <cfif cfqGetHeidrickIDs.recordcount gt 0>
        <cfif len(employerExcludeList)>
            <cfset employerExcludeList = employerExcludeList & "," & valueList(cfqGetHeidrickIDs.intEmployerID)>
        <cfelse>
            <cfset employerExcludeList = valueList(cfqGetHeidrickIDs.intEmployerID)>
        </cfif>
    </cfif>
    
    <cfif len(employerExcludeList)>
        <cfset employerExcludeList = employerExcludeList  & ",17963,15640,17802,16692,6004,2467,18788,19118,19033,20593">
    <cfelse>
        <cfset employerExcludeList = "17963,15640,17802,16692,6004,2467,18788,19118,19033,20593">
    </cfif>
        
	<cfquery datasource="#application.dsn#" name="getJobPostings">
    select a.intJobID,a.title,a.date_Submitted,a.strJobURL,a.blnshowJobUrl,a.jpname,b.strcompany,c.strcountry,
    	   c.strname as state,a.state as stateID, a.location,a.description,a.seoJobURL
      from tblJobs a (nolock), tblemployers b (nolock), tblstates c (nolock)
     where 1=1
       and a.intEmployerID=b.intemployerID
       and a.state=c.intoldid
       and a.blnValidated=1
       and a.blnactive=1
       and lower(a.jpname) != 'confidential'
       and b.intemployerID not in (#employerExcludeList#)
       and (a.state=c.intoldid and c.strCountry = 'US')
       <cfif application.machine EQ "DEV" OR application.machine EQ "UAT" OR application.machine EQ "LOCAL">
       and a.date_Submitted > getDate()-730
       <cfelse>
       and a.date_Submitted > getDate()-30
       </cfif>
	   and b.dteAcctExp > getdate()
	   and a.sourceApp = '6FigureJobs'
    </cfquery>
	<!---
	select a.intJobID,a.title,a.date_Submitted,a.strJobURL,a.blnshowJobUrl,a.jpname,b.strcompany,c.strcountry,
    	   c.strname as state,a.state as stateID, a.location,a.description,a.seoJobURL
      from tblJobs a (nolock), tblemployers b (nolock), tblstates c (nolock)
     where 1=1
       and a.intEmployerID=b.intemployerID
       and a.state=c.intoldid
       and a.blnValidated=1
       and a.blnactive=1
       and lower(a.jpname) != 'confidential'
       and b.intemployerID not in (<Cfoutput>#employerExcludeList#</Cfoutput>)
       and (a.state=c.intoldid and c.strCountry = 'US')
       <cfif application.machine EQ "DEV" OR application.machine EQ "LOCAL">
       and a.date_Submitted > getDate()-730
       <cfelse>
       and a.date_Submitted > getDate()-30
       </cfif>
	   and b.dteAcctExp > getdate()
	   and a.sourceApp = '6FigureJobs'
	<cfabort>
	--->
	    
    <!--- Get Offset for Greenwich Mean Time --->
    <cfset info=GetTimeZoneInfo()>
    <cfset GMT=DateAdd("h",info.utcHourOffset,now())>
    
	<cfset request.url="#application.url#">
	
    <?xml version="1.0" encoding="utf-8"?>
    <source>
        <publisher>6FigureJobs</publisher>
        <publisherurl><cfoutput>#request.url#</cfoutput></publisherurl>
        <cfoutput><lastBuildDate>#DateFormat(GMT,'ddd, dd mmm yyyy')# #TimeFormat(GMT,'HH:mm:ss')# GMT</lastBuildDate> </cfoutput>
        <cfoutput query="getJobPostings">
        	<cfset ThisJobdate=DateAdd("h",info.utcHourOffset,date_submitted)><!--- Convert Date to Greenwich Mean Time --->
        	<job>
            	<cfset titledisplay=REReplace(title, "<[^>]*>", "", "All")>
             	<cfif findnocase("$$DQ$$",titledisplay,1) gt 0><cfset titledisplay=replace(titledisplay,"$$DQ$$","&quot;","all")></cfif>
             	<title><![CDATA[ #titledisplay# ]]></title>
            	<date>#DateFormat(ThisJobdate,'ddd, dd mmm yyyy')# #TimeFormat(ThisJobdate,'HH:mm:ss')# GMT</date>
            	<referencenumber>#intJobID#</referencenumber>
            	<cfset strseoJobURL=replace(seoJobURL, "view", "view/$#tkcd#", "ALL")>
            	<url>#request.url##strseoJobURL#</url>
            	<company>#jpname#</company>
            	<city>#location#</city>
            	<cfif strcountry eq "US"><state>#state#</state><cfelse><cfif stateID eq "462"><state>Confidential</state><cfelse><state></state></cfif></cfif>
            	<cfif stateID eq "462"><country>Confidential</country><cfelse><country>#strcountry#</country></cfif>
            	<postalcode></postalcode>
            	<cfset strTempText="#Replace(description, "<br>", "#chr(10)##chr(13)#", "ALL")#">
            	<cfset strTempText="#replace(REReplace(strTempText, "<[^>]*>", "", "All"),"  "," ","all")#">
            	<cfset strTempText="#Replace(strTempText, "$$DQ$$", chr(34), "ALL")#">
            	<cfset strTempText="#Replace(strTempText, "$$SQ$$", chr(39), "ALL")#">
            	<cfset strTempText="#Replace(strTempText, "$$dq$$", chr(34), "ALL")#">
            	<cfset strTempText="#Replace(strTempText, "$$sq$$", chr(39), "ALL")#">
            	<cfset strTempText="#Replace(strTempText, "<![CDATA[", "", "ALL")#">			
        		<cfset intOpenTagFound = findnocase("<![CDATA[", strTempText)>
           		<cfif intOpenTagFound is 0><cfset strTempText = "<![CDATA[" & strTempText></cfif>
            	<cfset intCloseTagFound = findnocase("]]>", strTempText)>
            	<cfif intCloseTagFound is 0><cfset strTempText = strTempText & "]]>"></cfif>
            	<description>#strTempText#</description>
            	<cfset strTempText="">
        	</job>
			<cfset ThisJobdate="">
        </cfoutput>
    </source>
</cfif>
</cfprocessingdirective>