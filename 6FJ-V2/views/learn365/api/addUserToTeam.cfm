<!--- POST /teams/{team-id}/users --->

<cfset teamID = "8_sImXiEzDw1">

<!--- <cfset learn365UserId = "W-muCsLcWyU1"> --->
<cfset learn365Method = "POST">

<cfset learn365URL = application.api365URL>
<cfset learn365Path = "/teams/#teamID#/users">
<cfset learn365Key = "?apikey=#application.api365KeyName#">
<cfset learn365Source = "&source=#application.api365SourceName#">

<cfset learn365URL = "#learn365URL##learn365Path##learn365Key##learn365Source#">
<cfoutput> <!--- learn365UserId: #learn365UserId#<br> --->

<cfsavecontent variable="myXML">
<Users> 
   <User>  
   <Id>#learn365UserId#</Id>  
   <UserName></UserName>  
   <FirstName></FirstName>  
   <LastName></LastName>  
   </User>  
</Users>
</cfsavecontent>
</cfoutput>
<cfhttp url="#learn365URL#" method="#learn365Method#" >
	<cfhttpparam type="XML" name="Id" value="#myXML#">
</cfhttp>
<!--- <cfdump var="#CFHTTP.FileContent#"/>

<cfoutput> Add to team: #cfhttp.statusCode#<br></cfoutput> --->