<!--- <cfset learn365Username = "irma.rodela@gmail.com">
<cfset learn365FirstName = "">
<cfset learn365LastName = "Rodela"> --->

<cfset learn365Method = "POST">

<cfset learn365URL = application.api365URL>
<cfset learn365Path = "users">
<cfset learn365Key = "?apikey=#application.api365KeyName#">
<cfset learn365Source = "&source=#application.api365SourceName#">
<cfset learn365UserId = "">
<cfset learn365URL = "#learn365URL##learn365Path##learn365Key##learn365Source#">

<cfoutput>
 <cfsavecontent variable="myXML">
<User>
   <Id></Id>
   <UserName>#learn365Username#</UserName>
   <FirstName>#learn365FirstName#</FirstName>
   <LastName>#learn365LastName#</LastName>
   <FullName></FullName>
   <Email></Email>
   <AccessLevel>Learner</AccessLevel>
   <DisableMessages>true</DisableMessages>
   <Active>true</Active>
   <Skype></Skype>
   <PhoneWork></PhoneWork>
   <PhoneMobile></PhoneMobile>
   <LastLogin></LastLogin>
   <LoginKey></LoginKey>
   <IsCustomUsername>false</IsCustomUsername>
   <Password></Password>
   <SkipFirstLogin>true</SkipFirstLogin>
   <TimeZone></TimeZone>
   <Street1></Street1>
   <Street2></Street2>
   <City></City>
   <State></State>
   <PostalCode></PostalCode>
   <Country></Country>
   <CompanyName></CompanyName>
   <JobTitle></JobTitle>
   <CustomField1></CustomField1>
   <CustomField2></CustomField2>
   <CustomField3></CustomField3>
   <CustomField4></CustomField4>
   <CustomField5></CustomField5>
   <CustomField6></CustomField6>
   <CustomField7></CustomField7>
   <CustomField8></CustomField8>
   <CustomField9></CustomField9>
   <CustomField10></CustomField10>
   <Culture></Culture>
</User>
</cfsavecontent>
</cfoutput>

<cfhttp url="#learn365URL#" method="#learn365Method#" >
	<cfhttpparam type="XML" name="Id" value="#myXML#">
</cfhttp>

<!--- <cfoutput>Add User: #cfhttp.statusCode#<br></cfoutput> --->


<cfset mydoc = XmlParse(CFHTTP.FileContent)>
<!--- <cfoutput>#mydoc.User.Id.XmlText#<br></cfoutput> --->

<cfif cfhttp.statusCode contains "201">
	<cfset learn365UserId = #mydoc.User.Id.XmlText#>
<cfelse>
	<cfset learn365UserId = "">
</cfif>



<!--- <cfoutput>learn365UserId - #learn365UserId#<br></cfoutput> --->
