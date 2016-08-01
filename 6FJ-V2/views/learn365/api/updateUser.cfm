<!--- 
<cfset learn365Username = "irma.rodela@gmail.com">
<cfset learn365FirstName = "">
<cfset learn365LastName = "Rodela">
<cfset learn365UserId = session.EXEC.learn365UserID>
 --->

<cfset learn365Method = "PUT">

<cfset learn365URL = application.api365URL>

<cfset learn365Key = "?apikey=#application.api365KeyName#">
<cfset learn365Source = "&source=#application.api365SourceName#">
<cfset learn365Path = "users/#learn365UserId#">
<cfset learn365URL = "#learn365URL##learn365Path##learn365Key##learn365Source#">

<cfoutput>
	<cfsavecontent variable="myXML">
		<User> 
			<Id>#learn365UserId#</Id> 
			<UserName>#learn365Username#</UserName>
			<FirstName>#learn365FirstName#</FirstName>
			<LastName>#learn365LastName#</LastName> 
			<FullName/> 
			<Email/> 
			<AccessLevel/> 
			<DisableMessages>true</DisableMessages> 
			<Active>#learn365Active#</Active> 
			<Skype/> 
			<PhoneWork/> 
			<PhoneMobile/> 
			<LastLogin/> 
			<LoginKey/> 
			<Password/> 
			<SkipFirstLogin>true</SkipFirstLogin> 
			<TimeZone/> 
			<Street1/> 
			<Street2/> 
			<City/> 
			<State/> 
			<PostalCode/> 
			<Country/> 
			<CompanyName/> 
			<JobTitle/> 
			<CustomField1/> 
			<CustomField2/> 
			<CustomField3/> 
			<Culture/> 
		</User> 
	</cfsavecontent>
</cfoutput>

<cfhttp url="#learn365URL#" method="#learn365Method#" >
	<cfhttpparam type="XML" name="Id" value="#myXML#">
</cfhttp>

<!--- <cfoutput> Add to team: #cfhttp.statusCode#<br></cfoutput> --->

<cfif cfhttp.statusCode CONTAINS "200">
	<cfquery name="updateLearn365User" datasource="#application.dsn#">
		update tblLearn365Users
		set learn365Username = '#learn365Username#',
		blnActive = #learn365Active#
		where learn365UserId = '#learn365UserId#'
	</cfquery>
</cfif>




