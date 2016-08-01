<cfparam name="shortName" default="" />
<cfparam name="reNamedFile" default="" />
<cfparam name="uploadedFile" default="" />
<cfparam name="sovRenResumeID" default="">
<cfparam name="parsedResume" default="Could not get the resume from SovRen">
<cfparam name="parsedAddress" default="">
<!--- <cfparam name="session.exec.blnLearn365" default="0"> --->

<!---
<cfoutput>
<cfloop index="fieldName" list="#form.fieldnames#">
     #fieldName#=#Evaluate(fieldName)#<br />
</cfloop>
</cfoutput>
--->

<!--- URL Message Does Not Exists --->
<cfif not(len(url.message))>

	

	<cfquery name="cfqDelRecord" datasource="#application.dsn#">
		delete
		from tblResumeProfiles
		where fk_intresid = #intResID#

		delete
		from tblsecretQuestionAnswer
		where intResid = #intResID#

		delete tblResAtt
		where intResID = #intResID#
	</cfquery>


	<!---Privacy Setting --->
	<cfif intPrivacySetting eq 4>
		<cfset blnSearchable = 0 />
	<cfelse>
		<cfset blnSearchable = 1 />
	</cfif>
	<cfset intPostRecepient = intPrivacySetting />
	
	<cfif memoSalary_requirement contains "My current base salary is $135K; annual bonus 15% of base">
		<cfset memoSalary = "" />
	<cfelse>
		<!---Remove the single quotes and double quotes--->
		<!--- <cf_ct_removeQuotes strStrip="#memoSalary_requirement#" blnRemove="0"> --->
		<cfset strstrip = application.util.getRemoveQuotes(strStrip="#memoSalary_requirement#",  blnRemove="0")>
		<cfset memoSalary=strStrip />
	</cfif>
	
	<cfparam name="strIndNameList" default="">
	<cfif len(intsIndIDs)>
		<cfquery name="cfqGetIndName" datasource="#application.dsn#">
			select strIndName
			from tblIndustries (nolock)
			where intOldIndID in (#intsIndIDs#) order by intOldIndID asc
		</cfquery>
		<cfset strIndNameList = valueList(cfqGetIndName.strIndName) />
	</cfif>
	<cfparam name="strFuncNameList" default="">
	<cfif len(INTSFUNCIDS)>
		<cfquery name="cfqGetFuncName" datasource="#application.dsn#">
			select strFunctionName
			from tblFunctions (nolock)
			where intOldFunctionID in (#INTSFUNCIDS#) order by intOldFunctionID asc
		</cfquery>
		<cfset strFuncNameList = valueList(cfqGetFuncName.strFunctionName) />
	</cfif>
	
	<!---US Canada Toggle is Selected and --->
	<cfif USCAIntToggle is 1>
	
		<!---Validate the ZipCode to check against the US Database --->
		<cfquery name="cfqGetUSCityStateZipCode" datasource="#application.dsn#">
		select distinct zipcodes.city ipCity, zipcodes.state ipRegion, zipcodes.zipcode ipZipCode, 'United States' as ipCountry
	      from tbl_zipcodes_usa zipcodes(nolock) 
	     where 1=1
	       and (zipcodes.city like '#strUSCAZipCode#%' or zipcodes.zipcode like '#strUSCAZipCode#%')  
		</cfquery>
	
		<cfif cfqGetUSCityStateZipCode.recordcount is 1>
		
			<cfif strCity EQ "">
				<cfset strCity = cfqGetUSCityStateZipCode.ipCity>
			</cfif>
			<cfset strtempCity = REReplace(LCase(strCity), "(^[[:alpha:]]|[[:blank:]][[:alpha:]])", "\U\1\E", "ALL")>
	       	<cfset strCity = strtempCity>
			
			<cfif strState EQ ""> 
				<cfset strState = cfqGetUSCityStateZipCode.ipRegion>
			</cfif> 
			  
			<cfset tempStrState = strState>
			
			<cfquery name="cfqGetStateName" datasource="#application.dsn#">
			select strName from tblStates (nolock) where strAbbrev = <cfqueryparam value="#tempStrState#" cfsqltype="cf_sql_varchar" /> and strCountry = <cfqueryparam value="US" cfsqltype="cf_sql_varchar" />
			</cfquery>
		
			<cfif cfqGetStateName.strName neq "">
				<cfset strState = cfqGetStateName.strName>
			<cfelse>
				<cfset strState = tempStrState>
			</cfif>
		
			<cfset strZipCode = cfqGetUSCityStateZipCode.ipZipCode>
			
		<cfelse>
			<cfif isDefined("session.exec.liUser.mainAddress") and len(session.exec.liUser.mainAddress)>
				<cfset canadaZipCode = Right(session.exec.liUser.mainAddress, 7)>
				<cfquery name="cfqGetCanadaCityStateZipCode" datasource="#application.dsn#">
				select distinct zipcodes.city ipCity, zipcodes.province ipRegion, zipcodes.postalCode ipZipCode, 'Canada' as ipCountry
		          from tbl_zipcodes_canada zipcodes(nolock) 
		         where 1=1
		           and (zipcodes.city like '#strUSCAZipCode#%' or zipcodes.PostalCode like '#strUSCAZipCode#%')
				</cfquery>
		
				<cfif cfqGetCanadaCityStateZipCode.recordcount is 1>
				
					<cfset strCity = cfqGetCanadaCityStateZipCode.ipCity>
					<cfset strtempCity = REReplace(LCase(strCity), "(^[[:alpha:]]|[[:blank:]][[:alpha:]])", "\U\1\E", "ALL")>
		       		<cfset strCity = strtempCity>
				    
					<cfset tempStrState = cfqGetCanadaCityStateZipCode.ipRegion>
					<cfquery name="cfqGetStateName" datasource="#application.dsn#">
					select strName from tblStates (nolock) where strAbbrev = <cfqueryparam value="#tempStrState#" cfsqltype="cf_sql_varchar" /> and strCountry = <cfqueryparam value="CA" cfsqltype="cf_sql_varchar" />
					</cfquery>
		
					<cfif cfqGetStateName.strName neq "">
						<cfset strState = cfqGetStateName.strName>
					<cfelse>
						<cfset strState = templiUserState>
					</cfif>
				
					<cfset strZipCode = cfqGetCanadaCityStateZipCode.ipZipCode>
				
				</cfif>
			</cfif>	
		</cfif>
	</cfif>
	
	<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
		update tblResumes  set
			listCompletedSteps= '1,2',
			dteEdited= getdate(),
			showFname= 1,
			showLname= 1,
			showAddress= 1,
			blnFulltime= 1,
			blnContract= 1,
			blnStartup= 1,
			showEmail= 1,
			intAdmCode=1,
			blnValidated = 1,
			blnBigs=0,
			
			<!---City State Zip--->
			<cfif uscaIntToggle eq 1>
				city=<cfqueryparam value="#strCity#" cfsqltype="cf_sql_varchar" />,
				state=<cfqueryparam value="#strState#" cfsqltype="cf_sql_varchar" />,
				zip=<cfqueryparam value="#strUSCAZipCode#" cfsqltype="cf_sql_varchar" />,
				showCity= 1,
				showState= 1,
				showZip= 1,
			<cfelse>
				city=<cfqueryparam value="#strIntntlCity#" cfsqltype="cf_sql_varchar" />,
				state=<cfqueryparam value="#strCountry#" cfsqltype="cf_sql_varchar" />,
				showCity= 1,
				showState= 1,
				showZip= 1,
			</cfif>
			
			<!---Phone Numbers--->
			showworkphone = 1,
			showMobilePhone= 1,
			showHomePhone= 1,
			mobile_phone= '#strPhoneNumber#',
			home_phone= '#strPhoneNumber#',
			work_phone = '#strPhoneNumber#',

			<!---Privacy Setting--->
			blnSearchable= #blnSearchable#,
			intPostRecepient=#intPostRecepient#,

			<!---Recent Positions--->
			strExecJobTitle_1= '#Left(strExecJobTitle_1,49)#',
			strExecJOBCompany_1= '#Left(strExecJOBCompany_1,49)#',
			strExecJobTitle_2= '#Left(strExecJobTitle_2,49)#',
			strExecJOBCompany_2= '#Left(strExecJOBCompany_2,49)#',
			
			<!---Desired Job Title--->
			strDesiredJobTitle = '#Left(strDesiredJobTitle,70)#',
			
			<!---Compensation--->
			showCompensation= 1,
			<cfif isDefined("fltCompensation_package") AND len(fltCompensation_package)>
				fltCompensation_package = #fltCompensation_package#,
			</cfif>
			<cfif memoSalary neq "">
				memoSalary_requirement = '#memoSalary#',
			</cfif>
			
			<!---Work Experience--->
			intYearsExperience= #intYrsExp#,
			
			<!---Industries--->
			strCats= '#strIndNameList#',
			
			<!---Functions--->
			strFuncs= '#strFuncNameList#',
			
			
			<!---Member Email Subscriptions--->
			blnInHouseEmail=#blnInHouseEmail#,
			blnNewsletter=#blnNewsletter#,
			blnEmail=#blnEmail#,
			
			<!---Site Visit JobID--->
			<cfif isDefined("session.exec.intsitevisitjobid") and session.exec.intsitevisitjobid neq "">
			intSiteVisitJobID = #session.exec.intsitevisitjobid#,
			</cfif>
			
			<!---Site Registration JobID--->
			<cfif isDefined("session.exec.jaQintJobID") and session.exec.jaQintJobID neq "">
			intSiteRegJobID = #session.exec.jaQintJobID#,
			</cfif>
			
			<!---Registration Methhod--->
			strRegistrationMethod = '#application.sourceApp#',
			
			blnSpecialOffer=#blnSpecialOffer#
		where intResid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
	</cfquery>

	<!---Create a Starter JSA Based on the desired Job Title--->
	<cfif len(strDesiredJobTitle)>
		<cfset keywords = strDesiredJobTitle>
		<cfset keywords = Replace(keywords, "$$SQ$$", "", "all")>
	    <cfset keywords = Replace(keywords, "$$DQ$$", "", "all")>
		
		<cfset strAgentTitle = Left(keywords, 49)>
		<cfquery datasource="#application.dsn#">
        insert into tblSearchAgent ( intResID, dteEdited, strTitle, strKeyWords, blnFulltime, blnContract, blnStartup, strSearchType, dteCreated, blnEmailAgent, blnProcessedToday, blnWeekly, intJobTitleSearch, strSkills, strLocation )
                            values ( <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />, getdate(), <cfqueryparam value="#strAgentTitle#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="#keywords#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="0" cfsqltype="cf_sql_integer" />, <cfqueryparam value="0" cfsqltype="cf_sql_integer" />, <cfqueryparam value="0" cfsqltype="cf_sql_integer" />, <cfqueryparam value="broad" cfsqltype="cf_sql_varchar" />, getdate(), <cfqueryparam value="1" cfsqltype="cf_sql_integer" />, <cfqueryparam value="0" cfsqltype="cf_sql_integer" />, <cfqueryparam value="1" cfsqltype="cf_sql_integer" />, <cfqueryparam value="0" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#keywords#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="Any Location" cfsqltype="cf_sql_varchar" /> )
        </cfquery>	
	</cfif>
		
	<!---Insert the Industry IDs into the table tblResAtt--->
	<cfloop list="#intsIndIDs#" index="intIndID" delimiters=",">
		<cfquery name="cfqInsIndID" datasource="#application.dsn#">
			insert into tblResAtt(intResId, intAttID)
			values (#intResID#, #intIndID#)
		</cfquery>
	</cfloop>
	
	<!---Insert the Function IDs into the table tblResAtt--->
	<cfloop list="#intsFuncIDs#" index="intFuncID" delimiters=",">
		<cfquery name="cfqInsFuncID" datasource="#application.dsn#">
			insert into tblResAtt(intResId, intAttID)
			values (#intResID#, #intFuncID#)
		</cfquery>
	</cfloop>
	
	<!---Delete the previous entries---->
	<cfquery name="cfqDelDegreeCollege" datasource="#application.dsn#">
		delete
		from tblResDegreeUniversity
		where intResID = #intResID#
	</cfquery>
	
	<!---Insert the Education into tblResDegreeUniversity--->
	<!---Degree1--->
	<cfif STRHIGHESTDEGREE1 neq "">
		<cfif STRSCHOOL1 neq "">
			<!---Insert the record--->
			<cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
				values(#intResID#, '#STRHIGHESTDEGREE1#', '#STRSCHOOL1#')
			</cfquery>
			<!---No School--->
		<cfelse>
			<!---  ---><cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree)
				values(#intResID#, '#STRHIGHESTDEGREE1#')
			</cfquery>
		</cfif>
	</cfif>
	
	<!---Degree2--->
	<cfif STRHIGHESTDEGREE2 neq "">
		<cfif STRSCHOOL2 neq "">
			<!---Insert the record--->
			<cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
				values(#intResID#, '#STRHIGHESTDEGREE2#', '#STRSCHOOL2#')
			</cfquery>
			<!---No School--->
		<cfelse>
			<!--- ---><cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree)
				values(#intResID#, '#STRHIGHESTDEGREE2#')
			</cfquery> 
		</cfif>
	</cfif>
	
	<!---Degree3--->
	<cfif STRHIGHESTDEGREE3 neq "">
		<cfif STRSCHOOL3 neq "">
			<!---Insert the record--->
			<cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
				values(#intResID#, '#STRHIGHESTDEGREE3#', '#STRSCHOOL3#')
			</cfquery>
			<!---No School--->
		<cfelse>
			<!--- ---><cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree)
				values(#intResID#, '#STRHIGHESTDEGREE3#')
			</cfquery> 
		</cfif>
	</cfif>
	
	<!---Degree4--->
	<cfif STRHIGHESTDEGREE4 neq "">
		<cfif STRSCHOOL4 neq "">
			<!---Insert the record--->
			<cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
			values(#intResID#, '#STRHIGHESTDEGREE4#', '#STRSCHOOL4#')
			</cfquery>
			<!---No School--->
		<cfelse>
			<!--- ---><cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree)
				values(#intResID#, '#STRHIGHESTDEGREE4#')
			</cfquery> 
		</cfif>
	</cfif>
	
	<!---Degree5--->
	<cfif STRHIGHESTDEGREE5 neq "">
		<cfif STRSCHOOL5 neq "">
			<!---Insert the record--->
			<cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
				values(#intResID#, '#STRHIGHESTDEGREE5#', '#STRSCHOOL5#')
			</cfquery>
			<!---No School--->
		<cfelse>
			<!--- ---><cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResDegreeUniversity (intResID, strDegree)
				values(#intResID#, '#STRHIGHESTDEGREE5#')
			</cfquery> 
		</cfif>
	</cfif>
    
	<!-----//Process the Education----->
	
	
	
	
	
	<cfif isdefined("blnLearn365") and blnLearn365 eq 1>
		<!--- if interested in L365 go to step3 --->
		<cflocation url="/join-step3?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#&learn3=1" addtoken="no">
	<cfelse>
    	<cflocation url="/join-step3?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#" addtoken="no">
	</cfif>
</cfif>