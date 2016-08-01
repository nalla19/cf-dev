<!--- GET /teams/{teamId}/courses--->

<cfset teamID = "8_sImXiEzDw1">

<cfset learn365Method = "GET">

<cfset learn365URL = application.api365URL>
<cfset learn365Path = "/teams/#teamID#/courses">
<cfset learn365Key = "?apikey=#application.api365KeyName#">
<cfset learn365Source = "&source=#application.api365SourceName#">

<cfset learn365URL = "#learn365URL##learn365Path##learn365Key##learn365Source#">

<cfhttp url="#learn365URL#" method="#learn365Method#" />

 <cfdump var="#CFHTTP.FileContent#"/>

<!--- Parse the XML and output a list of resources. ---> 
<cfset mydoc = XmlParse(CFHTTP.FileContent)> 
  

<cfset numItems = ArrayLen(mydoc.courses.XmlChildren)> 
<cfoutput>#numItems#</cfoutput>
<br><br> 
  
<!--- Process the order into a query object ---> 
<cfset courseQuery = QueryNew("course_id, course_name") > 
<cfset temp = QueryAddRow(courseQuery, #numItems#)> 
<cfloop index="i" from = "1" to = #numItems#> 
    <cfset temp = QuerySetCell(courseQuery, "course_id", 
        #mydoc.courses.course[i].id.XmlText#,#i#)> 
    <cfset temp = QuerySetCell(courseQuery, "course_name", 
        #mydoc.courses.course[i].name.XmlText#, #i#)> 
    
</cfloop> 
  
<!--- Display the order query ---> 
<cfdump var=#courseQuery#> 


