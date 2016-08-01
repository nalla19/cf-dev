<cfoutput>
<cfscript>
// Assume Parsing Is OK --->
inValidParse = 1;
//uploadedPath = application.sixfj.paths.webroot & "exports\";
uploadedPath = "C:\webroot\6figurejobs\exports\";
</cfscript>

<!---Create the resume upload directory if it does not exist already--->
<cfif not(directoryExists(uploadedPath))>
	<cfdirectory directory="#uploadedPath#" action="create" />
</cfif>


<cfif len(form.resumeFile)>
	<!--- File Length Is Not OK Size is Over 153600 Bytes --->
	<cfif cgi.CONTENT_LENGTH gte 153600>
		<cfset url.message = "Uploaded file is too large. Please upload files smaller than 150KB.">
		<cfset url.messagecode = 1>
		<cfset request.resumeuploaded = false>
	<cfelse>
		<cftry>
			<!--- Upload File --->
			<cffile action="upload" destination="#uploadedPath#" filefield="form.resumeFile" nameconflict="makeunique">
			<cfset uploadedFile = uploadedPath & cffile.serverFile />
			<cfset extList = "docx,doc,pdf" />
	
			<cfset shortName = randrange(100,100000) & "." & cffile.clientFileExt>
			<cfset reNamedFile 	= uploadedPath &  shortName>
			<cffile action="rename" destination="#reNamedFile#" source="#uploadedFile#">
			<cfset uploadedFile = reNamedFile />

			<cfset sovConsultantID = application.executive.getStoredResumeID(resumeFile=uploadedFile,resumePath=uploadedPath) />
			<cfset sovRenResumeID = sovConsultantID>
			
			<cfif len(sovRenResumeID) gt 10>
				<cfset url.message = "Issue Uploading the Resume">
				<cfset url.messagecode = 0>
				<cfset request.resumeuploaded = false>
			</cfif>
	
			<cfcatch type="any">
				<cfset url.message = "Issue Uploading the Resume">
				<cfset url.messagecode = 0>
				<cfset request.resumeuploaded = false>
			</cfcatch>
		</cftry>
	</cfif>


	<cfif not(len(url.message))>
		<cfif isdefined("uploadedFile") and len(uploadedFile)>
			<cfset request.resumeuploaded = true>
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
					update tblResumes 
					   set resumeFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#" />
					 where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
					</cfquery>
				</cfif>

				<cfcatch type="any">
					<!---Log the error to the cflog file--->
				</cfcatch>
			</cftry>
		</cfif>
		<!----End: Upload the initial resume upload--->

		<!--- Resume Was Parsed, update the resume content on step1 --->
		<cfif len(sovRenResumeID)>
			<cfset consultants = application.executive.getParsedConsultants(consultantid=sovRenResumeID) />
			<cfset parsedResume = consultants.resume />
			<cfset parsedAddress = consultants.address1 />

			<cfif len(parsedResume)>
				<!---Update the Username for this intResID as the procedure sp_exec_registration does not update the username--->
				<cfquery name="cfqUpdResume" datasource="#application.dsn#">
				update tblresumes 
				   set resume = <cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
					   ,blnBigs = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				 where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
				</cfquery>
			</cfif>
		</cfif>
		
		<cfset resumeTitle = "New Resume - " & dateformat(now(), "mm/dd/yyyy")>
		<cfquery name="cfqUpdInsRecord" datasource="#application.dsn#">
		update tblResumeProfiles set blnactive = 0 where fk_intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
			
		insert into tblResumeProfiles(fk_intresid, blnactive, dteCreated, dteEdited, title, resumeFile, consIntID)
		values (#intResID#, 1, getdate(), getdate(),'#resumeTitle#', '#shortName#', '#sovRenResumeID#')

		update tblResumeProfiles 
		   set resume = <cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
		where fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
		  and blnactive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		</cfquery>
	
		<cfset session.EXEC.dteResumeEdited = now()>				
	</cfif>
</cfif>

<!---
url.message = #url.message#<br>
url.messagecode = #url.messagecode#<br>
request.resumeuploaded = #request.resumeuploaded#<br>
--->		

</cfoutput>