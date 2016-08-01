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
<cfif cgi.remote_addr NEQ "104.1.83.217" and cgi.remote_addr NEQ "76.23.141.164" and cgi.REMOTE_ADDR NEQ "207.237.212.168" AND cgi.REMOTE_ADDR NEQ "108.228.61.0">
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
		request.thePageGoogleVer	= "ELfSv-j-I27XjJ9tk7Q8gb2d_GjpFGw7AajZEVap_tE";
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
	
	
	<cfcase value="terms">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
	
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfscript>
		request.theContent 			= includeIT('../views/terms.cfm');
		
		request.thePageTitle		= "Terms of Use | 6FigureJobs";
		request.thePageDescription	= "6FigureJobs Terms of Use Agreement.";
		request.thePageKeywords		= "terms, conditions, use agreement";
		</cfscript>
	
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	
	<cfcase value="contact">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		
		<cfscript>
		request.theContent 			= includeIT('../views/contact.cfm');
		
		request.thePageTitle		= "Contact Us | 6FigureJobs";
		request.thePageDescription	= "Contact 6FigureJobs for technical job search assistance, client relations, advertising or sales recruitment information.";
		request.thePageKeywords		= "6FigureJobs, six figure jobs, 6 figure jobs, contact information, job search support";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="sitemap">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfscript>
		request.thePageTitle	= "Sitemap - 6FigureJobs";
		
		request.theContent 		= includeIT('../views/sitemap.cfm');
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="showcaptcha">
		<cfinclude template="../views/showcaptcha.cfm">
	</cfcase>
	
	
	<cfcase value="join,join/">								
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Coming from the join/index.cfm page if there is no password entered --->
		<cfif isDefined("url.error")>
			<cfset request.error = 1>
			
			<cfif isDefined("url.errorcode") and url.errorcode neq "">
				<cfset request.errorcode = url.errorcode>
			</cfif>
	
			<cfset request.querystring = URLDecode(cgi.query_string)>
			<cfset request.querystring = ReReplace(request.querystring, "act=join&error=1&errorcode=4&", "", "ALL")>
			
			<cfloop list="#request.querystring#" index="fieldName" delimiters="&">
			
				<cfif fieldName contains "fn10dtz">
					<cfset request.fname = ReReplace(fieldName, "fn10dtz=", "", "ALL")>
				</cfif>
				
				<cfif fieldName contains "ln09gTc">
					<cfset request.lname = ReReplace(fieldName, "ln09gTc=", "", "ALL")>
				</cfif>
				
				<cfif fieldName contains "em87LTr">
					<cfset request.email = ReReplace(fieldName, "em87LTr=", "", "ALL")>
				</cfif>
				
				<cfif fieldName contains "pd23pqE">
					<cfset request.passwd = ReReplace(fieldName, "pd23pqE=", "", "ALL")>
				</cfif>
			</cfloop>
		</cfif>
		
		
		<cfscript>
		request.linkedinlogo		= "signuplinkedin-button.png";
		request.regdivider			= "reg-divider-2.png";
			
		request.theJoinFrm			= includeIT('../views/join/frm_join.cfm');
		request.theContent 			= includeIT('../views/join/join.cfm');
		
		request.thePageTitle		= "6FigureJobs Professional / Executive Registration";
		request.thePageDescription	= "6FigureJobs is an elite community of senior-level and executive professionals that provides $100K+ job opportunities from leading companies and executive recruiting firms, including C-level, VP, Director and Senior Manager jobs. Membership is FREE.";
		request.thePageKeywords		= "search jobs, join free, free membership, $100K jobs, six-figure jobs, six figure jobs, job opportunities, executive community";
		</cfscript>
		
		<!---
		<div class="alert alert-error">
		Some of the required fields are missing from your submission.
		<br>
		Please correct the items marked in red below
		</div>
		--->
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="join-process">
    	<cfif len(cgi.http_referer)>
			<!--- Enable the Seeker Tracking Tag --->
			<cfset request.seekertrackingtag = true />
		   <cfinclude template="../views/join/processJoin.cfm">
		  <cfelse>
		 	<cflocation url="/home">
		 </cfif>
    </cfcase>
	
	<cfcase value="join-linkedin">
    	<!--- <cfif len(cgi.http_referer)> --->
			<!--- Enable the Seeker Tracking Tag --->
			<cfset request.seekertrackingtag = true />
		    <cfinclude template="../views/join/linkedin/index.cfm">
		  <!--- <cfelse>
		 	<cflocation url="/home">
		 </cfif> --->
    </cfcase>
	
	<cfcase value="join-linkedin-redirect">
    	<!--- <cfif len(cgi.http_referer)> --->
			<!--- Enable the Seeker Tracking Tag --->
			<cfset request.seekertrackingtag = true />
		    <cfinclude template="../views/join/linkedin/redir.cfm">
		 <!---  <cfelse>
		 	<cflocation url="/home">
		 </cfif> --->
    	
    </cfcase>
	
	<cfcase value="join-step2">
    	<!--- <cfif len(cgi.http_referer)> --->
			<!--- Enable the Seeker Tracking Tag --->
			<cfset request.seekertrackingtag = true />
			
		   <!--- <cfinclude template="../views/join/joinStep2.cfm"> --->
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				request.ary_states		= application.util.getStates();
				request.theContent = includeIT('../views/join/joinStep2.cfm');
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
		  <!--- <cfelse>
		 	<cflocation url="/home">
		 </cfif> --->
    	
    </cfcase>	
	
	<cfcase value="join-step3">
    	<cfif len(cgi.http_referer)>
			<!--- Enable the Seeker Tracking Tag --->
			<cfset request.seekertrackingtag = true />
			
		   <!--- <cfinclude template="../views/join/joinStep2.cfm"> --->
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				request.theContent = includeIT('../views/join/joinStep3.cfm');
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
		   <cfinclude template="../views/join/joinStep3SlideUp.cfm">
		 <cfelse>
		 	<cflocation url="/home">
		 </cfif>
    </cfcase>	
	
	<cfcase value="join-step3b">
    	<cfif len(cgi.http_referer)>
			<!--- Enable the Seeker Tracking Tag --->
			<cfset request.seekertrackingtag = true />
			
			<cfscript>
				request.thePageCSS	= "page-learn365.css";
				request.ary_states		= application.util.getStates();
				request.theContent = includeIT('../views/learn365/signup.cfm');
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
		 <cfelse>
		 	<cflocation url="/home">
		 </cfif>
    </cfcase>
	
	
	<cfcase value="join-thank-you">
		<cfif len(cgi.http_referer)>
			<!--- Enable the Seeker Tracking Tag --->
			<cfset request.seekertrackingtag = true />
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				request.theContent = includeIT('../views/join/thankyou.cfm');
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
		 <cfelse>
		 	<cflocation url="/home">
		 </cfif>
    </cfcase>	
	
	<cfcase value="join/sales/, join/sales">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Coming from the join/index.cfm page if there is no password entered --->
		<cfif isDefined("url.error")>
			<cfset request.error = 1>
			
			<cfif isDefined("url.errorcode") and url.errorcode neq "">
				<cfset request.errorcode = url.errorcode>
			</cfif>
	
			<cfset request.querystring = URLDecode(cgi.query_string)>
			<cfset request.querystring = ReReplace(request.querystring, "act=join&error=1&errorcode=4&", "", "ALL")>
			
			<cfloop list="#request.querystring#" index="fieldName" delimiters="&">
			
				<cfif fieldName contains "fn10dtz">
					<cfset request.fname = ReReplace(fieldName, "fn10dtz=", "", "ALL")>
				</cfif>
				
				<cfif fieldName contains "ln09gTc">
					<cfset request.lname = ReReplace(fieldName, "ln09gTc=", "", "ALL")>
				</cfif>
				
				<cfif fieldName contains "em87LTr">
					<cfset request.email = ReReplace(fieldName, "em87LTr=", "", "ALL")>
				</cfif>
				
				<cfif fieldName contains "pd23pqE">
					<cfset request.passwd = ReReplace(fieldName, "pd23pqE=", "", "ALL")>
				</cfif>
			</cfloop>
		</cfif>
		
		
		<cfscript>
		request.linkedinlogo		= "signuplinkedin-button.png";
		request.regdivider			= "reg-divider-2.png";
			
		request.theJoinFrm			= includeIT('../views/join/frm_join.cfm');
		request.theContent 			= includeIT('../views/join/sales_join.cfm');
		
		request.thePageTitle		= "6FigureJobs Professional / Executive Registration";
		request.thePageDescription	= "6FigureJobs is an elite community of senior-level and executive professionals that provides $100K+ job opportunities from leading companies and executive recruiting firms, including C-level, VP, Director and Senior Manager jobs. Membership is FREE.";
		request.thePageKeywords		= "search jobs, join free, free membership, $100K jobs, six-figure jobs, six figure jobs, job opportunities, executive community";
		</cfscript>
				
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="newsletter.signup">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfparam name="request.emailaddress" default="">
		<cfparam name="request.newsType" default="">
		
		<cfset request.email = request.emailaddress>
		
		<cfif len(request.email) AND len(request.newsType)>
			
			<cfinclude template="../filters/act_newsLetter.cfm">
			
			<cfsavecontent variable="request.theContent">
				<div class="container section">
					<h1 class="page-title">Thank you!</h1>
					<p class="page-subtitle">
						<cfif request.newsType is "exec">
							Thank you for subscribing to our Weekly Executive Newsletter for Job Seekers.
						<cfelseif request.newsType is "er">
							Thank you for subscribing to our Monthly Recruitment Newsletter for Recruiters.
						<cfelseif request.newsType is "both">
							Thank you for subscribing to our Weekly Executive Newsletter for Job Seekers ad our Monthly Recruitment Newsletter for Recruiters.
						</cfif>
						<br>
						<br>
						To ensure delivery, we recommend that you add CommunityManager@6FigureJobs.com to your address book. You can unsubscribe any time.
						<br>
						<br>
						
						Also, please be sure to follow us at our social media profiles below for current news, career advice, and job alerts.
	                </p>
				</div>
			</cfsavecontent>
			
		<cfelse>
		
			<cfsavecontent variable="request.theContent">
				<div class="container section">
					<div class="alert alert-error">Woops! We could not process the information submitted.</div>
				</div>
			</cfsavecontent>
			
		</cfif>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<!--- ---------------Start: Login via access token----------- --->
	<cfcase value="login,login/">
    	
		<cfscript>
		request.blnValidToken	= true;
		request.tokenExpired	= false;
		request.theContent 		= includeIT('../views/member/loginToken.cfm');
		request.thePageTitle	= "Job Seeker Invalid Login - 6FigureJobs";
		</cfscript>
		
		<!---
		<cfoutput>
		request.blnValidToken = #request.blnValidToken#<br>
		request.tokenExpired = #request.tokenExpired#<br>
		</cfoutput>
		--->
		
		<cfif !request.blnValidToken>
			<cfsavecontent variable="request.theContent">
			<div class="container section">
			<h1 class="page-title">Invalid Access Token</h1>
			<p class="page-subtitle">
			The access token invalid. Please <a href="#signin" data-toggle="modal" class="signin-link">click here</a> to sign in.
			<br />
			Click the <a href="/member-password">Forgot Password</a> link for assistance.
			<br>
			</p>
			</div>
			</cfsavecontent>
		</cfif>
		
		<cfif request.blnValidToken and request.tokenExpired>
			<cfsavecontent variable="request.theContent">
			<div class="container section">
			<h1 class="page-title">Access Token Expired</h1>
			<p class="page-subtitle">
			The access token has expired. Please <a href="#signin" data-toggle="modal" class="signin-link">click here</a> to sign in.
			<br />
			Click the <a href="/member-password">Forgot Password</a> link for assistance.
			<br>
			</p>
			</div>
			</cfsavecontent>
		</cfif>
		<!---
		<cfsavecontent variable="request.theContent">
		<div class="container section">
			<h1 class="page-title">Invalid Login</h1>
			<p class="page-subtitle">
			The login information you entered is invalid. Please <a href="#signin" data-toggle="modal" class="signin-link">click here</a> to sign in.
			<br />
			Click the <a href="/member-password">Forgot Password</a> link for assistance.
			<br>
			</p>
		</div>
		</cfsavecontent>
		--->
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	<!--- ---------------End: Login via access token----------- --->
	
	
<!--- --------------------------------Member login start------------------------------- --->
	<cfcase value="member-login">
    
    	<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
        
       <cfinclude template="../views/member/loginRequest.cfm">
      
    </cfcase>
	
	<cfcase value="member-refresh">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfquery datasource="#application.dsn#">
			   update tblResumes
			   set dteEdited=GetDate()
			   where intResID='#session.exec.intResID#'
			 </cfquery>
			
			 <cfset messageRefresh="Your resume was successfully refreshed.">
			 
			 <cfset session.EXEC.dteEdited=NOW()>
			<cflocation url="/member-dashboard">
			
		<cfelse>
		 	<cflocation url="/home">
		</cfif>
		 
		  
    </cfcase>
	
	<cfcase value="member-login-linkedin">
    
    	<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
        
       <cfinclude template="../views/member/linkedin/index.cfm">
       
    </cfcase>
	<cfcase value="login-linkedin-redirect">
    
    	<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
        
       <cfinclude template="../views/member/linkedin/redir.cfm">
       
    </cfcase>
<!--- --------------------------------Member login end------------------------------- --->

<!--- --------------------------------Member logout start------------------------------- --->
	<cfcase value="member-logout">
    
    	<cflock scope="session" timeout="10" type="Exclusive">
		 <cfif not StructIsEmpty(session)> 
          <cfset strSesionKeys=StructKeyList(session)>
          <cfloop list="#strSesionKeys#" index="ListElement">
           <cfset rc=StructDelete(session, "#ListElement#", "True")>
          </cfloop>
         </cfif>
		 <cfcookie name="RememberMe" value="" expires="now" />
        </cflock>
        <cflocation url="/home">
    </cfcase>
<!--- --------------------------------Member logout end------------------------------- --->

    
<!--- -------------------------------Member Retrieve Password start---------------------------- --->	
	<cfcase value="member-password">
    	<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfparam name="request.blnSendEmail" default="0">
    	<cfparam name="request.username" default="">
        <cfparam name="request.blnPassChecks" default="1">
        <cfparam name="request.memberInactive" default="0">
        
        <cfparam name="request.firstname" default="">
        <cfparam name="request.lastname" default="">
        <cfparam name="request.email" default="">
        <cfparam name="request.username" default="">
        <cfparam name="request.password" default="">
        
        <cfif request.blnSendEmail is 1 AND len(request.username) AND (isDefined('session.captcha') AND request.captcha EQ session.captcha)>
	    
            <cfset request.qry_memberlogininfo	= application.util.getMemberLoginInfo(username=request.username) />
            
			<cfif request.qry_memberlogininfo.recordcount is 0>
        
            	<cfset request.blnPassChecks = 0>
        
            <cfelseif request.qry_memberlogininfo.recordcount is 1>
        
            	<cfif request.qry_memberlogininfo.blndelete is 1>
                	<cfset request.blnPassChecks = 0>
                    <cfset request.memberInactive = 1>
                <cfelse>
                    <cfset request.firstname = request.qry_memberlogininfo.fname>
                    <cfset request.lastname = request.qry_memberlogininfo.lname>
                    <cfset request.email = request.qry_memberlogininfo.email>
                    <cfset request.username = request.qry_memberlogininfo.username>
                    <cfset request.password = request.qry_memberlogininfo.password>
                    <cfset request.blnPassChecks = 1>
                </cfif>
        
            </cfif>
        
		</cfif>
        
		<cfscript>
			request.theContent 		= includeIT('../views/member/password.cfm');
			
			request.thePageTitle	= "Retreive Password - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
    
<!--- --------------------------------Member Retrieve Password end----------------------------- --->

<!--- -------------------------------Member Reset Password start---------------------------- --->	
	<cfcase value="change-password">
    	<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
        
		<cfscript>
			request.theContent 		= includeIT('../views/member/changePassword.cfm');
			
			request.thePageTitle	= "Change Password - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
    
<!--- --------------------------------Member Reset Password end----------------------------- --->

<!--- --------------------------------Member Invalid login start------------------------------- --->
	<cfcase value="member-invalid-login, member-invalid-login/">
    	
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		        
		<cfscript>
		request.thePageTitle	= "Job Seeker Invalid Login - 6FigureJobs";
		</cfscript>

		<cflock scope="session" timeout="10" type="Exclusive">
		 <cfif not StructIsEmpty(session)> 
          <cfset strSesionKeys=StructKeyList(session)>
          <cfloop list="#strSesionKeys#" index="ListElement">
           <cfset rc=StructDelete(session, "#ListElement#", "True")>
          </cfloop>
         </cfif>
        </cflock>
		<cfsavecontent variable="request.theContent">
		<div class="container section">
			<h1 class="page-title">Invalid Login</h1>
			<p class="page-subtitle">
				The login information you entered is invalid. Please <a href="#signin" data-toggle="modal" class="signin-link">click here</a> to sign in.
				<br />
				Click the <a href="/member-password">Forgot Password</a> link for assistance.
				<br>
				
				
			</p>
		</div>
		</cfsavecontent>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
<!--- --------------------------------Member Invalid login end------------------------------- --->


<!--- -------------------------------Member Already Exists start----------------------------- --->
	<cfcase value="member.exists, member.exists/">
    	
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		        
		<cfscript>
		request.linkedinlogo	= "signinlinkedin-button.png";
		request.thePageTitle	= "Job Seeker Already Exists - 6FigureJobs";
		</cfscript>
		
		<cfsavecontent variable="request.theContent">
		<div class="container section">
			<h1 class="page-title">Member Already Exists</h1>
			<p class="page-subtitle">
				<!---
				The email address you are trying to register with already exists in our system.
				<br> 
				Please use a different email address to sign up. Please <a href="join" class="signin-link">click here</a> to sign up.
				<br>
				<br>
				--->
				<a href="member-password" class="signin-link">Click here</a> to retrieve your password
				<br>
				
				-OR-
				
				<br>
				If the email address for your LinkedIn Account and 6FigureJobs account are the same, then 
				<cfoutput>
				<a href="/join-linkedin?startli=1&tCode=#url.tkcd#<cfif isDefined("session.exec.intsitevisitjobid") and isnumeric(session.exec.intsitevisitjobid)>&Qf7DS7PEi=#session.exec.intsitevisitjobid#</cfif><cfif isDefined("url.Pf9ZL4URh") and url.Pf9ZL4URh neq "">&Pf9ZL4URh=#url.Pf9ZL4URh#</cfif>" ><img src="/images/#request.linkedinlogo#" alt="Sign in Via LinkedIn" title="Sign in Via LinkedIn." /></a>
				</cfoutput>
				
			</p>
		</div>
		</cfsavecontent>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
<!--- ----------------------------------Member Already Exists End------------------------------ --->

<!--- --------------------------------Member dashboard start------------------------------- --->
	<cfcase value="member-dashboard">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
        	<cfscript>
			request.thePageCSS	= "page-dashboard.css";
			//request.theLogin = includeIT('../views/member/loginRequest.cfm');
			request.thePNotification = includeIT('../views/member/profileNotification.cfm');
			request.theContent = includeIT('../views/member/dashboard.cfm');
			</cfscript> 				
       		<cfinclude template="../views/templates/mainTemplate.cfm">
			<cfinclude template="../views/member/learn365PopUp.cfm">
			
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member dashboard end------------------------------- --->

<!--- --------------------------------Member CPL Page start------------------------------- --->
	<cfcase value="member-cpl">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
        	<cfscript>
			request.thePageCSS	= "page-dashboard.css";
			request.theContent = includeIT('../views/member/cpl.cfm');
			</cfscript> 				
       		<cfinclude template="../views/templates/cplTemplate.cfm">
			<cfinclude template="../views/member/cplslideup.cfm">
			<cfinclude template="../views/member/learn365PopUp.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member CPL Page end------------------------------- --->


<!--- --------------------------------Member profile start------------------------------- --->
	<cfcase value="member-profile">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/profile.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
		   <cfinclude template="../views/member/profileValidation.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	
	<cfcase value="member-cancel">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/cancelMembership.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	
	<cfcase value="autosuggest-school">
    	<cfinclude template="../views/join/execSchoolSearch.cfm">
    </cfcase>
	
	<cfcase value="autosuggest-city">
    	<cfinclude template="../views/join/execCityStateSearch.cfm">
    </cfcase>
<!--- --------------------------------Member profile end------------------------------- --->

<!--- --------------------------------Member resume start------------------------------- --->
	<cfcase value="member-resume">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/resume/manageResumes.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	
	<cfcase value="member-resume-delete">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/resume/deleteResume.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	
	<cfcase value="member-resume-preview">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/resume/previewResume.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	
	<cfcase value="member-resume-edit">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/resume/editResume.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	
	<cfcase value="member-resume-download">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/resume/downloadResume.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	<cfcase value="member-letter-edit">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/resume/editCoverLetter.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	<cfcase value="member-letter-preview">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/resume/previewCoverLetter.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
	<cfcase value="member-letter-delete">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/resume/deleteCoverLetter.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member resume end------------------------------- --->

<!--- --------------------------------Member privacy start------------------------------- --->
	<cfcase value="member-privacy">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				//request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/privacy/privacy.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member privacy end------------------------------- --->

<!--- --------------------------------Member Reset Stats start------------------------------- --->
	<cfcase value="member-stats">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				request.theContent = includeIT('../views/member/resetStats.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member  Reset Stats end------------------------------- --->


<!--- --------------------------------Member Job Alerts start------------------------------- --->
	<cfcase value="member-job-alerts">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				request.theContent = includeIT('../views/member/alerts/alertView.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member Job Alerts end------------------------------- --->

<!--- --------------------------------Member Job History start------------------------------- --->
	<cfcase value="member-job-history">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				request.theContent = includeIT('../views/member/alerts/jobApplyHistory.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member Job History end------------------------------- --->

<!--- --------------------------------Member Job Detail start------------------------------- --->
	<cfcase value="member-job-detail">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				request.theContent = includeIT('../views/member/alerts/jobApplyDetail.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member Job Detail end------------------------------- --->

<!--- --------------------------------Member subscriptions start------------------------------- --->
	<cfcase value="member-email-subscriptions">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				//request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/member/subscriptions/emailSub.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------Member subscriptions end------------------------------- --->


<!--- -----------------------------Recruiter Retrieve Password start--------------------------- --->	
	<cfcase value="recruiter-password">
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfparam name="request.blnSendEmail" default="0">
		<cfparam name="request.email" default="">
		<cfparam name="request.blnPassChecks" default="1">
		<cfparam name="request.recruiterInactive" default="0">
		
		<cfparam name="request.firstname" default="">
		<cfparam name="request.lastname" default="">
		<cfparam name="request.email" default="">
		<cfparam name="request.username" default="">
		<cfparam name="request.password" default="">
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">

		<cfif request.blnSendEmail is 1 AND len(request.email) AND (isDefined('session.captcha') AND request.captcha EQ session.captcha)>
		
			<cfset request.qry_recruiterlogininfo	= application.util.getRecruiterLoginInfo(email=request.email) />
		  
			<cfif request.qry_recruiterlogininfo.recordcount is 0>
			
				<cfset request.blnPassChecks = 0>
			
			<cfelseif request.qry_recruiterlogininfo.recordcount is 1>
			
				<cfif request.qry_recruiterlogininfo.dteAcctExp lt now()>
				
					<cfset request.firstname = request.qry_recruiterlogininfo.strFirstName>
					<cfset request.lastname = request.qry_recruiterlogininfo.strLastName>
					<cfset request.email = request.qry_recruiterlogininfo.strEmail>
					<cfset request.username = request.qry_recruiterlogininfo.strusername>
					<cfset request.password = request.qry_recruiterlogininfo.strPassword>
					<cfset request.blnPassChecks = 1>
					<cfset request.recruiterInactive = 1>
				
				<cfelse>
				
					<cfset request.firstname = request.qry_recruiterlogininfo.strFirstName>
					<cfset request.lastname = request.qry_recruiterlogininfo.strLastName>
					<cfset request.email = request.qry_recruiterlogininfo.strEmail>
					<cfset request.username = request.qry_recruiterlogininfo.strusername>
					<cfset request.password = request.qry_recruiterlogininfo.strPassword>
					<cfset request.blnPassChecks = 1>
				
				</cfif>
			
			</cfif>
		
		</cfif>
        
        
		<cfscript>
			request.theContent 		= includeIT('../views/recruiter/password.cfm');
			
			request.thePageTitle	= "Retreive Password - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>	
<!--- -------------------------------Recruiter Retrieve Password end--------------------------- --->	


<!--- --------------------------------Recruiter Invalid login start------------------------------- --->
	<cfcase value="recruiter-invalid-login">
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfset request.signinactivetab = "recruiter">
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">

		<cfscript>
		request.thePageTitle	= "Recruiter Invalid Login - 6FigureJobs";
		</cfscript>
		
		<cfsavecontent variable="request.theContent">
		<div class="container section">
			<h1 class="page-title">Invalid Login</h1>
			<p class="page-subtitle">
				The login information you entered is invalid. Please <a href="#signin" data-toggle="modal" class="signin-link">click here</a> to sign in.
				<br />
				Click the <a href="/recruiter-password">Forgot Password</a> link for assistance.
				<br>
				
				
			</p>
		</div>
		</cfsavecontent>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
<!--- --------------------------------Recruiter Invalid login end------------------------------- --->



<!--- --------------------------------Recruiter Mutli users start------------------------------- --->
	<cfcase value="recruiter-multi-users">
    	
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">
		
		<cfset request.signinactivetab = "recruiter">
		
		<cfscript>
		request.thePageTitle	= "Recruiter Invalid Login - 6FigureJobs";
		</cfscript>
		
		<cfsavecontent variable="request.theContent">
		<div class="container section">
			<h1 class="page-title">License Limit</h1>
			<p class="page-subtitle">
				We're sorry, you have currently exceeded your User License limit or you did not properly logout of your last session.
				<br />
				<br />
				Please contact your account manager at (800) 605-5154 for further assistance.
				<br>				
			</p>
		</div>
		</cfsavecontent>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
<!--- --------------------------------Recruiter Mutli users end------------------------------- --->

    
<!--- --------------------------------------company start-------------------------------------- --->
	<cfcase value="companies">
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfscript>
		request.ary_companies		= application.companyManager.getFeaturedCompanies();
		request.ary_hiring			= application.companyManager.getHiringCompanies();
		request.qry_industries		= application.companyManager.getCompanyPostingIndustries();
			
		request.theContent 			= includeIT('../views/company/companies.cfm');
		
		request.thePageCSS			= "page-companies.css";
		request.thePageTitle		= "Hiring Companies Recruiting Top Talent | 6FigureJobs";
		request.thePageDescription	= "See the leading companies and recruiters that are actively posting $100K+ jobs and searching for senior-level and executive talent.";
		request.thePageKeywords		= "hiring companies, who's hiring, job opportunities, growing companies, companies recruiting";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	
	<cfcase value="company">
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<cfparam name="request.seoStrCompany" default="">
		<cfscript>
			request.company			= application.companyManager.getCompany(seoStrCompany=request.seoStrCompany,
																			includeEmployers=true);
			
			if (len(request.company.getEmployerIds())) {							
				request.ary_jobs			= application.jobManager.getEmployerJobs(employerIds=request.company.getEmployerIds());
				
				request.theContent 			= includeIT('../views/company/company.cfm');
				
				request.thePageCSS			= "page-company.css";
				request.thePageTitle		= "#request.company.getStrCoName()# Jobs | 6FigureJobs";
				request.thePageDescription	= "A leading company that is actively searching for and hiring senior-level and executive talent on 6FigureJobs.";
				request.thePageKeywords		= "six-figure jobs, $100K+ jobs, hiring companies, growing companies, management opportunities";
			}
		</cfscript>
			
		<cfif len(request.company.getEmployerIds())>
			<cfinclude template="../views/templates/mainTemplate.cfm">
		<cfelse>
			<cfset do404() />
		</cfif>
	</cfcase>
<!--- --------------------------------------company end-------------------------------------- --->



	
<!--- --------------------------------------career start-------------------------------------- --->
	<cfcase value="career">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfscript>
		request.linkedinlogo		= "signuplinkedin-button.png";
		request.regdivider			= "reg-divider-2.png";
		
		request.theJoinFrm			= includeIT('../views/join/frm_join.cfm');
		request.theContent 			= includeIT('../views/career/career.cfm');
			
		request.thePageCSS			= "page-career.css";
		request.thePageTitle		= "Career Resources for Professional Development | 6FigureJobs";
		request.thePageDescription	= "6FigureJobs offers career services and resources to give executive and senior-level job seekers an edge in their $100K+ job search, including career marketing, networking, and personal branding, and entrepreneur opportunities";
		request.thePageKeywords		= "career resources, executive career search, executive coaching, professional development, career advice, career marketing, career coaching, career assistance, entrepreneurship";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="education">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfscript>
		request.thePageHTML 		= application.util.getCPLMember(intMemberID=137);
		request.theContent 			= includeIT('../views/career/education.cfm');
		
		request.thePageCSS			= "page-career.css";
		request.thePageTitle		= "Continuing Executive Education Opportunities | 6FigureJobs";
		request.thePageDescription	= "Stay competitive and consider these top universities offering advanced degrees and certificates in programs such as six sigma, project management, and leadership management.";
		request.thePageKeywords		= "online learning, six sigma, project management, MBA, eMBA, online MBA, leadership, management, continuing executive education, certification";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="opportunities,entrepreneur">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfscript>
		request.thePageHTML 		= application.util.getCPLMember(intMemberID=138);
		request.theContent 			= includeIT('../views/career/opportunities.cfm');
			
		request.thePageCSS			= "page-career.css";
		request.thePageTitle		= "Business, Entrepreneur and Franchise Opportunities | 6FigureJobs";
		request.thePageDescription	= "Own your own business. Free information on diverse and high-income franchise oppourtunities for entrepreneur seekers, consultants and executives.";
		request.thePageKeywords		= "franchises, franchise opportunities, franchise information, franchising, business opportunities, consulting, entrepreneur opportunities, entrepreneurship, self employment";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="entrepreneur-info">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfscript>
		//request.thePageHTML 		= application.util.getCPLMember(intMemberID=138);
		request.theContent 			= includeIT('../views/career/info.cfm');
			
		request.thePageCSS			= "page-career.css";
		//request.thePageTitle		= "Business, Entrepreneur and Franchise Opportunities | 6FigureJobs";
		//request.thePageDescription	= "Own your own business. Free information on diverse and high-income franchise oppourtunities for entrepreneur seekers, consultants and executives.";
		//request.thePageKeywords		= "franchises, franchise opportunities, franchise information, franchising, business opportunities, consulting, entrepreneur opportunities, entrepreneurship, self employment";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="partner">
		
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfparam name="request.target" default="0">
		
		<cfscript>
		request.thePageHTML 	= application.util.getCPLMember(intMemberID=request.target);
		request.theContent 		= includeIT('../views/career/partner.cfm');
			
		request.thePageCSS		= "page-career.css";
		request.thePageTitle	= "Business, Entrepreneur & Franchise Opportunities - 6FigureJobs";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="partner.contact">
		
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfparam name="request.target" default="0">
		
		<cfscript>
		request.thePageHTML 	= application.util.getCPLMember(intMemberID=request.target);
		request.theContent 		= includeIT('../views/career/partner.cfm');
			
		request.thePageCSS		= "page-career.css";
		request.thePageTitle	= "Business, Entrepreneur & Franchise Opportunities - 6FigureJobs";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
<!--- --------------------------------------career end-------------------------------------- --->




<!--- --------------------------------------recruitment start-------------------------------------- --->
	<cfcase value="recruiters,recruiters/,recruitment,recruitment/">
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">
		
		<cfscript>
		request.qry_activemembers 	= application.util.getActiveMembers();
		request.qry_topindustries	= application.util.getIndustryDemographics();
			
		request.theContent 			= includeIT('../views/recruiter/recruiters.cfm');
			
		request.thePageCSS			= "page-recruiters.css";
		request.thePageTitle		= "6FigureJobs | An Elite Executive Recruitment Community | Search Executive and Business Leader Talent | Post $100K+ Jobs";
		request.thePageDescription	= "Since 1999, 6FigureJobs allows corporate and executive recruiters to post six figure job opportunities and search the largest source of pre-screened senior-level and executive talent. Every candidate is pre-screened when joining our elite community. Recruiters are able to engage and contact our high-caliber, business leader talent with no communication barriers.";
		request.thePageKeywords		= "executive talent, senior-level professionals, management professionals, business leaders, executives, active job seekers, passive job seekers, executive talent pipeline";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="pricing">
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		
		<cfscript>
			request.qry_packages		= application.er.erpackagesetting;
			
			request.theContent 			= includeIT('../views/recruiter/pricing.cfm');
			
			request.thePageCSS			= "page-pricing.css";
			request.thePageTitle		= "6FigureJobs Recruitment Solutions & Pricing | Executive Talent & Business Leader Community | 6FigureJobs";
			request.thePageDescription	= "6FigureJobs Recruitment allows corporate and executive recruiters to post six-figure job opportunities and search a pre-screened community of seasoned executives and business leaders across all industries such as IT, Finance, Management Consulting, and Sales. Since 1999, 6FigureJobs has been a reliable source for recruiters to find and easily contact active and passive candidates and offers affordable recruitment plans.";
			request.thePageKeywords		= "search talent, post jobs, executive talent, senior-level professionals, management professionals, business leaders, executives, active job seekers, passive job seekers, executive talent pipeline, recruitment branding";
		</cfscript>
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="package">
		
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">
		
		<cfparam name="request.pid" default="0">
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		
		<!--- get the package --->
		<cfset request.qry_package		= application.util.getRecruiterPackage(qry_packages=application.er.erPackageSetting,package_id=request.pid) />
		
		<!--- set the session cart default values --->
		<cfinclude template="../filters/act_ErShoppingCart.cfm">
		
		<!--- if the user submitted include the filter to process the form --->
		<cfif isDefined("form.submit")>
			<cfinclude template="../filters/act_ErRegSubmit.cfm">
		</cfif>
		
		<!--- put the session values into the request scope for access --->
		<cflock scope="session" timeout="10" type="Exclusive">
			<cfset request.theFormVals = StructCopy(session.ER.shoppingCart) />
		</cflock>
		
		<cfif isdefined("cookie.sixFJResTracker") and cookie.sixFJResTracker neq "">
			<cftry>
				<cfset request.qry_leadid = application.util.getLeadId(tcode=cookie.sixFJResTracker)>
				<cfcatch type="any">
					<cfcookie name="sixFJResTracker" expires="#now()#">
				</cfcatch>
			</cftry>
		</cfif>
		
		<!--- include the rest of the page components --->
		<cfscript>
		request.ary_states		= application.util.getStates();
		request.qry_referral	= application.util.getErHowFind();
			
		request.thePackageFrm	=  includeIT('../views/recruiter/frm_package.cfm');
		request.theContent 		= includeIT('../views/recruiter/package.cfm');
			
		request.thePageCSS		= "page-pricing.css";
		request.thePageTitle	= "Recruiters - 6FigureJobs";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="ajx_package">
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">
		
		<cfparam name="pid" default="0">
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		
		<cfscript>			
		request.qry_package		= application.util.getRecruiterPackage(qry_packages=application.er.erPackageSetting,package_id=request.pid);
		request.ary_states		= application.util.getStates();
		</cfscript>
		
		<cfinclude template="../views/recruiter/frm_package.cfm">
	</cfcase>
	
	<cfcase value="package.confirm">
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">
		
		<cfparam name="request.pid" default="0">
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		
		<cfif isDefined("session.er.shoppingCart")>
			<cfscript>
				request.qry_package		= application.util.getRecruiterPackage(qry_packages=application.er.erPackageSetting,package_id=request.pid);
				
				request.theContent 		= includeIT('../views/recruiter/package_confirm.cfm');
				
				request.thePageCSS		= "page-pricing.css";
				request.thePageTitle	= "Recruiters - 6FigureJobs";
			</cfscript>
		</cfif>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="branding">
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		
		<cfscript>
		request.theContent 				= includeIT('../views/recruiter/branding.cfm');
			
		request.thePageCSS				= "page-recruiters.css";
		request.thePageTitle			= "Employer Branding | Recruitment Advertising | 6FigureJobs";
		request.thePageDescription		= "6FigureJobs.com offers powerful, affordable and engaging Employer Branding Solutions to hiring employers, companies and recruitment advertising agencies. Promote your employer brand and corporate culture to top business leaders.";
		request.thePageKeywords			= "employer branding, employment branding, recruitment advertising, agencies, corporate culture, company benefits, perks, recruitment marketing, talent engagement, social recruiting";

		</cfscript>
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="demographics">
		<!--- Enable the Rec Tracking Tag --->
		<cfset request.recruitertrackingtag = true />
		<!--- go live 3/26 --->
		<cfset request.portalNav="recruiter">
		
		<!--- Enable the LeadFormix Tracking Tag --->
		<cfset request.ldfxtrackingtag = true />
		
		<cfscript>			
		request.qry_activemembers 	= application.util.getActiveMembers();
		request.getAverageJobSalary = application.util.getAverageJobSalary();
		
		request.theContent 			= includeIT('../views/recruiter/demographics.cfm');
			
		request.thePageCSS			= "page-recruiters.css";
		request.thePageTitle		= "6FigureJobs Talent Demographics | 6FigureJobs";
		request.thePageDescription	= "Get to know the 6FigureJobs community of senior-level and executive business leaders that are actively or passively seeking new job opportunities.";
		request.thePageKeywords		= "demographics, executive demographics, job seeker demographics, job statistics, recruiting trends, job seeker industry statistics, six-figure salary ranges, job seekers with military background";
		</cfscript>
		
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
<!--- --------------------------------------recruitment end-------------------------------------- --->

<!--- --------------------------------------job apply start-------------------------------------- --->
	<cfcase value="job-apply">
    	<cfif isdefined("session.EXEC.blnValidLogin")>
			<cfscript>
				request.thePageCSS	= "page-dashboard.css";
				//request.theLogin = includeIT('../views/member/loginRequest.cfm');
							
				//request.thePNotification = includeIT('../views/member/profileNotification.cfm');
				request.theContent = includeIT('../views/job/jobApply.cfm');
				
			</cfscript> 
			
		   <cfinclude template="../views/templates/mainTemplate.cfm">
       <cfelse>
       		<cflocation url="/home">
       </cfif>
    </cfcase>
<!--- --------------------------------------job apply end-------------------------------------- --->

<!--- --------------------------------------job apply login start-------------------------------------- --->
	<cfcase value="job,job/">
    	
		<cfscript>
		request.thePageCSS	= "page-dashboard.css";
		request.theContent = includeIT('../views/member/jobLogin.cfm');
		</cfscript> 
			
		<cfinclude template="../views/templates/mainTemplate.cfm">
       
    </cfcase>
<!--- --------------------------------------job apply login end-------------------------------------- --->

<!--- --------------------------------------job start-------------------------------------- --->
	<cfcase value="search">
	
    	<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfparam name="request.display_page" default="jobsearchresults">
		<cfscript>																			
			request.qry_advertisingbanner = application.util.getAdvertisingBanner(display_page=request.display_page);
			
			includeIT('../views/job/solr.cfm');
			
			request.ikey = "sideMenu";
			request.thSearchFunctions   = includeIT('../views/job/search_functions.cfm');
			request.theSearchFilters	= includeIT('../views/job/search_filters.cfm');
			request.theContent 			= includeIT('../views/job/search.cfm');
			
			request.ikey = "topMenu";
			request.theSearchFilters	= includeIT('../views/job/search_filters.cfm');
			
			request.thePageCSS			= "page-search.css";
			request.thePageTitle		= "Search $100K+ Jobs | 6FigureJobs";
			request.thePageDescription	= "6FigureJobs provides only pre-screened $100K+ job opportunities from leading Fortune 1000 companies and executive recruiting firms, including C-level, VP, Director and Senior Manager jobs. Membership is FREE to search and apply to jobs.";
			request.thePageKeywords		= "search jobs, $100K+ jobs, six-figure jobs, six figure jobs, executive job search, executive jobs, job opportunities, management jobs, hiring companies";
			request.thePageGoogleVer	= "ELfSv-j-I27XjJ9tk7Q8gb2d_GjpFGw7AajZEVap_tE";
		</cfscript>
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
	
	<cfcase value="listing">
		<!--- Enable the Seeker Tracking Tag --->
		<cfset request.seekertrackingtag = true />
		
		<cfparam name="request.seoJobURL" default="">
		
		<cfif isDefined("url.ID")>
			<!--- Coming from JSA --->
			<cfset request.intJobId = url.ID />
		<cfelse>
			<!---Find the position of the hipen sign--->
			<cfset request.intJobId = listLast(request.seoJobURL, "-") />
		</cfif>
		
		
		<cfif isNumeric(request.intJobId)>
			<!---if the intsitevisitjobid is already stored do not update it--->
			<cfif not len(session.exec.intsitevisitjobid)>		
				<cflock scope="session" timeout="10" type="Exclusive">
					<cfset session.exec.intsitevisitjobid = request.intJobId>
				</cflock>
			</cfif>
			<!---//if the intsitevisitjobid is already stored do not update it--->
			
			<cfif isDefined("session.exec.categoryJobsBackLink") and session.exec.categoryJobsBackLink neq "">
				<cfset request.strActionFile = session.exec.categoryJobsBackLink>
			<cfelseif isDefined("session.exec.corpJobsBackLink") and session.exec.corpJobsBackLink neq "">
				<cfset request.strActionFile = session.exec.corpJobsBackLink>
			<cfelseif isDefined("session.exec.JSABackLink") and session.exec.JSABackLink neq "">
				<cfset request.strActionFile = session.exec.JSABackLink>
			<cfelse>
				<cfparam name="url.start1" default="0">
				<cfparam name="url.pgNo" default="1">
				
				<cfif isDefined("session.exec.searchAgentParams.start")>
					<cfset url.start1=session.exec.searchAgentParams.start>
				</cfif>
				
				<cfif isDefined("session.exec.searchAgentParams.pgNo")>
					<cfset url.pgNo=session.exec.searchAgentParams.pgNo>
				</cfif>
				
				<cfset request.strActionFile =  "/jobs/?start1=#url.start1#&pgNo=#url.pgNo#">
			</cfif>
			
			<cfscript>
				request.job					= application.jobManager.getJob(intJobId=request.intJobId);
				
				if (request.job.getIntJobId() GT 0) {
					request.company				= application.companyManager.getCompany(request.job.getIntEmployerId());
					
					request.theContent 			= includeIT('../views/job/listing.cfm');
					
					request.thePageCSS			= "page-listing.css";
					request.thePageTitle		= "#request.seoJobURL# | 6FigureJobs";
					request.thePageDescription	= "6FigureJobs is a leading online $100K+ job search and career community for senior-level & executive talent. High-profile professionals use 6FigureJobs to search thousands of $100K+ job opportunities from leading hiring companies and recruiters.";
					request.thePageKeywords		= "$100K jobs, six-figure jobs, six figure jobs, executive job search, executive jobs, executive search, executive network,  management jobs";
				} else {
					request.theContent 			= includeIT('../views/job/nolisting.cfm');
				}
			</cfscript>
			
			<cfinclude template="../views/templates/mainTemplate.cfm">
		<cfelse>
			<cfset do404() />
		</cfif>
	</cfcase>
	
	<cfcase value="post">
		<cfscript>
			request.theContent 		= includeIT('../views/job/post.cfm');
			
			request.thePageCSS		= "page-blog.css";
			request.thePageTitle	= "Job - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/mainTemplate.cfm">
	</cfcase>
<!--- --------------------------------------job end-------------------------------------- --->

<!--- maintenanceMessage --->
<cfcase value="maintenance-message">
	<cfscript>
		request.theContent 		= includeIT('../views/maintenanceMessage.cfm');
		
				request.thePageTitle	= "Job - 6FigureJobs";
	</cfscript>
	<cfinclude template="../views/templates/maintenanceTemplate.cfm">
</cfcase>

<!--- learn365 start--->
<!--- go live 3/26 --->
<cfcase value="learn365">
	<cfscript>
		request.showButtons = 1;
		request.theContent 		= includeIT('../views/learn365/landingPage.cfm');
		
		request.thePageCSS		= "page-learn365.css";
		request.thePageTitle = "Skills Development Learning from Experts | eLearning | Learn365";
		request.thePageDescription = "Learn365 is a leading resource to develop, strengthen, or refresh your leadership, strategy, selling, creative, and technical skills through eLearning.Learn a new skill every day or take a skill to the next level. Create new opportunities. Open new doors for your career.  Over 600 courses available with more added each month.  Unlimited Access.";
		request.thepageKeywords = "Learn365, MyLearn365, skills development, everyday learning, excel how to, learning courses, learning videos, unlimited learning, leadership courses, sales courses, techical courses";
		request.thePageGoogleVer	= "ELfSv-j-I27XjJ9tk7Q8gb2d_GjpFGw7AajZEVap_tE";
		request.profileNav = 0;
		
		//request.thePageTitle	= "Job - 6FigureJobs";
	</cfscript>
	<cfinclude template="../views/templates/learn365Template.cfm">
	
</cfcase>

<cfcase value="learn365-details">

	<cfscript>
	request.showButtons = 0;
		request.theContent 		= includeIT('../views/learn365/membershipDetails.cfm');
		
		request.thePageCSS		= "page-learn365.css";
		
		
		//request.thePageTitle	= "Job - 6FigureJobs";
	</cfscript>
	<cfinclude template="../views/templates/learn365Modal.cfm">
</cfcase>

<cfcase value="learn365-signup">
	<cfscript>
	    request.ary_states		= application.util.getStates();
		request.theContent 		= includeIT('../views/learn365/signup.cfm');
		
		request.thePageCSS		= "page-learn365.css";
		request.profileNav = 0;
		request.hideNav = 1;
		//request.thePageTitle	= "Job - 6FigureJobs";
	</cfscript>
	<cfinclude template="../views/templates/learn365Template.cfm">

</cfcase>

<cfcase value="learn365-dashboard">
	<cfif isDefined("session.exec.blnLearn365") and session.exec.blnLearn365 EQ 1>
		<cfscript>
			request.theContent 		= includeIT('../views/learn365/dashboard.cfm');
			
			request.thePageCSS		= "page-learn365.css";
			request.profileNav = 1;
			
			//request.thePageTitle	= "Job - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/learn365Template.cfm">
	<cfelse>
		<cflocation url="/learn365" addtoken="no">
	</cfif>

</cfcase>

<cfcase value="learn365-profile">
	<cfif isDefined("session.exec.blnLearn365") and session.exec.blnLearn365 EQ 1> 
		<cfscript>
			request.ary_states		= application.util.getStates();
			request.theContent 		= includeIT('../views/learn365/profile.cfm');
			
			request.thePageCSS		= "page-learn365.css";
			request.profileNav = 1;
			
			//request.thePageTitle	= "Job - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/learn365Template.cfm">
	<cfelse>
		<cflocation url="/learn365" addtoken="no">
	</cfif>

</cfcase>

<cfcase value="learn365-sso">
	<cfif isDefined("session.exec.blnLearn365") and session.exec.blnLearn365 EQ 1>
		<cfscript>
			request.theContent 		= includeIT('../views/learn365/singleSignOn.cfm');
			
			request.thePageCSS		= "page-learn365.css";
			//request.thePageTitle	= "Job - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/learn365Template.cfm">
	<cfelse>
		<cflocation url="/learn365" addtoken="no">
	</cfif>
</cfcase>

<cfcase value="learn365-cancel">
	<cfif isDefined("session.exec.blnLearn365") and session.exec.blnLearn365 EQ 1>
		<cfscript>
			request.theContent 		= includeIT('../views/learn365/cancelMembership.cfm');
			request.profileNav = 1;
			request.thePageCSS		= "page-learn365.css";
			//request.thePageTitle	= "Job - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/learn365Template.cfm">
	<cfelse>
		<cflocation url="/learn365" addtoken="no">
	</cfif>
</cfcase>

<cfcase value="learn365-activate">
	<cfif isDefined("session.exec.blnLearn365") and session.exec.blnLearn365 EQ 1>
		<cfscript>
			request.ary_states		= application.util.getStates();
			request.theContent 		= includeIT('../views/learn365/reactivate.cfm');
			request.profileNav = 1;
			request.thePageCSS		= "page-learn365.css";
			//request.thePageTitle	= "Job - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/learn365Template.cfm">
	<cfelse>
		<cflocation url="/learn365" addtoken="no">
	</cfif>
</cfcase>

<cfcase value="learn365-thankyou">
	<cfif isDefined("session.exec.blnLearn365") and session.exec.blnLearn365 EQ 1>
		<cfscript>
			
			request.theContent 		= includeIT('../views/learn365/thankyou.cfm');
			request.profileNav = 1;
			request.thePageCSS		= "page-learn365.css";
			//request.thePageTitle	= "Job - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/learn365Template.cfm">
	<cfelse>
		<cflocation url="/learn365" addtoken="no">
	</cfif>
</cfcase>

<cfcase value="learn365-course">
	
		<cfscript>
			request.theContent 		= includeIT('../views/learn365/coursePopup.cfm');
			request.profileNav = 1;
			request.thePageCSS		= "page-learn365.css";
			//request.thePageTitle	= "Job - 6FigureJobs";
		</cfscript>
		<cfinclude template="../views/templates/learn365Course.cfm">
	
</cfcase>


	<!--- no public act was found, now check private(logged in user) methods --->
	<cfdefaultcase>
		
		<!--- they are not logged in and no page was found, throw a 404 message to the webserver --->
		<cfset do404() />
	
	</cfdefaultcase>
	

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