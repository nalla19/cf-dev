<!--- GET https://api.litmos.com/v1.svc/users/abc12345678?apikey=YOUR_API_KEY&source=sampleapp --->



<cfset learn365Method = "GET">

<cfset learn365URL = application.api365URL>
<cfset learn365Path = "/users/#learn365UserId#">
<cfset learn365Key = "?apikey=#application.api365KeyName#">
<cfset learn365Source = "&source=#application.api365SourceName#">

<cfset learn365URL = "#learn365URL##learn365Path##learn365Key##learn365Source#">

<cfhttp url="#learn365URL#" method="#learn365Method#" />

<!--- <cfdump var="#CFHTTP.FileContent#"/> --->

<cfset mydoc = XmlParse(CFHTTP.FileContent)>
<cfoutput>#mydoc.User.LoginKey.XmlText#</cfoutput>
