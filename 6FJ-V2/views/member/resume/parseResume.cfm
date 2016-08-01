<cfoutput>
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
			<cfmail to="irodela@calliduscloud.com" from="webmaster@6figurejobs.com" subject="Issue with Professional/profile/parseresume.cfm">
			#cfcatch.Detail#
			<br />
			#cfcatch.Message#
			</cfmail>
		</cfcatch>
	</cftry>
</cfif>
</cfoutput>                   