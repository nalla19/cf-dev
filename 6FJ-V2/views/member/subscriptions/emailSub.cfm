<!--- <link href="/join/assets/css/bootstrap.css" rel="stylesheet">
<link href="/join/assets/css/bootstrap-responsive.css" rel="stylesheet">


<cfinclude template="/6fj/_includes/templates/headers/preHeaderSetup.cfm">

 --->
<cfoutput>

<!--- (if logged in and a "new" member)  OR (a 6FigureOnTrack Member awaiting reapproval) --->
<cfif not isdefined("session.exec.intResAdmcode")>
	<cflocation url="/index.cfm" addtoken="no">
<cfelseif (session.exec.intResAdmCode eq 2) OR (session.exec.intResAdmCode eq 4) AND (session.exec.intResStatusCode eq 2)>
    <!---ISR <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr><td><cfinclude template="/6fj/t_PagePasswordText.cfm"></td></tr>
    </table> --->
<cfelse>
	    
	<cfif isDefined("form.fieldnames")>
	    <!--- <cfinclude template="ExecEditProfileSave.cfm"> --->
		<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
			update tblResumes set
			blnNewsletter=#form.blnNewsletter#,
			<!---blnEvents=#form.blnEvents#,--->
			blnSpecialOffer=#form.blnSpecialOffer#,
			blnInHouseEmail=#form.blnInHouseEmail#,
			blnEmail=#form.blnEmail#
			where intResid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif application.sourceApp EQ "6FigureJobs">
		
			<!--- //Add the contact to the newsletter if the candidate opted in to the newsletter// --->
			<cfif form.blnNewsletter is 1>
				<cfset application.leadFormixManager.addContact(list_name='Seeker Newsletter Opt In List 10-21-13', list_type='Newsletter', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com', 
																contact_email='#session.exec.strEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
																
			<!--- //Remove the contact from the newsletter if the candidate opted out of the newsletter// --->
			<cfelseif form.blnNewsletter is 0>
				<cfset application.leadFormixManager.removeContact( list_name='Seeker Newsletter Opt In List 10-21-13', list_type='Newsletter', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com',
																	contact_email='#session.exec.strEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
			</cfif>
			
			
			<!--- //Add the contact to the Special Offer if the candidate opted in to the Special Offer// --->
			<cfif form.blnSpecialOffer is 1>
				<cfset application.leadFormixManager.addContact(list_name='Seeker Special Offer Opt In List 11-06-13', list_type='Commercial', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com', 
																contact_email='#session.exec.strEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
																
			<!--- //Remove the contact from the newsletter if the candidate opted out of the newsletter// --->
			<cfelseif form.blnSpecialOffer is 0>
				<cfset application.leadFormixManager.removeContact( list_name='Seeker Special Offer Opt In List 11-06-13', list_type='Commercial', owner_name='Michelle Martin', owner_email='mmartin@calliduscloud.com',
																	contact_email='#session.exec.strEmail#', contact_first_name='#session.exec.strFirstName#', contact_last_name='#session.exec.strLastName#')>
			</cfif>  
		</cfif>
		
        	<div class="page-dashboard">
				<article class="section">
					<div class="container">
						<h1>Manage Email Subscriptions</h1>
						<div class="row">
							<div class="span12">
																
								<div class="alert alert-info" style="display:block;" id="successMessage">
								Your changes are saved successfully, please go back to the <a href="/member-dashboard">Dashboard</a>.
								</div>
								<div class="push"><!--//--></div>
								<div class="push"><!--//--></div>
								<div class="push"><!--//--></div>
							</div>
               			</div>
           			</div>
       			</article>
			</div>
   	<cfelse>
    	<!--- <cfinclude template="ExecEditProfileVars.cfm"> --->
		<!---ExecEditProfileVariables.cfm--->
		<cfparam name="blnInHouseEmail" default="1">
		<cfparam name="blnNewsLetter" default="1">
		<cfparam name="blnEmail" default="0">
		<cfparam name="blnSpecialOffer" default="0">
		<cfparam name="blnEvents" default="0">
		
		<!---<cfscript>
		//Get the decrypted intResID
		ISR resDetails = application.registration.getResDetails(session.exec.intResID); 
		</cfscript>--->
			
		
		<!---Parsing variables--->
		<cfparam name="url.message" default="" />
		<cfscript>
		// Assume Parsing Is OK --->
		inValidParse = 1;
		uploadedPath = application.sixfj.paths.webroot & "exports\";
		</cfscript>
		
		<!---Create the resume upload directory if it does not exist already--->
		<cfif not(directoryExists(uploadedPath))>
			<cfdirectory directory="#uploadedPath#" action="create" />
		</cfif>
		
		<!------------------------------------------------------------------------------------------------------------------------------------------------------->
		<cfif len(session.exec.intResID)>
			<cfquery name="cfqGetResDetails" datasource="#application.dsn#">
			select * from tblResumes (nolock) where intResID = #session.exec.intResID#
			</cfquery>
			
			<cfset blnEvents = cfqGetResDetails.blnEvents>
		
			<cfif len(cfqGetResDetails.blnInHouseEmail)>
				<cfset blnInHouseEmail = cfqGetResDetails.blnInHouseEmail>
			<cfelse>
				<cfset blnInHouseEmail = 1>
			</cfif>
			
			<cfset blnNewsLetter = cfqGetResDetails.blnNewsLetter>
			
			<cfif len(cfqGetResDetails.blnEmail)>
				<cfset blnEmail = cfqGetResDetails.blnEmail>
			<cfelse>
				<cfset blnEmail = 0>
			</cfif>
			
			<cfset blnSpecialOffer = cfqGetResDetails.blnSpecialOffer>
		</cfif>
		<!------------------------------------------------------------------------------------------------------------------------------------------------------->
        <cfoutput>
        
        <form name="ExecProfile" id="ExecProfile" method="post" enctype="multipart/form-data" action="/member-email-subscriptions" onSubmit="return checkform2();">
        
           <div class="page-dashboard">
				<article class="section">
					<div class="container">
						<h1>Manage Email Subscriptions</h1>
						<div class="row">
							
							<div class="span12">
																
								<div class="alert alert-error" id="errorDiv" style="max-width:600px;color:##F00; display:none;">
								<strong>Warning!</strong> Please complete the fields below highlighted in red.</div>
								<br>
															
								<!--- MEMBER EMAIL SUBSCRIPTIONS --->
								<!--- <div class="regsubheader"><h2>Member Email Subscriptions</h2></div> ---->
								<div class="row">
									<div class="span9">
									   <div class="controls" style="padding-bottom:25px;">Occasional updates about site improvements from our Community Manager (Recommended)</strong></div>
									</div>
							
									<div class="span3">
										<div class="controls">
											<label class="radio inline"><input tabindex="26" type="radio" name="blnInHouseEmail" id="blnInHouseEmail" value="1" <cfif blnInHouseEmail eq 1> checked </cfif>>Yes&nbsp;</label>
											<label class="radio inline"><input tabindex="27" type="radio" name="blnInHouseEmail" id="blnInHouseEmail" value="0" <cfif blnInHouseEmail eq 0> checked </cfif>>No</label>
										</div>
									</div>
								</div>
								
								<div class="row">
									<div class="span9">
									   <div class="controls" style="padding-bottom:25px;">Weekly #application.sourceApp# Executive Newsletter (Recommended)</strong></div>
									</div>
							
									<div class="span3">
										<div class="controls">
											<label class="radio inline"><input tabindex="26" type="radio" name="blnNewsLetter" id="blnNewsLetter" value="1" <cfif blnNewsLetter eq 1> checked </cfif>>Yes&nbsp;</label>
											<label class="radio inline"><input tabindex="27" type="radio" name="blnNewsLetter" id="blnNewsLetter" value="0" <cfif blnNewsLetter eq 0> checked </cfif>>No</label>
										</div>
									</div>
								</div>
								
								<div class="row">
									<div class="span9">
									   <div class="controls" style="padding-bottom:25px;" id="blnEmailErrTxt">Matching Job Alerts and New Hiring Company Announcements (Recommended)</div>
									</div>
							
									<div class="span3">
										<div class="controls">
											<label class="radio inline"><input tabindex="30" type="radio" name="blnEmail" id="blnEmail" value="1" onClick="document.getElementById('blnEmailErrTxt').style.color = '';" <cfif blnEmail eq 1> checked </cfif>>Yes&nbsp;</label>
											<label class="radio inline"><input tabindex="31" type="radio" name="blnEmail" id="blnEmail" value="0" onClick="document.getElementById('blnEmailErrTxt').style.color = '';" <cfif blnEmail eq 0> checked </cfif>>No</label>
										</div>
									</div>
								</div>
								
								<div class="row">
									<div class="span9">
									   <div class="controls" style="padding-bottom:25px;" id="blnSpecialOfferErrTxt">Special Offers from Career Sponsors &amp Partners</strong></div>
									</div>
							
									<div class="span3">
										<div class="controls">
											<label class="radio inline"><input tabindex="28" type="radio" name="blnSpecialOffer" id="blnSpecialOffer" value="1" onClick="document.getElementById('blnSpecialOfferErrTxt').style.color = '';" <cfif blnSpecialOffer eq 1> checked </cfif>>Yes&nbsp;</label>
											<label class="radio inline"><input tabindex="29" type="radio" name="blnSpecialOffer" id="blnSpecialOffer" value="0" onClick="document.getElementById('blnSpecialOfferErrTxt').style.color = '';" <cfif blnSpecialOffer eq 0> checked </cfif>>No</label>
										</div>
									</div>
								</div>
								
								
								<br>
								<input tabindex="32" class="btn btn-primary btn-small" type="submit" name="validate" id="submitBtn" value="SAVE &amp; CONTINUE" onclick="return checkform2();">
								
								<div class="push"><!--//--></div>
								<div class="push"><!--//--></div>
								<div class="push"><!--//--></div>
								
							</div>
						</div> <!-- /row -->
                	</div> <!-- /container -->
				</article>
            </div> <!-- //Wrapper -->
       	
        </form>
        <div class="push"><!--//--></div>
        

        <!---For Valdidation---->
		<!---ISR <cfif application.applicationname EQ "6FigureJobs">
            <script src="#request.url#/professional/esubscriptions/js/editProfileValidation.js"></script> 
        <cfelseif application.applicationname EQ "SalesStars">
            <script src="#request.url#/professional/esubscriptions/js/editProfileValidationSS.js"></script> 
        </cfif>  --->      
            
       <!---  <script src="#request.url#/join/assets/js/jquery.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-transition.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-alert.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-modal.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-dropdown.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-scrollspy.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-tab.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-tooltip.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-popover.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-button.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-collapse.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-carousel.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-typeahead.js"></script>
        <script src="#request.url#/join/assets/js/jquery.placeholder.js"></script>
         
        <script src="#request.url#/js/facebox/facebox.js" type="text/javascript"></script>
         
        <script type="text/javascript" src="#request.url#/js/ajax-dynamic-content.js"></script>
        <script type="text/javascript" src="#request.url#/js/ajax.js"></script>
        <script type="text/javascript" src="#request.url#/js/ajax-tooltip.js"></script>   --->     
        
        
        
       
        
    
        
       
        
        
        </cfoutput>
    </cfif>
</cfif>
</cfoutput>