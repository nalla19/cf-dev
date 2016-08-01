<cfparam name="shortName" default="" />
<cfparam name="reNamedFile" default="" />
<cfparam name="uploadedFile" default="" />
<cfparam name="sovRenResumeID" default="">
<cfparam name="parsedResume" default="Could not get the resume from SovRen">
<cfparam name="parsedAddress" default="">
<!--- <cfparam name="session.exec.blnLearn365" default="0"> --->

<cfparam name="blnInHouseEmail" default=1>
<cfparam name="blnNewsletter" default=1>
<cfparam name="blnEmail" default=0>
<cfparam name="blnSpecialOffer" default=0>

<!---
<cfoutput>
<cfloop index="fieldName" list="#form.fieldnames#">
     #fieldName#=#Evaluate(fieldName)#<br />
</cfloop>
</cfoutput>
--->
<cfscript>
uploadedPath = "C:\webroot\6figurejobs\exports\";
</cfscript>

<!-------------------------------------------------------------------------------------------->
<!-----Upload the Resumes to the Exports Directory and also upload it the Sovren database----->
<!-------------------------------------------------------------------------------------------->
<cfset shortName = randrange(100,100000) & ".doc">
<cfset destinationFileName="#uploadedPath#\#shortName#">
<cffile action="copy" source="#resumeFilePathAndName#" destination="#destinationFileName#">

<cfset uploadedFile = destinationFileName />
<cfset sovRenResumeID = application.executive.getStoredResumeID(resumeFile=uploadedFile,resumePath=uploadedPath) />


<cfif sovRenResumeID does not contain ("ERROR")>

<!-------------------------------------------------------------------------------------------->
<!----//Upload the Resumes to the Exports Directory and also upload it the Sovren database---->
<!-------------------------------------------------------------------------------------------->

<!--- URL Message Does Not Exists --->
<cfif not(len(url.message))>
	<!---
	Update the following on the users profile since the intResID is already created for the user
	1. Get the name of the resume that user uploaded during the registration process and update the tblResumes and tblResumeProfiles
	2. Update the form field information
	--->

	<cfif isdefined("uploadedFile") and len(uploadedFile)>
		<!--- Create Folder if Needed --->
		<cftry>
			<cfscript>
				resObj = application.resume;
				resObj.setResumePath(intResid);
				//Files Uploaded Here
				resumeDirectory = resObj.getResumeDir(intResid);
				resumePath = resObj.getResumePath(intResid);
				copyFile =  uploadedPath & shortName;
			</cfscript>

			<cfif fileExists(copyFile)>
				<!--- Copy Source File if Directory Exists --->
				<cfif directoryExists(resumeDirectory)>
					<cffile action="copy" destination="#resumeDirectory#" source="#copyFile#">
				</cfif>

				<cfquery datasource="#application.dsn#">
					update tblResumes set
						resumeFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#" />
					where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
				</cfquery>
			</cfif>

			<cfcatch type="any">
			<!---Log the error to the cflog file--->
			</cfcatch>
		</cftry>
	</cfif>
	<!----End: Upload the initial resume upload--->


	<!---
	<!--- Allen Leads --->
	<cfif blnSignUpForAAA eq "1">
		<cftry>
			<cfquery datasource="#strSixFigData#">
				insert into tblAAABatch (intresid, dateStamp, optinStep, regComplete)
				values (#intResID#,getDate(), 1, 0)
			</cfquery>
			<cfcatch type="any"></cfcatch>
		</cftry>
	</cfif>
	--->

	<!--- Resume Was Parsed, update the resume content on step1 --->
	<cfif len(sovRenResumeID)>
		<cfset consultants = application.executive.getParsedConsultants(consultantid=sovRenResumeID) />
		<cfset parsedResume = consultants.resume />
		<cfset parsedResume = ReReplace(parsedResume, "Print Clean Clean ", "", "ALL")>
		
		<cfset parsedAddress = consultants.address1 />
		
		<cfif len(parsedResume)>
			<!---Update the Username for this intResID as the procedure sp_exec_registration does not update the username--->
			<cfquery name="cfqUpdResume" datasource="#application.dsn#">
				update tblresumes set
					resume=<cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
				where intresid = #intResID#
			</cfquery>
		</cfif>
	</cfif>

	<!---
	sovRenResumeID=#sovRenResumeID#<br><cfloop index="field" list="#form.fieldnames#">#field#=#evaluate(field)#<br></cfloop>
	--->

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
	<cfif USCAIntToggle is 1 and (liUserCity is "" and liUserState is "")>
	
		<!---Validate the ZipCode to check against the US Database --->
		<cfquery name="cfqGetUSCityStateZipCode" datasource="#application.dsn#">
		select distinct zipcodes.city ipCity, zipcodes.state ipRegion, zipcodes.zipcode ipZipCode, 'United States' as ipCountry
	      from tbl_zipcodes_usa zipcodes(nolock) 
	     where 1=1
	       and (zipcodes.city like '#strUSCAZipCode#%' or zipcodes.zipcode like '#strUSCAZipCode#%')  
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
				</cfif>
			</cfif>
		</cfif>	
	</cfif>
	
	<cfset strExecJobTitle_1 	= Left(strExecJobTitle_1, 49)>
	<cfset strExecJOBCompany_1 	= Left(strExecJOBCompany_1, 49)>
	<cfset strExecJobTitle_2 	= Left(strExecJobTitle_2, 49)>
	<cfset strExecJOBCompany_2 	= Left(strExecJOBCompany_2, 49)>
			
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
			blnBigs=1,
			
			<!---City State Zip--->
			<cfif uscaIntToggle eq 1>
				<cfif isDefined("liUserCity") and len(liUserCity)>
				city=<cfqueryparam value="#liUserCity#" cfsqltype="cf_sql_varchar" />,
				</cfif>
				
				<cfif isDefined("liUserState") and len(liUserState)>
				state=<cfqueryparam value="#liUserState#" cfsqltype="cf_sql_varchar" />,
				</cfif>
				
				<cfif isDefined("strUSCAZipCode") and len(strUSCAZipCode)>
				zip=<cfqueryparam value="#strUSCAZipCode#" cfsqltype="cf_sql_varchar" />,
				</cfif>
				showCity= 1,
				showState= 1,
				showZip= 1,
			<cfelse>
				<cfif isDefined("strIntntlCity") and len(strIntntlCity)>
				city=<cfqueryparam value="#strIntntlCity#" cfsqltype="cf_sql_varchar" />,
				</cfif>
				<cfif isDefined("strCountry") and len(strCountry)>
				state=<cfqueryparam value="#strCountry#" cfsqltype="cf_sql_varchar" />,
				</cfif>
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
			strExecJobTitle_1= '#strExecJobTitle_1#',
			strExecJOBCompany_1= '#strExecJOBCompany_1#',
			strExecJobTitle_2= '#strExecJobTitle_2#',
			strExecJOBCompany_2= '#strExecJOBCompany_2#',
			
			<!---Desired Job Title--->
			strDesiredJobTitle = '#strDesiredJobTitle#',
			
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
			strRegistrationMethod = 'LinkedIn',
			
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
	
	<cfset resumeTitle = "#strFname##strLName#-LinkedInProfile">
	
	<cfquery name="cfqInsRecord" datasource="#application.dsn#">
		insert into tblResumeProfiles(fk_intresid, blnactive, dteCreated, dteEdited, title, resumeFile, consIntID)
		values (#intResID#, 1, getdate(), getdate(),'#resumeTitle#', '#shortName#', '#sovRenResumeID#')

		update tblResumeProfiles set
			resume=<cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
		where fk_intresid = #intResID#
	</cfquery>
	
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
	
	
	<!------Process the Education------>
	<cfif isDefined("session.exec.liUserEducation") and ArrayLen(session.exec.liUserEducation) gt 0>
		<!---Add the Degree--->
		
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
				<cfquery name="cfqInsRecord" datasource="#application.dsn#">
					insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
					values(#intResID#, '#strDegree#', '#strUniversity#')
				</cfquery>
			<cfelseif len(strDegree) and not len(strUniversity)>
				<cfquery name="cfqInsRecord" datasource="#application.dsn#">
					insert into tblResDegreeUniversity (intResID, strDegree)
					values(#intResID#, '#strDegree#')
				</cfquery>
			</cfif>
			
		</cfloop>
			
	<cfelse>
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
				<cfquery name="cfqInsRecord" datasource="#application.dsn#">
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
				<cfquery name="cfqInsRecord" datasource="#application.dsn#">
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
				<cfquery name="cfqInsRecord" datasource="#application.dsn#">
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
				<cfquery name="cfqInsRecord" datasource="#application.dsn#">
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
				<cfquery name="cfqInsRecord" datasource="#application.dsn#">
					insert into tblResDegreeUniversity (intResID, strDegree)
					values(#intResID#, '#STRHIGHESTDEGREE5#')
				</cfquery>
			</cfif>
		</cfif>
    </cfif>
	<!-----//Process the Education----->
	
	
	<!------Process the Social Media----->
	<cfif isDefined("session.exec.liUser.publicProfileUrl") and len(session.exec.liUser.publicProfileUrl)>
		<cfquery name="cfqUpdLIProfile" datasource="#application.dsn#">
			insert into tblResumesWebSites (intWebSiteCategoryID, intResID, strResumeWebSiteName, strResumeWebSiteURL)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="8" />, <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />, <cfqueryparam cfsqltype="cf_sql_varchar" value="LinkedIn" />, <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.exec.liUser.publicProfileUrl#" />)
		</cfquery>
	</cfif>
	<!-----//Process the social Media---->
	
  
	
		<cfif isdefined("blnLearn365") and blnLearn365 eq 1>
			<!--- if interested in L365 go to step3 --->
			<cflocation url="/join-step3?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#&learn3=1" addtoken="no">
		<cfelse>
			<cflocation url="/join-step3?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#" addtoken="no">
		</cfif>
        <cfabort />

</cfif>
<cfelse>
			<div class="page-spacer"></div>
			<div class="container">
			<div class="row">
				<div class="alert alert-error span12" id="displaySave_account">
					<button type="button" class="close" data-dismiss="alert">&times;</button>
					<strong>Resume Upload</strong><br>There was an issue uploading your resume from LinkedIn. Please try again. 
					<p>If this issue continues, please contact our support team for assistance.</p>
				</div>
			</div>
		</div>

</cfif>