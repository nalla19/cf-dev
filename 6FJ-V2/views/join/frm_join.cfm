
<div class="row-fluid">
	<div>
		<p>
		<!--- <cfoutput>#application.v1URL#</cfoutput>/join/LinkedIn/index.cfm --->
		<a href="/join-linkedin?startli=1&tCode=<cfoutput>#url.tkcd#</cfoutput><cfif isDefined("session.exec.intsitevisitjobid") and isnumeric(session.exec.intsitevisitjobid)>&Qf7DS7PEi=<cfoutput>#session.exec.intsitevisitjobid#</cfoutput></cfif><cfif isDefined("url.Pf9ZL4URh") and url.Pf9ZL4URh neq "">&Pf9ZL4URh=<cfoutput>#url.Pf9ZL4URh#</cfoutput></cfif>" ><img src="/images/<cfoutput>#request.linkedinlogo#</cfoutput>" alt="Register Via LinkedIn" title="Register Via LinkedIn. You can use your LinkedIn profile to speed up your registration." /></a>
		</p>
	</div>
</div>


<div class="row-fluid">
	<div>
		<p><img src="/images/<cfoutput>#request.regdivider#"</cfoutput> /></p>
	</div>
</div>


<cfif request.error is 1 and request.errorcode is 1>
	<div class="alert alert-error">
	First Name is missing.
	</div>
<cfelseif request.error is 1 and request.errorcode is 2>
	<div class="alert alert-error">
	Last Name is missing.
	</div>
<cfelseif request.error is 1 and request.errorcode is 3>
	<div class="alert alert-error">
	Email Address is missing.
	</div>
	<cfelseif request.error is 1 and request.errorcode is 4>
	<div class="alert alert-error">
	Password is missing
	</div>
</cfif>
	
<form name="joinFrm" id="joinFrm" action="<cfoutput>/join-process<cfif isDefined("session.exec.intsitevisitjobid") and isnumeric(session.exec.intsitevisitjobid)>?Qf7DS7PEi=<cfoutput>#session.exec.intsitevisitjobid#</cfoutput></cfif><cfif isDefined("url.Pf9ZL4URh") and url.Pf9ZL4URh neq ''>&Pf9ZL4URh=#url.Pf9ZL4URh#</cfif></cfoutput>" method="post" class="form">
	<!---//Pass the Tracking ID//--->
	<input type="hidden" name="tCode" value="<cfoutput>#url.tkcd#</cfoutput>">
	
	<div class="row-fluid">
		<div class="span6">
			<input id="strFName" name="strFName" type="text" class="input input-small span12 requiredField" placeholder="First name" value="<cfoutput>#request.fname#</cfoutput>">
		</div>
		<div class="span6">
			<input id="strLName" name="strLName" type="text" class="input input-small span12 requiredField" placeholder="Last name" value="<cfoutput>#request.lname#</cfoutput>">
		</div>
	</div>
	<input id="strEmail"  name="strEmail" type="email" class="input input-small span12 requiredField" placeholder="E-mail address" value="<cfoutput>#request.email#</cfoutput>">
	<input id="strPasswd" name="strPasswd" type="password" class="input input-small span12 requiredField" placeholder="Choose a password">
	
	<p><button class="btn btn-primary" type="submit">Create a Free Account</button></p>
	
	<p class="help-block2">*By joining 6FigureJobs, you agree to 6FigureJobs's Terms &amp; Privacy Policy.</p>
	<!--- <a href="<cfoutput>#application.v1URL#</cfoutput>/join/LinkedIn/index.cfm?startli=1&tCode=<cfoutput>#url.tkcd#</cfoutput><cfif isDefined("url.Pf9ZL4URh") and url.Pf9ZL4URh neq "">&Pf9ZL4URh=<cfoutput>#url.Pf9ZL4URh#</cfoutput></cfif>" style="vertical-align:text-bottom;"><img src="/images/linkedinButtonsmall.png" alt="Register Via LinkedIn" title="Register Via LinkedIn. You can use your LinkedIn profile to speed up your registration." border="0" style="vertical-align:text-bottom;" /></a> --->
</form>