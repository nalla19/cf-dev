<cfif isdefined("cookie.RememberMe") and cookie.RememberMe neq "">
	<cfinclude template="/api/autoLogin.cfm">
</cfif>
<!--- <cfdump var="#session#"> --->

<cfif (cgi.HTTP_REFERER contains 'ERExpAcctPage')>
	<cfif not StructIsEmpty(session)> 
   		<cfset strSesionKeys=StructKeyList(session)>
   		<cfloop list="#strSesionKeys#" index="ListElement">
    		<cfset rc=StructDelete(session, "#ListElement#", "True")>
   		</cfloop>
  	</cfif> 
</cfif>
<!--- set the default action to home --->
<cfparam name="url.act" default="home">
<cfif url.act eq "join/sales">
	<cfset url.act = "join/sales/">
</cfif>

<cfparam name="request.signinactivetab" default="member">
<cfparam name="session.exec.intsitevisitjobid" default="">
<!--- go live 3/26 --->
<cfparam name="request.portalNav" default="">
<cfparam name="request.error" default="0">
<cfparam name="request.errorcode" default="">
<cfparam name="request.fname" default="">
<cfparam name="request.lname" default="">
<cfparam name="request.email" default="">
<cfparam name="request.passwd" default="">
		
<!--- set the default URL tracking tags --->
<cfparam name="url.tkcd" default="-1">
<cfparam name="tCode" default="-1">

<!--- Set the tracking tags --->
<cfinclude template="../views/tracking.cfm">

<!--- LeadFormix Tracking Tag --->
<cfset request.ldfxtrackingtag = false />
<cfset request.seekertrackingtag = false />
<cfset request.recruitertrackingtag = false />

<!--- --------------------------start plugins (run on every page request)-------------------------- --->

<!--- url and form scope to request scope (this way we can access everything in the request scope for ease of use) --->
<cfset StructAppend(request, url, false)>
<cfset StructAppend(request, form, false)>

<!--- --------------------------end plugins-------------------------- --->


<!---ISR 03/07/14 maintenance message
<cfif cgi.remote_addr NEQ "xxxxx" and cgi.remote_addr NEQ "xxxxx" and cgi.REMOTE_ADDR NEQ "xxxx" AND cgi.REMOTE_ADDR NEQ "xxxx">
	<cfset url.act ="maintenance-message">
</cfif> --->

<!--- switch through the public url actions --->
<cfswitch expression="#url.act#">
	
	
	<!--- landing page --->
	<cfcase value="home">
		<cfif isdefined("cookie.RememberMe") and cookie.RememberMe neq "">
			<cfif isdefined("session.EXEC.strloginLoc")>
				<cfif session.EXEC.strloginLoc EQ "6FJ">
					<cflocation url="/member-dashboard" addtoken="no">
				</cfif>
				<cfif session.EXEC.strloginLoc EQ "L365">
					<cflocation url="/learn365-dashboard" addtoken="no">
				</cfif>
			</cfif>
		</cfif>
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfscript>
		request.linkedinlogo		= "signuplinkedin-button.png";
		request.regdivider			= "reg-divider.png";
			
		request.ary_companies		= application.companyManager.getBestInClassCompanies();
		request.company				= application.companyManager.getCompanyOfTheWeek();
		request.qry_activemembers 	= application.util.getActiveMembers();
		request.getAverageJobSalary = application.util.getAverageJobSalary();
			
		request.theJoinFrm			= includeIT('../views/join/frm_join.cfm');
		request.theContent 			= includeIT('../views/home.cfm');
			
		request.thePageCSS			= "page-home.css";
		request.thePageTitle		= "Senior-Level and Executive Job Search | $100K+ Jobs | 6FigureJobs";
		request.thePageDescription	= "6FigureJobs is a leading online $100K+ job search and recruitment community for senior-level & executive talent. High-caliber professionals use 6FigureJobs to market their candidacy, connect with leading companies and recruiters, and search thousands of six-figure executive and management level opportunities.";
		request.thepageKeywords		= "$100K jobs, six-figure jobs, six figure jobs, executive job search, executive jobs, executive careers, executive search, management jobs";
		request.thePageGoogleVer	= "xxxxxx";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	
	<cfcase value="about">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />

		<cfscript>
		request.theContent 			= includeIT('../views/about.cfm');
			
		request.thePageTitle		= "An Elite $100K+ Job Search and Recruitment Network for Senior-Level & Executive Professionals & Recruiters | 6FigureJobs";
		request.thePageDescription	= "Since 1999, 6FigureJobs has been a leading online $100K+ job search and recruitment community for senior-level & executive talent. High-caliber professionals use 6FigureJobs to market their candidacy, connect with leading companies and recruiters, and search thousands of six-figure executive and management level opportunities.";
		request.thePageKeywords		= "100K jobs, six-figure jobs, six figure jobs, executive job search, executive jobs, executive recruiter, executive search, top talent, talent specialists, executive network";
		</cfscript>
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	
	<cfcase value="faqs,faq">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfscript>
		request.theContent 			= includeIT('../views/faqs.cfm');
		
		request.thePageTitle		= "Frequently Asked Questions | 6FigureJobs";
		request.thePageDescription	= "Questions about 6FigureJobs free job seeker membership, executive job search, and companies seeking and hiring top talent today.";
		request.thePageKeywords		= "6FigureJobs, six figure jobs, 6 figure jobs, faqs, frequently asked questions";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	
	<cfcase value="advertise">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		
		<cfscript>
		request.theContent 			= includeIT('../views/advertise.cfm');
			
		request.thePageTitle		= "Advertise to Attract Executives, Decision Makers and Business Leaders | 6FigureJobs";
		request.thePageDescription	= "Advertise with 6FigureJobs, and gain maximum exposure to our exclusive executive membership base of business leaders and decision leaders.";
		request.thePageKeywords		= "executive lead generation, franchising lead generation, advertising opportunities, target executives, attract executives, decision-makers, business leaders";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	
	<cfcase value="privacy">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfscript>
		request.theContent 			= includeIT('../views/privacy.cfm');
		
		request.thePageTitle		= "Privacy Policy | 6FigureJobs";
		request.thePageDescription	= "6FigureJobs privacy policy.";
		request.thePageKeywords		= "privacy policy";
		</cfscript>
	
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>

</cfswitch>



<cffunction name="includeIT" output="false" returntype="string" access="private" hint="includes the cfm file passed in and returns it as a variable">
	<cfargument name="thePath" type="string" required="true" />
	<cfset var theContent = "" />
	<cfsavecontent variable="theContent"><cfinclude template="#thePath#"></cfsavecontent>
	<cfreturn theContent>
</cffunction>

<cffunction name="do404" output="true" access="private" hint="displays the custom 404 page not found message">
	<cfheader statuscode="404">
	<cfset request.theContent = "<br><br><div class='text-center'><h2>This page cannot be found.</h2></div><br><br>">
	<cfinclude template="../views/templates/mainTemplate.cfm">
</cffunction>