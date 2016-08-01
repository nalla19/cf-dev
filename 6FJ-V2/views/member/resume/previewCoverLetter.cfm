<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->
<cfparam name="form.title" default="" />
<cfparam name="form.coverletter" default="" />


<cftry>
	<cfparam name="URL.letterid" type="numeric" default="1" />
    <cfcatch>
    	<cfset URL.letterid = 1 />
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

<cfscript>
resObj = application.resume;
qgetCoverletter = resObj.getCoverLetterDetails(url.letterid);
</cfscript>


<cfif not(qgetCoverletter.recordcount)>
	<!--- <cfoutput>
	<meta http-equiv="refresh" content="0;url=/execs/resbuilder/execrescover.cfm?#application.strAppAddToken#&message=#urlencodedformat('This is not your Cover Letter')#">
	</cfoutput> --->
	<cfabort>
<cfelseif isdefined("form.fieldnames")>
	<cfscript>
	if (not(len(form.title))){
		form.title = "My Cover Letter";
	}
	resObj.updateCoverLetter(form.letterid,form.title,form.coverletter);
	</cfscript>
   	
    <cfif strApplyToJobPage neq "">
    	<!--- <cfoutput>
        <meta http-equiv="refresh" content="0;url=#strApplyToJobPage#">
        </cfoutput> --->
    <cfelse>
		<!--- <cfoutput>
		<!--- <meta http-equiv="refresh" content="0;url=/execs/resbuilder/execresmanager.cfm?#application.strAppAddToken#&confirm=#urlencodedformat('Your update was completed')#"> --->
    	<meta http-equiv="refresh" content="0;url=/execs/resbuilder/execrescover.cfm?#application.strAppAddToken#&confirm=#urlencodedformat('Your update was completed')#">
		</cfoutput> --->
   	</cfif>
    <cfabort>
</cfif>


<cfoutput>
<form action="" method="post">
<input type="hidden" name="letterid" value="#URL.letterid#" />
<input type="hidden" name="strApplyToJobPage" value="#strApplyToJobPage#" />
<div class="page-companies">
	<article class="section companies well">
		<div class="container">
<table width="100%" border="0" cellpadding="0" cellspacing="3">
	<tr>
  		<td <cfif strApplyToJobPage neq "">width="70%"<cfelse>width="60%"</cfif>><h1>Preview Cover Letter</h1><!--- : (#ucase(qgetCoverletter.strCoverName)#)</span> ---></td>
  		<td align="right">
	        <!---
            <a href="/execs/resbuilder/execrescoveredit.cfm?#application.strAppAddToken#&letterid=#url.letterID#">Edit</a>&nbsp;
			<a href="/execs/resbuilder/execrescoverdelete.cfm?#application.strAppAddToken#&letterid=#url.letterID#">Delete</a>&nbsp;
        	<a href="/execs/resbuilder/execrescover.cfm?#application.strAppAddToken#">Back to Cover Letters</a>
            --->
			<cfif strApplyToJobPage eq "">
			<a href="/member-resume?activeTab=letters&#application.strAppAddToken#&panel=2">Back to Cover Letters</a>
			</cfif>
            
            
        </td>
	</tr>
	
    
	<tr>
 	 	<td >
        	<strong>Cover Letter Name:</strong>
       	</td>
		<td align="right">
			<cfif strApplyToJobPage neq "">
            	<a href="#strApplyToJobPage#" class="btn btn-primary btn-small">Back to Apply Job</a>
            <cfelse>
            	<a href="/member-letter-edit?#application.strAppAddToken#&letterid=#url.letterID#" class="btn btn-primary btn-small">Edit</a> 
				&nbsp;&nbsp;
				<a href="/member-letter-delete?#application.strAppAddToken#&letterid=#url.letterID#" class="btn btn-primary btn-small">Delete</a>
                
               
                
           	</cfif>
		</td>
  	</tr>
    
    <tr>
 	 	<td colspan="2">
            #qgetCoverletter.strCoverName#
       	</td>
  	</tr>
    
    <tr>
      	<td  colspan="2">&nbsp;</td>
    </tr>
    <tr>
    	<td  colspan="2"><strong>Cover Letter:&nbsp;</strong></td>
    </tr>
    <tr>
    	<td colspan="2"><cfscript>strCoverLetterFormatted=paragraphFormat(qgetCoverletter.strCoverLetter);</cfscript>
      		#strCoverLetterFormatted#
        </td>
    </tr>
</table>
	</div>
	</article>
</div>
</form>
</cfoutput>