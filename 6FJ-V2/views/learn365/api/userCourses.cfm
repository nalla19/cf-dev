
<cfquery name="getSSOID" datasource="#application.dsn#">
	select learn365UserId from tblLearn365Users
	where intresid = #session.exec.intResID# and blnActive=1
</cfquery>

<cfif getSSOID.recordcount EQ 1>
	<cfset learn365UserId = getSSOID.learn365UserId>
	
</cfif>
<!--- GET /teams/{teamId}/courses--->

<cfset teamID = "8_sImXiEzDw1">

<cfset learn365Method = "GET">

<cfset learn365URL = application.api365URL>
<cfset learn365Path = "/users/#learn365UserId#/courses">
<cfset learn365Key = "?apikey=#application.api365KeyName#">
<cfset learn365Source = "&source=#application.api365SourceName#">

<cfset learn365URL = "#learn365URL##learn365Path##learn365Key##learn365Source#&search=lead">

<cfhttp url="#learn365URL#" method="#learn365Method#" />

<!---  <cfdump var="#CFHTTP.FileContent#"/> --->

<!--- Parse the XML and output a list of resources. ---> 
<cfset mydoc = XmlParse(CFHTTP.FileContent)> 
  
<!--- <cfdump var="#mydoc#"> --->
<cfset numItems = ArrayLen(mydoc.courses.XmlChildren)> 
<!--- <cfoutput>#numItems#</cfoutput>
<br><br>  
--->  
<!--- Process the order into a query object ---> 
<cfset courseQuery = QueryNew("course_id, course_name, course_active, course_complete, course_percentage, course_startDt, course_completeDt") > 
<cfset temp = QueryAddRow(courseQuery, #numItems#)> 
<cfloop index="i" from = "1" to = #numItems#> 
    <cfset temp = QuerySetCell(courseQuery, "course_id", 
        #mydoc.courses.course[i].id.XmlText#,#i#)> 
    <cfset temp = QuerySetCell(courseQuery, "course_name", 
        #mydoc.courses.course[i].name.XmlText#, #i#)> 
	 <cfset temp = QuerySetCell(courseQuery, "course_active", 
        #mydoc.courses.course[i].active.XmlText#, #i#)> 
	 <cfset temp = QuerySetCell(courseQuery, "course_complete", 
        #mydoc.courses.course[i].complete.XmlText#, #i#)> 
	 <cfset temp = QuerySetCell(courseQuery, "course_percentage", 
        #mydoc.courses.course[i].percentagecomplete.XmlText#, #i#)> 
	 <cfset temp = QuerySetCell(courseQuery, "course_startDt", 
        #mydoc.courses.course[i].startdate.XmlText#, #i#)> 
	 <cfset temp = QuerySetCell(courseQuery, "course_completeDt", 
        #mydoc.courses.course[i].datecompleted.XmlText#, #i#)> 
    
</cfloop> 
  
<!--- Display the order query  
 <cfdump var=#courseQuery#>
---> 

