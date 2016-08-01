<cfoutput>
<cfparam name="headershown" default="0">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
<cfif (parameterExists(intTargetLocation))>
 <cfif (intTargetLocation gt 0)>
  <cfswitch expression="#intTargetLocation#">
   <cfcase value="4">
    <!--- <tr><td><hr size=1 width="100%"></td></tr>
    <tr><td style="font-size:12px" class="exec_bld_grn" align="center">
     <!--- While we have your attention, please take a moment to read about this offer. --->
	 Please take a moment to read about these entrepreneurial opportunities. 
    </td></tr>
    <tr><td><hr size=1 width="100%"></td></tr>
    <tr><td>&nbsp;</td></tr> --->
    <div style="clear:both; padding-bottom:20px;"></div>
    <div class="horizontal_dotted_line"></div>
    <div style="clear:both; padding-bottom:20px;"></div>
   </cfcase>
  </cfswitch>
 <cfelse>
<!---  <tr><td><cfif headershown eq "0"><img src="Images/header_beyourownboss.gif" width="195" height="14" alt="" border="0"><img src="images/header_entrepreneur.gif" width="309" height="14" alt="" border="0"></cfif><cfset headershown=1><br>
	<br>
	</td></tr> --->
 </cfif>
<cfelse>
	<!--- <tr><td><cfif headershown eq "0"><img src="Images/header_beyourownboss.gif" width="195" height="14" alt="" border="0"><img src="images/header_entrepreneur.gif" width="309" height="14" alt="" border="0"></cfif><cfset headershown=1><br>
	<br>
	</td></tr> --->
</cfif>

<tr><td><cfif cfqGetCPLMember.RecordCount eq 1> <!--- only one member ---><cfset CPLMemberIDList=cfqGetCPLMember.intMemberID>
 <cfset ArrCPLMemberIDList = ArrayNew(2)>
 <!--- Create an array to carry values for the checkbox output --->
 <cfset ArrCPLMemberIDList[1][1] = "#cfqGetCPLMember.intMemberID#">
 <!--- Get Short titles if available --->
 <cfif trim(cfqGetCPLMember.ShortTitle) neq "">
	 <cfset ArrCPLMemberIDList[1][2] = "#cfqGetCPLMember.ShortTitle#">
 <cfelse>
 	<cfif isdefined('cfqGetCPLMember.MemberTitle')>
		<cfset ArrCPLMemberIDList[1][2] = "#cfqGetCPLMember.MemberTitle#">
	<cfelse>
		<cfset ArrCPLMemberIDList[1][2] = "#cfqGetCPLMember.strTitle#">
	</cfif>
 </cfif>
 
 <!--- <input type="hidden" name="CPLMemberIDList" value="#cfqGetCPLMember.intMemberID#"> ---><table border=0 cellpadding=0 cellspacing=0 width="100%">
  <tr><td>
   <cfset temp=cfqGetCPLMember.MemberBody>
   <cfset strstrip = application.util.getRemoveQuotes(strStrip="#temp#",  blnRemove="0")>
   <!--- <cf_ct_removeQuotes strStrip=#temp# blnRemove=0> --->
   #strStrip# 
  </td></tr>
  <tr><td>&nbsp;</td></tr>
 </table>
<cfelse><!--- mulitple CPLs to display --->
	<cfset ArrCPLMemberIDList = ArrayNew(2)>
	
 <cfset candidateName="">
 <!--- <cflock scope="session" timeout="#strLockTimeOut#" type="Exclusive">
  <cfparam name="session.EXEC.strFirstName" default="">
  <cfif session.EXEC.strFirstName neq "">
   <cfset lcl_title=session.EXEC.strFirstName & ", " & cfqGetCPLMember.GroupTitle>
  <cfelse>
   <cfset lcl_title=cfqGetCPLMember.GroupTitle>
   <cfset temp=ucase(left(lcl_title,1))>
   <cfset lcl_title=temp & removeChars(lcl_title, 1, 1)>
  </cfif>
 </cflock> --->
 <cflock scope="session" timeout="10" type="Exclusive">
  <cfparam name="session.EXEC.strFirstName" default="">
  <cfif session.EXEC.strFirstName neq "">
   <cfset lcl_title=session.EXEC.strFirstName & ", are you accustomed to a 6 figure income, but want to own your own business?">
  <cfelse>
   <cfset lcl_title="Are you accustomed to a 6 figure income, but want to own your own business?">
  </cfif>
 </cflock>
 <cfif cgi.script_name does not contain "ExecEditProfile.cfm">
 	<cfif headershown eq "0"><img src="Images/header_beyourownboss.gif" width="195" height="14" alt="6FigureJobs.com - Be Your Own Boss" border="0"><!--- <img src="images/header_entrepreneur.gif" width="309" height="14" alt="" border="0"> ---></cfif><cfset headershown=1>
 </cfif>
<table border=0 cellpadding=0 cellspacing=0 width="100%">
  <cfif cgi.script_name does not contain "ExecEditProfile.cfm">
  <tr><td colspan="3"><br>
  <b>#lcl_title#</b> <br>
  If the answer is yes, then please take a moment to read about these exciting entrepreneurial opportunities.<br>
  <br>
  </td></tr>
  <cfelse>
  <cfquery name="cfqGetCPLTitle" datasource="#application.dsn#">
  	select strHTMLTxt
	  from tblCPLGroup  (nolock)
	  where intGroupID=#cfqGetCPLMember.intgroupID#
  </cfquery>
  <cflock scope="session" timeout="10" type="Readonly">
  <cfif session.EXEC.strFirstName neq "">
   <cfset lcl_title="<b>" & session.EXEC.strFirstName & "</b>, " & cfqGetCPLTitle.strHTMLTxt>
  <cfelse>
   <cfset lcl_title=cfqGetCPLTitle.strHTMLTxt>
  </cfif>
  </cflock>
  #lcl_title#
  </cfif>
  <tr><td colspan="3"><img width=1 src="images/spacer.gif" height="8" border=0></td></tr> 
  <cfif cgi.script_name contains "/CPartners.cfm" or cgi.script_name contains "ExecEditProfile.cfm">
  	<cfset limit=cfqGetCPLMember.RecordCount>
  <cfelse>
  	<cfset limit=3>
  </cfif>
  <cfloop query="cfqGetCPLMember" startrow="1" endrow="#limit#">
   <tr>
    <td valign="middle">
	<!--- Create an array to carry values for the checkbox output --->
	<cfset ArrCPLMemberIDList[currentrow][1] = "#cfqGetCPLMember.intMemberID#">
	<!--- Get Short titles if available --->
	<cfif trim(cfqGetCPLMember.ShortTitle) neq "">
		<cfset ArrCPLMemberIDList[currentrow][2] = "#cfqGetCPLMember.ShortTitle#">
	 <cfelse>
	 	<cfif isdefined('cfqGetCPLMember.MemberTitle')>
			<cfset ArrCPLMemberIDList[currentrow][2] = "#cfqGetCPLMember.MemberTitle#">
		<cfelse>
			<cfset ArrCPLMemberIDList[currentrow][2] = "#cfqGetCPLMember.strTitle#">
		</cfif>
	 </cfif><a href=" CPartner.cfm?#strAppAddToken#&target=#cfqGetCPLMember.intMemberID#"><img src="images/#cfqGetCPLMember.strImageName#" border=0></a></td>
    <td><img width=10 src="images/spacer.gif" border=0></td>
    <td valign="top"><table border=0 cellpadding=0 cellspacing=0 width="100%">
      <tr><td class="bold"><a href=" CPartner.cfm?#strAppAddToken#&target=#cfqGetCPLMember.intMemberID#" style="text-decoration:none;font-weight:bold;">#cfqGetCPLMember.MemberTitle#</a></td></tr>	   
      
	  <tr><td valign="top">
       <cfset temp=cfqGetCPLMember.MemberTxt>
	   <cfset strstrip = application.util.getRemoveQuotes(strStrip="#temp#",  blnRemove="0")>
       <!--- <cf_ct_removeQuotes strStrip=#temp# blnRemove=0> --->
       #strStrip#
      </td></tr>
     </table>
    </td>
   </tr>
 <!---   <tr><td colspan="2">&nbsp;</td><td class="bold"><input onclick="checkBoxes(this);" type="checkbox" <cfif ListFind(CPLMemberIDList, #cfqGetCPLMember.intMemberID#) gt 0>checked<cfelseif blnFirstPass neq 0>checked</cfif> value="#cfqGetCPLMember.intMemberID#" name="CPLMemberIDList">Request To be Contacted</td></tr>
  ---><!---   <tr><td colspan="3">&nbsp;</td></tr> --->
  <!--- <cfif currentrow eq "3">
	  <tr><td colspan="3"><img width=1 src="images/spacer.gif" height="7" border=0></td></tr>
  <cfelse>
  	<tr><td colspan="3"><img width=1 src="images/spacer.gif" height="4" border=0></td></tr>
  </cfif> --->
  <tr><td colspan="3"><img width=1 src="images/spacer.gif" height="2" border=0></td></tr>

   
   <tr><td colspan="3"><img src="images/sponsorgray.gif" width="100%" height=1 border=0></td></tr>
	<tr><td colspan="3"><img width=1 src="images/spacer.gif" height="2" border=0></td></tr> 
  <!---  <tr><td colspan="3">&nbsp;</td></tr>   --->
  </cfloop>
 </table>
</cfif>
</td></tr>
</table></cfoutput>
