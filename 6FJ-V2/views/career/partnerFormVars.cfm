<cfoutput>

<cfparam name="CPLFname" default="">
<cfparam name="CPLLname" default="">
<cfparam name="CPLAddr" default="">
<cfparam name="CPLAddr2" default="">
<cfparam name="CPLZip" default="">
<cfparam name="CPLDPhone" default="">
<cfparam name="CPLEPhone" default="">
<cfparam name="CPLEmail" default="">
<cfparam name="CPLCity" default="">
<cfparam name="CPLCntry" default="">


<cfparam name="strAction" default="edit">

<cfparam name="in_error0" default="<span class='error_red'>">
<cfparam name="in_error1" default="</span>">
<cfparam name="blnPassValidate" default="1">
<cfparam name="blnPassFname" default="1">
<cfparam name="blnPassLname" default="1">
<cfparam name="blnPassAddr" default="1">
<cfparam name="blnPassZip" default="1">
<cfparam name="blnPassDphone" default="1">
<cfparam name="blnPassEphone" default="1">
<cfparam name="blnPassEmail" default="1">
<cfparam name="blnPassCity" default="1">
<cfparam name="blnPassCntry" default="1">
<cfparam name="blnSaved" default="0">
<cfparam name="intCPLType" default="99">

<cfparam name="blnAddtFields" default="0"> <!--- are there add't fields??? --->
<cfparam name="intFieldList" default="0"> <!--- if so, what is the list of fields --->

<cfparam name="blnAddtLoggedInFields" default="0">
<cfparam name="intLoggedInFieldList" default="0">

<cfparam name="strEducationLevel" default="">
<cfparam name="blnPassEdu" default="1">
<cfparam name="intFormID" default="2">
<!--- Added by Jim --->
<cfparam name="blnCPLoggedIn" default="0">
<cfparam name="blnFirstPass" default="1">
<!--- /Added by Jim --->
<!--- blnFirstPass = <cfoutput>#blnFirstPass#</cfoutput> --->
<cfif blnFirstPass neq 0>
 <!--- get the member profile information --->
 <cfquery name="cfqGetAddtFields" datasource="#application.dsn#">
  select intAddFieldList, intLoggedInFieldsList, m.strAddCommentsQues as memberQues <cfif intFormID eq 1>, g.strAddCommentsQues as groupQues</cfif>, intCPLType
  from tblCPLMember m (nolock)
   <cfif intFormID eq 1>
    inner join tblCPLMemberLokUp lok (nolock) on m.intMemberID=lok.intMemberID and lok.intGroupID=#CPLGroupID#
		inner join tblCPLGroup g (nolock) on lok.intGroupID=g.intGroupID
   </cfif>
  <cfif intFormID eq 2>
   where intMemberID=#CPLMemberID#
  </cfif>
 </cfquery>
 
 <!--- build the list of add't fields --->
  <cfset prevList="">  
  <cfloop query="cfqGetAddtFields">
   <cfset currList=cfqGetAddtFields.intAddFieldList>
   <cfif currList neq 0>
    <cfif listLen(currList) gt listLen(prevList)>
     <cfset intFieldList=currList>
    </cfif>
   <cfelse>
    <cfset currList="">
   </cfif>
   <cfset prevList=currList>
  </cfloop>
  <cfif (listLen(intFieldList) gt 0) AND (intFieldList neq 0)>
   <cfset blnAddtFields=1>
  </cfif>
    
 <!--- 
 <cfif blnAddtFields neq 0>
  <cfparam name="strEducationLevel" default="">
  <cfparam name="blnPassEdu" default="1">
 </cfif>
 --->
 
 <!--- build the list of add't fields for when you are logged in --->
 <cfset prevList="">
 <cfset currList="">
 <cfloop query="cfqGetAddtFields">
  <cfset currList=cfqGetAddtFields.intLoggedInFieldsList>
  <cfif currList neq 0>
   <cfif listLen(currList) gt listLen(prevList)>
    <cfset intLoggedInFieldList=currList>
   </cfif>
  <cfelse>
   <cfset currList="">
  </cfif>
  <cfset prevList=currList>
 </cfloop>
 <cfif (listLen(intLoggedInFieldList) gt 0) AND (intLoggedInFieldList neq 0)>
  <cfset blnAddtLoggedInFields=1>
 </cfif>

 <cfif blnAddtLoggedInFields neq 0>
  <cfparam name="strAddCommentsQues" default="">
  <cfif intFormID eq 1>
   <cfset strAddCommentsQues=cfqGetAddtFields.groupQues>
  <cfelse>
   <cfset strAddCommentsQues=cfqGetAddtFields.memberQues>
  </cfif>
  <cfparam name="strAddtComments" default="#strAddCommentsQues#">
  <cfparam name="blnPassAddtComments" default="1">
 </cfif>
 
 
 <!--- if the person is logged in, get their profile information --->
 <cfif isDefined("session.EXEC.blnValidLogin")>
  <cflock scope="session" timeout="10" type="Exclusive">
   <cfparam name="session.EXEC.intResID" default="">
   <cfset lcl_resID=session.EXEC.intResID>
  </cflock>

  <cfif lcl_resID neq "">
   <cfquery name="cfqGetCPLLead" datasource="#application.dsn#">
     select fname, lname, address, city, state, zip, work_phone, home_phone, email, degrees, strHighestDegree
 	 from tblResumes (nolock)
	 where intResID=#lcl_resID#    
   </cfquery>
    
   <cfif cfqGetCPLLead.RecordCount gt 0>
    <cfset CPLFname=cfqGetCPLLead.fname>
    <cfset CPLLname=cfqGetCPLLead.lname>
    <cfset CPLAddr=cfqGetCPLLead.address>
    <cfset CPLZip=cfqGetCPLLead.zip>
    <cfset CPLDPhone=cfqGetCPLLead.work_phone>
    <cfset CPLEPhone=cfqGetCPLLead.home_phone>
    <cfset CPLEmail=cfqGetCPLLead.email>
    <cfset CPLCity=cfqGetCPLLead.city>
    <cfset CPLCntry=cfqGetCPLLead.state>
    <cfif cfqGetCPLLead.strHighestDegree neq "">
     <cfset strEducationLevel=cfqGetCPLLead.strHighestDegree>
    <cfelse>
     <cfset strEducationLevel=cfqGetCPLLead.degrees>
    </cfif>
   </cfif>
  </cfif>
 </cfif>
 
</cfif>

</cfoutput>
