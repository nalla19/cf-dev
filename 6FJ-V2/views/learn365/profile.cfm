<cfparam name="updateMsg" default="">
<cfparam name="errorMsg" default="">
<cfparam name="url.reactivate" default="">
<cfif isdefined("form.fieldnames")>
	<!--- <cfdump var="#form#"> --->
	<cfinclude template="updateProfile.cfm">
	<cfif (getResponse.RESULT eq 0 and getResponse.RESPMSG eq "Approved")>
		<cfset updateMsg="#RESPTYPEMSG#">
		
	<cfelse>
		<cfset errorMsg="1">
	</cfif>
	<cflocation url="learn365-profile?updateMsg=#updateMsg#&errorMsg=#errorMsg#">
</cfif>
<cfparam name="firstName" default="">
<cfparam name="lastName" default="">
<cfparam name="strEmail" default="">
<cfparam name="strPasswd" default="">

<cfparam name="phonenumber" default="">
<cfparam name="strAddress1" default="">
<cfparam name="strAddress2" default="">
<cfparam name="strCity" default="">
<cfparam name="strState" default="">
<cfparam name="strZipCode" default="">

<cfparam name="cardname" default="">
<cfparam name="strCardType" default="">
<cfparam name="cardNumber" default="">
<cfparam name="cardMonth" default="">
<cfparam name="cardYear" default="">
<cfparam name="securityCode" default="">
<cfparam name="disableForm" default=0>
<cfparam name="bln6FJAccount" default=1>

	<cfquery name="getCurrentUser" datasource="#application.dsn#">
		SELECT 
		intResID,
		email, 
		fname,
		lname,
		address,
		city,
		state,
		zip,
		home_phone,
		username,
		password,
		blnLearn365,
		blnHide6FJBtn
		FROM tblResumes (nolock) 
		WHERE intResID = #session.EXEC.intResID#
	</cfquery>
	
	<cfif getCurrentUser.recordcount EQ 1>
		<cfset firstName=getCurrentUser.fname>
		<cfset lastName=getCurrentUser.lname>
		<cfset stremail=getCurrentUser.email>
		<cfset strPasswd=getCurrentUser.password>
		
		<cfset phonenumber = getCurrentUser.home_phone>
		<cfset strAddress1=getCurrentUser.address>
		<cfset strCity=getCurrentUser.city>
		<cfset strState=getCurrentUser.state>
		<cfset strZipCode=getCurrentUser.zip>
		<cfset intResID=getCurrentUser.intResID>
		<cfset blnLearn365=getCurrentUser.blnLearn365>
		
		<cfif getCurrentUser.blnHide6FJBtn EQ "">
			<cfset bln6FJAccount=1>
		<cfelseif getCurrentUser.blnHide6FJBtn>
			<cfset bln6FJAccount=0>
		<cfelse>
			<cfset bln6FJAccount=1>
		</cfif>
		
	</cfif>

	<cfscript>
		profileid =  application.executive.getProfileidByResumeid(intresid).profileid;
		premiumObj 	= application.premium;
		qProfile 	= premiumObj.getPremiumPackageDetails(profileid); 
		
	</cfscript>
	
	<cfif qProfile.premiumstatus eq 'inactive'>
	
		<cfset disableForm = 1>
	</cfif>
	
 <!--- <cfdump var="#qProfile#">  --->
<cfoutput>
	<article class="section companies well">
		<div class="container">
			<h1>Membership Profile</h1>
			<div class="row-fluid">
				<cfif len(updateMsg)>
					<div class="alert alert-success" id="displaySave_account">
						<button type="button" class="close" data-dismiss="alert">&times;</button>
						<strong>Your #updateMsg#  information has been updated!</strong>
					</div>
				</cfif>
				<cfif len(errorMsg)>
					<div class="alert alert-error" id="displaySave_account">
						<button type="button" class="close" data-dismiss="alert">&times;</button>
						<strong>There was a problem with your credit card transaction. Please try again.</strong>
					</div>
				</cfif>
				<cfif len(url.reactivate)>
					<div class="alert alert-success" id="displaySave_account">
						<button type="button" class="close" data-dismiss="alert">&times;</button>
						<strong>Your account is now active!</strong>
					</div>
				</cfif>
			</div>
			<div class="page-spacer"></div>
			<div class="row-fluid">
				<!--- left column --->
				<div class="span6  accountprofile" style="min-height:340px">
					<h3>Billing Details</h3>
					
					<div class="row-fluid">
						<div class="span12"> 
							<form action="" method="post" >
							<div class="row-fluid">
								<div class="span8"><input name="phonenumber" type="text" class="span12" id="phonenumber" tabindex="3" placeholder="Phone Number" value="#phonenumber#" maxlength="20" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>></div>
								
							</div>
							<div class="row-fluid">
								<div>
									<input tabindex="17" id="strAddress1" name="strAddress1" type="text" value="#strAddress1#" class="input input-small span12 requiredField" maxlength="145" placeholder="Address 1" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
								</div>
							</div>
							<div class="row-fluid">
								<div>
									<input tabindex="17" id="strAddress2" name="strAddress2" type="text" value="#strAddress2#"  class="input input-small span12" maxlength="145" placeholder="Address 2" <cfif disableForm>disabled</cfif>>
								</div>
							</div>
							<div class="row-fluid">
								<div>
									<input tabindex="17" id="strCity" name="strCity" type="text" value="#strCity#" class="input input-small span12 requiredField" maxlength="60" placeholder="City" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
								</div>
							</div>
							<div class="row-fluid">
								<div class="span6">
									<!--- <cfinclude template="/v16fj/professional/profile/_includes/states_list.cfm"> --->
									<select id="strState" class="input input-medium span12 requiredField" name="strState" tabindex="17" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
										<option value="">State</option>
										<cfloop index="request.s" from="1" to="#arrayLen(request.ary_states)#">
											
											<option value="#request.ary_states[request.s][2]#" <cfif strState EQ request.ary_states[request.s][2]>selected="true"</cfif>> #request.ary_states[request.s][2]# </option>
										</cfloop>
									</select>
								</div>
								<div class="span6">
									<input tabindex="17" id="strZipCode" name="strZipCode" type="text" value="#strZipCode#" class="input input-small span12 requiredField" maxlength="19" placeholder="Zip Code" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
								</div>
							</div>
							 <cfif not disableForm>
							<div class="row-fluid">
								<div class="span10"> 
								<input type="hidden" name="type" value="billing">
									<input type="submit" name="updtBilling" value="Update Billing Details" class="btn btn-primary btn-small" onClick="return saveData('billing');">
								</div>
							</div>
							</cfif>
							</form>
						</div>
					</div>
				</div>
				
				<!--- left column end --->
				
				<!--- right column --->
				<div class="span6  accountprofile" style="min-height:340px">
					<h3>Credit Card</h3>
					<div class="row-fluid">
						<div class="span12" id="display_creditcard"> 
							<form action="" method="post">
							<div class="row-fluid">
								<div>
									<input id="cardName"  type="text" name="cardName" value="#cardName#" size="28" maxlength="50" placeholder="Name on Card" class="input input-small span12 requiredField" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
								</div>
							</div>
							<div class="row-fluid">
								<div>
									<select  id="strCardType"  name="strCardType" class="input input-small span12 requiredField" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
										<option value="">Choose Credit Card
										<option value="mc" <cfif strCardType eq "mc">selected</cfif>>MasterCard</option>
										<option value="visa" <cfif strCardType eq "visa">selected</cfif>>Visa</option>
										<option value="amex" <cfif strCardType eq "amex">selected</cfif>>Amex</option>
										<option value="discover" <cfif strCardType eq "discover">selected</cfif>>Discover</option>
										<option value="diners" <cfif strCardType eq "diners">selected</cfif>>Diners Club</option>
									</select>
								</div>
							</div>
							<div class="row-fluid">
								<div> 
									<input id="cardNumber" autcomplete="off" type="text" name="cardNumber" value="<cfif len(cardNumber)>XXXX XXXX XXXX </cfif>#right(cardNumber,4)#" size="28" maxlength="25" placeholder="Credit Card Number" class="input input-small span12 requiredField" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
								</div>
							</div>
							<div class="row-fluid">
								<div class="span4">
									<select id="cardMonth" name="cardMonth" class="input input-small span12 requiredField" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
									<option value="">Card Month</option>
									<option value="01" <cfif cardMonth eq "01"> selected</cfif> > 01 </option>
									<option value="02" <cfif cardMonth eq "02"> selected</cfif> > 02 </option>
									<option value="03" <cfif cardMonth eq "03"> selected</cfif> > 03 </option>
									<option value="04" <cfif cardMonth eq "04"> selected</cfif> > 04 </option>
									<option value="05" <cfif cardMonth eq "05"> selected</cfif> > 05 </option>
									<option value="06" <cfif cardMonth eq "06"> selected</cfif> > 06 </option>
									<option value="07" <cfif cardMonth eq "07"> selected</cfif> > 07 </option>
									<option value="08" <cfif cardMonth eq "08"> selected</cfif> > 08 </option>
									<option value="09" <cfif cardMonth eq "09"> selected</cfif> > 09 </option>
									<option value="10" <cfif cardMonth eq "10"> selected</cfif> > 10 </option>
									<option value="11" <cfif cardMonth eq "11"> selected</cfif> > 11 </option>
									<option value="12" <cfif cardMonth eq "12"> selected</cfif> > 12 </option>
									</select>
									
								</div>
								<div class="span4">
									<select id="cardYear"  name="cardYear" class="input input-small span12 requiredField" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
									<option value="">Card Year</option>
									<cfloop from="#year(now())#" to="#(year(now()) +10)#" index="yearLoop">
									<option value="#yearLoop#" <cfif cardYear eq "#yearLoop#"> selected</cfif> > #yearLoop#</option>
									</cfloop>
									</select>
								</div>
								<div class="span4">
									<input  id="securityCode"  type="text" name="securityCode" value="<cfif len(securityCode)>XXXX<cfelse>#securityCode#</cfif>" size="10" maxlength="4" placeholder="Security Code" class="input input-small span12 requiredField" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);" <cfif disableForm>disabled</cfif>>
								</div>
							</div>
							<div class="row-fluid">
								<div class="span10"> 
								
								</div>
							</div>
							<cfif not disableForm>
							<div class="row-fluid">
								<div class="span10"> 
								<input type="hidden" name="type" value="creditcard">
									<input type="submit" name="updtCard" value="Update Credit Card" class="btn btn-primary btn-small" onClick="return saveData('creditcard');">
								</div>
							</div>
							</cfif>
							</form>
						</div>
					</div>
				</div>
				<!--- right column end --->
				
				
			</div>
			<div class="page-spacer"></div>
			<div class="page-spacer"></div>
			<div class="row-fluid">
				<!--- left column --->
				<div class="span6 accountprofile" style="min-height:325px">
					<div class="row-fluid">
						<div class="span12 ">
							<h3>Account Details</h3>
						</div>
					</div>
					<div class="page-spacer"></div>
					<form action="" method="post" autocomplete="off" method="post" enctype="multipart/form-data">
					<div class="row-fluid">
						<div class="span6"><input name="firstName" type="text" class="span12" id="firstName" tabindex="1" placeholder="First Name" value="#firstName#" autocomplete="off"></div>
						<div class="span6"> <input name="lastName" type="text" class="span12" id="lastName" tabindex="2" placeholder="Last Name" value="#lastName#" autocomplete="off"></div>
					</div>
					<div class="row-fluid">
						<div class="span10"> 
							<input class="input-small span12" tabindex="6" type="email" autocomplete="off" name="strEmail" value="#strEmail#" id="strEmail" placeholder="Email Address" maxlength="75" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);">
						</div>
					</div>
					<div class="row-fluid">
						<div class="span10"> 
							<input class="input-small span12" tabindex="10" type="password" name="strPasswd" value="#strPasswd#" id="strPasswd" placeholder="Password" maxlength="20" onFocus="return checkBlanks(this);" onBlur="return checkBlanks(this);">
						</div>
					</div>
					<div class="page-spacer"></div>
					<div class="row-fluid">
						<div class="span12">
						<label class="checkbox inline" id="6FJAccount"><input type="checkbox" name="bln6FJAccount" id="bln6FJAccount" value="1" <cfif bln6FJAccount>checked</cfif>>Yes, I want access to <a href="/join" target="_blank">6FigureJobs</a>.</label>
						</div>
					</div>
					<div class="page-spacer"></div>
					<input type="hidden" name="type" value="account">
					<input style="bottom:0" type="submit" name="updtAccount" value="Update Account Details" class="btn btn-primary btn-small" onClick="return saveData('account');">
					</form>
				</div>
				
				<!--- left column end --->
				<!--- right column --->
				<div class="span6 accountprofile" style="min-height:325px">
					<div class="row-fluid">
						<div class="span12  ">
							<h3>Membership Details</h3>
						</div>
					</div>
					<div class="page-spacer"></div>
					<div class="row-fluid">
						<div class="span4">
							<strong>Status</strong>														
						</div>
						<div class="span6">
							#UCASE(qProfile.premiumstatus)#												
						</div>
					</div>
					<div class="page-spacer"></div>
					<div class="row-fluid">
						<div class="span4">
							<strong>Credit Card</strong>														
						</div>
						<div class="span6">
							<cfif disableForm>N/A<cfelse>#UCASE(qProfile.cardtype)# (#qProfile.strnumber#)</cfif>									
						</div>
					</div>
					<div class="page-spacer"></div>
					<div class="row-fluid">
						<div class="span4">
							
							<strong>Last Payment</strong> 
							
						</div>
						<div class="span6  ">
							
							#qProfile.dtesubmitted#
							
						</div>
					</div>
					<div class="page-spacer"></div>
					<div class="row-fluid">
						<div class="span4  ">
							<cfif qProfile.premiumstatus IS "active">
							<strong>Next Payment</strong>
							<cfelse>
							<strong>Access Expires</strong>
							</cfif>
						</div>
						<div class="span6  ">
							
								#qProfile.dteexpires#
							
						</div>
					</div>
					<div class="page-spacer"></div>
					<div class="row-fluid">
						<div class="span12  ">
							<cfif qProfile.premiumstatus IS "active">
							<a href="/learn365-cancel" class="btn btn-primary btn-small">Cancel Membership</a>
							<cfelse>
							<a href="/learn365-activate?expireDt=#qProfile.dteexpires#" class="btn btn-primary btn-small">Activate Membership</a>
							</cfif>
						</div>
					</div>
				</div>
				
			</div>
		</div>
	</article>
</cfoutput>

<script type="text/javascript">

	function saveData(type){ 
		var errNum=0; 
		//alert("hi");
		if (type == 'creditcard'){
		
			if (document.getElementById('cardName').value == ''){
				document.getElementById('cardName').style.borderColor = 'red';
				errNum+=1;		
			}
		
			if (document.getElementById('cardYear').value == ''){
				document.getElementById('cardYear').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('cardMonth').value == ''){
				document.getElementById('cardMonth').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('cardNumber').value == ''){
				document.getElementById('cardNumber').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('strCardType').value == ''){
				document.getElementById('strCardType').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('securityCode').value == ''){
				document.getElementById('securityCode').style.borderColor = 'red';
				errNum+=1;		
			}
		}
		
		if (type == 'billing'){
			if (document.getElementById('phonenumber').value == ''){
				document.getElementById('phonenumber').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('strAddress1').value == ''){
				document.getElementById('strAddress1').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('strCity').value == ''){
				document.getElementById('strCity').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('strState').value == ''){
				document.getElementById('strState').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('strZipCode').value == ''){
				document.getElementById('strZipCode').style.borderColor = 'red';
				errNum+=1;		
			}
		}
		
		if (type == 'account'){
			if (document.getElementById('strEmail').value == ''){
				document.getElementById('strEmail').style.borderColor = 'red';
				errNum+=1;		
			}
			
			if (document.getElementById('strPasswd').value == ''){
				document.getElementById('strPasswd').style.borderColor = 'red';
				errNum+=1;		
			}
			
		}
		
		
		if (errNum == 0){
		/*
			var creditCard = '&cardName=' + encodeURIComponent(document.getElementById('cardName').value)+ '&cardType='+ document.getElementById('strCardType').value + '&cardNumber=' + document.getElementById('cardNumber').value + '&cardMonth=' + document.getElementById('cardMonth').value + '&cardYear=' + document.getElementById('cardYear').value + '&securityCode=' + document.getElementById('securityCode').value;
			var callURL = 'jQueryCalls/updateLearningProfile.cfm?type=' +type;
			callURL = callURL + creditCard;
			//alert(callURL);
			//
			$('#loader_'+type).show();
			$('#display_'+type).hide();
			$('#loader_'+type).load(callURL);
			//$('#showCreditCard').hide();		
		*/
		}else{
			return false;
		}
	}
	
	function checkBlanks(formField){
		if(formField.value==''){
			formField.style.borderColor= 'red';
		}else{
			formField.style.borderColor= '';
		}	
	}

</script>
