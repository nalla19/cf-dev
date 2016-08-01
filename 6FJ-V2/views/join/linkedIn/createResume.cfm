<cfoutput>
<!---Parsing variables--->
<cfparam name="url.message" default="" />
<cfscript>
// Assume Parsing Is OK --->
inValidParse = 1;
uploadedPath = application.sixfj.paths.webroot & "exports\";
</cfscript>

<!---Create the resume upload directory if it does not exist already--->
<cfif not(directoryExists(uploadedPath))>
	<cfdirectory directory="#uploadedPath#" action="create" />
</cfif>

<!------------------------------------------------------------------------------------->
<!---------------------Create and Save a  Word Document Resume------------------------->
<!------------------------------------------------------------------------------------->
<!--- <cfset resumeFilePath="#getDirectoryFromPath(expandPath('\'))#join\LinkedIn\resumes"> --->
<cfset resumeFilePath="C:\webroot\v2.6figurejobs.com\views\join\LinkedIn\resumes">
<cfset resumeName = "#session.exec.liUser.firstName##session.exec.liUser.lastName##dateformat(now(),'yyyymmdd')#.doc">
<cfset resumeName = REReplace(resumeName,"[^0-9A-Za-z ]","","all")>
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

<!-------------------------------------------------------------------------------------------->
<!-----Upload the Resumes to the Exports Directory and also upload it the Sovren database----->
<!-------------------------------------------------------------------------------------------->
<cfset shortName = randrange(100,100000) & ".doc">
<cfset destinationFileName="#uploadedPath#\#shortName#">
<cffile action="copy" source="#resumeFilePathAndName#" destination="#destinationFileName#">

<cfset uploadedFile = destinationFileName />
<cfset sovRenResumeID = application.executive.getStoredResumeID(resumeFile=uploadedFile,resumePath=uploadedPath) />
<!-------------------------------------------------------------------------------------------->
<!----//Upload the Resumes to the Exports Directory and also upload it the Sovren database---->
<!-------------------------------------------------------------------------------------------->

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

<!--- Resume Was Parsed, update the resume content on step1 --->
<cfif len(sovRenResumeID)>
	<cfset consultants = application.executive.getParsedConsultants(consultantid=sovRenResumeID) />
	<cfset parsedResume = consultants.resume />
	<cfset parsedResume = ReReplace(parsedResume, "Print Clean Clean ", "", "ALL")>
	
	<cfset parsedAddress = consultants.address1 />
		
	<cfif len(parsedResume)>
		<!---Update the Username for this intResID as the procedure sp_exec_registration does not update the username--->
		<cfquery name="cfqUpdResume" datasource="#application.dsn#">
			update tblresumes 
  			   set resume=<cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
			       ,dteEdited = getdate()
			       <cfif len(session.exec.liUser.lastModifiedTimestamp)>
				   ,bigIntLILastModified = #session.exec.liUser.lastModifiedTimestamp#
				   </cfif>
			 where intresid = #intResID#
		</cfquery>
			
		<cfset resumeTitle = "#fname##lname#-LinkedInProfile">
		
		<!---Check to see how many resumes are there for that user --->
		<cfquery name="cfqchkResumes" datasource="#application.dsn#">
		select * from tblResumeProfiles (nolock) where fk_intResid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
		</cfquery>
	
		<cfif cfqchkResumes.recordcount is 0>
			<cfquery name="cfqInsRecord" datasource="#application.dsn#">
			insert into tblResumeProfiles(fk_intresid, blnactive, dteCreated, dteEdited, title, resume, resumeFile, consIntID)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">, <cfqueryparam cfsqltype="cf_sql_integer" value="1">, getdate(), getdate(),<cfqueryparam cfsqltype="cf_sql_varchar" value="#resumeTitle#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#sovRenResumeID#">)
		    </cfquery>	
		<cfelse>
			<!---Check to see if there is a linkedIn resume --->
			<cfquery name="cfqChkLI" datasource="#application.dsn#">
			select * from tblResumeProfiles (nolock) where fk_intResid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#"> and title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#resumeTitle#">
			</cfquery>
			
			<cfif cfqChkLI.recordcount is 0>
				<cfquery name="cfqInsRecord" datasource="#application.dsn#">
				insert into tblResumeProfiles(fk_intresid, blnactive, dteCreated, dteEdited, title, resume, resumeFile, consIntID)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">, <cfqueryparam cfsqltype="cf_sql_integer" value="1">, getdate(), getdate(),<cfqueryparam cfsqltype="cf_sql_varchar" value="#resumeTitle#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#sovRenResumeID#">)
			    </cfquery>	
			<cfelse>
				<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
				delete from Sovern2000.dbo.Consultants where consIntID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfqChkLI.consIntID#">
				</cfquery>
				
				<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
				update tblResumeProfiles 
				   set resume = <cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
				       ,resumeFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">
					   ,consIntID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sovRenResumeID#">
					   ,dteEdited = getdate()
				 where fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
				   and title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#resumeTitle#">
				</cfquery>				
			</cfif>
		</cfif>		
	</cfif>
</cfif>
</cfoutput>