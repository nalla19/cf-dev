<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>LinkedIn Registration</title>
</head>


<body>
<cfoutput>
<cfparam name="strFname" default="" />
<cfparam name="strLname" default="" />
<cfparam name="strPasswd" default="" />
<cfparam name="strEmail" default="" />
<cfparam name="url.tkcd" default="-1">
<cfparam name="tCode" default="-1">

<cfparam name="request.emailErrorMsg" default="">
<cfparam name="request.emailBorderColor" default="##F00">

<!--- CJ Tracking --->
<cfparam name="URL.AID" default="">
<cfparam name="URL.PID" default="">
<cfparam name="URL.SID" default="">
<cfparam name="Query_String" default="">

<cfif len(URL.AID) and len(URL.PID)>
	<cfparam name="how_find" default="CJ">
	<cfcookie name="strExecCJID" expires="5" value="#QUERY_STRING#">
</cfif>

<!---Set the intJobID in session if coming from the Apply Job link and the candidate is not a member yet--->
<cfif isDefined("url.Pf9ZL4URh") and url.Pf9ZL4URh neq "">
	<cfset session.exec.jaQintJobID = url.Pf9ZL4URh>
</cfif>

<!---Set the intJobID in session if coming from the Apply Job link and the candidate is not a member yet--->
<cfif isDefined("url.tCode") and url.tCode neq "">
	<cfset session.exec.tCode = url.tCode>
</cfif>


<cfif not isDefined("session.licode")>
 
  <cfif isDefined("url.startli")>
		<cfset session.state = createUUID()>
			
		<cfif cgi.HTTP_HOST EQ "6figurejobs.com" OR cgi.HTTP_HOST EQ "www.6figurejobs.com" OR cgi.HTTP_HOST EQ "web1.6figurejobs.com" OR cgi.HTTP_HOST EQ "web2.6figurejobs.com" OR cgi.HTTP_HOST EQ "web3.6figurejobs.com" OR cgi.HTTP_HOST EQ "access.6figurejobs.com" OR cgi.HTTP_HOST EQ "salesstars.com" OR cgi.HTTP_HOST EQ "www.salesstars.com">
			<cfset redirurl = urlEncodedFormat("https://www.6figurejobs.com/login-linkedin-redirect")>
		<cfelseif cgi.HTTP_HOST EQ "uat.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat2.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat.salesstars.com">
			<cfset redirurl = urlEncodedFormat("http://uat.6figurejobs.com/login-linkedin-redirect")>
		<cfelseif cgi.HTTP_HOST EQ "dev.6figurejobs.com" OR cgi.HTTP_HOST EQ "dev.salesstars.com">
			<cfset redirurl = urlEncodedFormat("http://dev.6figurejobs.com/login-linkedin-redirect")>
		</cfif>
		
		<cfset liURL = "https://www.linkedin.com/uas/oauth2/authorization?response_type=code" & 
		"&client_id=#application.linkedin.apikey#&scope=r_fullprofile%20r_emailaddress%20r_network%20r_contactinfo" &
		"&state=#session.state#&redirect_uri=#redirurl#">
		<cflocation url="#liURL#" addToken="false">
 
	</cfif>
 
	<a href="?startli=1">Login with LinkedIn</a>
 
 
<cfelse>
 
	<!--- This is a LI user. --->
 	<cfset session.liAPI = createObject("component","v26fj.views.join.linkedin.linkedin").init(session.liaccesstoken)>
	
	<cfparam name="session.exec.liUser.liProfileModifiedDate" default=""> 
	<cfparam name="liProfileUpdated" default="0">
		
	<cfset session.exec.liUser = session.liAPI.getMe()>	
	<!---
	<cfset bigInt = createObject( "java", "java.math.BigInteger" ).init(javaCast( "string", "255" )) />
	<cfset bigInt = session.exec.liUser.liProfileModifiedDate>	
	--->
		
	<cfset liUser=session.liAPI.getMe()>
 	<cfset fname=liUser.firstName>
	<cfset lname=liUser.lastName>
    <cfset email=liUser.emailAddress>
			
	<!---Validate the users email address and if validated as an active user in the system, send them through the pg_ExecLoginProcess.cfm--->
	<cfquery name="request.cfqValidateUser" datasource="#application.dsn#">
	 SELECT intresid, username, password, bigIntLILastModified
	   FROM tblResumes (nolock)  
	  WHERE email = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar" />
		AND sourceApp = <cfqueryparam value="#application.sourceapp#" cfsqltype="cf_sql_varchar" />
		AND blndelete = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
	</cfquery>
	
	<cfif session.exec.liUser.lastModifiedTimestamp neq request.cfqValidateUser.bigIntLILastModified>
		<cfset liProfileUpdated=1>
	</cfif>
		
	<cfif request.cfqValidateUser.recordcount>
			
		<cfset intResID = request.cfqValidateUser.intResID>
		
		<!---Update the two recent companies and titles for that user--->
		<cfinclude template="../../join/linkedIn/linkedinvariables.cfm">
		
	
		<!---Save the LI Upated Profile if the profile has been updated--->
		<cfif liProfileUpdated is 1>
			<cfinclude template="../../join/linkedIn/createResume.cfm">
			
			<!---Update the zip code--->
			<cfif len(liUserZipCode)>
				<cfquery name="cfqUpdAddress" datasource="#application.dsn#">
				update tblResumes
			   	   set city     = <cfqueryparam value="#liUserCity#" cfsqltype="cf_sql_varchar" />,
				       state    = <cfqueryparam value="#liUserState#" cfsqltype="cf_sql_varchar" />,
   				       zip      = <cfqueryparam value="#liUserZipCode#" cfsqltype="cf_sql_varchar" />
    			 where intResid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />		
     			</cfquery>
			</cfif>
			<!---//Update the zip code--->
			
			<!---Update the Phone Numbers--->		
			<cfif ArrayLen(liUserPhoneNumbers) gt 0>
				<cfquery name="cfqUpdPhoneNumbers" datasource="#application.dsn#">
				update tblResumes
				   set mobile_phone = <cfqueryparam value="#liUserPhoneNumbers[1][1]#" cfsqltype="cf_sql_varchar" />,
				       home_phone   = <cfqueryparam value="#liUserPhoneNumbers[1][1]#" cfsqltype="cf_sql_varchar" />,
				       work_phone   = <cfqueryparam value="#liUserPhoneNumbers[1][1]#" cfsqltype="cf_sql_varchar" />
			     where intResid     = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />		  
				</cfquery>
			</cfif>
			<!---//Update the Phone Numbers--->		
			
			<!--- Two most recent Positions --->
			<cfif ArrayLen(liUserExperience)>
				<!---
				<cfquery name="cfqUpdPositions" datasource="#application.dsn#">
				update tblResumes
				   set strExecJobTitle_1	=  <cfqueryparam value="#liUserExperience[1][2]#" cfsqltype="cf_sql_varchar" />,
					   strExecJOBCompany_1 	=  <cfqueryparam value="#liUserExperience[1][1]#" cfsqltype="cf_sql_varchar" />,
					   strExecJobTitle_2 	=  <cfqueryparam value="#liUserExperience[2][2]#" cfsqltype="cf_sql_varchar" />,
					   strExecJOBCompany_2 	=  <cfqueryparam value="#liUserExperience[2][1]#" cfsqltype="cf_sql_varchar" />
	    		 where intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
				</cfquery>
				--->
				
				<!---
				<cfset strJobTitle1 = Left(liUserExperience[1][2], 49)>
				<cfset strJobCompany1 = Left(liUserExperience[1][1], 49)>
				<cfset strJobTitle2= Left(liUserExperience[2][2], 49)>
				<cfset strJobCompany2 = Left(liUserExperience[2][1], 49)>
				--->
				<!---
				<cfquery name="cfqUpdPositions" datasource="#application.dsn#">
				update tblResumes
				   set strExecJobTitle_1	=  <cfqueryparam value="#strJobTitle1#" cfsqltype="cf_sql_varchar" />,
					   strExecJOBCompany_1 	=  <cfqueryparam value="#strJobCompany1#" cfsqltype="cf_sql_varchar" />,
					   strExecJobTitle_2 	=  <cfqueryparam value="#strJobTitle2#" cfsqltype="cf_sql_varchar" />,
					   strExecJOBCompany_2 	=  <cfqueryparam value="#strJobCompany2#" cfsqltype="cf_sql_varchar" />
	    		 where intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
				</cfquery>
				--->
				
				<cftry>
					<cfset strJobTitle1 = Left(liUserExperience[1][2], 49)>
					<cfcatch type="any">
						<cfset strJobTitle1 = "">
					</cfcatch>
				</cftry>
				
				<cftry>
					<cfset strJobCompany1 = Left(liUserExperience[1][1], 49)>
					<cfcatch type="any">
						<cfset strJobCompany1 = "">
					</cfcatch>
				</cftry>
				
				<cftry>
					<cfset strJobTitle2= Left(liUserExperience[2][2], 49)>
					<cfcatch type="any">
						<cfset strJobTitle2 = "">
					</cfcatch>
				</cftry>
				
				<cftry>
					<cfset strJobCompany2 = Left(liUserExperience[2][1], 49)>
					<cfcatch type="any">
						<cfset strJobCompany2 = "">
					</cfcatch>
				</cftry>
				
				<cfif len(strJobTitle1)>
					<cfquery name="cfqUpdPositions" datasource="#application.dsn#">
					update tblResumes
					   set strExecJobTitle_1	=  <cfqueryparam value="#strJobTitle1#" cfsqltype="cf_sql_varchar" />
					where intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />   
					</cfquery>	
				</cfif>
				
				<cfif len(strJobCompany1)>
					<cfquery name="cfqUpdPositions" datasource="#application.dsn#">
					update tblResumes
					   set strExecJOBCompany_1 	=  <cfqueryparam value="#strJobCompany1#" cfsqltype="cf_sql_varchar" />
					where intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />   
					</cfquery>	
				</cfif>
				
				<cfif len(strJobTitle2)>
					<cfquery name="cfqUpdPositions" datasource="#application.dsn#">
					update tblResumes
					   set strExecJobTitle_2 	=  <cfqueryparam value="#strJobTitle2#" cfsqltype="cf_sql_varchar" />
					where intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />   
					</cfquery>	
				</cfif>
				
				<cfif len(strJobCompany2)>
					<cfquery name="cfqUpdPositions" datasource="#application.dsn#">
					update tblResumes
					   set strExecJOBCompany_2 	=  <cfqueryparam value="#strJobCompany2#" cfsqltype="cf_sql_varchar" />
					where intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />   
					</cfquery>	
				</cfif>
				
			</cfif>
			<!--- //Two most recent Positions --->
			
			<!--- Education --->
			<cfif isDefined("session.exec.liUserEducation") and ArrayLen(session.exec.liUserEducation) gt 0>
				<cfloop index="i" from="1" to="#ArrayLen(session.exec.liUserEducation)#">
				
					<cfset strUniversity = session.exec.liUserEducation[i][1]>
					<cfset strDegree = session.exec.liUserEducation[i][2]>
					<cfif strDegree contains "Bachelor">
						<cfset strDegree = "BS/BA">
					<cfelseif strDegree contains "Master">
						<cfset strDegree = "Masters">
					<cfelseif strDegree contains "Associate">
						<cfset strDegree = "Associates Degree">
					<cfelseif strDegree contains "Doctor">
						<cfset strDegree = "Doctorate">
					<cfelseif strDegree contains "Juris">
						<cfset strDegree = "Juris Doctorate">
					</cfif>
					
					<cfif len(strDegree) and len(strUniversity)>
	
						<!--- Check to see if there is already an entry for this University for this candidate --->
						<cfquery name="cfqCheckUniversity" datasource="#application.dsn#">
						select * 
						  from tblResDegreeUniversity (nolock)
						 where strDegree = <cfqueryparam value="#strDegree#" cfsqltype="cf_sql_varchar" />
						   and strUnivCollegeName = <cfqueryparam value="#strUniversity#" cfsqltype="cf_sql_varchar" />
						   and intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<!---If there is not entry for the education, insert the record --->
						<cfif cfqCheckUniversity.recordcount is 0>
							<cfquery name="cfqInsRecord" datasource="#application.dsn#">
								insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
								values(#intResID#, '#strDegree#', '#strUniversity#')
							</cfquery>
						</cfif>
						
					<cfelseif len(strDegree) and not len(strUniversity)>
				
						<!--- Check to see if there is already an entry for this University for this candidate --->
						<cfquery name="cfqCheckUniversity" datasource="#application.dsn#">
						select * 
						  from tblResDegreeUniversity (nolock)
						 where strDegree = <cfqueryparam value="#strDegree#" cfsqltype="cf_sql_varchar" />
						   and intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<!---If there is not entry for the education, insert the record --->
						<cfif cfqCheckUniversity.recordcount is 0>
							<cfquery name="cfqInsRecord" datasource="#application.dsn#">
								insert into tblResDegreeUniversity (intResID, strDegree)
								values(#intResID#, '#strDegree#')
							</cfquery>
						</cfif>
									
					</cfif>
							
				</cfloop>				
			</cfif>
			<!--- //Education--->
		</cfif>
		<!--- //Save the LI Upated Profile if the profile has been updated--->
		
		<cfset queryString="">
		<cfif isDefined("session.exec.jaQintJobID") and session.exec.jaQintJobID neq "">
			<cfset queryString= "&intJobID=#session.exec.jaQintJobID#&strCaller=execOneClickApply">
		</cfif>
		
		<!---Send the user to the dashboard--->
		<cflocation url="/member-login?strUserName=#request.cfqValidateUser.username#&strPassword=#request.cfqValidateUser.password##queryString#&blnRememberMe=1" addtoken="no">
	<cfelse>
		<cfset StructDelete(session, "exec.liUser")>
		<cfset StructDelete(session, "liAPI.getMe()")>
		<cfset StructDelete(session, "licode")>
		
		<cfset request.emailErrorMsg = "Invalid User, please try again" />
		<cfset request.emailBorderColor = "##F00" />
		<cfabort>
		<!--- <cflocation url="#application.v2url#/join/?error_code=2&error_message=#request.emailErrorMsg#" addtoken="false"> --->
		<cflocation url="/member-invalid-login" addtoken="false">
		
	</cfif>
</cfif>
</cfoutput>
</body>
</html>