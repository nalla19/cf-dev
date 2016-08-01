<cfif form.intPrivacySetting eq 4>
	<cfset blnSearchable = 0>
<cfelse>
    <cfset blnSearchable = 1>
</cfif>
<cfset intPostRecepient = form.intPrivacySetting>

<cfparam name="memoSalary" default="">
<cfif isDefined("form.memoSalary_requirement")>
	<cfif form.memoSalary_requirement contains "My current base salary is $135K; annual bonus 15% of base">
		<cfset memoSalary = "">
	<cfelse>
	    <!---Remove the single quotes and double quotes--->
	    <!--- <cf_ct_removeQuotes strStrip="#form.memoSalary_requirement#" blnRemove="0">
	    <cfset memoSalary=strStrip> --->
		<cfset memoSalary= "#form.memoSalary_requirement#">
	</cfif>
</cfif>


<cfquery name="cfqGetIndName" datasource="#application.dsn#">
	select strIndName
	from tblIndustries (nolock)
	where intOldIndID in (#intsIndIDs#)
	order by intOldIndID asc
</cfquery>
<cfset strIndNameList = valueList(cfqGetIndName.strIndName)>


<cfquery name="cfqGetFuncName" datasource="#application.dsn#">
	select strFunctionName
	from tblFunctions (nolock)
	where intOldFunctionID in (#INTSFUNCIDS#)
	order by intOldFunctionID asc
</cfquery>
<cfset strFuncNameList = valueList(cfqGetFuncName.strFunctionName)>



<!---Start: Relocation--->
<cfset stateIDList = "">
<cfif isDefined("form.blnrelocate") and form.blnrelocate is 1>
    <cfset relocateLocation = form.FORM_Q_NST>
    <cfloop list="#relocateLocation#" index="relocState" delimiters=",">
        <cfquery name="cfqGetStateID" datasource="#application.dsn#">
        	select intOldID
			from tblStates (nolock)
			where strName = '#relocState#'
        </cfquery>
        <cfif  cfqGetStateID.recordcount gt 0>
            <cfset stateIDList = ListAppend(stateIDList, "#cfqGetStateID.intOldID#", ",")>
        </cfif>
    </cfloop>
<cfelse>
	<cfset stateIDList = "">
</cfif>
<!---End: Relocation--->


<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
	update tblResumes set
				fname='#form.strFName#',
				lname='#form.strLName#',
				dteEdited= getdate(),
				zip= '#form.execlocation#',
				city= '#form.strCity#',
				state= '#form.strState#',
				home_phone= '#form.strHomePhone#',
				mobile_phone= '#form.strMobilePhone#',
				UserName = '#form.strUserName#',
				Password = '#form.strPasswd#',
                email = '#form.strEmail#',
				relocate = '#form.blnRelocate#',
				<cfif len(stateIDList)>
					location_preference = '#stateIDList#',
				<cfelse>
					location_preference = NULL,
				</cfif>
				blnSearchable= #blnSearchable#,
				intPostRecepient=#intPostRecepient#,
				strExecJobTitle_1= '#form.strExecJobTitle_1#',
				strExecJOBCompany_1= '#form.strExecJOBCompany_1#',
				strExecJobTitle_2= '#form.strExecJobTitle_2#',
				strExecJOBCompany_2= '#form.strExecJOBCompany_2#',
				strDesiredJobTitle = '#form.strDesiredJobTitle#',
                
                <cfif isDefined("form.fltCompensation_package")>
				fltCompensation_package = #form.fltCompensation_package#,
                </cfif>
                
				<cfif memoSalary neq "">
					memoSalary_requirement = '#memoSalary#',
				</cfif>
				strCats= '#strIndNameList#',
				strFuncs= '#strFuncNameList#',
				intYearsExperience= #form.intYrsExp#,
				blnNewsletter=#form.blnNewsletter#,
				<!---blnEvents=#form.blnEvents#,--->
				blnSpecialOffer=#form.blnSpecialOffer#,
				blnInHouseEmail=#form.blnInHouseEmail#,
				blnEmail=#form.blnEmail#
	where intResid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
</cfquery>

<!--- update Litmos if userid is available & they are an active litmos user --->
<cfif isDefined("session.EXEC.isLearn365Active") and session.EXEC.isLearn365Active>
	<cfset learn365Username = form.strEmail>
	<cfset learn365FirstName = form.strFName>
	<cfset learn365LastName = form.strLName>
	<cfset learn365UserId = session.EXEC.learn365UserID>
	<cfset learn365Active = session.EXEC.isLearn365Active>
	
	<cfinclude template="../learn365/api/updateUser.cfm">
</cfif>

<cfscript>
session.EXEC.strEmail=form.strEmail;
session.EXEC.blnSearchable=blnSearchable;
session.EXEC.strCity=form.strCity;
session.EXEC.strState=form.strState;
session.EXEC.strZip=form.execlocation;		
session.EXEC.strHomePhone=form.strHomePhone;
session.EXEC.strMobilePhone=form.strMobilePhone;
session.EXEC.strExecJOBTitle_1=form.strExecJobTitle_1;
session.EXEC.strExecJOBCompany_1=form.strExecJOBCompany_1;
session.EXEC.strExecJOBTitle_2=form.strExecJobTitle_2;
session.EXEC.strExecJOBCompany_2=form.strExecJOBCompany_2;
session.EXEC.strFirstName= form.strFName;
session.EXEC.strLastName= form.strLName;
session.exec.dteEdited = NOW();

</cfscript>

<!--- //Update all references to the email address// --->
<cfif form.strEmail neq session.exec.strEmail>
	<cfset strNewEmail = form.strEmail>
    <cfset strOldEmail = session.exec.strEmail>
    
	<!---Update the 6FJ Backend---->
    <cfif session.EXEC.strUN eq session.exec.strEmail>
	    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
	    update tblResumes set email='#strNewEmail#', username='#strNewEmail#' where email='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
	    </cfquery>
    
    	<cfquery name="cfqUpdRes" datasource="#application.dsn#">
	    update tblResumesRecent set email='#strNewEmail#', username='#strNewEmail#' where email='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
	    </cfquery>
   	<cfelse>
    	<cfquery name="cfqUpdRes" datasource="#application.dsn#">
	    update tblResumes set email='#strNewEmail#' where email='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
	    </cfquery>
    
    	<cfquery name="cfqUpdRes" datasource="#application.dsn#">
	    update tblResumesRecent set email='#strNewEmail#' where email='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
	    </cfquery>
    </cfif>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblExecCompensation set email='#strNewEmail#' where email='#strOldEmail#'
    </cfquery>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblExecNewsletter set email='#strNewEmail#' where email='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
    </cfquery>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblJSAsStrongmail set email='#strNewEmail#' where email='#strOldEmail#'
    </cfquery>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblJSAsStrongmail2 set email='#strNewEmail#' where email='#strOldEmail#'
    </cfquery>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblNewsDistribution set email='#strNewEmail#' where email='#strOldEmail#'
    </cfquery>

    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblResumeArchive set email='#strNewEmail#' where email='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
    </cfquery>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblCPLLeadInfo set strEmail='#strNewEmail#' where strEmail='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
    </cfquery>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblExNewsletter set strEmail='#strNewEmail#' where strEmail='#strOldEmail#'
    </cfquery>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblVerifications set strEmail='#strNewEmail#' where strEmail='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
    </cfquery>

    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblVizibility set strEmail='#strNewEmail#' where strEmail='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
    </cfquery>

    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblBOALogs set strEmail='#strNewEmail#' where strEmail='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
    </cfquery>
    
    <cfquery name="cfqUpdRes" datasource="#application.dsn#">
    update tblMBAResume set strEmail='#strNewEmail#' where strEmail='#strOldEmail#' and intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
    </cfquery>
    
    <cfif application.sourceApp EQ "6FigureJobs">
		<!--- //Remove the candidate from the NewsLetter List// --->
        <cfset application.leadFormixManager.removeContact( list_name='Seeker Newsletter Opt In List 10-21-13', list_type='Newsletter', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com',
                                                            contact_email='#strOldEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
																													
		<!--- //Remove the candidate from the Special Offer List// --->
        <cfset application.leadFormixManager.removeContact( list_name='Seeker Special Offer Opt In List 11-06-13', list_type='Commercial', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com',
                                                            contact_email='#strOldEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
  
    </cfif>
    
    <!--- //Finally change the session variable value for the email address// --->
    <cfset session.exec.strEmail =  form.strEmail>
    
    <!--- //Add the email to the Lyris Lists// --->
    <cfset currClientID = session.exec.intResID>
    <cfif application.sourceApp EQ "6FigureJobs">
		<!--- Add the record to Lyris lists --->
		<!---Lyris Process to add the candidate to the Candidate List, Executive Newsletter List, Exclusive Email List--->
	   <!--- ISR <cfinclude template="Lyris/addResumeToLyrisLists.cfm"> --->
	</cfif>
</cfif>


<cfif application.sourceApp EQ "6FigureJobs">
	<!--- //Add the contact to the newsletter if the candidate opted in to the newsletter// --->
    <cfif form.blnNewsletter is 1>
        <cfset application.leadFormixManager.addContact(list_name='Seeker Newsletter Opt In List 10-21-13', list_type='Newsletter', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com', 
                                                        contact_email='#form.strEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
                                                        
    <!--- //Remove the contact from the newsletter if the candidate opted out of the newsletter// --->
    <cfelseif form.blnNewsletter is 0>
        <cfset application.leadFormixManager.removeContact( list_name='Seeker Newsletter Opt In List 10-21-13', list_type='Newsletter', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com',
                                                            contact_email='#form.strEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
    </cfif>
	
	
	<!--- //Add the contact to the Special Offer if the candidate opted in to the Special Offer// --->
    <cfif form.blnSpecialOffer is 1>
        <cfset application.leadFormixManager.addContact(list_name='Seeker Special Offer Opt In List 11-06-13', list_type='Commercial', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com', 
                                                        contact_email='#form.strEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
                                                        
    <!--- //Remove the contact from the newsletter if the candidate opted out of the newsletter// --->
    <cfelseif form.blnSpecialOffer is 0>
        <cfset application.leadFormixManager.removeContact( list_name='Seeker Special Offer Opt In List 11-06-13', list_type='Commercial', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com',
                                                            contact_email='#form.strEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
    </cfif>
	
</cfif>


<cflock scope="session" timeout="10">
	<cfscript>
		session.EXEC.blnSearchable = blnSearchable;
		session.Exec.strExecJOBTitle_1 = form.strExecJobTitle_1;
		session.Exec.strExecJOBCompany_1 = form.strExecJobCompany_1;
		session.Exec.strExecJOBTitle_2 = form.strExecJobTitle_2;
		session.Exec.strExecJOBCompany_2 = form.strExecJobCompany_2;
	</cfscript>
</cflock>

<!---If the resume has been marked private, delete the resume from the Solr Index--->
<cfif not(blnSearchable)>
	
	<!---01/09/2013
	<cfscript>
	solr =  createObject("component","/com/solr/SolColdfusion");
	solr.init(application.SOLRResumeServer, application.SOLRresumeServerPort,"/solr/candidates");
	result = XmlParse(solr.deleteById(session.exec.intresid));
	commit = XmlParse(solr.commit());
	</cfscript>
	--->
    
<!---Else add the resume to the Solr Index--->
<cfelse>
	<cfquery name="cfqGetResumes" datasource="#application.dsn#">
		select res.intresid, res.dteSubmitted, res.dteEdited, res.email, res.resume, res.resumeFile, prof.pk_managerid, prof.consIntID
		from tblResumes res (nolock)
			inner join tblresumeprofiles prof (nolock) on prof.fk_intresid = res.intResID
		where 1=1
		and prof.blnactive = 1
		and prof.fk_intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
	</cfquery>

	<cfset intResID = cfqGetResumes.intresID>
	<cfset dteCreated = cfqGetResumes.dteSubmitted>
	<cfset dteEdited = cfqGetResumes.dteEdited>
	<cfset resume =  cfqGetResumes.resume>
	<cfset resumeFile = cfqGetResumes.resumeFile>
	<cfset email = cfqGetResumes.email>
	<cfset pkManagerID = cfqGetResumes.pk_managerid>
	<cfset SovrenConsultantID = cfqGetResumes.consIntID>

	<!---If there is no parsed resume for this record, parse the resume--->
	<cfif not len(SovrenConsultantID)>
		<cfset currClientID = session.exec.intresid>
		<!--- <cfinclude template = "parseResume.cfm"> --->
		<!---Coming from the profile save and the resume manager--->
		<cfif isDefined("session.exec.intresid") and session.exec.intresid neq "">
			<cfset intresume_id = session.exec.intresid>
		<!---coming from the resume approval bin--->
		<cfelseif isDefined("currClientID") and currClientID neq "">
			<cfset intresume_id = currClientID>
		<cfelse>
			<cfset intresume_id = "">
		</cfif>
		
		<cfif intresume_id neq "">
			<cftry>
				<cfquery name="cfqGetResumes" datasource="#application.dsn#">
				select res.intresid, res.dteSubmitted, res.dteEdited, res.email, res.resume, res.resumeFile, prof.pk_managerid
				  from tblResumes res (nolock) 
				 inner join tblresumeprofiles prof (nolock)
					on prof.fk_intresid = res.intResID
				 where 1=1
				   and prof.blnactive = 1
				   and prof.fk_intresid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#intresume_id#">
				</cfquery>
				
				<cfset intResID = cfqGetResumes.intresID>
				<cfset dteCreated = cfqGetResumes.dteSubmitted>
				<cfset dteEdited = cfqGetResumes.dteEdited>
				<cfset resume =  cfqGetResumes.resume>
				<cfset resumeFile = cfqGetResumes.resumeFile>
				<cfset email = cfqGetResumes.email>
				<cfset pkManagerID = cfqGetResumes.pk_managerid>
				
				<cfparam name="uploadedFile" default="" />
				<cfscript>
				//Assume Parsing Is OK --->
				inValidParse = 1;
				uploadedPath = application.sixfj.paths.webroot & "exports\";
				</cfscript>
							   
				<cfset uploadedFile = uploadedPath & createUUID() & ".txt" />
				<cffile action="write" addnewline="no" file="#uploadedFile#" output="#cfqGetResumes.resume#" fixnewline="no"> 
				<!--- Parse Text --->
							
				<cfscript>
				SovrenConsultantID = application.executive.getStoredResumeID('#uploadedFile#', '#uploadedPath#');
				</cfscript>
					
				<!---update the tblResumeProfiles with the consIntID--->
				<cfquery name="cfqUpdResProfiles" datasource="#application.dsn#">
				update tblResumeProfiles set consIntID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SovrenConsultantID#"> where fk_intResID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#intResID#"> and pk_managerID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkManagerID#">
				</cfquery>
			
				<!---update the Sovren database with the Email1--->
				<cfquery name="cfqUpdResProfiles" datasource="#application.dsn#">
				update Sovern2000.dbo.Consultants set email1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#"> where ConsIntID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SovrenConsultantID#"> 
				</cfquery>
				
				<cfcatch type="any">
					<cfmail to="vnalla@calliduscloud.com,irodella@calliduscloud.com" from="webmaster@6figurejobs.com" subject="Issue with Professional/profile/parseresume.cfm">
					#cfcatch.Detail#
					<br />
					#cfcatch.Message#
					</cfmail>
				</cfcatch>
			</cftry>
		</cfif>
	</cfif>
	
	<!--- 01/09/2013
	<cfinclude template="AddResumeSolrIndex.cfm">
	--->
</cfif>


<!-------------------------------------------
-------Delete the previous attributes--------
-------------------------------------------->
<cfquery name="cfqDelResAtt" datasource="#application.dsn#">
	delete
	from tblResAtt
	where intResID = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
</cfquery>

<!---Update the tblResumes with the relocation information--->
<cfif len(stateIDList)>
	<!---Insert the relocation preference into tblResAtt--->
	<cfloop list="#stateIDList#" index="stateID" delimiters=",">
		<cfquery name="cfqInsAtt" datasource="#application.dsn#">
			insert into tblResAtt(intResID, intAttID)
			values (#session.exec.intResID#, #stateID#)
		</cfquery>
	</cfloop>
</cfif>

<!---Insert the industries--->
<cfloop list="#intsIndIDs#" index="intIndID" delimiters=",">
	<cfquery name="cfqInsAtt" datasource="#application.dsn#">
		insert into tblResAtt(intResID, intAttID)
		values (#session.exec.intResID#, #intIndID#)
	</cfquery>
</cfloop>

<!---Insert the functions--->
<cfloop list="#INTSFUNCIDS#" index="intFuncID" delimiters=",">
	<cfquery name="cfqInsAtt" datasource="#application.dsn#">
		insert into tblResAtt(intResID, intAttID)
		values (#session.exec.intResID#, #intFuncID#)
	</cfquery>
</cfloop>


<!------------------------------------------------------------>
<!-------------------Start: WebSite Categories---------------->
<!------------------------------------------------------------>
<cfquery name="cfqResWebSites" datasource="#application.dsn#">
	delete
	from tblResumesWebSites
	where intResID = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
</cfquery>
<!---My Website 1--->
<cfif isDefined("form.resumeWebSitesCategory1") and form.resumeWebSitesCategory1 neq "">
    <cfquery name="cfqInsMyWebsites" datasource="#application.dsn#">
	    insert into tblResumesWebSites (intResID, intWebSiteCategoryID, strResumeWebSiteName, strResumeWebSiteURL)
	    values (#session.exec.intresid#, #form.resumeWebSitesCategory1#, '#form.resumeWebSiteName1#', '#form.resumeWebSiteURL1#')
    </cfquery>
</cfif>

<!---My Website 2--->
<cfif isDefined("form.resumeWebSitesCategory2") and form.resumeWebSitesCategory2 neq "">
    <cfquery name="cfqInsMyWebsites" datasource="#application.dsn#">
	    insert into tblResumesWebSites (intResID, intWebSiteCategoryID, strResumeWebSiteName, strResumeWebSiteURL)
	    values (#session.exec.intresid#, #form.resumeWebSitesCategory2#, '#form.resumeWebSiteName2#', '#form.resumeWebSiteURL2#')
    </cfquery>
</cfif>

<!---My Website 3--->
<cfif isDefined("form.resumeWebSitesCategory3") and form.resumeWebSitesCategory3 neq "">
    <cfquery name="cfqInsMyWebsites" datasource="#application.dsn#">
	    insert into tblResumesWebSites (intResID, intWebSiteCategoryID, strResumeWebSiteName, strResumeWebSiteURL)
	    values (#session.exec.intresid#, #form.resumeWebSitesCategory3#, '#form.resumeWebSiteName3#', '#form.resumeWebSiteURL3#')
    </cfquery>
</cfif>

<!---My Website 4--->
<cfif isDefined("form.resumeWebSitesCategory4") and form.resumeWebSitesCategory4 neq "">
    <cfquery name="cfqInsMyWebsites" datasource="#application.dsn#">
	    insert into tblResumesWebSites (intResID, intWebSiteCategoryID, strResumeWebSiteName, strResumeWebSiteURL)
	    values (#session.exec.intresid#, #form.resumeWebSitesCategory4#, '#form.resumeWebSiteName4#', '#form.resumeWebSiteURL4#')
    </cfquery>
</cfif>

<!---My Website 5--->
<cfif isDefined("form.resumeWebSitesCategory5") and form.resumeWebSitesCategory5 neq "">
    <cfquery name="cfqInsMyWebsites" datasource="#application.dsn#">
	    insert into tblResumesWebSites (intResID, intWebSiteCategoryID, strResumeWebSiteName, strResumeWebSiteURL)
	    values (#session.exec.intresid#, #form.resumeWebSitesCategory5#, '#form.resumeWebSiteName5#', '#form.resumeWebSiteURL5#')
    </cfquery>
</cfif>
<!---------------------------------------------------------->
<!-------------------End: WebSite Categories---------------->
<!---------------------------------------------------------->


<!---------------------------------------------------------->
<!------------------Start: Degree University---------------->
<!---------------------------------------------------------->
<cfquery name="cfqResWebSites" datasource="#application.dsn#">
	delete
	from tblResDegreeUniversity
	where intResID = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
</cfquery>

<!---Degree1--->
<cfif isDefined("form.strHighestDegree1") and form.strHighestDegree1 neq "">
    <cfif isDefined("form.strSchool1") and  form.strSchool1 neq "">
        <!---Insert the record--->
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
			values(#session.exec.intResID#, '#form.strHighestDegree1#', '#form.strSchool1#')
        </cfquery>
    <!---No School--->
    <cfelse>
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree)
			values(#session.exec.intResID#, '#form.strHighestDegree1#')
        </cfquery>
    </cfif>
</cfif>

<!---Degree2--->
<cfif isDefined("form.strHighestDegree2") and form.strHighestDegree2 neq "">
    <cfif isDefined("form.strSchool2") and  form.strSchool2 neq "">
        <!---Insert the record--->
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
			values(#session.exec.intResID#, '#form.strHighestDegree2#', '#form.strSchool2#')
        </cfquery>
    <!---No School--->
    <cfelse>
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree)
			values(#session.exec.intResID#, '#form.strHighestDegree2#')
        </cfquery>
    </cfif>
</cfif>

<!---Degree3--->
<cfif isDefined("form.strHighestDegree3") and form.strHighestDegree3 neq "">
    <cfif isDefined("form.strSchool3") and  form.strSchool3 neq "">
        <!---Insert the record--->
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
			values(#session.exec.intResID#, '#form.strHighestDegree3#', '#form.strSchool3#')
        </cfquery>
    <!---No School--->
    <cfelse>
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree)
			values(#session.exec.intResID#, '#form.strHighestDegree3#')
        </cfquery>
    </cfif>
</cfif>

<!---Degree4--->
<cfif isDefined("form.strHighestDegree4") and form.strHighestDegree4 neq "">
    <cfif isDefined("form.strSchool4") and  form.strSchool4 neq "">
        <!---Insert the record--->
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
			values(#session.exec.intResID#, '#form.strHighestDegree4#', '#form.strSchool4#')
        </cfquery>
    <!---No School--->
    <cfelse>
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree)
			values(#session.exec.intResID#, '#form.strHighestDegree4#')
        </cfquery>
    </cfif>
</cfif>

<!---Degree5--->
<cfif isDefined("form.strHighestDegree5") and form.strHighestDegree5 neq "">
    <cfif isDefined("form.strSchool5") and  form.strSchool4 neq "">
        <!---Insert the record--->
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree, strUnivCollegeName)
			values(#intResID#, '#form.strHighestDegree5#', '#form.strSchool5#')
        </cfquery>
    <!---No School--->
    <cfelse>
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
	        insert into tblResDegreeUniversity (intResID, strDegree)
			values(#intResID#, '#form.strHighestDegree5#')
        </cfquery>
    </cfif>
</cfif>
<!-------------------------------------------------------->
<!------------------End: Degree University---------------->
<!-------------------------------------------------------->