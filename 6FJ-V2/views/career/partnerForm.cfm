<script language="javascript">
var emailExistsErrTxt = '';

function checkform2(){

	var errormsg = '';
 	var errNum=0;
	//alert(errNum);
	//First Name
	if (document.getCPLInfo.CPLFname.value == '' || document.getCPLInfo.CPLFname.value == 'First Name'){
		document.getElementById('CPLFname').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Last Name
	if (document.getCPLInfo.CPLLname.value == '' || document.getCPLInfo.CPLLname.value == 'Last Name'){
		document.getElementById('CPLLname').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Email
	if (document.getCPLInfo.CPLEmail.value == '' || document.getCPLInfo.CPLEmail.value == 'Email'){
		document.getElementById('CPLEmail').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Phone 1
	if (document.getCPLInfo.CPLDPhone.value == '' || document.getCPLInfo.CPLDPhone.value == 'Day Phone'){
		document.getElementById('CPLDPhone').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Phone 2
	if (document.getCPLInfo.CPLEPhone.value == '' || document.getCPLInfo.CPLEPhone.value == 'Evening Phone'){
		document.getElementById('CPLEPhone').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Address
	if (document.getCPLInfo.CPLAddr.value == '' || document.getCPLInfo.CPLAddr.value == 'Address'){
		document.getElementById('CPLAddr').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//City
	if (document.getCPLInfo.CPLCity.value == '' || document.getCPLInfo.CPLCity.value == 'City'){
		document.getElementById('CPLCity').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//State
	if (document.getCPLInfo.CPLCntry.value == ''){
		document.getElementById('CPLCntry').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Zip
	if (document.getCPLInfo.CPLZip.value == '' || document.getCPLInfo.CPLZip.value == 'Zip'){
		document.getElementById('CPLZip').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//alert(errNum);
	//Errors
  	if (errNum > 0){
		document.getElementById('submitBtn').style.visibility = "visible";
		document.getElementById('errorDiv').style.display = "block";
		//Scroll to the top		
		$("html, body").animate({ scrollTop: 0 }, "fast");
  		return false ;
 	}else{
		$("#submitBtn").attr("disabled", "disabled");
		document.getElementById('errorDiv').style.display = "none";
  		document.getCPLInfo.submit();
  	}
	
}	
</script>
<cfoutput>
<cfparam name="intLeadTrackingID" default="">
<cfparam name="intPID" default="">
<!--- <cfset blnPIDShown="1"> --->
<cfif cgi.script_name contains "ExecMyAccountAd">
	<cfset intPID="3">
</cfif>


<cfinclude template="partnerFormVars.cfm">

<cfif isdefined('form.popupform')>
	<!--- <cfinclude template="t_CPLPartnerRegValidate.cfm"> --->
<cfelse>
	<cfset blnPassValidate = 0>
</cfif>

<cfif not isdefined('CPLGROUPID') or CPLGROUPID eq "">
	 <cfquery name="cfqGetGrpID" datasource="#application.dsn#">
 		 select intGroupID from tblCPLMemberLokUp (nolock) 
	 	where intMemberID=#CPLMemberID#
 	 </cfquery>
	 <cfset CPLGROUPID = cfqGetGrpID.intGroupID>

</cfif>

<cfquery name="getCPLInfo" datasource="#application.dsn#">
	 select strDisplayName,strImageName from tblCPLMember (nolock) 
	where intMemberID=#CPLMemberID#
 </cfquery>
 <div class="alert alert-error" id="errorDiv" style="max-width:600px;color:##F00; display:none;">
	<strong>Warning!</strong> Please complete the fields below highlighted in red.
</div>
<form action="/partner?#application.strAppAddToken#&forminsert=Y&target=#url.target#" method="post" name="getCPLInfo">
<table cellpadding="0" cellspacing="0" border="0">
<!--- <cfif blnCPLoggedIn neq 1>  --->
	<cfif blnCPLoggedIn eq 1>
		<cfinclude template="t_CPLPartnerRegValidate.cfm">
	</cfif>
	
	<cfif CPLEmail neq "">
		<cfstoredproc procedure="sp_cpl_check_for_dup" datasource="#application.dsn#" returncode="Yes">
	    <cfprocparam type="IN" dbvarname="@intMemberID" value="#val(url.target)#" cfsqltype="CF_SQL_INTEGER">
	    <cfprocparam type="IN" dbvarname="@strEmail" value="#CPLEmail#" cfsqltype="CF_SQL_VARCHAR">
	    <cfprocresult resultset="1" name="cfqCheckCPLDup">
	   </cfstoredproc>
	   <cfif cfqCheckCPLDup.recordcount gt 0>
	   		<cfset blnPassValidate=1>
	   </cfif>
   </cfif>
	
	
	
<!--- <cfif blnPassValidate eq 0> --->
<!--- if the person is NOT LOGGED in --->

<cfif isdefined("getCPLInfo.strDisplayName")>
<input type="hidden" name="franchiseName" value="#getCPLInfo.strDisplayName#">
<input type="hidden" name="franchiseImage" value="#getCPLInfo.strImageName#">
	<tr>
		<td colspan="5">
			<div align=""><img src="/images/cpls/#getCPLInfo.strImageName#" /><br /><br /></div>
		<b>Please enter your contact information before submitting your request to #getCPLInfo.strDisplayName#.</b>
</td>
	</tr>
<Cfelse>
	<tr>
		<td colspan="5"><b>Please enter your contact information before submitting your request.</b></td>
	</tr>
</cfif>

	<tr><td colspan="5"><input type="hidden" name="popupform" value="1">
	<input type="hidden" name="CPLMEMBERIDLIST" value="#url.target#">
	<input type="hidden" name="intLeadTrackingID" value="#intLeadTrackingID#">
	<!--- Carry all of the hidden fields submitted to this page --->
	<!--- <!--- 
	<input type="hidden" name="returnlink" value="#ReturnLink#">
	<input type="hidden" name="CPLMEMBERIDLIST" value="#CPLMEMBERIDLIST#">
	<input type="hidden" name="INTTARGETID" value="#INTTARGETID#">
	<input type="hidden" name="TARGETLOCATION" value="#TARGETLOCATION#">
	
	<input type="hidden" name="AM" value="#AM#">
	<input type="hidden" name="BLNADDTFIELDS" value="#BLNADDTFIELDS#">
	<input type="hidden" name="BLNADDTLOGGEDINFIELDS" value="#BLNADDTLOGGEDINFIELDS#">
	<input type="hidden" name="BLNCPLOGGEDIN" value="#BLNCPLOGGEDIN#">
	<input type="hidden" name="BLNFIRSTPASS" value="#BLNFIRSTPASS#">
	
	<input type="hidden" name="intLeadTrackingID" value="#intLeadTrackingID#">
	<input type="hidden" name="intPID" value="#intPID#">
	
	<input type="hidden" name="INTFIELDLIST" value="#INTFIELDLIST#">
	<input type="hidden" name="INTLOGGEDINFIELDLIST" value="#INTLOGGEDINFIELDLIST#">
	<input type="hidden" name="M" value="#M#">
	<input type="hidden" name="RETURNTEXT" value="#RETURNTEXT#">
	<input type="hidden" name="STREDUCATIONLEVEL" value="#STREDUCATIONLEVEL#">
	<input type="hidden" name="CPLGROUPID" value="#CPLGROUPID#"> ---> --->
	
	&nbsp;</td></tr>
	
	<tr>
		<td colspan="5"><cfinclude template="partnerFormFields.cfm"></td>
	</tr>
	
	</form>
	<!--- <cfelse>
		<tr>
			<td colspan="5">here
			
			
			
			</td>
		</tr> 
	</cfif>--->
<!--- <cfelse>
	<tr>
		<td colspan="5">
			<cfinclude template="t_CPLPartnerRegValidate.cfm">
			<cfinclude template="t_CPartnerConfirmPopup.cfm">
			<!--- <cflocation url="#ReturnLink#"> --->
		</td>
	</tr>
	
</cfif>  --->
</table>

</cfoutput>

