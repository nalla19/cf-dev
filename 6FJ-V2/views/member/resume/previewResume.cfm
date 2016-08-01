<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->
<cfsetting showdebugoutput="no" />

<cftry>
	<cfparam name="URL.resumeid" type="numeric" default="1" />
  	<cfcatch>
    	<cfset URL.resumeid = 1 />
  	</cfcatch>
</cftry>

<!----
APPLY TO JOB:
-------------
When coming from the apply to job page, the user needs to have a link
to go back to the Apply to Job page
------>
<cfparam name="strApplyToJobPage" default="" />
<cftry>
	<cfparam name="URL.blnapplytojob" type="numeric" default="0" />
  	<cfcatch>
    	<cfset URL.blnapplytojob = 0 />
  	</cfcatch>
</cftry>

<cfif (url.blnapplytojob) and url.blnapplytojob eq 1>
	<cfset strApplyToJobPage = cgi.http_referer>
</cfif>
<!---
<cfoutput>
blnapplytojob=#url.blnapplytojob#<br />
strApplyToJobPage=#strApplyToJobPage#<br />
</cfoutput>
--->
<!--- ----->

<cfscript>
resObj = application.resume;
qgetResume = resObj.getResume(url.resumeid);

//Files Uploaded Here
resumeDirectory = resObj.getResumeDir(session.exec.intresid);
resumePath = resObj.getResumePath(session.exec.intresid);

resumeView = qgetResume.resume;

//Replace B.S.
if (REFind("<[^>]*>",resumeView,"1") eq "0"){
	resumeView=Replace("#resumeView#", "#chr(10)#", "<br>","All");
	resumeView=Replace("#resumeView#", "#chr(13)#", "","All");
}
</cfscript>


<cfif not(qgetResume.recordcount)>
	<!--- <cfoutput>
    <meta http-equiv="refresh" content="0;url=#request.secureURL#/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#&message=#urlencodedformat('This is not your resume')#">
  	</cfoutput> --->
  	<cfabort>
</cfif>
  
<cfoutput>
<div class="page-companies">
	<article class="section companies well">
		<div class="container">
			<table width="100%" border="0" cellpadding="0" cellspacing="3">
				<tr>
					<td align="left"><h1 class="PageHeader">Resume Preview</h1></td>
					<td width="50%" align="right">
						<!--- <a href="/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#">Back to Resume Manager</a> --->
						<cfif strApplyToJobPage neq "">
							<a href="#strApplyToJobPage#">Back to Apply to Job</a>
						<cfelse>
							<a href="/member-resume?#application.STRAPPADDTOKEN#">Back to Resume Management</a>
						</cfif>
					</td>
				</tr>
				<tr>
					<td align="left" width="50%" style="font-size:14px;"><strong>Resume Name:</strong> &nbsp;#ucase(qgetResume.title)#</td>
					<td align="right" width="50%">
						<!--- <table align="right" width="300" border="0" cellpadding="2" cellspacing="1">
							<tr> --->
								<cfif strApplyToJobPage eq "">
									<!--- <td width="105" align="right"> ---><a href="/member-resume-edit?#application.STRAPPADDTOKEN#&resumeid=#resumeid#" role="button" class="btn btn-primary btn-xs">Edit Resume</a><!--- </td> --->
									<!--- <td width="80" align="right"> --->&nbsp;&nbsp;<a href="/member-resume-delete?#application.STRAPPADDTOKEN#&resumeid=#resumeid#" role="button" class="btn btn-primary btn-xs">Delete</a><!--- </td> --->
						
									<cfif len(qgetResume.resumeFile) and fileExists(resumeDirectory & qgetResume.resumeFile)>
									<!--- <td nowrap width="105" align="right"> --->
										&nbsp;&nbsp;<a href="/member-resume-download?#application.STRAPPADDTOKEN#&resumeid=#resumeid#" role="button" class="btn btn-primary btn-xs">Download</a>
										<!--- </td> --->
									</cfif>          
								</cfif>
							<!--- </tr>
						</table> --->
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">
						<!--- <!-- Start Preview -->
						<script language="JavaScript" src="/js/iframe-resize.js" type="text/javascript"></script>  
						<iframe id="res_frame" src="#request.secureURL#/execs/resbuilder/execrespreview-iframe.cfm?#application.STRAPPADDTOKEN#&resumeid=#url.resumeid#" width="930" height="1000" name="res_frame" marginwidth="0" marginheight="0" frameborder="0" scrolling="yes" style="overflow:visible;border:none;" allowtransparency="true"></iframe>
						<!-- End Preview --> --->
						
						<table width="100%" border="0" cellpadding="5" cellspacing="0" bordercolor="##000000">
							<tr>
								<td>#resumeView#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</div>
	</article>
</div>
</cfoutput>