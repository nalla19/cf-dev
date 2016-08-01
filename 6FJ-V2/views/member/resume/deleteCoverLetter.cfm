<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->
<cfparam name="form.title" default="" />
<cfparam name="form.letterid" default="" />

<cftry>
	<cfparam name="URL.letterid" type="numeric" default="1" />
    <cfcatch>
    	<cfset URL.letterid = 1 />
  	</cfcatch>
</cftry>

<cfscript>
resObj = application.resume;
qgetCoverletter = resObj.getCoverLetterDetails(url.letterid);
</cfscript>

<cfif not(qgetCoverletter.recordcount)>
	<!--- <cfoutput>
    <meta http-equiv="refresh" content="0;url=/execs/resbuilder/execrescover.cfm?#application.strAppAddToken#&message=#urlencodedformat('This is not your cover letter')#">
  	</cfoutput> 
  	<cfabort>--->
<cfelseif isdefined("form.fieldnames")>  
  <cfset void = resObj.deleteCoverLetter(form.letterid) />
  <!--- <cfoutput>
    <meta http-equiv="refresh" content="0;url=/execs/resbuilder/execresmanager.cfm?#application.strAppAddToken#&panel=2&confirm=#urlencodedformat('Your request was completed')#">
  </cfoutput>
  <cfabort> --->
  <cflocation url="/member-resume?activeTab=letters">
</cfif>

<div class="page-companies">
	<article class="section companies well">
		<div class="container">
<cfoutput>
<form action="/member-letter-delete?#application.strAppAddToken#&resumeid=#session.exec.intresid#" method="post" name="execDelCover">
<input type="hidden" name="letterid" value="#URL.letterid#" />
<table width="100%" border="0" cellpadding="0" cellspacing="3">
	<tr>
    	<td width="78%"><h2 class="PageHeader">Delete Cover Letter<!--- : (#ucase(qgetCoverletter.strCoverName)#) ---></h2></td>
     	<td align="right"><a href="/member-resume?#application.strAppAddToken#&activeTab=letters" role="button">Back to Cover Letters</a></td>
   	</tr>
    <tr>
        <td>&nbsp;</td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2"<span class="header4"><strong>Cover Letter Name:</strong>&nbsp;#qgetCoverletter.strCoverName#<strong> </strong></span></td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">Please confirm you are deleting your cover letter.</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">
		<a href="##" onclick="document.execDelCover.submit();" role="button" class="btn btn-primary btn-medium">Delete Cover Letter</a>
		</td>
    </tr>
</table>
</form>
</cfoutput>
	</div>
	</article>
</div>