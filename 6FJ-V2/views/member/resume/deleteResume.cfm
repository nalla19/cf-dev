<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->
<cfparam name="form.title" default="" />
<cfparam name="form.resume" default="" />

<cftry>
    <cfparam name="URL.resumeid" type="numeric" default="1" />
    <cfcatch>
    <cfset URL.resumeid = 1 />
    </cfcatch>
</cftry>

<cfscript>
resObj = application.resume;
qgetResume = resObj.getResume(url.resumeid);
resumeDirectory = resObj.getResumeDir(session.exec.intresid);
resumePath = resObj.getResumePath(session.exec.intresid);
</cfscript>

<cfif not(qgetResume.recordcount)>
	<!--- <cfoutput>
    <meta http-equiv="refresh" content="0;url=#request.secureURL#/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#&message=#urlencodedformat('This is not your resume')#">
  	</cfoutput> --->
	<cflocation url="/member-resume?#application.STRAPPADDTOKEN#&confirm=#urlencodedformat('This is not your resume')#">
  	<cfabort>
<cfelseif isdefined("form.fieldnames") and (isboolean(qgetResume.BLNACTIVE) and qgetResume.BLNACTIVE)>
  	<!--- <cfoutput>
    <meta http-equiv="refresh" content="0;url=#request.secureURL#/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#&message=#urlencodedformat('Sorry you can not delete your active resume')#">
  	</cfoutput> --->
	<cflocation url="/member-resume?#application.STRAPPADDTOKEN#&confirm=#urlencodedformat('Sorry you can not delete your active resume')#">
  	<cfabort>
<cfelseif isdefined("form.fieldnames")>
	<!---Delete FILE---> 
	<cfif fileExists(resumeDirectory & qgetResume.resumeFile)>
    	<cffile action="delete" file="#(resumeDirectory & qgetResume.resumeFile)#" />
    </cfif>

  	<cfset void = resObj.deleteResume(form.resumeid) />
  	<!--- <cfoutput>
    <meta http-equiv="refresh" content="0;url=#request.secureURL#/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#&confirm=#urlencodedformat('Your request was completed')#">
  	</cfoutput> --->
	<cflocation url="/member-resume?#application.STRAPPADDTOKEN#&confirm=#urlencodedformat('Your request was completed.')#">
  	<cfabort>
</cfif>

<div class="page-companies">
	<article class="section companies well">
		<div class="container">
			<cfoutput>
			<form action="/member-resume-delete?#application.STRAPPADDTOKEN#&resumeid=#url.resumeid#" method="post" name="ExecResDelete">
			<input type="hidden" name="resumeid" value="#url.resumeid#" />
			<table width="100%" border="0" cellpadding="0" cellspacing="3">
				<tr>
					<td ><h1>Delete Resume</h1></td>
					<td align="right"><a href="/member-resume?#application.STRAPPADDTOKEN#">Back to Resume Management</a></td>
				</tr>
				
				<tr>
					<td colspan="2"><strong>Resume Name:</strong>&nbsp;#qgetResume.title#</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">Are you sure you want to delete this resume?  Once your resume is deleted, it can not be recovered.</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">
						<!--- <input type="submit" class="exec_submit" value="Delete Resume" /> --->
						<a href="##" onclick="javascript:document.ExecResDelete.submit();"  role="button" class="btn btn-primary btn-xs"><span>DELETE RESUME</span></a>
					</td>
				</tr>
			</table>
			</form>
			</cfoutput>
		</div>
	</article>
</div>