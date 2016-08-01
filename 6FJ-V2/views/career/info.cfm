<cfoutput>
<!--- 
<cflock scope="session" timeout="10" type="Exclusive">
	<cfparam name="session.EXEC.blnValidLogin" default="0">
  	<cfset loggedIn=session.EXEC.blnValidLogin>
</cflock> --->

<cfparam name="blnFirstPass" default="1">
<cfparam name="TargetLocation" default="0">
<cfif blnFirstPass neq 0>
	<cfparam name="URL.target" default="0">
 	<cfset CPLMemberID=URL.target>
 
 	<cfif (HTTP.REFERER neq "") AND (findNoCase(".cfm?", HTTP.REFERER) gt 0)>
  		<cfif (findNoCase("CPartner", HTTP.REFERER) eq 0) OR (findNoCase("click", HTTP.REFERER) eq 0)>
   			<cfset returnLink=HTTP.REFERER>
   			<cfset returnText="Return to Previous Section">
  		<cfelse>
   			<cfset returnLink="ExecCareerResources.cfm?#application.strAppAddToken#">
   			<cfset returnText="Return to Career Resource Section">
  		</cfif>  
 	<cfelse> <!--- send them to the res section if came from a different page than 6FJ --->
  		<cfset returnLink="ExecCareerResources.cfm?#application.strAppAddToken#">
  		<cfset returnText="Return to Career Resources Section">
 	</cfif>
</cfif>

<!---Set the return link to go to the ExecMyAccount.cfm page if the MemberID is 87--->
<cfif CPLMemberID eq "87">
	<cfset returnLink="/ExecMyAccount.cfm?#application.strAppAddToken#">
  	<cfset returnText="Return to Executive Home Page">	
</cfif>


<cfif CPLMemberID gt 0>
	<!--- <cf_ct_CPLPartner formID=2 targetID=#CPLMemberID# loggedIn=#loggedIn# showEverytime=1 ActiveLeftNav=#m# ActiveLeftSubNav=#am# FirstPass=#blnFirstPass# datasource="#strsixfigdata#" CFIDToken="#strAppAddToken#" LockTimeOut="#strLockTimeOut#" returnLink="#returnLink#" returnText="#returnText#" TargetLocation=#TargetLocation#> --->
		<cfparam name="CPLMemberID" default="0">
		
		<cfif CPLMemberID neq "0">
		<cfif CPLMemberID contains "##">
			<cfset CPLMemberID=Replace(CPLMemberID,"##","","all")>
		</cfif>
		 <cfquery name="cfqGetCPLMember" datasource="#application.dsn#">
		  select intMemberID
		  from tblCPLMember (nolock)
		  where intMemberID=<cfqueryparam cfsqltype="cf_sql_integer" value="#CPLMemberID#" />
		  and blnActive=1
		 </cfquery>
		 
		 <cfif cfqGetCPLMember.RecordCount eq 1>
		  <table border=0 cellpadding=0 cellspacing=0 width="100%">
		   <tr><td>
			<!--- <cfinclude template="t_CPLPartnerAdForm.cfm"> --->	
			<!--- load the member --->
			<cfstoredproc procedure="sp_cpl_check_for_member" datasource="#application.dsn#" returncode="Yes">
				<cfprocparam type="IN" dbvarname="@intMemberID" value="#val(url.target)#" cfsqltype="CF_SQL_INTEGER">
				<cfprocresult resultset="1" name="cfqGetCPLMember">
			</cfstoredproc>
			
			<cfif (cfstoredproc.StatusCode gt 0)>
			
				<!--- no errors and some info was returned --->
				<cfparam name="CPLMemberID" default="">
				<cfset CPLMemberID=cfqGetCPLMember.intMemberID />
				<cfset intCPLType=cfqGetCPLMember.intCPLType />
				<!--- <cfinclude template="t_CPLRegistrationInfo.cfm"> --->
				
				<table border=0 cellpadding=0 cellspacing=0 width="100%">
				<form name="cplLead" id="cplLead" action="CPLPartnerPopupform.cfm?#application.strAppAddToken#" method="post"><!--- CPartners.cfm?#strAppAddToken# --->
				  <tr><td>
				
				 
				   <input type="hidden" name="CPLMemberID" value="#CPLMemberID#">
					<input type="hidden" name="franchiseName" value="#cfqGetCPLMember.STRDISPLAYNAME#">
				   <input type="hidden" name="franchiseImage" value="#cfqGetCPLMember.STRIMAGENAME#">
				   
				   <input type="hidden" name="popupform" value="1">
				   <input type="hidden" name="blnFirstPass" value="0">
				  <!---  <input type="hidden" name="m" value="#m#">
				   <input type="hidden" name="am" value="#am#"> --->
				   <input type="hidden" name="returnLink" value="#returnToLink#"> <!--- where to redirect to --->
				   <input type="hidden" name="returnText" value="#returnToText#">
				   <input type="hidden" name="blnCPLoggedIn" value="#blnMemberLoggedIn#"> <!--- tells the redirect page if the person is logged in or not --->
				   <input type="hidden" name="intTargetID" value="#intTargetID#">
				   <input type="hidden" name="TargetLocation" value="#intTargetLocation#">
				   <input type="hidden" name="intLeadTrackingID" value="#intLeadTrackingID#">
				   <input type="hidden" name="intPID" value="#intPID#">
				 <!---   <cfinclude template="t_CPLPartnerRegDisplay.cfm">
				
				   <cfinclude template="t_CPLPartnerRegistration.cfm"> --->
				
				   <cfif (len(lcl_intResID))>   
					<!--- <cfinclude template="t_CPLPartnerRegPassVars.cfm"> --->
				   </cfif>
				   
				   <!--- <cfinclude template="t_CPLPartnerRegAction.cfm">    --->
				   
				 </form>  <!--- --->
				  
				 <!---  <cfif blnSaved neq 0>
				  <form name="regCPLLead" id="regCPLLead" action="CPartnerConfirm.cfm?#strAppAddToken#" method="post">
				   <input type="hidden" name="intFormID" value="#intFormID#">
				   <input type="hidden" name="intTargetID" value="#intTargetID#">
				   <input type="hidden" name="TargetLocation" value="#intTargetLocation#">   
				   <input type="hidden" name="m" value="#m#">
				   <input type="hidden" name="am" value="#am#">
				   <input type="hidden" name="blnFirstPass" value="0">
				   <input type="hidden" name="CPLMemberIDList" value="#CPLMemberIDList#">
				   <input type="hidden" name="returnLink" value="#returnToLink#"> <!--- where to redirect to --->
				   <input type="hidden" name="returnText" value="#returnToText#">
				   <input type="hidden" name="blnCPLoggedIn" value="#blnMemberLoggedIn#">   
				   <input type="hidden" name="CPLFname" value="#CPLFname#">
				   <input type="hidden" name="CPLLname" value="#CPLLname#">
				   <input type="hidden" name="CPLAddr" value="#CPLAddr#">
				   <input type="hidden" name="CPLAddr2" value="#CPLAddr2#">
				   <input type="hidden" name="CPLZip" value="#CPLZip#">
				   <input type="hidden" name="CPLDPhone" value="#CPLDPhone#">
				   <input type="hidden" name="CPLEPhone" value="#CPLEPhone#">
				   <input type="hidden" name="CPLEmail" value="#CPLEmail#">
				   <input type="hidden" name="CPLCity" value="#CPLCity#">
				   <input type="hidden" name="CPLCntry" value="#CPLCntry#">
				   <input type="hidden" name="blnAddtFields" value="#blnAddtFields#">
				   <input type="hidden" name="intFieldList" value="#intFieldList#">
				   <input type="hidden" name="intLeadTrackingID" value="#intLeadTrackingID#">
				   <input type="hidden" name="intPID" value="#intPID#">
				   <cfif blnAddtFields neq 0>
					<input type="hidden" name="strEducationLevel" value="#strEducationLevel#">
				   </cfif>
				   <cfif blnAddtLoggedInFields neq 0>
					<input type="hidden" name="blnAddtLoggedInFields" value="#blnAddtLoggedInFields#">
					<input type="hidden" name="intLoggedInFieldList" value="#intLoggedInFieldList#">
					<input type="hidden" name="strAddtComments" value="#strAddtComments#">
				   </cfif>
				 
				 
				  </td></tr></form>
				  <script language="JavaScript">
					document.regCPLLead.submit();
				  </script>
				  <cfelse>
				  </td></tr>
				  </cfif> --->
				
				</table> 
				
				
				<!--- end t_CPLRegistrationInfo.cfm --->
				
			<cfelse>
			
				<cfif blnreDirect neq 1>
					<table border=0 cellpadding=0 cellspacing=0 width="100%">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center">
								<img src="images/icon_back.gif" border=0 align="absmiddle">&nbsp;&nbsp;<a href="#returnToLink#">#returnToText#</a>
							</td>
						</tr>
					</table>
				<cfelse>
					<!--- <script language="JavaScript">location.href="#returnToLink#";</script> --->
					<cflocation url="#returnToLink#" addtoken="no">
				</cfif>
				
			</cfif>
		   </td></tr>
		  </table>
		 <cfelse> 
		  <cfif blnRedirect neq 1> <!--- do not redirect the user --->
		   <cfif blnDisplayMsg neq 0>
			<table border=0 cellpadding=0 cellspacing=0 width="100%">
			 <tr><td align="center" class="bold">
			  Sorry, the requested page is no longer available.
			 </td></tr>
			</table>
		   </cfif> 
		   <table border=0 cellpadding=0 cellspacing=0 width="100%">
			<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
			<tr><td align="center"><a href="#returnToLink#">#returnToText#</a></td></tr>
		   </table>
		  <cfelse>
		   <cflocation url="#returnToLink#" addtoken="no">
		   <!--- <script language="JavaScript">location.href="#returnToLink#";</script> --->
		  </cfif>
		 </cfif> 
		<cfelse>
		 <cfif blnRedirect neq 1> <!--- do not redirect the user --->
		  <cfif blnDisplayMsg neq 0>
		   <table border=0 cellpadding=0 cellspacing=0 width="100%">
			<tr><td align="center" class="bold">
			 Sorry, the requested page is no longer available.
			</td></tr>
		   </table>
		  </cfif>
		  <table border=0 cellpadding=0 cellspacing=0 width="100%">
		   <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
		   <tr><td align="center">&nbsp;&nbsp;<a href="#returnToLink#">#returnToText#</a></td></tr>   
		  </table>
		 <cfelse>
		  <cflocation url="#returnToLink#" addtoken="no">
		  <!--- <script language="JavaScript">location.href="#returnToLink#";</script> --->
		 </cfif>
		</cfif>





<cfelse>
	<table border=0 cellpadding=0 cellspacing=0 width="100%">
		<tr><td align="center" class="bold">We are sorry but the requested page is no longer available.</td></tr>
	</table>
</cfif>
</cfoutput>