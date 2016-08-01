<cfparam name="request.thePageTitle" default="6FigureJobs Professional Registration">
<cfparam name="request.thePageDescription" default="">
<cfparam name="request.thePageKeywords" default="">
<cfparam name="request.thePageGoogleVer" default="">
<cfparam name="request.thePageCSS" default="page-home.css">
<cfparam name="request.signinactivetab" default="">
<cfparam name="request.ldfxtrackingtag" default="true">
<cfparam name="request.theContent" default="">
<cfparam name="request.act" default="">
<cfparam name="url.act" default="">

<!--- Default is false for LinkedIn user --->
<cfparam name="url.liuser" default="false">

<cfif not isDefined("url.Fy4ZT9ZUv")>
<cflocation url="/home">
</cfif>

<!--- <!DOCTYPE html>
<html>
<head>
	<cfoutput>
	<title>#request.thePageTitle#</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="#request.thePageDescription#" />
	<meta name="keywords" content="#request.thePageKeywords#" />
	<cfif len(request.thePageGoogleVer)>
		<meta name="google-site-verification" content="#request.thePageGoogleVer#" />
	</cfif>
	
	<meta name="allow-search" content="yes">
	<meta name="robots" content="index,follow">
	<meta name="author" content="6FigureJobs.com">
	
	<!-- Bootstrap -->
	<link href="assets/css-join/bootstrap.min.css" rel="stylesheet" media="screen">
	<link href="assets/css-join/bootstrap-responsive.min.css" rel="stylesheet" media="screen">
	<link href="assets/css-join/custom-theme/jquery-ui-1.10.0.custom.css" rel="stylesheet" media="screen">
	
	<!-- Stylesheet -->
	<link href="assets/css-join/custom.css?#application.appVersionNumber#" rel="stylesheet" media="screen">
	
	<link href="assets/css/custom.css?#application.appVersionNumber#" rel="stylesheet" media="screen">
	<link href="assets/css/page-join.css?#application.appVersionNumber#" rel="stylesheet" media="screen">
	
	<!--[if lt IE 9]>
	<script src="assets/js-join/html5shiv.js"></script>
	<script src="assets/js-join/respond.min.js"></script>
	<![endif]-->
	
	<script src="assets/js-join/prefixfree.min.js"></script>--->
	<!---><link rel="shortcut icon" href="assets/img/favicon.ico">--->
	<!--- <link rel="shortcut icon" href="assets/img/favicon-092012.ico?#application.appVersionNumber#">  --->

	<!--- <cfif application.machine NEQ "local">
		<script type="text/javascript" src="//use.typekit.net/qis2rct.js"></script>
		<script type="text/javascript">try{Typekit.load();}catch(e){}</script>
	</cfif> 
	
	</cfoutput>--->
	
<!-- Start Visual Website Optimizer Asynchronous Code -->
<!--- <script type='text/javascript'>
var _vwo_code=(function(){
var account_id=45132,
settings_tolerance=2000,
library_tolerance=2500,
use_existing_jquery=false,
// DO NOT EDIT BELOW THIS LINE
f=false,d=document;return{use_existing_jquery:function(){return use_existing_jquery;},library_tolerance:function(){return library_tolerance;},finish:function(){if(!f){f=true;var a=d.getElementById('_vis_opt_path_hides');if(a)a.parentNode.removeChild(a);}},finished:function(){return f;},load:function(a){var b=d.createElement('script');b.src=a;b.type='text/javascript';b.innerText;b.onerror=function(){_vwo_code.finish();};d.getElementsByTagName('head')[0].appendChild(b);},init:function(){settings_timer=setTimeout('_vwo_code.finish()',settings_tolerance);this.load('//dev.visualwebsiteoptimizer.com/j.php?a='+account_id+'&u='+encodeURIComponent(d.URL)+'&r='+Math.random());var a=d.createElement('style'),b='body{opacity:0 !important;filter:alpha(opacity=0) !important;background:none !important;}',h=d.getElementsByTagName('head')[0];a.setAttribute('id','_vis_opt_path_hides');a.setAttribute('type','text/css');if(a.styleSheet)a.styleSheet.cssText=b;else a.appendChild(d.createTextNode(b));h.appendChild(a);return settings_timer;}};}());_vwo_settings_timer=_vwo_code.init();
</script> --->
<!-- End Visual Website Optimizer Asynchronous Code -->
<!--- </head>

<body class="page-join"> --->
<cfparam name="strCity" default="">
<cfparam name="strFName" default="">
<cfparam name="strLName" default="">
<cfparam name="strEmail" default="">
<cfparam name="strHomePhone" default="">
<cfparam name="strMobilePhone" default="">
<cfparam name="strState" default="">
<cfparam name="execLocation" default="">
<cfparam name="resumeFile" default="">
<cfparam name="blnSignUpForAAA" default="">
<cfparam name="resumeTitle" default="">
<cfparam name="intPrivacySetting" default="">

<cfparam name="strExecJobTitle_1" default="">
<cfparam name="strExecJobTitle_2" default="">
<cfparam name="strExecJOBCompany_1" default="">
<cfparam name="strExecJOBCompany_2" default="">
<cfparam name="strDesiredJobTitle" default="">
<cfparam name="fltCompensation_package" default="">
<cfparam name="memoSalary_requirement" default="
Examples:
My current base salary is $135K; annual bonus 15% of base.
I'm looking for a minimum of $145K. Salary is negotiable.
Currently out of work, but was making $150K." />
              
<cfparam name="intsIndIDs" default="">
<cfparam name="intsFuncIDs" default="">
<cfparam name="intYrsExp" default="">
<cfparam name="strHighestDegree1" default="">
<cfparam name="strHighestDegree2" default="">
<cfparam name="strHighestDegree3" default="">
<cfparam name="strHighestDegree4" default="">
<cfparam name="strHighestDegree5" default="">
<cfparam name="blnInHouseEmail" default="1">
<cfparam name="blnNewsLetter" default="1">
<cfparam name="blnEmail" default="0">
<cfparam name="blnSpecialOffer" default="0">

<cfparam name="blnEvents" default="">
<cfparam name="strSchool" default="">
<cfparam name="strSchool1" default="">
<cfparam name="strSchool2" default="">
<cfparam name="strSchool3" default="">
<cfparam name="strSchool4" default="">
<cfparam name="strSchool5" default="">

<cfparam name="strAddress1" default="">
<cfparam name="strAddress2" default="">
<cfparam name="strState" default="">
<cfparam name="strCardType" default="">
<cfparam name="cardNumber" default="">
<cfparam name="cardMonth" default="">
<cfparam name="cardYear" default="">
<cfparam name="securityCode" default="">
<cfparam name="cardname" default="">


<cfscript>
//Get the decrypted intResID
intResID = application.registration.getDecryptedResID(url.Fy4ZT9ZUv);
resDetails = application.registration.getResDetails(intResID);
</cfscript>

<cfset strFName=resDetails.fname>
<cfset strLName=resDetails.lname>
<cfset strEmail=resDetails.email>
<cfset STRLOCKTIMEOUT  = 10>

<!---Set the intResID into the Session variables--->
<cfparam name="session.exec.intResID" default="0">
<cflock scope="session" timeout="10" type="Exclusive">                
	<cfset session.exec.intResID = intResID>
</cflock>

<!---Parsing variables--->
<cfparam name="url.message" default="" />
<cfscript>
// Assume Parsing Is OK --->
inValidParse = 1;
//uploadedPath = "\v16fj\exports\";
</cfscript>

<!---Create the resume upload directory if it does not exist already--->
<!--- <cfif not(directoryExists(uploadedPath))>
	<cfdirectory directory="#uploadedPath#" action="create" />
</cfif> --->

<cfif isDefined("form.fieldnames")>
	<cfif isDefined("url.liUser") and (url.liUser)>
	    <!--- <cfinclude template="_includes/process_linkedInstep2.cfm"> --->
		<cfinclude template="processJoinLinkedInStep2.cfm">
	<cfelse>
		<cfinclude template="processJoinStep2.cfm">
	</cfif>	
<cfelse>
	<!--- <cfinclude template = "_includes/step2Variables.cfm">	 --->
	<cfif len(intResID)>
	<cfquery name="cfqGetResDetails" datasource="#application.dsn#">
    select * from tblResumes (nolock) where intResID = #intResID#
    </cfquery>
    
    <cfset strCity = cfqGetResDetails.city>
    <cfset strState = cfqGetResDetails.state>
	
    <cfset execLocation = cfqGetResDetails.zip>
    
	<cfset strHomePhone = cfqGetResDetails.home_phone>
    <cfset strMobilePhone = cfqGetResDetails.mobile_phone>
    
   	<cfquery name="cfqCheckAAA" datasource="#application.dsn#">
    select * from tblAAABatch (nolock) where intResID = #intResID#
    </cfquery>
    <cfif cfqCheckAAA.recordcount gt 0>
	    <cfset blnSignUpForAAA = 1>
    </cfif>
    
    <cfquery name="cfqResProfiles" datasource="#application.dsn#">
    select * from tblResumeProfiles (nolock) where fk_intResID = #intResID#
    </cfquery>
    <cfset resumeTitle = cfqResProfiles.title>
    
    <cfset intPrivacySetting = cfqGetResDetails.intPostRecepient>
    
    <cfset strExecJobTitle_1 = cfqGetResDetails.strExecJobTitle_1>
    <cfset strExecJobTitle_2 = cfqGetResDetails.strExecJobTitle_2>
    <cfset strExecJOBCompany_1 = cfqGetResDetails.strExecJobCompany_1>
    <cfset strExecJOBCompany_2 = cfqGetResDetails.strExecJobCompany_2>
    <cfset strDesiredJobTitle = cfqGetResDetails.strDesiredJobTitle>
    <cfset fltCompensation_package = cfqGetResDetails.fltCompensation_package>
    
	
	<cfif len(cfqGetResDetails.memoSalary_requirement) gt 0>
        <cfset memoSalary_requirement = cfqGetResDetails.memoSalary_requirement>
    <cfelse>
	<cfset memoSalary_requirement = "
	Examples:
	My current base salary is $135K; annual bonus 15% of base.
	I'm looking for a minimum of $145K. Salary is negotiable.
	Currently out of work, but was making $150K." />   	
		</cfif>
		
		
		
		<cfquery name="cfqGetInds" datasource="#application.dsn#">
		select intAttID
		  from tblResAtt (nolock)
		 where 1=1
		   and intResID = #intResID#
		   and intAttID in (select intOldIndID from tblIndustries (nolock))
		</cfquery>
		<cfset intsIndIDs = valuelist(cfqGetInds.intAttID)>
		
		<cfquery name="cfqGetFuncs" datasource="#application.dsn#">
		select intAttID
		  from tblResAtt (nolock)
		 where 1=1
		   and intResID = #intResID#
		   and intAttID in (select intOldFunctionID from tblFunctions (nolock))
		</cfquery>
		<cfset intsFuncIDs = valuelist(cfqGetFuncs.intAttID)>
		
		
		<cfif cfqGetResDetails.intYearsExperience gt 0>
			<cfset intYrsExp = cfqGetResDetails.intYearsExperience>
		</cfif>
		
		<cfif cfqGetResDetails.blnInHouseEmail is "">
			<cfset blnInHouseEmail = 1>
		<cfelse>
			<cfset blnInHouseEmail = cfqGetResDetails.blnInHouseEmail>
		</cfif>
		
		<cfif cfqGetResDetails.blnNewsLetter is "">
			<cfset blnNewsLetter = 1>
		<cfelse>
			<cfset blnNewsLetter = cfqGetResDetails.blnNewsLetter>
		</cfif>
		
		<cfset blnSpecialOffer = cfqGetResDetails.blnSpecialOffer>
		<cfset blnEvents = cfqGetResDetails.blnEvents>
		
		<cfset blnEmail = cfqGetResDetails.blnEmail>
		
		<cfquery name="cfqGetDegreeCollege" datasource="#application.dsn#">
		select * from tblResDegreeUniversity (nolock) where intResID = #intResID#
		</cfquery>
		
		<cfset i=1>
		<cfloop query="cfqGetDegreeCollege" startrow="1" endrow="#cfqGetDegreeCollege.recordcount#">
			<cfset strHighestDegree = "strHighestDegree#i#">
			<cfset strHighestDegree = cfqGetDegreeCollege.strDegree>
			
			<cfset strSchool = "strSchool#i#">
			<cfset strSchool = cfqGetDegreeCollege.strUnivCollegeName>
			<cfset i=i+1>
		</cfloop>
		
	</cfif>
</cfif>

<cfoutput>	
	<cfif url.liuser>
		<!--- <cfinclude template="_includes/step2LinkedInRegistration.cfm"> --->
		<cfinclude template="joinStep2LinkedInForm.cfm">
		<script src="/js/join/step2LinkedInValidation.js"></script>
	<!--- Regular 6FigureJobs Registration --->
	<cfelse>
		<cfinclude template="joinStep2Form.cfm">
		<script src="/js/join/step26FJValidation.js"></script>
	</cfif>



<!--- 
<script src="assets/js-join/jquery.min.js"></script>
<script src="assets/js-join/bootstrap.min.js"></script>
<script src="assets/js-join/jquery-ui-1.10.0.custom.min.js"></script>
<script src="assets/js-join/Placeholders.min.js"></script>

<script src="assets/js/jquery.js"></script>
<script src="assets/js/bootstrap-transition.js"></script>
<script src="assets/js/bootstrap-alert.js"></script>
<script src="assets/js/bootstrap-modal.js"></script>
<script src="assets/js/bootstrap-dropdown.js"></script>
<script src="assets/js/bootstrap-scrollspy.js"></script>
<script src="assets/js/bootstrap-tab.js"></script>
<script src="assets/js/bootstrap-tooltip.js"></script>
<script src="assets/js/bootstrap-popover.js"></script>
<script src="assets/js/bootstrap-button.js"></script>
<script src="assets/js/bootstrap-collapse.js"></script>
<script src="assets/js/bootstrap-carousel.js"></script>
<script src="assets/js/bootstrap-typeahead.js"></script>

<script src="/js/jQuery.bubbletip-1.0.6.js" type="text/javascript"></script>
<script src="/js/facebox/facebox.js" type="text/javascript"></script>
<script src="/js/jQuery.bubbletip-1.0.6.js" type="text/javascript"></script>

<script type="text/javascript" src="/js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="/js/ajax.js"></script>
<script type="text/javascript" src="/js/ajax-tooltip.js"></script>  

<script language="javascript" src="assets/js/execloc_ajax_framewok.js"></script>
<script language="javascript" src="assets/js/execschool_ajax_framewok.js"></script>
 --->
<!--- <script type="text/javascript">
jQuery(document).ready(function($) {
	//For the BasicPlan popup
	$('a[rel*=facebox]').facebox() 
})

$('##myModal').modal('hide');

// To test the @id toggling on password inputs in browsers that don’t support changing an input’s @type dynamically (e.g. Firefox 3.6 or IE), uncomment this:
// $.fn.hide = function() { return this; }
// Then uncomment the last rule in the <style> element (in the <head>).
$(function() {
    // Invoke the plugin
    $('input, textarea').placeholder();
});
</script> --->

<!--//Education-->
<!--- <cfloop index="i" from="1" to="5">
	<cfset j = i-1>
    <script>
    $("##removeDegEduText#i#").click(function() {
        $("##addEducationSchool#i#").slideUp(0);
        $("##removeDegEduText#j#").show();
		
		//Degree
		$("##strHighestDegree#i#")[0].selectedIndex = 0;
		//School University Name
		$("##strSchool#i#").val('')
        
		myDegreeCollege-=1;
        <cfif i is 5>
           $("##addDegreeSchool").show();
        </cfif>
    });  	
    </script>
</cfloop>
 ---><!--//Education-->
</cfoutput>

<script src="/js/autoSuggest.js"></script>