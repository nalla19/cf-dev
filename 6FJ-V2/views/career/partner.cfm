

<cfif isDefined("url.forminsert")>

<cfinclude template="partnerInsert.cfm">

</cfif>


<cfparam name="request.thePageHTML" default="">

<div class="page-partner">
<cfif not isdefined("url.showform")>
	<header class="page-header">
		<div class="container">
			<a href="career" class="back">Career &raquo;</a>
		</div>
	</header>
</cfif>
	<article class="section">
		<cfif not isdefined("url.showform")>
			<!------> 
			<div class="container">
				<cfoutput>#replacenocase(request.thePageHTML,'<a class="btn btn-primary btn-small" href="" target="_blank">Request Free Information</a>','','all')#</cfoutput>
				<br>
				<cfoutput><a class="btn btn-primary btn-small" href="/partner?target=#url.target#&showform=y">Request Free Information</a></cfoutput>
			</div> 
		<cfelse>
			<cfif url.showform eq 'N'>
				<cfoutput>
					<div class="container">
					<h1>Thank You</h1>
						We have forwarded your email, address and phone number, as per your request.  You will be contacted or will receive information within two business days.
					</div> 
				</cfoutput>
			<cfelse>
				<cfset CPLMemberID = url.target>
				<div class="container">
					<br>
					<cfinclude template="partnerForm.cfm">
				</div> 
			</cfif>
		
			
		</cfif>
	</article>
	
</div>
<!--->
<form name="cplLead" id="cplLead" action="CPLPartnerPopupform.cfm?#strAppAddToken#" method="post"><!--- CPartners.cfm?#strAppAddToken# --->
<tr><td>
<cfif intFormID eq 1> <!--- display multiple groups --->
	<input type="hidden" name="CPLGroupID" value="#CPLGroupID#">
<cfelse>
	<!--- display the individual memeber --->
	<input type="hidden" name="CPLMemberID" value="#CPLMemberID#">
</cfif>

<input type="hidden" name="franchiseName" value="#cfqGetCPLMember.STRDISPLAYNAME#">
<input type="hidden" name="franchiseImage" value="#cfqGetCPLMember.STRIMAGENAME#">

<input type="hidden" name="popupform" value="1">
<input type="hidden" name="blnFirstPass" value="0">
<input type="hidden" name="m" value="#m#">
<input type="hidden" name="am" value="#am#">
<input type="hidden" name="returnLink" value="#returnToLink#"> <!--- where to redirect to --->
<input type="hidden" name="returnText" value="#returnToText#">
<input type="hidden" name="blnCPLoggedIn" value="#blnMemberLoggedIn#"> <!--- tells the redirect page if the person is logged in or not --->
<input type="hidden" name="intTargetID" value="#intTargetID#">
<input type="hidden" name="TargetLocation" value="#intTargetLocation#">
<input type="hidden" name="intLeadTrackingID" value="#intLeadTrackingID#">
<input type="hidden" name="intPID" value="#intPID#">

<cfinclude template="t_CPLPartnerRegistration.cfm">

<cfif (len(lcl_intResID))>   
<cfinclude template="t_CPLPartnerRegPassVars.cfm">
</cfif>

<cfinclude template="t_CPLPartnerRegAction.cfm">   
</form>
--->