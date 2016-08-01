<cfparam name="errTxt" default="">
<cfparam name="url.s" default="0">

<cfif len(errTxt)>
	<div class="alert alert-error"><cfoutput>#errTxt#</cfoutput></div>
</cfif>

<form id="packageFrm" action="<cfoutput>#application.secureURL#</cfoutput>/package" method="post">
	
	<div id="payment-details" class="row-fluid hide">
		<h2>Credit Card Information</h2>
		<div>
			<label for="intCardType">Credit Card</label>
			
			<div class="row-fluid">
				<div class="span4">
					<select name="intCardType" id="intCardType" class="requiredField">
						<option value="">Card Type</option>
						<option value="1">MasterCard</option>
						<option value="2">Visa</option>
						<option value="3">Amex</option>
						<option value="4">Discover</option>
						<option value="5">Diners Club</option>
					</select>
				</div>
				<div class="span8">
					<input type="text" class="input span6 requiredField" id="cc" name="intCCNumber" maxlength="16" placeholder="Card Number">
				</div>
			</div>
		</div>
		<div>
			<label for="exp-mo">Expiration date</label>
			<div class="row-fluid">
				<div class="span2">
					<select name="intCardMonth" class="input-small requiredField">
						<option value="">Month</option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option> 
						<option value="06">06</option> 
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
					</select>
				</div>
				<div class="span2">
					<cfset endYear = year(now()) + 10>
					<cfoutput>
					<select name="intCardYear" class="input-small requiredField">
						<option value="">Year</option>
						<cfloop index="year" from="#year(now())#" to="#endYear#">
							<option value="#year#">#year#</option> 
						</cfloop>
					</select>
					</cfoutput>
				</div>
			</div>
		</div>
		<div>
			<label for="code">Security Code</label>
			<input type="text" class="input-small requiredField" id="code" name="strCSC">
			<span class="btn-link btn-tooltip" title="Tooltip text">?</span>
		</div>
		<div>
			<label for="name">Name on card</label>
			<input type="text" class="input input-block requiredField" id="ccname" name="strCCNameOnCard">
		</div>
		<p class="help-block">We'll process the information through a SSL Secured Server.</p>
		<p class="form-submit">
			<button name="submit" class="btn btn-primary">Register & Make Payment</button>
			Or <a href="pricing" class="btn-link" data-dismiss="modal" aria-hidden="true">Cancel</a>
		</p>
	</div><!--/#payment-details-->
	
	
	<cfoutput>
	<div id="company-details">
		
		<div class="row-fluid">
		
			<div class="span6">
				<div id="your-information">
					<h2>Account Information</h2>
					<div class="row-fluid">
						<div class="span6">
							<label for="fn">First name</label>
							<input type="text" class="input span12 requiredField" id="fn" name="strFirstName" maxlength="50" value="#strFirstName#">
						</div>
						<div class="span6">
							<label for="ln">Last name</label>
							<input type="text" class="input span12 requiredField" id="ln" name="strLastName" maxlength="50" value="#strLastName#">
						</div>
					</div>
					<div>
						<label for="strUsername">Username</label>
						<input type="text" class="input span12 requiredField" id="strUsername" name="strUsername" maxlength="50" value="#strUsername#">
					</div>
					<div class="row-fluid">
						<div class="span6">
							<label for="Password">Password</label>
							<input type="password" class="input span12 requiredField" id="Password" name="strPassword" maxlength="50">
						</div>
						<div class="span6">
							<label for="strconfirm_password">Password (confirm)</label>
							<input type="password" class="input span12 requiredField" id="strconfirm_password" name="strconfirm_password" maxlength="50">
						</div>
					</div>
					
					
					<cfif isdefined("cookie.sixFJResTracker") and cookie.sixFJResTracker neq "">
						<cfset intERTrkID = request.qry_leadid>
					</cfif>
					
					<!---
					<cfif isdefined("cookie.sixFJResTracker") and cookie.sixFJResTracker neq "">
						<cfloop query="request.qry_referral">
							<cfif cookie.sixFJResTracker EQ request.qry_referral.strTrackCode>
								<cfset intERTrkID = request.qry_referral.intTrackingID />
							</cfif>
						</cfloop>
					</cfif>
					--->
					
					<div class="row-fluid">
						<cfif intERTrkID gt 0>
							<input type="hidden" name="intERTrkID" value="#intERTrkID#" />
						<cfelse>
							<div class="span6">
								<cfoutput>
								<label for="intERTrkID">Referred By</label>
								<select name="intERTrkID" id="intERTrkID" class="span12 requiredField">
									<option value="">Choose One:</option>
									<cfloop query="request.qry_referral">
										<option value="#request.qry_referral.intTrackingID#">#request.qry_referral.strName#</option>
									</cfloop>
								</select>
								</cfoutput>
							</div>
						</cfif>

						<div class="span6">
							<label for="ln">Recruitment Firm?</label>
							<label for="blnExeRec1" class="radio inline"><input type="radio" name="blnExeRec" id="blnExeRec1" value="1" <cfif blnExeRec EQ 1>checked="true"</cfif>>Yes</label>
							<label for="blnExeRec0" class="radio inline"><input type="radio" name="blnExeRec" id="blnExeRec0" value="0" <cfif blnExeRec EQ 0>checked="true"</cfif>>No</label>
						</div>
					</div>
				</div>
			</div>
			<div class="span6">
				<div class="details">
					<small>You Selected</small>
					<h3>#request.qry_package.packageheading#</h3>
					<p class="price"><strong>$#request.qry_package.price#</strong> / month</p>
					
					<cfif request.qry_package.packageheading NEQ "Search Only">
						<p>
							<label for="blnSearch">Optional Search License</label>
							<label for="blnSearch1" class="radio inline"><input type="radio" name="blnSearch" id="blnSearch1" value="1" <cfif url.s EQ 1>checked="true"</cfif>>Yes</label>
							<label for="blnSearch0" class="radio inline"><input type="radio" name="blnSearch" id="blnSearch0" value="0" <cfif url.s EQ 0>checked="true"</cfif>>No</label>
						</p>
						
						<p class="price"><strong>Total: $<span id="tprice" data-bp="#request.qry_package.price#" data-sp="150"></span></strong> / month</p>
					<cfelse>
						<input name="blnSearch" type="hidden" value="1">
					</cfif>
					
					<ul class="has-purple-bullet">
						<cfloop index="request.f" list="#request.qry_package.packagetext#" delimiters=";">
							<cfif request.f contains "Optional Search License">
								<cfset request.f = request.f & " and 100 Profile views/day">
							</cfif>
							<li>#request.f#</li>
						</cfloop>
					</ul>
				</div>
				
			</div>
			
		</div>
		
		
		
		<div class="row-fluid section">
		
			<div class="span6">
				<div id="contact-info">
					<h2>Company Contact Information</h2>
					<div>
						<label for="co">Company Name</label>
						<input type="text" class="input span12 requiredField" id="co" name="strCompanyName" maxlength="50" value="#strCompanyName#">
					</div>
					<div>
						<label for="ad1">Address 1</label>
						<input type="text" class="input span12 requiredField" id="ad1" name="strAddress1" maxlength="50" value="#strAddress1#">
					</div>
					<div>
						<label for="ad2">Address 2</label>
						<input type="text" class="input span12" id="ad2" name="strAddress2" maxlength="50" value="#strAddress2#">
					</div>
					<!--->
					<div>
						<label for="country">Country</label>
						<input type="text" class="input span12" id="ad2">
					</div>
					--->
					<div class="row-fluid">
						<div class="span4">
							<label for="city">City</label>
							<input type="text" class="input span12 requiredField" id="city" name="strCity" maxlength="50" value="#strCity#">
						</div>
						<div class="span4">
							<label for="state">State</label>
							<select id="state" class="span12 requiredField" name="intState">
								<option value=""></option>
								<cfloop index="request.s" from="1" to="#arrayLen(request.ary_states)#">
									<option value="#request.ary_states[request.s][1]#" <cfif intState EQ request.ary_states[request.s][1]>selected="true"</cfif>> #iif(len(request.ary_states[request.s][3]),de(request.ary_states[request.s][3]),de(request.ary_states[request.s][2]))# </option>
								</cfloop>
							</select>						
						</div>
						<div class="span4">
							<label for="zip">Zipcode</label>
							<input type="text" class="input span12 requiredField" id="zip" name="strZip" maxlength="50" value="#strZip#">
						</div>
					</div>
					<div>
						<label for="stremail">E-mail</label>
						<input type="text" class="input span12 requiredField" id="stremail" name="stremail" maxlength="50" value="#strEmail#">
					</div>
					<div class="row-fluid">
						<div class="span6">
							<label for="tel">Phone</label>
							<input type="text" class="input span12 requiredField" id="tel" name="strPhone" maxlength="50" value="#strPhone#">
						</div>
						<div class="span6">
							<label for="fax">Fax</label>
							<input type="text" class="input span12" id="fax" name="strFax" maxlength="50" value="#strFax#">
						</div>
					</div>
					<div>
						<label for="www">Website</label>
						<input type="text" class="input span12" id="www" name="strUrl" maxlength="50" value="#strUrl#">
					</div>
				</div>
			</div>
			<div class="span6">
				<div id="billing-info" class="hide">
					<h2>Billing Information</h2>
					<div>
						<label for="ad1">Address 1</label>
						<input type="text" class="input span12 requiredField" id="ad1" name="strBillAddress1" maxlength="50" value="#strBillAddress1#">
					</div>
					<div>
						<label for="ad2">Address 2</label>
						<input type="text" class="input span12" id="ad2" name="strBillAddress2" maxlength="50" value="#strBillAddress2#">
					</div>
					<!--->
					<div>
						<label for="country">Country</label>
						<input type="text" class="input span12" id="ad2">
					</div>
					--->
					<div class="row-fluid">
						<div class="span4">
							<label for="city">City</label>
							<input type="text" class="input span12 requiredField" id="city" name="strBillCity" maxlength="50" value="#strBillCity#">
						</div>
						<cfoutput>
						<div class="span4">
							<label for="strBillState">State</label>
							<select id="strBillState" class="span12 requiredField" name="strBillState">
								<option value=""></option>
								<cfloop index="request.s" from="1" to="#arrayLen(request.ary_states)#">
									<!---
									<cfset billsval = iif(len(request.ary_states[request.s][1]),de(request.ary_states[request.s][3]),de(request.ary_states[request.s][2])) />
									<option value="#billsval#" <cfif billsval EQ strBillState>selected="true"</cfif> > #billsval#</option>
									--->
									<option value="#request.ary_states[request.s][1]#" <cfif strBillState EQ request.ary_states[request.s][1]>selected="true"</cfif>> #iif(len(request.ary_states[request.s][3]),de(request.ary_states[request.s][3]),de(request.ary_states[request.s][2]))# </option>
								</cfloop>
							</select>													
						</div>
						</cfoutput>
						<div class="span4">
							<label for="zip">Zipcode</label>
							<input type="text" class="input span12 requiredField" id="zip" name="strBillZip" maxlength="50" value="#strBillZip#">
						</div>
					</div>
					<div>
						<label for="strBillemail">E-mail</label>
						<input type="text" class="input span12 requiredField" id="strBillemail" name="strBillemail" maxlength="50" value="#strBillEmail#">
					</div>
					<div class="row-fluid">
						<div class="span6">
							<label for="tel">Phone</label>
							<input type="text" class="input span12 requiredField" id="tel" name="strBillPhone" maxlength="50" value="#strBillPhone#">
						</div>
						<div class="span6">
							<label for="fax">Fax</label>
							<input type="text" class="input span12" id="fax" name="strBillFax" maxlength="50" value="#strBillFax#">
						</div>
					</div>
				</div>
			</div>
			
		</div>
		</cfoutput>
		
		
		<div class="row-fluid">
		
			<div class="span12">
				<div>
					<label for="sameAsCheck" class="checkbox"><input type="checkbox" id="sameAsCheck" name="intSameAsContact" value="1" checked="true"> Billing information is the same as above</label>
				</div>
				<div class="control-group">
					<div class="controls">
						<label for="terms" class="checkbox"><input type="checkbox" id="terms"> I agree with 6FigureJobs <a href="terms" target="_blank">Terms and Conditions</a></label>
					</div>
				</div>
				<p class="form-submit">
					<a href="#payment-details" class="btn btn-primary" id="continueBtn">Continue &rarr;</a>
					Or <a href="pricing" class="btn-link" data-dismiss="modal" aria-hidden="true">Cancel</a>
				</p>
			</div>
			
		</div>
	</div>

	<cfoutput>
	<input name="pid" type="hidden" value="#request.qry_package.package#">
	</cfoutput>
</form>