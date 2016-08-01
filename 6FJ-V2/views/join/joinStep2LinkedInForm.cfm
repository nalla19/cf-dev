<cfoutput>
<!--- <cfdump var="#session.exec.liUser#" expand="true"> --->
<cfparam name="liUserCity" default="">
<cfparam name="liUserState" default="">
<cfparam name="liUserZipCode" default="">
<cfparam name="liUserCountry" default="">
<cfparam name="strCountry" default="">
<!--- 
<cfparam name="session.exec.liUser.liProfileModifiedDate" default="">
<cfset session.exec.liUser.liProfileModifiedDate = dateadd('s', (session.exec.liUser.lastModifiedTimestamp/1000)-18000, createdatetime(1970, 1, 1, 0, 0, 0))>
--->

<!------------------------------------------------------------------------------------->
<!--------------------Get the ZipCode, City, State and Country ------------------------>
<!------------------------------------------------------------------------------------->
<cfif isDefined("session.exec.liUser.mainAddress") and len(session.exec.liUser.mainAddress)>
	<cfset usZipCode = Right(session.exec.liUser.mainAddress, 5)>
	
	<!---Validate the ZipCode to check against the US Database --->
	<cfquery name="cfqGetUSCityStateZipCode" datasource="#application.dsn#">
	select distinct zipcodes.city ipCity, zipcodes.state ipRegion, zipcodes.zipcode ipZipCode, 'United States' as ipCountry
      from tbl_zipcodes_usa zipcodes(nolock) 
     where 1=1
       and (zipcodes.city like '#usZipCode#%' or zipcodes.zipcode like '#usZipCode#%')  
	</cfquery>
	
	<cfif cfqGetUSCityStateZipCode.recordcount is 1>
		
		<cfset liUserCity = cfqGetUSCityStateZipCode.ipCity>
		<cfset strtempCity = REReplace(LCase(liUserCity), "(^[[:alpha:]]|[[:blank:]][[:alpha:]])", "\U\1\E", "ALL")>
       	<cfset liUserCity = strtempCity>
			    
		<cfset templiUserState = cfqGetUSCityStateZipCode.ipRegion>
		<cfquery name="cfqGetStateName" datasource="#application.dsn#">
		select strName from tblStates (nolock) where strAbbrev = <cfqueryparam value="#templiUserState#" cfsqltype="cf_sql_varchar" /> and strCountry = <cfqueryparam value="US" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfif cfqGetStateName.strName neq "">
			<cfset liUserState = cfqGetStateName.strName>
		<cfelse>
			<cfset liUserState = templiUserState>
		</cfif>
		
		<cfset liUserZipCode = cfqGetUSCityStateZipCode.ipZipCode>
		<cfset liUserCountry = cfqGetUSCityStateZipCode.ipCountry>
		
	<cfelse>
		
		<cfset canadaZipCode = Right(session.exec.liUser.mainAddress, 7)>
		<cfquery name="cfqGetCanadaCityStateZipCode" datasource="#application.dsn#">
		select distinct zipcodes.city ipCity, zipcodes.province ipRegion, zipcodes.postalCode ipZipCode, 'Canada' as ipCountry
          from tbl_zipcodes_canada zipcodes(nolock) 
         where 1=1
           and (zipcodes.city like '#canadaZipCode#%' or zipcodes.PostalCode like '#canadaZipCode#%')
		</cfquery>
		
		<cfif cfqGetCanadaCityStateZipCode.recordcount is 1>
			
			<cfset liUserCity = cfqGetCanadaCityStateZipCode.ipCity>
			<cfset strtempCity = REReplace(LCase(liUserCity), "(^[[:alpha:]]|[[:blank:]][[:alpha:]])", "\U\1\E", "ALL")>
       		<cfset liUserCity = strtempCity>
			    
			<cfset templiUserState = cfqGetCanadaCityStateZipCode.ipRegion>
			<cfquery name="cfqGetStateName" datasource="#application.dsn#">
			select strName from tblStates (nolock) where strAbbrev = <cfqueryparam value="#liUserState#" cfsqltype="cf_sql_varchar" /> and strCountry = <cfqueryparam value="CA" cfsqltype="cf_sql_varchar" />
			</cfquery>
		
			<cfif cfqGetStateName.strName neq "">
				<cfset liUserState = cfqGetStateName.strName>
			<cfelse>
				<cfset liUserState = templiUserState>
			</cfif>
			
			<cfset liUserZipCode = cfqGetCanadaCityStateZipCode.ipZipCode>
				
			<cfset liUserCountry = cfqGetCanadaCityStateZipCode.ipCountry>
		</cfif>
		
	</cfif>
</cfif>
<!------------------------------------------------------------------------------------->
<!------------------//Get the ZipCode, City, State and Country ------------------------>
<!------------------------------------------------------------------------------------->


<!------------------------------------------------------------------------------------->
<!---------------------------Get the User Eduction Details ---------------------------->
<!------------------------------------------------------------------------------------->
<cfset liUserEducation = ArrayNew(2)>
<cfif isDefined("session.exec.liUser.educations")>
	<cfloop index="i" from="1" to="#session.exec.liUser.educations._total#">
		<!---School Name --->
		<cftry>
			<cfset liUserEducation[i][1] = session.exec.liUser.educations.values[i].schoolName>
			<cfcatch type="any">
				<cfset liUserEducation[i][1] = "">
			</cfcatch>
		</cftry>
		
		<!---Degree--->
		<cftry>
			<cfset liUserEducation[i][2] = session.exec.liUser.educations.values[i].degree>
			<cfcatch type="any">
				<cfset liUserEducation[i][2] = "">
			</cfcatch>
		</cftry>
		
		<!---Field Of Study--->
		<cftry>
			<cfset liUserEducation[i][3] = session.exec.liUser.educations.values[i].fieldOfStudy>
			<cfcatch type="any">
				<cfset liUserEducation[i][3] = "">
			</cfcatch>
		</cftry>
		
		<!---Start Date--->
		<cftry>
			<cfset liUserEducation[i][4] = session.exec.liUser.educations.values[i].startDate.year>
			<cfcatch type="any">
				<cfset liUserEducation[i][4] = "">
			</cfcatch>
		</cftry>
		
		<!---End Date--->
		<cftry>
			<cfset liUserEducation[i][5] = session.exec.liUser.educations.values[i].endDate.year>
			<cfcatch type="any">
				<cfset liUserEducation[i][5] = "">
			</cfcatch>
		</cftry>
	</cfloop>
</cfif>
<cfset session.exec.liUserEducation = ArrayNew(2)>
<cfset session.exec.liUserEducation = liUserEducation>
<!------------------------------------------------------------------------------------->
<!-------------------------//Get the User Eduction Details ---------------------------->
<!------------------------------------------------------------------------------------->


<!------------------------------------------------------------------------------------->
<!---------------------------Get the User Experience Details--------------------------->
<!------------------------------------------------------------------------------------->
<cfset liUserExperience = ArrayNew(2)>
<cfif isDefined("session.exec.liUser.positions")>
	<cfloop index="i" from="1" to="#session.exec.liUser.positions._total#">
		<!---Company Name--->
		<cftry>
			<cfset liUserExperience[i][1] = session.exec.liUser.positions.values[i].company.name>
			<cfcatch type="any">
				<cfset liUserExperience[i][1] = "">
			</cfcatch>
		</cftry>
			
		<!---Title--->
		<cftry>
			<cfset liUserExperience[i][2] = session.exec.liUser.positions.values[i].title>
			<cfcatch type="any">
				<cfset liUserExperience[i][2] = "">
			</cfcatch>
		</cftry>
	
		<!---Summary--->
		<cftry>
			<cfset liUserExperience[i][3] =  session.exec.liUser.positions.values[i].summary>
			<cfcatch type="any">
				<cfset liUserExperience[i][3] =  "">
			</cfcatch>
		</cftry>
	
		<!---Employment Start Date--->
		<cftry>
			<cfset employmentStartDate = MonthAsString(session.exec.liUser.positions.values[i].startdate.month) & " " & session.exec.liUser.positions.values[i].startdate.year>
			<cfset liUserExperience[i][4] =  employmentStartDate>
			<cfcatch type="any">
				<cfset liUserExperience[i][4] = "">
			</cfcatch>
		</cftry>
	
		<!---Employment End Date--->
		<cftry>
			<cfif session.exec.liUser.positions.values[i].isCurrent is "Yes">
				<cfset liUserExperience[i][5] =  "Present">
			<cfelse>
				<cfset employmentEndDate = MonthAsString(session.exec.liUser.positions.values[i].endDate.month) & " " & session.exec.liUser.positions.values[i].endDate.year>
				<cfset liUserExperience[i][5] =  employmentEndDate>
			</cfif>
			
			<cfcatch type="any">
				<cfset liUserExperience[i][5] =  "">
			</cfcatch>
		</cftry>
	</cfloop>
</cfif>
<!--- <cfdump var="#liUserExperience#"> --->
<!------------------------------------------------------------------------------------->
<!-------------------------//Get the User Experience Details--------------------------->
<!------------------------------------------------------------------------------------->


<!------------------------------------------------------------------------------------->
<!-------------------------Get the User Phone Numbers Details-------------------------->
<!------------------------------------------------------------------------------------->
<cfset liUserPhoneNumbers = ArrayNew(2)>
<cfif isDefined("session.exec.liUser.phoneNumbers")>
	<cfloop index="i" from="1" to="#session.exec.liUser.phoneNumbers._total#">
		<!---Phone Number--->
		<cftry>
			<cfset liUserPhoneNumbers[i][1] = session.exec.liUser.phoneNumbers.values[i].phoneNumber>
			<cfcatch type="any">
				<cfset liUserPhoneNumbers[i][1] = "">
			</cfcatch>
		</cftry>
	
		<!---Phone Number Type--->
		<cftry>
			<cfset liUserPhoneNumbers[i][2] = session.exec.liUser.phoneNumbers.values[i].phoneType>
			<cfcatch type="any">
				<cfset liUserPhoneNumbers[i][2] = "">
			</cfcatch>
		</cftry>
	</cfloop>
</cfif>
<!------------------------------------------------------------------------------------->
<!------------------------//Get the User Phone Number Details-------------------------->
<!------------------------------------------------------------------------------------->


<!------------------------------------------------------------------------------------->
<!----------------------------Get the User Skill Details------------------------------->
<!------------------------------------------------------------------------------------->
<cfset liUserSkills = "">
<cfif isDefined("session.exec.liUser.skills")>
	<cfloop index="i" from="1" to="#session.exec.liUser.skills._total#">
		<cftry>
			<cfset liUserSkills = ListAppend(liUserSkills, session.exec.liUser.skills.values[i].skill.name)>
			<cfcatch type="any">
				<cfset liUserSkills = liUserSkills>
			</cfcatch>
		</cftry>
	</cfloop>
</cfif>
<!------------------------------------------------------------------------------------->
<!--------------------------//Get the User Skill Details------------------------------->
<!------------------------------------------------------------------------------------->


<!------------------------------------------------------------------------------------->
<!---------------------Create and Save a  Word Document Resume------------------------->
<!------------------------------------------------------------------------------------->
<cfset resumeFilePath="C:\webroot\v2.6figurejobs.com\views\join\LinkedIn\resumes">
<!--- <cfoutput>#resumeFilePath#</cfoutput>
<cfabort> --->

<cfset resumeName = "#session.exec.liUser.firstName##session.exec.liUser.lastName##dateformat(now(),'yyyymmdd')#.doc">
<cfset resumeFilePathAndName = "#resumeFilePath#\#resumeName#">
<cfset session.exec.resumeFilePathAndName = resumeFilePathAndName>

<cfsavecontent variable="myDocument">
<html xmlns:w="urn:schemas-microsoft-com:office:word">
<!--- Head tag instructs Word to start up a certain way, specifically in print view. --->
<head>
<xml>
   	<w:WordDocument>
	<w:View>Print</w:View>
    <w:SpellingState>Clean</w:SpellingState>
    <w:GrammarState>Clean</w:GrammarState>
    <w:Compatibility>
    <w:BreakWrappedTables/>
    <w:SnapToGridInCell/>
    <w:WrapTextWithPunct/>
    <w:UseAsianBreakRules/>
    </w:Compatibility>
    <w:DoNotOptimizeForBrowser/>
    </w:WordDocument>
</xml>
<style>
<!-- /* Style Definitions */
@page Section1 {
	size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in; 
	mso-paper-source:0;
	font-size:16pt;
	font-weight:bold;}

div.Section1{
	page:Section1;}

.header{
	font-size:18pt;
	font-weight:bold;}

.header2{
	font-size:12pt;}

.
-->
</style>
</head>
<body lang=EN-US style="tab-interval:.5in">
	<div class="header">#session.exec.liUser.firstName# #session.exec.liUser.lastName#</div><br />
	<div class="header2">Email: #session.exec.liUser.emailAddress#</div>
	<cfif ArrayLen(liUserPhoneNumbers) gt 0>
	<div class="header2">Phone: #liUserPhoneNumbers[1][1]#</div>
	</cfif>
	<hr />
	
	<cfif isDefined("session.exec.liUser.summary") and len(session.exec.liUser.summary)>
	<div class=Section1>Summary</div><br />
	#paragraphformat(session.exec.liUser.summary)#
	<br>
	</cfif>
	
		
	<div class=Section1>Experience</div><br />
	<cfloop index="j" from="1" to="#arrayLen(liUserExperience)#">
		<strong>#liUserExperience[j][2]# at #liUserExperience[j][1]#</strong>
		<br />
		#liUserExperience[j][4]# - #liUserExperience[j][5]#
		<br />
		#ltrim( rtrim( paragraphformat(liUserExperience[j][3]) ) )#
	</cfloop>
	<p></p>
	
	<cfif len(liUserSkills)>
		<div class=Section1>Skills & Expertise </div><br />
		<cfloop list="#liUserSkills#" index="skillname">
		#skillname#<br />
		</cfloop>
	</cfif>
	<p></p>
	
	<cfif ArrayLen(liUserEducation)>
		<div class=Section1>Education</div><br />
		<cfloop index="i" from="1" to="#arrayLen(liUserEducation)#">
			<strong>#liUserEducation[i][1]#</strong>
			<br />
			#liUserEducation[i][2]#, #liUserEducation[i][3]#, #liUserEducation[i][4]# - #liUserEducation[i][5]#
			<br />
		</cfloop>
	</cfif>
</body>
</html>
</cfsavecontent> 

<cffile action="write" file="#resumeFilePathAndName#" output="#myDocument#" />

<!------------------------------------------------------------------------------------->
<!-------------------//Create and Save a  Word Document Resume------------------------->
<!------------------------------------------------------------------------------------->


<!--- Get International Countries --->
<cfquery name="cfqgetCountries" datasource="#application.dsn#">
select intOldID, strName, strCountry, intDisplayOrder From tblStates (nolock) where strcountry not in ('US', 'CA') and intDisplayOrder IS NOT NULL order by intDisplayOrder
</cfquery>

<!---
<cfif isDefined("session.exec.liUser.industry")>
	session.exec.liUser.indsutry=#session.exec.liUser.industry#
</cfif>
--->

<!--- <form name="ExecProfile" id="ExecProfile" method="post" enctype="multipart/form-data" action="#request.secureURL#/join/step2.cfm?Fy4ZT9ZUv=#urlencodedformat(url.Fy4ZT9ZUv)#<cfif isDefined('url.liuser') and len(url.liuser)>&liuser=true</cfif>" onSubmit="return checkform2();"> --->
<form name="ExecProfile" id="ExecProfile" method="post" enctype="multipart/form-data" action="join-step2?Fy4ZT9ZUv=#urlencodedformat(url.Fy4ZT9ZUv)#<cfif isDefined('url.liuser') and len(url.liuser)>&liuser=true</cfif>" onSubmit="return checkform2();">
	<input type="hidden" name="resumeFilePathAndName" value="#resumeFilePathAndName#">
	<input type="hidden" name="USCAIntToggle" id="USCAIntToggle" value="1" />
	<div class="page-companies">
		<article class="section companies well">
			<div class="container">
				<div class="span12">
					<div class="row">
						<h1 class="page-title">6FigureJobs Professional Registration</h1>
						<h2 class="page-subtitle">
						Hi #session.exec.liUser.firstName#!
						<br>
						We just need a few more pieces of profile information to get you started.
						<br>
						Please complete the following
						</h2>
				
						<section>
							<div class="row-fluid">
								
								<div class="span12 alert alert-error" id="errorDiv" style="color:##F00; display:none;">
				                	<!---<button type="button" class="close" data-dismiss="alert">x</button>--->
                					<strong>Warning!</strong> Please complete the fields below highlighted in red.
								</div>
								<cfif isDefined("url.creditErrMsg")>
									<cfset blnLearn365 = 1>
									<div class="span12 alert alert-error" id="errorDiv" style="color:##F00;">
				                		<strong>Warning!</strong>
										<br>
										#url.creditErrMsg#
										
									</div>
								</cfif>
							</div>
							
							
							<cfif len(liUserZipCode)>
								<input type="hidden" name="strUSCAZipCode" value="#liUserZipCode#" />
								<input type="hidden" name="liUserCity" value="#liUserCity#">
								<input type="hidden" name="liUserState" value="#liUserState#">
								<input type="hidden" name="liUserCountry" value="#liUserCountry#">
							<cfelse>	
								<input type="hidden" name="liUserCity" value="">
								<input type="hidden" name="liUserState" value="">
								<input type="hidden" name="liUserCountry" value="">
								
								<div class="row-fluid">
									<div class="span4">
										<h2>Contact Information</h2>
									</div>	
								</div>
							
								<div class="row-fluid" id="USCanadaZipCode" style="display:block;">
									<div class="span4">
										<input tabindex="1" id="strUSCAZipCode" name="strUSCAZipCode" type="text" class="input input-small span12 requiredField" maxlength="7" placeholder="U.S or Canadian Zip/Postal Code" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 1, this);">
									</div>
								
									<div class="span2">
										<a href="##" onClick="javascript:document.getElementById('USCanadaZipCode').style.display='none'; document.getElementById('intnlZipCode').style.display='block'; document.getElementById('USCAIntToggle').value=2;"><span id="uscaIntZipCodeToggle">International?</span></a>
									</div>
								</div>
							
								<div class="row-fluid" id="intnlZipCode" style="display:none;">
									<div class="span5">
										<input  tabindex="2" id="strIntntlCity" name="strIntntlCity" type="text" class="input input-small span12 requiredField" maxlength="50" placeholder="City" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';} ; updateRegistrationStep(#session.exec.intresid#, 2, 2, this);">
									</div>
				
									<div class="span4">
										<select tabindex="3" name="strCountry" id="strCountry" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';} ; updateRegistrationStep(#session.exec.intresid#, 2, 3, this);">
			                        	    <option value="">Country</option>
											<cfloop query="cfqgetCountries">	
			                            	<option value="#cfqgetCountries.strname#" <cfif strCountry eq cfqgetCountries.strname>selected</cfif>>#cfqgetCountries.strname#</option>
											</cfloop>
		                            	</select>
									</div>
				
									<div class="span2">
										<a href="##" onClick="javascript:document.getElementById('intnlZipCode').style.display='none'; document.getElementById('USCanadaZipCode').style.display='block'; document.getElementById('USCAIntToggle').value=1;"><span id="uscaIntZipCodeToggle">U.S or Canadian?</span></a>
									</div>
								</div>
							</cfif>
							
							<cfif ArrayLen(liUserPhoneNumbers) gt 0>
								<input type="hidden" name="strPhoneNumber" value="#liUserPhoneNumbers[1][1]#">
							<cfelse>
								<div class="row-fluid">
									<div class="span4">
										<input tabindex="4" id="strPhoneNumber" name="strPhoneNumber" type="text" class="input input-small span12 requiredField" maxlength="19" placeholder="Phone Number" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 4, this);">
									</div>
								</div>
								<div class="page-spacer"><!--//--></div>
							</cfif>								
											
							
							
							<div class="page-spacer"><!--//--></div>
							<div class="row-fluid">
								<div class="span4">
									<h2>Privacy Setting</h2>
								</div>
							</div>
							
							<div class="row-fluid">
								<div class="span5">
		                        	<h5>Make My Profile &amp; resume...</h5>
		                            <select tabindex="5" name="intPrivacySetting" id="intPrivacySetting" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 5, this);" >
		                            <option value="">Choose one:</option>
									<option value="1" <cfif intPrivacySetting neq "4">selected</cfif>>Searchable</option>
									<option value="4" <cfif intPrivacySetting eq "4">selected</cfif>>Private</option>
		                            <!--- <option value="1" <cfif intPrivacySetting eq 1>selected</cfif>>Searchable by Employers & Recruiters</option>
		                            <option value="2" <cfif intPrivacySetting eq 2>selected</cfif>>Searchable by Employers Only</option>
		                            <option value="3" <cfif intPrivacySetting eq 3>selected</cfif>>Searchable by Recruiters Only</option>
		                            <option value="4" <cfif intPrivacySetting eq 4>selected</cfif>>Private to Employers & Recruiters</option> --->
		                            </select>                    
                    			</div>
							</div>
							<div class="page-spacer"><!--//--></div>
							
														
							<!--- Recent Positions --->
							<cfif ArrayLen(liUserExperience) gte 2 and len(liUserExperience[1][1]) gt 0 and len(liUserExperience[1][2]) gt 0 and len(liUserExperience[2][1]) gt 0 and len(liUserExperience[2][2]) gt 0>
								<input type="hidden"  name="strExecJobTitle_1" value="#liUserExperience[1][2]#">
								<input type="hidden"  name="strExecJOBCompany_1" value="#liUserExperience[1][1]#">
								<input type="hidden"  name="strExecJobTitle_2" value="#liUserExperience[2][2]#">
								<input type="hidden"  name="strExecJOBCompany_2" value="#liUserExperience[2][1]#">
							<cfelse>
								<div class="row-fluid">
									<div class="span12">
										<h2>What are your 2 most recent positions held? </h2>
									</div>
								</div>
			               		
								<div class="row-fluid">
									<div class="span0">1</div>
									
	                    			<div class="span4">
				                    	<input tabindex="6" class="span" type="text"  name="strExecJobTitle_1" value="#strExecJobTitle_1#" id="strExecJobTitle_1" placeholder="Most Recent Job Title" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 6, this);"  maxlength="48">
	                    			</div>
	                    			
									<div class="span0">@</div>
									
	                    			<div class="span4">
	                            		<input tabindex="7" class="span" type="text"  name="strExecJOBCompany_1" value="#strExecJOBCompany_1#" id="strExecJOBCompany_1" placeholder="Most Recent Company" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 7, this);"  maxlength="48">
	                    			</div> 
	                			</div>
								
						
								<div class="row-fluid">
									<div class="span0">2</div>
									
	                    			<div class="span4">
	                    			    <input tabindex="8" class="span" type="text"  name="strExecJobTitle_2" value="#strExecJobTitle_2#" id="strExecJobTitle_2" placeholder="Second Most Recent Job Title" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 8, this);"  maxlength="48">
	                    			</div>
	                    			
									<div class="span0">@</div>
																	
	                    			<div class="span4">
	                            		<input tabindex="9" class="span" type="text"  name="strExecJOBCompany_2" value="#strExecJOBCompany_2#" id="strExecJOBCompany_2" placeholder="Second Most Recent Company" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 9, this);"  maxlength="48">
	                    			</div> 
	                			</div>
															
								<div class="page-spacer"><!--//--></div>
							</cfif>
							
							<cfif application.sourceapp NEQ "SalesStars">
							<div class="page-spacer"><!--//--></div>
								<div class="row-fluid">
									<div class="span4">
										<h2>Compensation History&nbsp;&nbsp;<a href="##myModal" data-toggle="modal"><i class="icon-info-sign"></i></a></h2>
									</div>
								</div>
								
								<!-- List View Modal Begin -->
	                			<div class="modal hide fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					                <div class="modal-header">
				                    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
										<!--- 	<h4 id="myModalLabel">Example: How you will show up in search results.</h4> --->
				               		</div>
								
                  					<div class="modal-body">
									(a) This info is used for administrative pre-screening purposes for community inclusion.
									<br>
									(b) This info is displayed on your #application.applicationname# profile to recruiters.
									<br>
									(c) Other job seekers will NOT see this information.
	                  				</div>
	                			</div>
								<!-- List View Modal End -->
								
								<div class="row-fluid">                
									<div class="span4">
										<div id="fltCompPackageErrTxt">What was your highest salary (total compensation) earned?</div>
									</div>
									
									<div class="span4">
										<select tabindex="10"  name="fltCompensation_package" id="fltCompensation_package" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 10, this);" >
											<option value="">Highest salary earned:</option>
											<option value="69" <cfif fltCompensation_package is "69">selected</cfif>>Less than $70K</option>
											<option value="70" <cfif fltCompensation_package is "70">selected</cfif>>$70K - $99K</option>
											<cfloop index="LoopCnt" from="100" to="250" step="10">
											<option value="#LoopCnt#" <cfif LoopCnt eq fltCompensation_package>selected</cfif>>$#LoopCnt#K+</option>
											</cfloop>
											<cfloop index="LoopCnt" from="300" to="500" step="50">
											<option value="#LoopCnt#" <cfif LoopCnt eq fltCompensation_package>selected</cfif>>$#LoopCnt#K+</option>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="page-spacer"><!--//--></div>
								
								<div class="row-fluid">
									<div class="span4">
										<div><span class="label label-info">Optional</span> Use the box to share salary details or your current situation.
										Sharing your current compensation situation or requirements helps recruiters better match jobs that may be of interest to you.
										</div>
									</div>
								
									<div class="span4">
										<textarea tabindex="11" name="memoSalary_requirement" rows="5" cols="100" wrap="virtual"  style="width:385px; max-width:385px; height:100px; max-height:100px; resize:none; font-size:12px; font-style:italic;" onFocus="if(this.value==this.defaultValue){this.value='';}this.style.color='##333333';" onBlur="if(this.value==''){this.value=this.defaultValue;this.style.color='##333333';}; updateRegistrationStep(#session.exec.intresid#, 2, 11, this);">#memoSalary_requirement#</textarea>
									</div>
								</div>
								 <div class="page-spacer"><!--//--></div>			
							</cfif>
							
							
							<div class="row-fluid">
			                    <div class="span4">
                        			<h4>What is your desired job title?</h4>
								</div>
								
								<div class="span5">
									<input tabindex="12" class="span" type="text"  name="strDesiredJobTitle" value="#strDesiredJobTitle#" id="strDesiredJobTitle" placeholder="Ex. Director of Operations" class="input input-small span12 requiredField" maxlength="70" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 12, this);">
								</div>
				              	
				         	</div>
				           <div class="page-spacer"><!--//--></div>
							
							
							<div class="row-fluid">
                    			<div class="span4">
									<h4>## of Years Work Experience</h4>
			                   	</div>
							
                        		<div class="span5">
		                            <select tabindex="13" name="intYrsExp" id="intYrsExp" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 13, this);" >
			                        	<option value="">Choose One:</option>
			                            <cfloop index="LoopCnt" from="0" to="49" step="1">
			                            <option value="#LoopCnt#" <cfif LoopCnt eq intYrsExp>selected</cfif>>#LoopCnt#</option>
			                            </cfloop>
			                            <option value="50" <cfif intYrsExp eq 50>selected</cfif>>50+</option>
		                        	</select>
		                        </div>
        		            </div>
 							<div class="page-spacer"><!--//--></div>
				
							
							<!--- Industry & Function Experience --->
            	   			<!--- If the LinkedIn user does not have a Industry in their profile then map to the other industry --->
							<cfif not isDefined("session.exec.liUser.indsutry") >
								<input type="hidden" name="intsIndIDs" value="644">
							<cfelseif isDefined("session.exec.liUser.indsutry") and len("session.exec.liUser.indsutry") >
								<!--- Map the LinkedIn industry to the 6FJ Industry --->
								<cfquery name="cfqGetLi6FJIndMap" datasource="#application.dsn#">
								select * from tbl6FJLIIndustryMapping where strLIIndustryName = <cfqueryparam value="#session.exec.liUser.indsutry#" cfsqltype="cf_sql_varchar" />
								</cfquery>
								<cfif cfqGetLi6FJIndMap.recordcount gt 0>
									<input type="hidden" name="intsIndIDs" value="#valueList(cfqGetLi6FJIndMap.int6FJIndustryId)#">
								<cfelse>
									<input type="hidden" name="intsIndIDs" value="644">
								</cfif>
							<cfelse>
								<input type="hidden" name="intsIndIDs" value="644">
							</cfif>
							
							<!---Map the function to other by default --->
							<input type="hidden" name="intsFuncIDs" value="830">
							
							
							<!--- Education --->
							<cfif not ArrayLen(liUserEducation) gt 0>
								<div class="row-fluid">
									<div class="span6">
				           				<h4>Education</h4>
									</div>
								</div>

    	            			<cfloop index="i" from="1" to="5">
					                <cfset strHighestDegree = "strHighestDegree#i#">
					                <div class="row-fluid" id="addEducationSchool#i#" <cfif i lte 1 or  #evaluate(strHighestDegree)# neq "">style="display:block;"<cfelse>style="display:none;"</cfif>>
					                    <div class="span4">
					                   		<h5>Degree Earned:</h5>
					                        <select tabindex="14" name="strHighestDegree#i#" id="strHighestDegree#i#" onChange="disableSchool(#i#, this.selectedIndex);" onFocus="this.style.borderColor = '';" onBlur="if(this.selectedIndex==0){this.style.borderColor= '##F00';};<cfif i is 1>updateRegistrationStep(#session.exec.intresid#, 2, 16, this);</cfif>">
					                        <option value="">Choose One:</option>
					                        <option value="High School/GED" <cfif #evaluate(strHighestDegree)# eq "High School/GED">selected</cfif>>High School/GED</option>
					                        <option value="Some College" <cfif #evaluate(strHighestDegree)# eq "Some College">selected</cfif>>Some College</option>
					                        <option value="Associates Degree" <cfif #evaluate(strHighestDegree)# eq "Associates Degree">selected</cfif>>Associates Degree</option>
					                        <option value="BS/BA" <cfif #evaluate(strHighestDegree)# eq "BS/BA">selected</cfif>>BS/BA</option>
					                        <option value="Masters" <cfif #evaluate(strHighestDegree)# eq "Masters">selected</cfif>>Masters</option>
					                        <option value="Doctorate" <cfif #evaluate(strHighestDegree)# eq "Doctorate">selected</cfif>>Doctorate</option>
					                        <option value="Juris Doctorate" <cfif #evaluate(strHighestDegree)# eq "Juris Doctorate">selected</cfif>>Juris Doctorate</option>
					                        </select>
					                    </div>
					                    <cfset strSchool = "strSchool#i#">                    
				
					                    <div class="span6">
	                				   		<h5>School:</h5>
					                        <span class="school_searchform"><input tabindex="25" style="width:400px;" name="strSchool#i#" id="strSchool#i#" type="text" value="#evaluate(strSchool)#" autocomplete="off" onKeyUp="javascript:execSchoolAutoSuggest(event, 'strSchool#i#', #i#);" onFocus="document.getElementById('submitBtn').disabled=true;" onBlur="document.getElementById('submitBtn').disabled=false;"  maxlength="75"></span>                        
					                        <!---<div id="listselection_school" style="margin-left:60px; position:absolute;"><select size="5" style="display:none; width:415px;" onChange="fillSchool(this); return false;" multiple="" name="execSchoolresults#i#" id="execSchoolresults#i#"></select></div><cfif i gt 1><span id="removeDegEduText#i#" <cfif i lte 1>style="display:none;"</cfif>><a href="javascript:removeDegreeEduction(#i#)"><i class="icon-remove-circle"></i></a></span></cfif>--->
						                    <div id="listselection_school" style="margin-left:60px; position:absolute;"><select size="5" style="display:none; width:415px;" onChange="fillSchool(this); return false;" multiple="" name="execSchoolresults#i#" id="execSchoolresults#i#"></select></div><cfif i gt 1><span id="removeDegEduText#i#" <cfif i lte 1>style="display:none;"</cfif>><a href="javascript:void"><i class="icon-remove-circle"></i></a></span></cfif>
					                 	</div>    	                           
				               		</div>
	                			</cfloop>
                
	                			<div class="page-spacer"><!--//--></div>
	                			
								<div class="row-fluid" id="addDegreeSchool">
				                    <div class="span5">
					                    <a href="javascript:addDegreeEduction();"><i class="icon-plus-sign"></i>&nbsp;List Another Degree &amp; School</a>       		
				                    </div>
				               	</div>
 	               
								<div class="page-spacer"><!--//--></div>
							</cfif>					
							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							<!--- Learn365 Membership Start --->
							<cfinclude template="learn365Form.cfm">
							<!--- Learn365 Membership End --->
							<div class="page-spacer"><!--//--></div>
							
							<!---Member Email Subscriptions--->				
							<div class="row-fluid">
			                    <div class="span12">
                        			<h2>Member Email Subscriptions</h2>
									<h5>Please Note: We respect your privacy. Your email address will not be sold to any 3rd party. You may optout of these subscriptions at any time</h5>
								</div>
				         	</div>
							
							<div class="row-fluid">
                				<div class="span10">
				                    <div id="blnInHouseEmailErrTxt">Occasional updates about site improvements from our Community Manager (Recommended)</div>
			                    </div>
								<div class="span2">               
									<label class="radio inline"><input tabindex="15" type="radio" name="blnInHouseEmail" id="blnInHouseEmail" value="1" onClick="document.getElementById('blnInHouseEmailErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 17, this);" checked>Yes&nbsp;</label>
					                <label class="radio inline"><input tabindex="16" type="radio" name="blnInHouseEmail" id="blnInHouseEmail" value="0" onClick="document.getElementById('blnInHouseEmailErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 17, this);" >No</label>
			                  	</div>
							</div>
							<div class="page-spacer"><!--//--></div>
							
							
							<div class="row-fluid">
                				<div class="span10">
				                    <span id="blnNewsLetterErrTxt">Weekly #application.applicationname# Executive Newsletter (Recommended)</span>
			                    </div>
								<div class="span2">               
									<label class="radio inline"><input tabindex="17" type="radio" name="blnNewsLetter" id="blnNewsLetter" value="1" onClick="document.getElementById('blnNewsLetterErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 18, this);" checked>Yes&nbsp;</label>
					                <label class="radio inline"><input tabindex="18" type="radio" name="blnNewsLetter" id="blnNewsLetter" value="0" onClick="document.getElementById('blnNewsLetterErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 18, this);" >No</label>
			                  	</div>
							</div>            	
							<div class="page-spacer"><!--//--></div>
							
							<div class="row-fluid">
                				<div class="span10">
				                    <div id="blnEmailErrTxt">Matching Job Alerts and New Hiring Company Announcements (Recommended)</div>
			                    </div>
								<div class="span2">               
									<label class="radio inline"><input tabindex="19" type="radio" name="blnEmail" id="blnEmail" value="1" onClick="document.getElementById('blnEmailErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 19, this);" >Yes&nbsp;</label>
					                <label class="radio inline"><input tabindex="20" type="radio" name="blnEmail" id="blnEmail" value="0" onClick="document.getElementById('blnEmailErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 19, this);" >No</label>
			                  	</div>
							</div>            	
							<div class="page-spacer"><!--//--></div>
							
							
							<div class="row-fluid">
                				<div class="span10">
				                    <div id="blnSpecialOfferErrTxt">Special Offers from Career Sponsors &amp; Partners</div>
			                    </div>
								<div class="span2">               
									<label class="radio inline"><input tabindex="21" type="radio" name="blnSpecialOffer" id="blnSpecialOffer" value="1" onClick="document.getElementById('blnSpecialOfferErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 20, this);" >Yes&nbsp;</label>
					                <label class="radio inline"><input tabindex="22" type="radio" name="blnSpecialOffer" id="blnSpecialOffer" value="0" onClick="document.getElementById('blnSpecialOfferErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 20, this);" >No</label>
			                  	</div>
							</div>            	
							<div class="page-spacer"><!--//--></div>
							
							<input tabindex="23" class="btn btn-primary btn-large" type="submit" name="validate" id="submitBtn" value="SAVE &amp; CONTINUE">
			            	<div class="page-spacer"><!--//--></div>
			                
		                </div>
						
						
						</section>
				
						<div class="page-spacer"><!--//--></div>
		
					</div>
				</div>
			</div>
		</article>
	</div>
</form>
</cfoutput>