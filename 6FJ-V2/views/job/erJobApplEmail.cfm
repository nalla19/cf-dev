<cfparam name="token" default="">
<cfparam name="generatedResume" default="">

<cfset request.thisYear = dateformat(now(), 'yyyy')>
<cfoutput>  

<cfquery  name="cfqGetResumeID" datasource="#application.dsn#">
select pk_managerid 
  from tblresumeprofiles (nolock) 
 where pk_managerid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#resumeID#" />
   and fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intresid#" />
   and len(resumeFile) > 0 
</cfquery>

<cfquery name="cfqGetResDegUniv" datasource="#application.dsn#">
select * from tblResDegreeUniversity (nolock) where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intresid#" />
</cfquery>
      
<cfstoredproc procedure="spS_ExecResumeRead" datasource="#application.dsn#" returncode="Yes">
	<cfprocparam type="IN" dbvarname="@intresid" value="#val(intresid)#" cfsqltype="CF_SQL_INTEGER">
    <cfprocparam type="IN" dbvarname="@resumeid" value="#val(resumeid)#" cfsqltype="CF_SQL_INTEGER">
    <cfprocresult resultset="1" name="q">
</cfstoredproc>

<cfscript>
resObj = application.resume;
//Files Uploaded Here
resumeDirectory = resObj.getResumeDir(intresid);
resumePath = resObj.getResumePath(intresid);
downloadFile = resumeDirectory & q.resumeFile;
downloadName = rereplacenocase(q.resumeFile,' ',"_","ALL");
</cfscript>

<!---
resumeid=#resumeid#<br />
intresid=#intresid#<br />
resumeDirectory=#resumeDirectory#<br />
resumePath=#resumePath#<br />
downloadFile=#downloadFile#<br />
downloadName=#downloadName#<br />
--->

<cfif FileExists(downloadFile)>

	<!--- Make this exception if the candidate chose to upload a resume saved to the local drive and not the saved resume on his profile --->    
    <cfif cfqGetResumeID.recordcount gt 0>
        <cfscript> 
		HonestyObj = createObject('component', 'v16fj.execs.components.honestyOnline').init(
											dsn			= application.dsn,
											machine		= application.machine);
        //HonestyObj =  application.honestyOnline;
        alphaNumeric = HonestyObj.getAlphaNumericNumber();
        </cfscript>
        
        <cfset resumeFileId = session.exec.intresid & alphaNumeric & cfqGetResumeID.pk_managerid>
        <cfset token=CFusion_Encrypt("#resumeFileId#","556")>
        
        <!---insert the record in the tblResumeDownloads--->
        <cfquery name="cfqInsRecord" datasource="#application.dsn#">
        insert into tblresumedownloads (token, intresid, intresumeid) values ('#token#', #session.exec.intresid#, #cfqGetResumeID.pk_managerid#) 
        </cfquery>
    </cfif>
	
    <cfset docFile = "C:\webroot\6figurejobs\email\JobApplication\worddocs\#application.applicationName#-#downloadName#" />
    <cffile action="copy" source="#downloadFile#" destination="#docFile#">
    <cfset downloadFile = docFile>
<cfelse>

	<!--- //Generate the Word document resume// --->
		
    <cfset tempResumeDisplay = #Replace(resumedisplay, chr(13), "<br />", "ALL")#>
    <cfsavecontent variable="resumeDoc">
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
        </head>
        <body>
        #ParagraphFormat(tempResumeDisplay)#
        <!--- Create a page break microsoft style (took hours to find this) --->
        <br clear="all" style="page-break-before:always;mso-break-type:page-break" />
        </body>
        </html>
    </cfsavecontent>
    
    <cfset docFile = "C:\webroot\6figurejobs\email\JobApplication\worddocs\#application.applicationName#-#intresid#.doc" />
    
    <cffile action="write" addnewline="yes" file="#docFile#"  output="#resumeDoc#" fixnewline="yes">
    <cfset downloadFile = docFile>
    <!--- //Generate the Word document resume// --->
</cfif>

<cfset title = replace(title, "&", chr(38), "ALL")>
<cfset jcode = replace(jcode, "&", chr(38), "ALL")>

<!--- //Ex: Job Application: Chief Financial Officer - John Smith// --->
<cfset emailSubject = "Job Application: #title# - #fname# #lname#">

<cfsavecontent variable = "emailMessage">
    <table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
        <tr>
            <!-- MASTHEAD BEGIN -->
            <td width="350">
                <a href="http://#cgi.HTTP_HOST#">
                    <cfif application.applicationName EQ "6FigureJobs">
                        <img src="http://#cgi.HTTP_HOST#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.applicationName#"><br><br>
                    <cfelseif application.applicationName EQ "SalesStars">
                        <img src="http://#cgi.HTTP_HOST#/_includes/templates/assets/img/salesstars-logo-black-beta.png" border="0" alt="#application.applicationName#">
                    </cfif>
                </a>
            </td>
            <td width="250" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333;">
            <strong>Job Application Notification</strong><br>
            <strong>Job Code:</strong> #jcode#</td>
            <!-- MASTHEAD END -->
        </tr>
    </table>
    
    <table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
        <tr>
            <td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
				<!--- COMMUNICATION MESSAGE BEGIN --->
                <strong>The following professional has just applied for the following job:</strong><br>
                #title#
                <br><br>
                <span style="font-size:22px; font-weight:bold; color:##9f58a2;">#fname# #lname#</span><br>
                <a href="mailto:#cfqRes.email#">#cfqRes.email#</a><br>
                <cfif len(cfqRes.home_phone)>
                #cfqRes.home_phone# (home)<br>
                </cfif>
                
                <cfif len(cfqRes.mobile_phone)>
                #cfqRes.mobile_phone# (cell)<br><br>
                </cfif>
                    
               	<span style="font-size:22px; font-weight:bold; color:##9f58a2;">See Attached Resume</span><br><br />
                
                <strong>Two Most Recent Positions Held:</strong><br>
                #cfqRes.strExecJOBTitle_1# (#cfqRes.strExecJOBCompany_1#)<br>
                #cfqRes.strExecJOBTitle_2# (#cfqRes.strExecJOBCompany_2#)<br><br>
                
                <strong>Industry Experience:</strong><br>
                #cfqRes.strCats#<br><br>
            
                <strong>Function Experience:</strong><br>
                #cfqRes.strFuncs#<br><br>
                
                <strong>Education:</strong><br>
                <cfif cfqGetResDegUniv.recordcount gt 0>
                    <cfloop query="cfqGetResDegUniv">
                    #strDegree#<cfif len(strUnivCollegeName)>, #strUnivCollegeName#</cfif><br>	
                    </cfloop>
                    <br>
                <cfelse>
                    #cfqRes.strHighestDegree#<br /><br />
                </cfif>            
                <!--- COMMUNICATION MESSAGE END --->
            </td>
        </tr>
    </table>
    
    <br>
    
    <table width="650" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
                <cfif application.applicationName EQ "SalesStars">
                    &copy; #year(now())# SalesStars.com | <a href="http://#cgi.HTTP_HOST#/SalesStars_PrivacyStatement.cfm">Privacy</a> | <a href="http://#cgi.HTTP_HOST#/SalesStars_TOS.cfm">Terms of Use</a> | <a href="http://#cgi.HTTP_HOST#/SalesStars_ContactUs.cfm">Contact</a> | <a href="http://#cgi.HTTP_HOST#/sitemap.cfm">Site Map</a>
                    <br />
                    SalesStars.com | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
                    <br /><br>
                    You are receiving this email because you recently registered to become a member of SalesStars.com.
                    <br>
                    This email is a confirmation that your membership is active.
                    <br /><br />
                <cfelse>
                    &copy; #year(now())# 6FigureJobs.com | <a href="http://#cgi.HTTP_HOST#/privacy">Privacy</a> | <a href="http://#cgi.HTTP_HOST#/terms">Terms of Use</a> | <a href="http://#cgi.HTTP_HOST#/contact">Contact</a>
                    <br />
                    6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
                    <br /><br>
                    You are receiving this job application notification because you have an active job listing on 6FigureJobs.com<br />
                    Need assistance? Please contact the 6FigureJobs <a href="mailto:communitymanager@6figurejobs.com?subject=Job Application Notification Inquiry">Community Manager</a>.
                    <br /><br />
                </cfif>
            </td>
        </tr>
	</table>
</cfsavecontent>

<!--- //Call the component to send the email// --->
<!--- <cfset jobemail ="irodela@calliduscloud.com"> ---> 
<cfset application.emailManager.sendJobApplNotification(emailTo=jobemail, emailSubject=emailSubject, emailAttachment=downloadFile, emailReplyTo=cfqRes.email, emailBody=emailMessage)>
     
<!--- 
downloadFile=#downloadFile#
<cffile action="delete" file="#downloadFile#"> 
--->
</cfoutput>