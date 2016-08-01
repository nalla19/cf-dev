<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->
<cfsetting showdebugoutput="no" />

<cftry>
	<cfparam name="URL.resumeid" type="numeric" default="1" />
  	<cfcatch>
    	<cfset URL.resumeid = 1 />
  	</cfcatch>
</cftry>

<cfscript>
resObj = application.resume;
qgetResume = resObj.getResume(url.resumeid);

//Files Uploaded Here
resumeDirectory = resObj.getResumeDir(session.exec.intresid);
resumePath = resObj.getResumePath(session.exec.intresid);
downloadFile = resumeDirectory & qgetResume.resumeFile;
downloadName = rereplacenocase(qgetResume.resumeFile,' ',"_","ALL");
</cfscript>


<cfif not(qgetResume.recordcount) or not(fileExists(downloadFile))>
	<!--- <cfoutput>
    <meta http-equiv="refresh" content="0;url=#request.secureURL#/execs/resbuilder/execresmanager.cfm?#strAppAddToken#&message=#urlencodedformat('This is not your resume')#">
  	</cfoutput> --->
  	<cfabort>
<cfelse>
	<!--- Download File --->    
	<cfheader name="Content-Disposition" value="inline; filename=#downloadName#" />
	<cfcontent type="application/msword" file="#downloadFile#" />
</cfif>