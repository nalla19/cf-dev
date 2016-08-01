<cflock scope="session" timeout="10" type="ReadOnly">
	<cfset ioc_trans_id			= session.ER.shoppingCart.IOC_TransID>
	<cfset shopperID			= session.ER.shoppingCart.EmployerID>
	<cfset purchasePrice		= session.ER.shoppingCart.PurchasePrice>
	<cfset packTotalPurchased	= session.ER.shoppingCart.TotalPurchasePrice>
	<cfset packPurchased		= session.ER.shoppingCart.PackagePurchased>
	<cfset date_purchased		= session.ER.shoppingCart.DateSubmitted>
	<cfset blnAutoRenew			= session.ER.shoppingCart.autoRenew>
	<cfset bill_email			= session.ER.shoppingCart.Email>
	<cfset bill_phone			= session.ER.shoppingCart.Phone>
	<cfset bill_fax				= session.ER.shoppingCart.Fax>
	<cfset bill_cardType		= session.ER.shoppingCart.CardType>
	<cfset bill_cardNumber		= CFusion_decrypt(session.ER.shoppingCart.CardNumber, 63)>
	<cfset bill_cardMonth		= session.ER.shoppingCart.CardMonth>
	<cfset bill_cardYear		= session.ER.shoppingCart.CardYear>
	<cfset strCSC				= session.ER.shoppingCart.strCSC>
	<cfset bill_cardOwner		= session.ER.shoppingCart.CardOwner>
	<cfset bill_cardCompany		= session.ER.shoppingCart.CCCompany>
	<cfset bill_addr1			= session.ER.shoppingCart.CCaddress1>
	<cfset bill_addr2			= session.ER.shoppingCart.CCaddress2>
	<cfset bill_city			= session.ER.shoppingCart.CCCity>
	<cfset bill_state			= session.ER.shoppingCart.CCState>
	<cfset bill_country			= session.ER.shoppingCart.CCCountry>
	<cfset bill_zip				= session.ER.shoppingCart.CCzip>
</cflock>



<cfquery name="cfqGetEmpConfirm" datasource="#application.dsn#">
	select strFirst_Name, strLast_Name, strUsername, strPassword, strState, strCompany, strAddress1, strAddress2, strCity, strZip, strPhone, strFax, strEmail, strURL
	from tblEmployers (nolock)
	where intEmployerID = <cfqueryparam value="#shopperID#">
</cfquery>


<cfif cfqGetEmpConfirm.recordcount EQ 1>
	<!----------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<!--- //Add the registration to the "Nurture_Marketing_Campaign_Active_Recruiter_List" list in LeadFormix if the registration is One month or Single Job Posting--->
	<!----------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<!---><cfif (isDefined("session.erpackage.intAccountExpires") and session.erpackage.intAccountExpires is 30) or (isDefined("session.erpackage.intJobSlots") and session.erpackage.intJobSlots is 1)> --->
		<cfset message = application.leadFormixManager.addERContact(list_name='Nurture_Marketing_Campaign_Active_Recruiter_List',
		                                                            list_type='Commercial',
																	owner_name='Michelle Martin',
																	owner_email='mmartin@calliduscloud.com',
	                                                                contact_email='#cfqGetEmpConfirm.strEmail#',
																	contact_first_name='#cfqGetEmpConfirm.strFirst_Name#',
																	contact_last_name='#cfqGetEmpConfirm.strLast_Name#',
																	company_name='#cfqGetEmpConfirm.strCompany#') />
	<!---></cfif>--->
	
	
	
	<cfoutput>
	<div class="page-pricing" id="page-package">
	
		<header class="page-header">
			<div class="container">
				<div class="alert alert-success">
					<h2>Success!</h2>
					Your application for 6FigureJobs Recruitment has been successfully processed.<br />
					An invoice has been emailed to your billing email address. <b>Please print a copy of this invoice for your records.</b>
					<br /><br />
					
					<a href="#application.v1URL#/pg_ERLoginProcess.cfm?strUsername=#cfqGetEmpConfirm.strUsername#&strPassword=#cfqGetEmpConfirm.strPassword#&100k=1&admin=6fj"><button class="btn btn-primary" type="button" style="margin:0 0 10px 0; font-size:16px; font-weight:bold;">Go to your Dashboard to start using 6FigureJobs</button></a>
				</div>
			</div>
		</header>
	
		<article>
	
			<div class="container">
	
				<div class="row-fluid section">
					<div class="span6">
					
						<h3>#request.qry_package.packageheading#</h3>
						<div class="well">
							<p><strong>$#request.qry_package.price#</strong> / month</p>
							<ul class="has-purple-bullet">
								<cfloop index="request.f" list="#request.qry_package.packagetext#" delimiters=";">
									<li>#request.f#</li>
								</cfloop>
							</ul>
						</div>
						
						<div class="well">
							<cfset tax_amt=(packTotalPurchased - purchasePrice)>
							<strong>Total:</strong> $#NumberFormat(purchasePrice, "999.99")#
						</div>
						
						<h2>Your Username &amp; Password</h2>
						<div class="well">
							Username: #cfqGetEmpConfirm.strUsername# <br />
							Password: #cfqGetEmpConfirm.strPassword#<br />
						</div>
					</div>
				
				
				
					<div class="span6">
						<h2>Profile Information</h2>
						<div class="well">
							#cfqGetEmpConfirm.strFirst_Name# #cfqGetEmpConfirm.strLast_Name#
						</div>
				
						<h2>Company Contact Information</h2>
						<div class="well">
							#cfqGetEmpConfirm.strCompany#<br />
							#cfqGetEmpConfirm.strAddress1#<br />
							<cfif len(cfqGetEmpConfirm.strAddress2)>#cfqGetEmpConfirm.strAddress2#<br /></cfif>
							#cfqGetEmpConfirm.strCity#, #cfqGetEmpConfirm.strState# #cfqGetEmpConfirm.strZip#<br />
							<cfif len(cfqGetEmpConfirm.strPhone)>Phone:&nbsp;#cfqGetEmpConfirm.strPhone#<br /></cfif>
							<cfif len(cfqGetEmpConfirm.strFax)>Fax:&nbsp;#cfqGetEmpConfirm.strFax#<br /></cfif>
							<cfif len(cfqGetEmpConfirm.strEmail)>Email:&nbsp;#cfqGetEmpConfirm.strEmail#<br /></cfif>
							<cfif len(cfqGetEmpConfirm.strURL)>URL:&nbsp;#cfqGetEmpConfirm.strURL#<br /></cfif>
						</div>
						
						
						
				
						<h2>Company Billing Information</h2>
						<div class="well">
							#cfqGetEmpConfirm.strCompany#<br />
							#bill_addr1#<br />
							<cfif bill_addr2 neq "">#bill_addr2#<br /></cfif>
							#bill_city#, #bill_state# #bill_zip#<br />
							<cfif bill_phone neq "">Phone:&nbsp;#bill_phone#<br /></cfif>
							<cfif bill_fax neq "">Fax:&nbsp;#bill_fax#<br /></cfif>
							<cfif bill_email neq "">Email:&nbsp;#bill_email#<br /></cfif>
						</div>
						
						<h2>Credit Card / Purchase Information</h2>
						<div class="well">
							Date of Purchase: #dateformat(now(), "mm/dd/yyyy")#<br />
							Invoice Number: #ioc_trans_id#<br />
							<br />
							Card Type:
							<cfswitch expression="#bill_cardType#">
								<cfcase value="1">Mastercard</cfcase>
								<cfcase value="2">Visa</cfcase>
								<cfcase value="3">Amex</cfcase>
								<cfcase value="4">Discover</cfcase>
								<cfcase value="5">Diners Club</cfcase>
							</cfswitch>
			
							<cfset temp=reMoveChars(bill_cardNumber, 1, (len(bill_cardNumber)- 4))>
							Card Number Ending In: #temp#
							         <cfparam name="strCSC" default="">
							<br />
							CSC Code: #strcsc#
							<br />
							Expiration Date: #bill_cardMonth#/#bill_cardYear#<br />
							<br />
							Name on Card: #bill_cardOwner#<br />
							<cfif bill_cardCompany neq "">
								Company Name on Card: #bill_cardCompany#<br />
							</cfif>
						</div>
					</div>
				</div>
			
			</div>
			
		</article>
	
	</div>
	</cfoutput>
	
	
	<cfif application.machine EQ "LIVE">
		<script src="https://ssl.google-analytics.com/urchin.js" type="text/javascript"></script>
		
		<script type="text/javascript">
			_uacct = "UA-214963-8";
			urchinTracker();
		</script>
		
		<!-- Google Code for Recruiter Confirmation Conversion Page 09/17/2013-->
		<script type="text/javascript">
			/* <![CDATA[ */
			var google_conversion_id = 986961148;
			var google_conversion_language = "en";
			var google_conversion_format = "2";
			var google_conversion_color = "ffffff";
			var google_conversion_label = "4wU7CMy5iQcQ_KnP1gM";
			var google_conversion_value = 0;
			var google_remarketing_only = false;
			/* ]]> */
		</script>
		
		<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js"></script>
		
		<noscript>
			<div style="display:inline;">
				<img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/986961148/?value=0&amp;label=4wU7CMy5iQcQ_KnP1gM&amp;guid=ON&amp;script=0"/>
			</div>
		</noscript>
	</cfif>

<cfelse>

	error

</cfif>