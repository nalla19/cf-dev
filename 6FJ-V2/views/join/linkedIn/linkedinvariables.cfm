<!--- <cfdump var="#session.exec.liUser#"> --->

<cfparam name="liUserCity" default="">
<cfparam name="liUserState" default="">
<cfparam name="liUserZipCode" default="">
<cfparam name="liUserCountry" default="">
<cfparam name="strCountry" default="">

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
				<cfset liUserExperience[i][3] = "">
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
				<cfset liUserExperience[i][5] = "Present">
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