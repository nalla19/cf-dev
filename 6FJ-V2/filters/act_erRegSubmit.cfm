<!--- -----------------------------------------form processing params----------------------------------------- --->
<cfset intAddJobSlot = request.qry_package.INTJOBSLOTS />



<!--- -----------------------------------------cc info----------------------------------------- --->
<cfparam name="sixFJEncryptKey" default="63">
<cfparam name="intCardType" default="">
<cfparam name="intCCNumber" default="">
<cfparam name="intCardMonth" default="">
<cfparam name="intCardYear" default="">
<cfparam name="strCSC" default="">
<cfparam name="strCCNameOnCard" default="">
<cfparam name="strCCCompanyNameOnCard" default="">
<cfparam name="blnAutoRenew" default="">


<!--- -----------------------------------------billing info----------------------------------------- --->
<cfparam name="intPassBillAddress1" default="1">
<cfparam name="intPassBillCity" default="1">
<cfparam name="intPassBillState" default="1">
<cfparam name="intPassBillZip" default="1">
<cfparam name="intPassBillPhone" default="1">
<cfparam name="intPassBillEmail" default="1">
<cfparam name="intPassBillEmailSyntax" default="1">
<cfparam name="intPassBillUniqueEmail" default="1">
<cfparam name="intPassBillEmailConfirm" default="1">
<cfparam name="intPassCSC" default="1">

<!--- --------------------------------Package Offer Defaults ---------------------------------------- --->
<cfparam name= "request.intJobSlots" default = 0>
<cfparam name= "request.blnSearchDB" default = 0>
<cfparam name= "request.blnPostNtl" default = 0>
<cfparam name= "request.blnNtlJobSlots" default = 0>
<cfparam name= "request.intPackageType" default = 0>
<cfparam name= "request.intAcctType" default = 0>
<cfparam name= "request.intDetailLimit" default = 0>
<cfparam name= "request.intDetailLimitMonthly" default = 0>
<cfparam name= "request.strAcctClass" default="">
<cfparam name= "request.dteAcctExp" default = 'dateformat(dateadd("d", 30, now()), "mm/dd/yyyy")'>

<!--- -----------------------------------------pass defaults----------------------------------------- --->
<cfset intPassFirstName=0>
<cfset intPassLastName=0>
<cfset intPassHowFind=0>
<cfset intPassUsername=0>
<cfset intPassUniqueUsername=0>
<cfset intPassPwd=0>
<cfset intPassPwdConfirm=0>
<cfset intPass1eqPass2=0>
<cfset intPassCompany=0>
<cfset intPassAddress1=0>
<cfset intPassCity=0>
<cfset intPassState=0>
<cfset intPassZip=0>
<cfset intPassPhone=0>
<cfset intPassEmail=0>
<cfset intPassEmailSyntax=0>
<cfset intPassUniqueEmail=0>
<cfset intPassCCType=0>
<cfset intPassCCNumber=0>
<cfset intPassCCMatch=0>
<cfset intPassCCExpMonth=0>
<cfset intPassCCExpYear=0>
<cfset intPassCCName=0>
<cfset intPassJobSlot=0>
<cfset intPassRecruitFirm=0>


<cfset errTxt = "" />



<!--- -----------------------------------------Validate First Name----------------------------------------- --->
<cfset strFirstName=trim(strFirstName)>
<cfif len(strFirstName) GT 0>
	<cfset intPassFirstName=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>First Name</strong>: Please enter First Name. <br>">
</cfif>



<!--- -----------------------------------------Validate Last Name----------------------------------------- --->
<cfset strLastName=trim(strLastName)>
<cfif len(strLastName) GT 0>
	<cfset intPassLastName=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Last Name</strong>: Please enter Last Name. <br>">
</cfif>


<cfif intERTrkID NEQ 0 AND intERTrkID NEQ "">
	<cfset intPassHowFind=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Referred By</strong>: Please selected Referred By. <br>">
</cfif>



<!--- -----------------------------------------Validate UserName----------------------------------------- --->
<cfset strUserName = trim(strUserName) />
<cfif len(strUserName) GTE 5>
	<cfset intPassUsername=1>

	<cfquery name="cfqUniqueERUsername" datasource="#application.dsn#">
		SELECT strUsername
		FROM tblEmployers (NOLOCK)
		WHERE strUsername='#strUsername#'
	</cfquery>

	<cfif cfqUniqueERUsername.RecordCount eq 0>
		<cfset intPassUniqueUsername=1>
	<cfelse>
		<cfset errTxt=errTxt & "<strong>User Name</strong>: User Name entered already in use.<br>">
	</cfif>

<cfelse>
	<cfset errTxt=errTxt & "<strong>User Name</strong>: Please Enter a User Name 5 or more characters.<br>">
</cfif>



<!--- -----------------------------------------Validate Password----------------------------------------- --->
<cfset strPassword = trim(strPassword) />
<cfif len(strPassword) GTE 5>
	<cfset intPassPwd=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Password</strong>: Please Enter a valid password 5 or more characters.<br>">
</cfif>



<!--- -----------------------------------------Validate Confirm Password----------------------------------------- --->
<cfset strconfirm_password = trim(strconfirm_password) />
<cfif len(strconfirm_password) GTE 5>
	<cfset intPassPwdConfirm=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Retype Password</strong>: Please Enter a Retype password 5 or more characters.<br>">
</cfif>

<cfif strPassword eq strconfirm_password>
	<cfset intPass1eqPass2=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Password</strong>: Password and Retype Passwords do not match.<br>">
</cfif>



<!--- -----------------------------------------Validate Company Name----------------------------------------- --->
<cfset strCompanyName=trim(strCompanyName)>
<cfif len(strCompanyName) GT 0>
	<cfset intPassCompany=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Company</strong>: Please enter the Company name.<br>">
</cfif>



<!--- -----------------------------------------Validate Address1----------------------------------------- --->
<cfset strAddress1=trim(strAddress1)>
<cfif len(strAddress1) GT 0>
	<cfset intPassAddress1=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Address 1</strong>: Please enter the Address 1.<br>">
</cfif>



<!--- -----------------------------------------Validate Address2----------------------------------------- --->
<cfif len(strAddress2) GT 0>
	<cfset strAddress2=trim(strAddress2)>
</cfif>



<!--- -----------------------------------------Validate City----------------------------------------- --->
<cfset strCity=trim(strCity)>
<cfif len(strCity) GT 0>
	<cfset intPassCity=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>City</strong>: Please enter the city.<br>">
</cfif>



<!--- -----------------------------------------Validate State----------------------------------------- --->
<cfif intState GT 0>
	<cfset intPassState=1>
	
	<!---Get the state name --->
	<cfquery name="cfqGetState" datasource="#application.dsn#">
	select strName from tblStates (nolock) where intOldID = #intState# 
	</cfquery>
	<cfif len(cfqGetState.strName)>
		<cfset strState = cfqGetState.strName>
	</cfif>
	
<cfelse>
	<cfset errTxt=errTxt & "<strong>State</strong>: Please select the state.<br>">
</cfif>



<!--- -----------------------------------------Validate Zip----------------------------------------- --->
<cfset strZip=trim(strZip)>
<cfif len(strZip) GT 0>
	<cfset intPassZip=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Zip</strong>: Please enter the zipcode.<br>">
</cfif>



<!--- -----------------------------------------Validate Phone----------------------------------------- --->
<cfset strPhone=trim(strPhone)>
<cfif len(strPhone) GT 0>
	<cfset strTemp=ReplaceList(strPhone,"(,),-,.,e,E,x,X,t,T, ","")>
	<cfif IsNumeric(strTemp)>
		<cfset intPassPhone=1>
	</cfif>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Phone</strong>: Please enter a valid Phone number.<br>">
</cfif>



<!--- -----------------------------------------Validate Fax----------------------------------------- --->
<cfif len(strFax) GT 0>
	<cfset strFax=trim(strFax)>
</cfif>



<!--- -----------------------------------------Validate Employer/Recruiter----------------------------------------- --->
<cfif blnExeRec NEQ "">
	<cfset intPassRecruitFirm=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Recruting Firm</strong>: Please select Yes or No.<br>">
</cfif>



<!--- -----------------------------------------Validate Email----------------------------------------- --->
<cfset stremail=trim(stremail) />

<cfif len(stremail) GT 0>
	<!---> <cf_ct_RemoveInvalidEmailChars strVerifyEmail=#strEmail#> --->
	
	<cfmodule template="/v16fj/_customTags/ct_RemoveInvalidEmailChars.cfm" strVerifyEmail=#strEmail#>
	
	<cfset strEmail=strVerifyEmail />

	<cfif len(strEmail) GT 0>

		<cfset intPassEmail=1>

		<cfif
			(ListContainsNoCase(strEmail, '@') is not 0) And (
			(ListContainsNoCase(strEmail, '.ae') is not 0) OR
			(ListContainsNoCase(strEmail, '.ar') is not 0) OR
			(ListContainsNoCase(strEmail, '.at') is not 0) OR
			(ListContainsNoCase(strEmail, '.au') is not 0) OR
			(ListContainsNoCase(strEmail, '.be') is not 0) OR
			(ListContainsNoCase(strEmail, '.biz') is not 0) OR
			(ListContainsNoCase(strEmail, '.bm') is not 0) OR
			(ListContainsNoCase(strEmail, '.br') is not 0) OR
			(ListContainsNoCase(strEmail, '.bz') is not 0) OR
			(ListContainsNoCase(strEmail, '.ca') is not 0) OR
			(ListContainsNoCase(strEmail, '.cc') is not 0) OR
			(ListContainsNoCase(strEmail, '.ch') is not 0) OR
			(ListContainsNoCase(strEmail, '.cn') is not 0) OR
			(ListContainsNoCase(strEmail, '.co') is not 0) OR
			(ListContainsNoCase(strEmail, '.com') is not 0) OR
			(ListContainsNoCase(strEmail, '.de') is not 0) OR
			(ListContainsNoCase(strEmail, '.dk') is not 0) OR
			(ListContainsNoCase(strEmail, '.edu') is not 0) OR
			(ListContainsNoCase(strEmail, '.es') is not 0) OR
			(ListContainsNoCase(strEmail, '.gov') is not 0) OR
			(ListContainsNoCase(strEmail, '.gr') is not 0) OR
			(ListContainsNoCase(strEmail, '.fr') is not 0) OR
			(ListContainsNoCase(strEmail, '.fm') is not 0) OR
			(ListContainsNoCase(strEmail, '.hk') is not 0) OR
			(ListContainsNoCase(strEmail, '.hu') is not 0) OR
			(ListContainsNoCase(strEmail, '.kr') is not 0) OR
			(ListContainsNoCase(strEmail, '.id') is not 0) OR
			(ListContainsNoCase(strEmail, '.ie') is not 0) OR
			(ListContainsNoCase(strEmail, '.il') is not 0) OR
			(ListContainsNoCase(strEmail, '.in') is not 0) OR
			(ListContainsNoCase(strEmail, '.it') is not 0) OR
			(ListContainsNoCase(strEmail, '.jp') is not 0) OR
			(ListContainsNoCase(strEmail, '.mil') is not 0) OR
			(ListContainsNoCase(strEmail, '.mx') is not 0) OR
			(ListContainsNoCase(strEmail, '.name') is not 0) OR
			(ListContainsNoCase(strEmail, '.net') is not 0) OR
			(ListContainsNoCase(strEmail, '.nl') is not 0) OR
			(ListContainsNoCase(strEmail, '.nz') is not 0) OR
			(ListContainsNoCase(strEmail, '.org') is not 0) OR
			(ListContainsNoCase(strEmail, '.rr') is not 0) OR
			(ListContainsNoCase(strEmail, '.ru') is not 0) OR
			(ListContainsNoCase(strEmail, '.uk') is not 0) OR
			(ListContainsNoCase(strEmail, '.us') is not 0) OR
			(ListContainsNoCase(strEmail, '.vg') is not 0) OR
			(ListContainsNoCase(strEmail, '.se') is not 0) OR
			(ListContainsNoCase(strEmail, '.sg') is not 0) OR
			(ListContainsNoCase(strEmail, '.th') is not 0) OR
			(ListContainsNoCase(strEmail, '.to') is not 0) OR
			(ListContainsNoCase(strEmail, '.tr') is not 0) OR
			(ListContainsNoCase(strEmail, '.tv') is not 0) OR
			(ListContainsNoCase(strEmail, '.ws') is not 0) OR
			(ListContainsNoCase(strEmail, '.za') is not 0) )>

			<cfset intPassEmailSyntax=1>

			<cfif strEmail EQ strOrigEmail>
				<cfset intPassUniqueEmail=1>
			<cfelse>

				<cfquery name="cfqUniqueEREmail" datasource="#application.dsn#">
					SELECT strEmail as strExistEmail, intAcctMngrID
					FROM tblEmployers (NOLOCK)
					WHERE stremail='#stremail#'
					AND blnMBASignUp=0
					AND blnSinglePost=0
				</cfquery>

				<cfif cfqUniqueEREmail.RecordCount eq 0>
					<cfset intPassUniqueEmail=1>
				<cfelse>

					<cfquery name="cfqGetERAcctMngr" datasource="#application.dsn#">
						SELECT strLastName, strFirstName, strEmail, strPhoneExt
						FROM tblAcctMngr (NOLOCK)
						WHERE intAcctMngrID='#cfqUniqueEREmail.intAcctMngrID#'
					</cfquery>

					<cfset errTxt=errTxt & "<strong>Email</strong>: Email address entered already in use.<br>">
				</cfif>

			</cfif>

		</cfif>

	</cfif>

<cfelse>
	<cfset errTxt=errTxt & "<strong>Email</strong>: Please enter a valid email address.<br>">
</cfif>

<cfif not isDefined("form.intSameAsContact")>
	<cfset intSameAsContact = 0>
</cfif>

<!--- -----------------------------------------Validate Billing Address same as Contact Address----------------------------------------- --->
<cfif intSameAsContact NEQ 1>
	<!--- if not the same as contact info, perform the checks --->
	<cfset intPassBillAddress1=0>
	<cfset intPassBillAddress2=0>
	<cfset intPassBillCity=0>
	<cfset intPassBillState=0>
	<cfset intPassBillZip=0>
	<cfset intPassBillPhone=0>
	<cfset intPassBillEmail=0>
	<cfset intPassBillUniqueEmail=0>
	<cfset intPassBillEmailSyntax=0>
	<cfset intPassBillEmailConfirm=0>
	<cfset strBillAddress1=trim(strBillAddress1)>

	<cfif len(strBillAddress1) GT 0>
		<cfset intPassBillAddress1=1>
	<cfelse>
		<cfset errTxt=errTxt & "<strong>Billing Address 1</strong>: Please enter the billing address 1.<br>">
	</cfif>

	<cfif len(strBillAddress2) GT 0>
		<cfset strBillAddress2=trim(strBillAddress2)>
	</cfif>

	<cfset strBillCity=trim(strBillCity)>
	<cfif len(strBillCity) GT 0>
		<cfset intPassBillCity=1>
	<cfelse>
		<cfset errTxt=errTxt & "<strong>Billing City</strong>: Please enter the billing city.<br>">
	</cfif>

	<cfif len(strBillState) GT 0>
		<cfset intPassBillState=1>
		<!---Get the state name --->
		<cfquery name="cfqGetBillState" datasource="#application.dsn#">
		select strName from tblStates (nolock) where intOldID = #strBillState# 
		</cfquery>
		<cfif len(cfqGetBillState.strName)>
			<cfset strBillState = cfqGetBillState.strName>
		</cfif>
	<cfelse>
		<cfset errTxt=errTxt & "<strong>Billing State</strong>: Please select the billing state.<br>">
	</cfif>

	<cfset strBillZip=trim(strBillZip)>
	<cfif len(strBillZip) GT 0>
		<cfset intPassBillZip=1>
	<cfelse>
		<cfset errTxt=errTxt & "<strong>Billing Zip</strong>: Please enter the billing zipcode.<br>">
	</cfif>

	<cfset strBillPhone=trim(strBillPhone)>
	<cfif len(strBillPhone) GT 0>
		<cfset strBillTemp=ReplaceList(strBillPhone,"(,),-,.,e,E,x,X,t,T, ","")>
		<cfif IsNumeric(strBillTemp)>
			<cfset intPassBillPhone=1>
		<cfelse>
			<cfset errTxt=errTxt & "<strong>Billing Phone</strong>: Please enter a valid billing phone number.<br>">
		</cfif>
	<cfelse>
		<cfset errTxt=errTxt & "<strong>Billing Phone</strong>: Please enter the billing phone number.<br>">
	</cfif>

	<cfif len(strBillFax) GT 0>
		<cfset strBillFax=trim(strBillFax)>
	</cfif>

	<cfset strBillemail=trim(strBillemail)>
	<cfif len(strBillemail) GT 0>
		
		<!---> <cf_ct_RemoveInvalidEmailChars strVerifyEmail=#strBillEmail#> --->
		<cfmodule template="/v16fj/_customTags/ct_RemoveInvalidEmailChars.cfm" strVerifyEmail=#strBillEmail#>

		<cfset strBillEmail=strVerifyEmail>

		<cfif len(strBillEmail) GT 0>

			<cfset intPassBillEmail=1>

			<cfif
				(ListContainsNoCase(strBillEmail, '@') is not 0) And (
				(ListContainsNoCase(strBillEmail, '.ae') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.ar') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.at') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.au') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.be') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.biz') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.bm') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.br') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.bz') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.ca') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.cc') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.ch') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.cn') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.co') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.com') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.de') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.dk') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.edu') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.es') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.gov') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.gr') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.fr') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.fm') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.hk') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.hu') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.kr') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.id') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.ie') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.il') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.in') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.it') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.jp') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.mil') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.mx') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.name') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.net') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.nl') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.nz') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.org') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.rr') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.ru') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.uk') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.us') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.vg') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.se') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.sg') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.th') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.to') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.tr') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.tv') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.ws') is not 0) OR
				(ListContainsNoCase(strBillEmail, '.za') is not 0) )>
				<cfset intPassBillEmailSyntax=1>
				<cfset intPassBillUniqueEmail=1>
			</cfif>
		<cfelse>
			<cfset errTxt=errTxt & "<strong>Billing Email</strong>: Please enter the valid billing email address.<br>">
		</cfif>
	<cfelse>
		<cfset errTxt=errTxt & "<strong>Billing Email</strong>: Please enter the valid billing email address.<br>">
	</cfif>

</cfif>



<!--- -----------------------------------------Validate Credit Card Type----------------------------------------- --->
<cfif intCardType NEQ "">
	<cfset intPassCCType=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Credit Card Type</strong>: Please select the credit card type.<br>">
</cfif>



<!--- -----------------------------------------Validate Credit Card Number----------------------------------------- --->
<cfset intCCNumber=trim(intCCNumber)>
<cfif len(intCCNumber) GT 0>
	<!---><cf_ct_VerifyCC intCCOrderNum="#intCCNumber#">--->
	<cfmodule template="/v16fj/_customTags/ct_VerifyCC.cfm" intCCOrderNum="#intCCNumber#">
	<cfif intCCErrorCode EQ 0>
		<cfset intPassCCNumber=1>
		<cfif intCCType EQ intCardType>
			<cfset intPassCCMatch=1>
		<cfelse>
			<cfset errTxt=errTxt & "<strong>Credit Card Number</strong>: Please enter the valid credit card number.<br>">
		</cfif>
	</cfif>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Credit Card Number</strong>: Please enter the valid credit card number.<br>">
</cfif>



<!--- -----------------------------------------Validate Credit Card Expiration Month----------------------------------------- --->
<cfif intCardMonth NEQ "">
	<cfset intPassCCExpMonth=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Expiration Month</strong>: Please select the expiration month.<br>">
</cfif>



<!--- -----------------------------------------Validate Credit Card Expiration Year----------------------------------------- --->
<cfif intCardYear NEQ "">
	<cfset intPassCCExpYear=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Expiration Year</strong>: Please select the expiration year.<br>">
</cfif>



<!--- -----------------------------------------Validate Credit Card CSC Code----------------------------------------- --->
<cfif isdefined('strCSC')>
	<cfset intPassCSC=0>
	<cfif len(strcSC) GTE 3 and isnumeric(strCSC)>
		<cfif replace(strCSC,"0","","all") NEQ "">
			<cfset intPassCSC=1>
		</cfif>
	<cfelse>
		<cfset errTxt=errTxt & "<strong>CSC Code</strong>: Please enter the valid csc code.<br>">
	</cfif>
</cfif>



<!--- -----------------------------------------Validate Name on the Credit Card----------------------------------------- --->
<cfif len(strCCNameOnCard) GT 0>
	<cfset intPassCCName=1>
</cfif>

<cfset strCCNameOnCard=trim(strCCNameOnCard)>
<cfif len(strCCNameOnCard) GT 0>
	<cfset intPassCCName=1>
<cfelse>
	<cfset errTxt=errTxt & "<strong>Name on the card</strong>: Please enter the name as it appears on the credit card.<br>">
</cfif>

<cfif intAddJobSlot GT 0>
	<cfset intPassJobSlot=1>
</cfif>


<!--- ---------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-----------------------------------------Check the checks-----------------------------------------
----------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------- --->


<cfif (intPassFirstName NEQ 0 AND
		intPassLastName NEQ 0 AND
		intPassHowFind NEQ 0 AND
		intPassUsername NEQ 0 AND
		intPassUniqueUsername NEQ 0 AND
		intPassPwd NEQ 0 AND
		intPassPwdConfirm NEQ 0 AND
		intPass1eqPass2 NEQ 0 AND
		intPassCompany NEQ 0 AND
		intPassAddress1 NEQ 0 AND
		intPassBillAddress1 NEQ 0 AND
		intPassCity NEQ 0 AND
		intPassBillCity NEQ 0 AND
		intPassState NEQ 0 AND
		intPassBillState NEQ 0 AND
		intPassZip NEQ 0 AND
		intPassBillZip NEQ 0 AND
		intPassPhone NEQ 0 AND
		intPassBillPhone NEQ 0 AND
		intPassEmail NEQ 0 AND
		intPassEmailSyntax NEQ 0 AND
		intPassUniqueEmail NEQ 0 AND
		intPassRecruitFirm NEQ 0 AND
		intPassBillEmail NEQ 0 AND
		intPassBillEmailSyntax NEQ 0 AND
		intPassBillUniqueEmail NEQ 0 AND
		intPassCCType NEQ 0 AND
		intPassCCNumber NEQ 0 AND
		intPassCCMatch NEQ 0 AND
		intPassCCExpMonth NEQ 0 AND
		intPassCCExpYear NEQ 0 AND
		intPassCSC NEQ 0 AND
		intPassCCName NEQ 0)>



	<!--- ----------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------
	the base form passed, continue to store and process
	---------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------- --->


	<cfset dteSubmitted 			= now() />
	<cfset dteAcctExp 				= now() />
	<cfset intDetailLimit 			= "50" />
	<cfset intDetailLimitMonthly 	= "500" />


	<!--- blnMonthlyLimitInd indicates whether or not to look to see if we are limiting monthly views --->
	<cfset blnMonthlyLimitInd		= "1" />
	<cfset intJobsAllowed			= 0 />


	<cfif intAddJobSlot EQ 1>
		<cfset intJobsAllowed		= 1>
	<cfelseif intAddJobSlot EQ 2>
		<cfset intJobsAllowed		= 3>
	<cfelseif intAddJobSlot EQ 3>
		<cfset intJobsAllowed		= 1>
	<cfelseif intAddJobSlot EQ 4>
		<cfset intJobsAllowed		= 1>
	<cfelseif intAddJobSlot EQ 5>
		<cfset intJobsAllowed		= 6>
	<cfelseif intAddJobSlot EQ 6>
		<cfset intJobsAllowed		= 1>
	</cfif>


	<!--- translate boolean values --->
	<cfif blnExeRec EQ 0>
		<cfset intExeRec			= 0 />
		<cfset strAcctClass 		= "New Sale - Corporate" />
	</cfif>

	<cfif blnExeRec EQ 1>
		<cfset intExeRec			= 1 />
		<cfset strAcctClass 		= "New Sale - Recruiter" />
	</cfif>
	

	<cfset lcl_cc_cardType			= intCardType>
	<cfset strEncryptCCNbr			= CFusion_Encrypt(intCCNumber, sixFJEncryptKey)>
	<cfset lcl_cc_cardNumber		= intCCNumber>
	<cfset lcl_cc_cardMonth			= intCardMonth>
	<cfset lcl_cc_cardYear			= intCardYear>
	<cfset lcl_cc_cardName			= strCCNameOnCard>
	<cfset lcl_cc_cardCompany		= strCCCompanyNameOnCard>


	<cfif intSameAsContact NEQ 0>
		<cfset lcl_cc_addr1			= strAddress1>
		<cfset lcl_cc_addr2			= strAddress2>
		<cfset lcl_cc_city			= strCity>
		<cfset lcl_cc_state			= strState>
		<cfset lcl_cc_country		= strCountry>
		<cfset lcl_cc_zip			= strZip>
		<cfset lcl_cc_phone			= strPhone>
		<cfset lcl_cc_fax			= strFax>
		<cfset lcl_cc_email			= strEmail>
	<cfelse>
		<cfset lcl_cc_addr1			= strBillAddress1>
		<cfset lcl_cc_addr2			= strBillAddress2>
		<cfset lcl_cc_city			= strBillCity>
		<cfset lcl_cc_state			= strBillState>
		<cfset lcl_cc_country		= strBillCountry>
		<cfset lcl_cc_zip			= strBillZip>
		<cfset lcl_cc_phone			= strBillPhone>
		<cfset lcl_cc_fax			= strBillFax>
		<cfset lcl_cc_email			= strBillEmail>
	</cfif>


	<cfset blnTax=0>
	<!---07082013: Commented Out
	<cfif lcl_cc_state EQ "CT" or lcl_cc_state EQ "Connecticut">
	<cfset blnTax=1>
	</cfif>
	--->


	<cfscript>
		intJobsAllowed 	= request.qry_package.intjobSlots;
		intRenewAmt 	= request.qry_package.price;
		lcl_cc_price 	= request.qry_package.price;
		
		//optional search license
		if (blnSearch EQ 1 AND request.qry_package.packageheading NEQ "Search Only") {
			lcl_cc_price = lcl_cc_price+150;
		}
		
		intAcctType		= 1;
	</cfscript>



	<!---05/15/2013: Set the registration parameters --->
	<!--- 9/24/13 - this looks to be some kind of hack job that may or may not be needed since the plans changed (alan) --->
	<cfif request.qry_package.price is "199">
		<cfset intDetailLimit			= 0 />
		<cfset intDetailLimitMonthly	= 0 />
		<cfset blnMonthlyLimitInd		= 0 />
	<cfelseif request.qry_package.price is "499">
		<cfset intAcctType				= 2 />
		<cfset intJobsAllowed			= 5 />
	</cfif>
	
	
	<!--- 09/30/2013: These are the package parameter depending upon the package selected --->	
	<cfif request.qry_package.package is 1>

		<cfset request.intJobSlots = 1>
		<cfset request.blnSearchDB = 0>
		<cfset request.blnPostNtl = 0>
		<cfset request.blnNtlJobSlots = 0>
		<cfset request.intPackageType = 1>
		<cfset request.intAcctType = 1>
		<cfset request.intAcctType = 1>
		<cfset request.intDetailLimit = 0>
		<cfset request.intDetailLimitMonthly = 0>
		<cfset request.dteAcctExp = dateformat(dateadd("d", 30, now()), "mm/dd/yyyy")>
		<cfset request.strAcctClass = "Single Job Posting Package">
			
	<cfelseif request.qry_package.package is 2>
			
		<cfset request.intJobSlots = 5>
		<cfset request.blnSearchDB = 0>
		<cfset request.blnPostNtl = 1>
		<cfset request.blnNtlJobSlots = 5>
		<cfset request.intPackageType = 1>
		<cfset request.intAcctType = 1>
		<cfset request.intDetailLimit = -1>
		<cfset request.intDetailLimitMonthly = -1>
		<cfset request.dteAcctExp = dateformat(dateadd("d", 30, now()), "mm/dd/yyyy")>
		<cfset request.strAcctClass = "Starter Membership Package">
		
	<cfelseif request.qry_package.package is 3>
			
		<cfset request.intJobSlots = 1000>
		<cfset request.blnSearchDB = 0>
		<cfset request.blnPostNtl = 1>
		<cfset request.blnNtlJobSlots = 1000>
		<cfset request.intPackageType = 2>
		<cfset request.intAcctType = 1>
		<cfset request.intDetailLimit = -1>
		<cfset request.intDetailLimitMonthly = -1>
		<cfset request.dteAcctExp = dateformat(dateadd("d", 60, now()), "mm/dd/yyyy")>
		<cfset request.strAcctClass = "Autumn Special Package">
			
	<cfelseif request.qry_package.package is 4>
			
		<cfset request.intJobSlots = 1>
		<cfset request.blnSearchDB = 0>
		<cfset request.blnPostNtl = 1>
		<cfset request.blnNtlJobSlots = 1>
		<cfset request.intPackageType = 1>
		<cfset request.intAcctType = 1>
		<cfset request.intDetailLimit = -1>
		<cfset request.intDetailLimitMonthly = -1>
		<cfset request.dteAcctExp = dateformat(dateadd("d", 30, now()), "mm/dd/yyyy")>
		<cfset request.strAcctClass = "Starter Package">
			
	<cfelseif request.qry_package.package is 5>
			
		<cfset request.intJobSlots = 3>
		<cfset request.blnSearchDB = 0>
		<cfset request.blnPostNtl = 1>
		<cfset request.blnNtlJobSlots = 3>
		<cfset request.intPackageType = 1>
		<cfset request.intAcctType = 1>
		<cfset request.intDetailLimit = -1>
		<cfset request.intDetailLimitMonthly = -1>
		<cfset request.dteAcctExp = dateformat(dateadd("d", 30, now()), "mm/dd/yyyy")>
		<cfset request.strAcctClass = "Bronze Package">
			
	<cfelseif request.qry_package.package is 6>
			
		<cfset request.intJobSlots = 6>
		<cfset request.blnSearchDB = 0>	
		<cfset request.blnPostNtl = 1>
		<cfset request.blnNtlJobSlots = 6>
		<cfset request.intPackageType = 1>
		<cfset request.intAcctType = 1>
		<cfset request.intDetailLimit = -1>
		<cfset request.intDetailLimitMonthly = -1>
		<cfset request.dteAcctExp = dateformat(dateadd("d", 30, now()), "mm/dd/yyyy")>
		<cfset request.strAcctClass = "Silver Package">
			
	<cfelseif request.qry_package.package is 7>
			
		<cfset request.intJobSlots = 1000>
		<cfset request.blnSearchDB = 0>
		<cfset request.blnPostNtl = 1>
		<cfset request.blnNtlJobSlots = 1000>
		<cfset request.intPackageType = 1>
		<cfset request.intAcctType = 1>
		<cfset request.intDetailLimit = -1>
		<cfset request.intDetailLimitMonthly = -1>
		<cfset request.dteAcctExp = dateformat(dateadd("d", 30, now()), "mm/dd/yyyy")>
		<cfset request.strAcctClass = "Gold Package">
		
	<cfelseif request.qry_package.package is 8>
		
		<cfset request.intJobSlots = 0>
		<cfset request.blnSearchDB = 1>
		<cfset request.blnPostNtl = 0>
		<cfset request.blnNtlJobSlots = 0>
		<cfset request.intPackageType = 1>
		<cfset request.intAcctType = 1>
		<cfset request.intDetailLimit = -1>
		<cfset request.intDetailLimitMonthly = -1>
		<cfset request.dteAcctExp = dateformat(dateadd("d", 30, now()), "mm/dd/yyyy")>
		<cfset request.strAcctClass = "Search Only Package">
		
	</cfif>
	
	<cfif (blnSearch EQ 1 AND request.qry_package.packageheading NEQ "Search Only")>
		<cfset request.blnSearchDB=1>	
	</cfif>
	
	
	<!--- Try writing the  DB records --->
	<cftransaction>

		<cfif not(len(strPromoCode))>
			<cfset strPromoCode="Online Reg">
		</cfif>

		<cfset intRenewAmt = 0 />

		<cfif len(lcl_cc_price)>
			<cfif findNoCase(".", lcl_cc_price, 1) GT 0>
				<cfset intRenewAmt = removeChars(lcl_cc_price, findNoCase(".", lcl_cc_price, 1), 3)>
			<cfelse>
				<cfset intRenewAmt = lcl_cc_price>
			</cfif>
		</cfif>

		<cftry>
			<cfif not(len(strHowFind)) or strHowFind eq "Choose One">

				<cfquery name="cfqGetTracking" datasource="#application.dsn#">
	                 SELECT strName
	                 FROM tblHowFindTracking (nolock)
	                 WHERE intTrackingID = <cfqueryparam value="#intERTrkID#" cfsqltype="CF_SQL_INTEGER" />
              		</cfquery>

				<cfif cfqGetTracking.Recordcount GT 0>
					<cfset strHowFind = cfqGetTracking.strName>
				</cfif>
			</cfif>

			<cfcatch type="Any">
				<!--- Let the Null go Through --->
			</cfcatch>
		</cftry>

		
		<!---Start: 02/11/2014 : Hack for setting the daily profile view limit and the monthly profile view limits --->
		<cfset request.intDetailLimit = 100>
		<cfset request.intDetailLimitMonthly = 3000>
		<!---End: 02/11/2014 : Hack for setting the daily profile view limit and the monthly profile view limits --->

				
		<cfquery name="cfqNewER" datasource="#application.dsn#">
		SET NOCOUNT ON
		INSERT INTO tblEmployers(strfirst_name,
										strlast_name,
										strCompany,
										strAddress1,
										strAddress2,
										strCity,
										strState,
										intCountry,
										strZip,
										strPhone,
										strFax,
										strEmail,
										strURL,
										blnExeRec,
										blnSearchable,
										memocompany_nature,
										strUserName,
										strPassword,
										strAdminPassword,
										blnPostJobs,
										intNumJobsAllowed,
										blnNationalPosting,
					   					intNatnlPostJobSlots,
										blnSearch,
										intDetailLimit,
										intDetailLimitMonthly,					
										blnMonthlyLimitInd,
										blnValidated,
										intLoggedOn,
										intAcctMngrID,
										intAcctType,
										dteAcctExp,
										intAutoEmailJobs,
										blnSinglePost,
										strHowFind,
										strPromoCode,
										intHowFindTrkID,
										blnAutoRenew,
										intRenewAmt,
										intPackageType,
										sourceApp
										)
			VALUES ('#strFirstName#',
					'#strLastName#',
					'#strCompanyName#',
					'#straddress1#',
					'#straddress2#',
					'#strCity#',
					'#strState#',
					'#intState#',
					'#strZip#',
					'#strphone#',
					'#strfax#',
					'#strEmail#',
					'#strURL#',
					'#intExeRec#',
					0,
					'',
					'#strUsername#',
					'#strPassword#',
					'#strPassword#',
					<cfif  request.intJobSlots gt 0>
					1,
					#request.intJobSlots#,
					1,
					#request.intJobSlots#,
					<cfelse>
					0,
					0,
					0,
					0,
					</cfif>
					   					
 					<cfif request.qry_package.package is 8>
				        1,
				        #request.intDetailLimit#,
						#request.intDetailLimitMonthly#,
					<cfelse>
						<cfif isDefined("blnSearch") and blnSearch is 1>
						1,
						#request.intDetailLimit#,
					        #request.intDetailLimitMonthly#,
					        <cfelse>
						0,
						0,
						0,
						</cfif>
					</cfif>					
					#blnMonthlyLimitInd#,
					1,
					1,
					77,
					#intAcctType#,
					'#request.dteAcctExp#',
					1,
					0,
					'#strHowFind#',
					'#strPromoCode#',
					#intERTrkID#,
					'',
					#intRenewAmt#,
					#request.intPackageType#,
					'#application.sourceApp#')
			SET NOCOUNT OFF
			SELECT intIDno=@@IDENTITY
  		</cfquery>
		<cfset ERID = cfqNewER.intIDno>


		<!--- intAdminCode: 21 for incomplete, 22 for completed --->
		<cfquery name="cfqInsertERBillInfo" datasource="#application.dsn#">
			INSERT INTO tblERPay(intEmployerID,
									intCardType,
									strCardOwner,
									strCCFirstName,
									strCCLastName,
									strCCCompany,
									strCCAddress1,
									strCCAddress2,
									strCCCity,
									strCCState,
									strCCZip,
									strCCPhone,
									strCCEmail,
									strAcctClass,
									strPackPurch,
									blnTax,
									intPurchaseTotal,
									intAdminCode)
			VALUES(#ERID#,
					'#lcl_cc_cardType#',
					'#lcl_cc_cardName#',
					'#strFirstName#',
					'#strLastName#',
					'#strCompanyName#',
					'#lcl_cc_addr1#',
					'#lcl_cc_addr2#',
					'#lcl_cc_city#',
					'#lcl_cc_state#',
					'#lcl_cc_zip#',
					'#lcl_cc_phone#',
					'#lcl_cc_email#',
					'#request.strAcctClass#',
					'#request.qry_package.package#',
					#blnTax#,
					#lcl_cc_price#,
					21)
		</cfquery>



		<cfquery name="cfqNewERPwds" datasource="#application.dsn#">
			INSERT INTO tblERPwds(intEmployerID,strPassword,strFirstName,strLastName,strEmail,blnActive)
			VALUES('#ERID#','#strPassword#','#strFirstName#','#strLastName#','#stremail#','0')
		</cfquery>

		

		<cflock scope="session" timeout="10" type="Exclusive">
			<cfset session.ER.shoppingCart.Status			= 1>
			<cfset session.ER.shoppingCart.EmployerID		= ERID>
			<cfset session.ER.shoppingCart.FirstName		= strFirstName>
			<cfset session.ER.shoppingCart.LastName			= strLastName>
			<cfset session.ER.shoppingCart.Email			= lcl_cc_email>
			<cfset session.ER.shoppingCart.Phone			= lcl_cc_phone>
			<cfset session.ER.shoppingCart.Fax				= lcl_cc_fax>
			<cfset session.ER.shoppingCart.BillingSame		= intSameAsContact>
			<cfset session.ER.shoppingCart.CardType			= lcl_cc_cardType>
			<cfset session.ER.shoppingCart.CardNumber		= lcl_cc_cardNumber>
			<cfset session.ER.shoppingCart.CardMonth		= lcl_cc_cardMonth>
			<cfset session.ER.shoppingCart.CardYear			= lcl_cc_cardYear>
			<cfset session.ER.shoppingCart.strCSC			= strCSC>
			<cfset session.ER.shoppingCart.CardOwner		= lcl_cc_cardName>
			<cfset session.ER.shoppingCart.CCCompany		= lcl_cc_cardCompany>
			<cfset session.ER.shoppingCart.CCaddress1		= lcl_cc_addr1>
			<cfset session.ER.shoppingCart.CCaddress2		= lcl_cc_addr2>
			<cfset session.ER.shoppingCart.CCCity			= lcl_cc_city>
			<cfset session.ER.shoppingCart.CCState			= lcl_cc_state>
			<cfset session.ER.shoppingCart.strCCState		= strBillState>
			<cfset session.ER.shoppingCart.CCCountry		= lcl_cc_country>
			<cfset session.ER.shoppingCart.CCzip			= lcl_cc_zip>
			<cfset session.ER.shoppingCart.autoRenew		= blnAutoRenew>
			<cfset session.ER.shoppingCart.PurchasePrice	= lcl_cc_price>
			<cfset session.ER.shoppingCart.PackagePurchased	= intAddJobSlot>

			<cfif not(len(session.ER.shoppingCart.DateSubmitted))>
				<cfset session.ER.shoppingCart.DateSubmitted= dteSubmitted>
			</cfif>
		</cflock>


	
		<cflock scope="session" timeout="10" type="ReadOnly">
			<cfset ioc_transID		= session.ER.shoppingCart.IOC_TransID>
			<cfset intPersonID		= session.ER.shoppingCart.EmployerID>
			<cfset strFirstName		= session.ER.shoppingCart.FirstName>
			<cfset strLastName		= session.ER.shoppingCart.LastName>
			<cfset strEmail			= session.ER.shoppingCart.Email>
			<cfset strPhone			= session.ER.shoppingCart.Phone>
			<cfset intCardType		= session.ER.shoppingCart.CardType>
			<cfset strCardNumber	= session.ER.shoppingCart.CardNumber>
			<cfset intCardMonth		= session.ER.shoppingCart.CardMonth>
			<cfset intCardYear		= session.ER.shoppingCart.CardYear>
			<cfset strCardOwner		= session.ER.shoppingCart.CardOwner>
			<cfset strCCCompany		= session.ER.shoppingCart.CCCompany>
			<cfset strCCaddress1	= session.ER.shoppingCart.CCaddress1>
			<cfset strCCaddress2	= session.ER.shoppingCart.CCaddress2>
			<cfset strCCCity		= session.ER.shoppingCart.CCCity>
			<cfset strCCState		= session.ER.shoppingCart.CCState>
			<cfset strCCCountry		= session.ER.shoppingCart.CCCountry>
			<cfset strCCZip			= session.ER.shoppingCart.CCzip>
			<cfset intCost			= session.ER.shoppingCart.PurchasePrice>
			<cfset intEmployerID	= session.ER.shoppingCart.EmployerID>
			<cfset dteSubmitted		= session.ER.shoppingCart.DateSubmitted>
		</cflock>
		
				
		<cflock scope="session" timeout="10" type="Exclusive">
			<cfset session.ER.shoppingCart.Status 		= 2>
			<cfset session.ER.shoppingCart.CardNumber	= CFusion_Encrypt(session.ER.shoppingCart.CardNumber, sixFJEncryptKey)>
		</cflock>

		<cfset strCallingPage = "ERSignUp">
		
		<!--- 09/30/2013 This is the correct price for the package--->
		<cfset intCost = lcl_cc_price>

		<cfparam name="strCSC" default="">
		<cfparam name="IOC_TransID" default="">
		<!--- the BOA transaction ID --->
		<cfparam name="intPersonID" default="">
		<!--- ID of the transaction --->
		<cfparam name="ioc_merchant_order_id" default="#IOC_TransID#">
		<!--- BOA reference ID --->
		<cfparam name="ioc_merchant_shopper_id" default="#intPersonID#">
		<!--- ID of the transaction (SeminarID, NetworkID, etc...) --->


		<!--- tells BOA to automatically process the cc (use "n" for batch processing mode or in testing mode) --->
		<!---> <cf_ct_vsp> --->
		<cfmodule template="/v16fj/_customTags/ct_vsp.cfm">

		<!--- security code vcalidation return code --->
		<cfparam name="scv" default="">
		<cfparam name="fltAmtSalesTax" default="0">
		<cfparam name="Tax" default="0.00">
		<cfparam name="cfAmount" default="0.00">


		<cfparam name="intEmployerID" default="">
		<!--- used by single job posting and ER SignUp--->
		<cfparam name="dteSubmitted" default="#dateformat(now(), 'mm/dd/yyyy')#">
		<!--- used by ER SignUp--->


		<!---> <cf_ct_vspdc VSPWENC="#VSPWENC#" VSUNENC="#VSUNENC#" VSPENC="#VSPENC#"> --->
		<cfmodule template="/v16fj/_customTags/ct_vspdc.cfm" VSPWENC="#VSPWENC#" VSUNENC="#VSUNENC#" VSPENC="#VSPENC#">


		<!--- remove the $$SQ$$ and $$DQ$$ from certain fields --->
		<cfif len(strLastName)>
			<!--- add the quotes --->
			<!--- <cf_ct_removeQuotes strStrip="#strLastName#" blnRemove="0"> --->
			<cfmodule template="/v16fj/_customTags/ct_removeQuotes.cfm" strStrip="#strLastName#" blnRemove="0">
			<cfset strLastName=strStrip>
		</cfif>

		<cfif len(strCardOwner)>
			<!--- add the quotes --->
			<!--- <cf_ct_removeQuotes strStrip="#strCardOwner#" blnRemove="0"> --->
			<cfmodule template="/v16fj/_customTags/ct_removeQuotes.cfm" strStrip="#strCardOwner#" blnRemove="0">
			<cfset strCardOwner=strStrip>
		</cfif>

		<cfif len(strCCCompany)>
			<!--- add the quotes --->
			<!--- <cf_ct_removeQuotes strStrip="#strCCCompany#" blnRemove="0"> --->
			<cfmodule template="/v16fj/_customTags/ct_removeQuotes.cfm" strStrip="#strCCCompany#" blnRemove="0">
			<cfset strCCCompany=strStrip>
		</cfif>

		<cfif len(strCCaddress1)>
			<!--- add the quotes --->
			<!--- <cf_ct_removeQuotes strStrip="#strCCaddress1#" blnRemove="0"> --->
			<cfmodule template="/v16fj/_customTags/ct_removeQuotes.cfm" strStrip="#strCCaddress1#" blnRemove="0">
			<cfset strCCaddress1=strStrip>
		</cfif>

		<cfif len(strCCaddress2)>
			<!--- add the quotes --->
			<!--- <cf_ct_removeQuotes strStrip="#strCCaddress2#" blnRemove="0"> --->
			<cfmodule template="/v16fj/_customTags/ct_removeQuotes.cfm" strStrip="#strCCaddress2#" blnRemove="0">
			<cfset strCCaddress2=strStrip>
		</cfif>

		<cfif len(strCCcity)>
			<!--- add the quotes --->
			<!--- <cf_ct_removeQuotes strStrip="#strCCcity#" blnRemove="0"> --->
			<cfmodule template="/v16fj/_customTags/ct_removeQuotes.cfm" strStrip="#strCCcity#" blnRemove="0">
			<cfset strCCcity=strStrip>
		</cfif>

		<!--- strip out any characters from the price --->
		<cfset intCost=reReplace(intCost, "[,$]", "", "ALL")>

		<!--- calculate any tax --->
		<!---07/08/2013 Commented out
		<cfif strCCState EQ "CT" or strCCState EQ "Connecticut">
		<cfset tax=intCost * fltAmtSalesTax>
		<cfset cost_w_tax=intCost + tax>
		<cfset intCost=numberformat(cost_w_tax, "______.__")>
		</cfif>
		--->

		<!--- the code below does not run for Single Job Postings, the insert into BOA is done on the t_EmpRecSingleJobSubmit page --->
		<!--- encrypt CC number before the insert --->
		<cfscript>
			strEncryptCCNbr=CFusion_Encrypt(strCardNumber, sixFJEncryptKey);
			CCExpDte=intCardMonth & '/' & intCardYear;
			if (not(isdate(dteSubmitted))){
				dteSubmitted = NOW();
			}
		</cfscript>

		<!--- Update Merchant Info --->
		<cfif len(ioc_merchant_order_id) GT 3>

			<cfquery datasource="#application.dsn#">
				UPDATE tblBOALogs set
					intTransID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ioc_merchant_shopper_id#" null="no" />,
					strTransType=<cfqueryparam cfsqltype="cf_sql_varchar" value="#strCallingPage#" null="no" />,
					strName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#strCardOwner#" null="no" />,
					strNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#strEncryptCCNbr#" null="no" />,
					dteExp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#CCExpDte#" null="no" />
				WHERE IOC_Trans_ID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#ioc_merchant_order_id#" null="no" />
			</cfquery>

		<cfelse>

			<!--- insert the CC transaction record into the dB --->
			<cfquery datasource="#application.dsn#">
				INSERT INTO tblBOALogs (intTransID,
										strTransType,
										strName,
										strNumber,
										dteExp,
										dteSubmitted
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ioc_merchant_shopper_id#" null="no" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#strCallingPage#" null="no" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#strCardOwner#" null="no" />,
					NULL,
					NULL,
					getdate()
				)
			</cfquery>

			<cfquery name="cfqGetBOAID" datasource="#application.dsn#">
				SELECT max(IOC_Trans_ID) as ID
				FROM tblBOALogs (NOLOCK)
				WHERE intTransID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ioc_merchant_shopper_id#" null="no" />
			</cfquery>

			<cfset ioc_merchant_order_id=cfqGetBOAID.ID>
		</cfif>


		
		<cfset TaxExempt = "Yes" />
		


		<!--- Production Only --->
		<cfif application.machine EQ "LIVE">
			<cfset PayFlowURL="payflowpro.paypal.com">
		<cfelse>
			<cfset PayFlowURL="pilot-payflowpro.paypal.com">
		</cfif>
		
		
		<!--- Authorizations For 6FJ Admins --->
		<CFX_PAYFLOWPRO
			URLSTREAMHANDLER="sun.net.www.protocol.https.Handler"
			PROXYADDRESS=""
			PROXYPASSWORD=""
			PROXYPORT=""
			PROXYLOGON=""
			QUERY="PNResponse"
			HOSTADDRESS="#PayFlowURL#"
			HOSTPORT="443"
			TIMEOUT="30"
			TRXTYPE="S"
			TENDER="C"
			PARTNER="#VSPartner#"
			VENDOR="#VSUserName#"
			USER="#VSUserName#"
			PWD="#VSPassword#"
			ACCT="#strCardNumber#"
			EXPDATE="#intCardMonth##right(intCardYear,2)#"
			AMT="#intCost#"
			COMMENT1="#ioc_merchant_order_id#"
			COMMENT2="#ioc_merchant_shopper_id#"
			CVV2="#strCSC#"
			firstname="#strFirstName#"
			Lastname="#strLastName#"
			email="#strEmail#"
			TaxExempt="#TaxExempt#"
			TaxAmt="#Tax#"
			PONum="#ioc_merchant_order_id#">


		<cfif isdefined('PNResponse.result') AND PNResponse.result EQ "0">

				<cfscript>
					rejected=PNResponse.result;

					if (isdefined('PNResponse.AVSADDR')){
						AVSAddr=PNResponse.AVSAddr;
					} else {
						AVSAddr="";
					}

					if (isdefined('PNResponse.AVSZip')){
						AVSZip=PNResponse.AVSZip;
					} else {
						AVSZip="";
					}

					blnPassAVS = 1;
				</cfscript>


				<!-- Google Code for Google Employer/Recruiter Conversion Page -->
				<script language="JavaScript" type="text/javascript">
				<!--
				var google_conversion_id = 1071435707;
				var google_conversion_language = "en_US";
				var google_conversion_format = "3";
				var google_conversion_color = "ffffff";
				var google_conversion_label = "et00CPXrZBC7n_P-Aw";
				//-->
				</script>
				<script language="JavaScript" src="https://www.googleadservices.com/pagead/conversion.js"></script>
				<noscript>
					<img height="1" width="1" border="0" src="https://www.googleadservices.com/pagead/conversion/1071435707/?label=et00CPXrZBC7n_P-Aw&amp;script=0"/>
				</noscript>

		<cfelse>
			<cfscript>
				rejected=-1;
				scv="";
				AVSAddr="";
				AVSZip="";
				blnPassAVS = "";
			</cfscript>
		</cfif>



		<!--- Bypass the validation on dev for now and let the transaction go through if the PNResponse.result = 1 set it to 0 --->
		<cfif application.machine EQ "LOCAL" OR application.machine EQ "DEV">
			<cfscript>
				rejected 			= 0;
				blnPassAVS 			= "1";
				PNResponse.result 	= 0;
			</cfscript>
		</cfif>




		<!--- BOA variables --->
		<cfparam name="ioc_merchant_shopper_id" default="">
		<!--- ID of the transaction (SeminarID, NetworkID, etc...) --->
		<cfparam name="blnPassAVS" default="">
		<cfparam name="rejected" default="">
		<!--- misc vars passed back by BOA --->
		<!--- 6FJ variables --->
		<cfparam name="strAppAddToken" default="">
		<!--- determines if in admin area or not--->
		<cfparam name="strCallingPage" default="">
		<!--- the 6FJ area which called the cc approval --->
		<cfparam name="intEmployerID" default="">
		<!--- used by single job posting and ER SignUp --->
		<cfparam name="dteSubmitted" default="">
		<!--- used by ER SignUp--->



		<!--- if the record has not been approved yet, update the values. this will fix the problem of multiple submits --->
		<cfset blnDupRec=0>


		<cfquery name="cfqCheckForDup" datasource="#application.dsn#">
			SELECT strOrderID
			FROM tblBOALogs (NOLOCK)
			WHERE IOC_Trans_ID = #ioc_merchant_order_id#
			AND strRespCode=0
		</cfquery>


		<!--- "Good faith" (-1) allows for the CC to be submitted but not charged, therefore an order ID is givin to the account --->
		<cfif cfqCheckForDup.strOrderID NEQ "">
			<cfset blnDupRec=1>
			<cfset tempErrDesc="Duplicate Record - Order ID:" & ioc_merchant_order_id>
		<cfelse>
			<cfset errFields="">
			<cfset tempErrDesc="">
			
			<!--- update the log table --->
			<cfquery datasource="#application.dsn#">
			    UPDATE tblBOALogs set
					<cfif isdefined('PNResponse.authcode')>strAuthCode=<cfif PNResponse.authcode NEQ "">'#PNResponse.authcode#'<cfelse>NULL</cfif>,</cfif>
					strRespCode=<cfif isdefined('PNResponse.result') and PNResponse.result NEQ "">'#PNResponse.result#'<cfelse>NULL</cfif>,
					strRespDesc=<cfif isdefined('PNResponse.RESPMSG') and PNResponse.RESPMSG NEQ "">'#PNResponse.RESPMSG#'<cfelse>NULL</cfif>,
					strOrderID=<cfif isdefined('PNResponse.PNREF') and PNResponse.PNREF NEQ "">'#PNResponse.PNREF#'<cfelse>NULL</cfif>
					<cfif isdefined('AVSADDR') and AVSADDR NEQ "">, AVSADDRResp='#AVSADDR#'</cfif>
					<cfif isdefined('AVSZIP') and AVSZIP NEQ "">, AVSZIPResp='#AVSZIP#'</cfif>
					<cfif tempErrDesc eq "">, intCost=<cfif intcost NEQ "">#intcost#<cfelse>NULL</cfif></cfif>
					<cfif isdefined('cgi.Remote_Addr') and cgi.Remote_Addr NEQ "">,strIPAddress='#cgi.Remote_Addr#'</cfif>
			     WHERE IOC_Trans_ID = <cfqueryparam value="#ioc_merchant_order_id#">
		    </cfquery>

			<cfquery datasource="#application.dsn#">
				UPDATE tblBOALogs set
					strIPAddress = <cfqueryparam value="#cgi.Remote_Addr#">
				WHERE IOC_Trans_ID = <cfqueryparam value="#ioc_merchant_order_id#">
			</cfquery>
		</cfif>

		
		
		<cfif isdefined('PNResponse.result') AND PNResponse.result EQ 0 AND blnPassAVS EQ "1">

			<cfquery datasource="#application.dsn#">
				UPDATE tblERPay set
					fltTotalwithTax = <cfqueryparam value="#intcost#">
				WHERE intEmployerID = <cfqueryparam value="#intEmployerID#">
			</cfquery>
			
			<cflock scope="session" timeout="10" type="Exclusive">
				<cfset session.ER.shoppingCart.Status				= 3 />
				<cfset session.ER.shoppingCart.IOC_TransID 			= ioc_merchant_order_id />
				<cfset session.ER.shoppingCart.TotalPurchasePrice 	= intcost />
			</cflock>



			<cflock scope="session" timeout="10" type="ReadOnly">
				<cfset ioc_trans_id		= session.ER.shoppingCart.IOC_TransID>
				<cfset shopperID		= session.ER.shoppingCart.EmployerID>
				<cfset subtotal			= session.ER.shoppingCart.PurchasePrice>
				<cfset total			= session.ER.shoppingCart.TotalPurchasePrice>
				<cfset bill_cardType	= session.ER.shoppingCart.CardType>
				<cfset bill_cardNumber	= CFusion_decrypt(session.ER.shoppingCart.CardNumber, sixFJEncryptKey)>
				<cfset bill_cardMonth	= session.ER.shoppingCart.CardMonth>
				<cfset bill_cardYear	= session.ER.shoppingCart.CardYear>
			</cflock>


			<cfswitch expression="#bill_cardType#">
				<cfcase value="1"><cfset bill_strType="Mastercard"></cfcase>
				<cfcase value="2"><cfset bill_strType="Visa"></cfcase>
				<cfcase value="3"><cfset bill_strType="Amex"></cfcase>
				<cfcase value="4"><cfset bill_strType="Discover"></cfcase>
				<cfcase value="5"><cfset bill_strType="Diners Club"></cfcase>
			</cfswitch>


			<cfset bill_cardNumber = reMoveChars(bill_cardNumber, 1, (len(bill_cardNumber)- 4))>
			<cfset tax = (total-subtotal)>

			<!---
			<cfquery name="cfqGetEmpConfirm" datasource="#application.dsn#">
				SELECT strFirst_Name, strLast_Name, strUsername, strPassword, strState, strCompany, strAddress1, strAddress2, strCity, strZip, strPhone, strFax, strEmail, strURL, strHowFind
				FROM tblEmployers (nolock)
				WHERE intEmployerID = <cfqueryparam value="#shopperID#">
			</cfquery>
			--->
			
			<cfquery name="cfqGetEmpConfirm" datasource="#application.dsn#">
			SELECT TOP 1 pay.strccFirstName, pay.strCCLastName, pay.strCardOwner, pay.strCCCompany, pay.strCCAddress1, pay.strCCAddress2, pay.strCCCity, pay.strCCState, pay.strCCZip, pay.strCCEmail, emp.strusername, emp.stremail
			  FROM tblERPay pay(nolock)
   		     INNER JOIN tblEmployers emp (nolock)
				ON emp.intEmployerID = pay.intEmployerID
			 WHERE pay.intEmployerID = <cfqueryparam value="#shopperID#">
			 ORDER BY pay.dteSubmitted desc
			</cfquery>

			<cfoutput>
			<cfsavecontent variable="emailMessage">
			<table cellpadding="0" cellspacing="0" style="padding:10px;" width="780">
				<tr>
					<!-- MASTHEAD BEGIN -->
					<td width="350">
						<a href="#application.url#">
							<img src="#application.url#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.sourceApp#"><br><br>
						</a>
					</td>

					<td width="250" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333;">
						<strong>Account Registration Confirmation</strong>
					</td>
					<!-- MASTHEAD END -->
				</tr>
			</table>

			<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="780">
				<tr>
			    	<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">

					<!--- COMMUNICATION MESSAGE BEGIN --->
					<span style="font-size:18px; color:##9f58a2; font-weight:bold;">Your #application.sourceApp# Account Confirmation</span><br><br>

					<strong>Dear #cfqGetEmpConfirm.strCCFirstName# #cfqGetEmpConfirm.strCCLastName#,</strong><br><br>
					Thank you for your registration with #application.sourceApp#<br>
					Please visit #application.url#/recruitment to login.<br><br>
					Username: #cfqGetEmpConfirm.strUsername#<br><br>

					If you have any questions, please email us at sales@6FigureJobs.com. <br><br>

					<table border="0">
						<tr>
							<td colspan="2" valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;"><span style="color:##9f58a2; font-weight:bold;">Purchase Information Summary</span></td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Purchase Date:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#dateformat(now(), "mm/dd/yyyy")#</td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Invoice Number:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#ioc_trans_id#</td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Credit Card Type:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#bill_strType#</td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Credit Card Ending In:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#bill_cardNumber#</td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right"> Expiration Date:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#bill_cardMonth#/#bill_cardYear#</td>
						</tr>
						<tr>
							<td colspan="2" style="line-height: 15px; color:##333333; padding-top:3px;">&nbsp;</td>
						</tr>
						<!---07/08/2013 Commented out
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Subtotal:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#dollarformat(subtotal)#</td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Tax:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#dollarformat(tax)#</td>
						</tr>
						--->
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Total:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#dollarformat(total)#</td>
						</tr>
						<tr>
							<td colspan="2" style="line-height: 20px; color:##333333; padding-top:3px;">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2" valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 20px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;"><span style="color:##9f58a2; font-weight:bold;">Package Purchased</span></td>
						</tr>
						<tr>
							<td colspan="2" valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 20px; color:##333333; padding-top:3px;">
								<strong>#request.qry_package.packageheading# Package</strong><br />
								<strong>$#request.qry_package.price# / month</strong><br />
								<cfif request.qry_package.packageheading NEQ "Search Only">
								<label><cfif blnSearch is 1>with Search License (+ $150)</cfif></label><br />
								</cfif>
								
								<cfloop list="#request.qry_package.packageText#" index="lineItem" delimiters=";">
									<cfif !lineItem contains "Optional">
										<li>#lineItem#</li>
									<cfelse>
										<cfif request.qry_package.packageheading EQ "Search Only">
										<li>Search Licence</li>
										<cfelse>
											<cfif blnSearch is 1>
											<li>Search License</li>
											</cfif>
										</cfif>
									</cfif>
								
									<!--->#lineItem#<br />--->
								</cfloop>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="line-height: 20px; color:##333333; padding-top:3px;">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2" valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;"><span style="color:##9f58a2; font-weight:bold;">Billing Information Summary</span></td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Name on Card:</td>
							<!--- <td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#cfqGetEmpConfirm.strFirst_Name# #cfqGetEmpConfirm.strLast_Name#</td> --->
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#strCardOwner#</td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Company Name on Card:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">#cfqGetEmpConfirm.strCCCompany#</td>
						</tr>
						<tr>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-top:3px;" align="right">Address:</td>
							<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 15px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
								#cfqGetEmpConfirm.strCCAddress1#<br>
								<cfif len(cfqGetEmpConfirm.strCCAddress2)>#cfqGetEmpConfirm.strCCAddress2#<br></cfif>
								#cfqGetEmpConfirm.strCCCity#, #cfqGetEmpConfirm.strCCState# #cfqGetEmpConfirm.strCCZip#<br>
							</td>
						</tr>
					</table>
					<!--- COMMUNICATION MESSAGE END --->
					</td>
				</tr>
			</table>
			<br>
			<table width="780" border="0" cellpadding="0" cellspacing="0">
			    <tr>
			       <td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
		                &copy; #year(now())# 6FigureJobs.com | <a href="#application.url#/privacy">Privacy</a> | <a href="#application.url#/terms">Terms of Use</a> | <a href="#application.url#/contact">Contact</a> | <a href="#application.url#/sitemap">Site Map</a>
		                <br />
		                6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
		                <br /><br>
		                You are receiving this registration confirmation because you registered with 6FigureJobs.com<br />
		                <br /><br />
			        </td>
			    </tr>
			</table>
			</cfsavecontent>
			
			</cfoutput>


			<cfset application.emailManager.erRegConfirmation(emailTo=cfqGetEmpConfirm.strEmail,
																emailSubject="6FigureJobs Registration - Invoice ###ioc_trans_id#",
																emailBody=emailMessage) />

														
			<!--- Send an email to finanace regarding this transaction --->
			<!--- Production Only --->
			<cfif application.machine EQ "LIVE">
				<cfset application.emailManager.erRegConfirmation(emailTo='ar.6figurejobs@calliduscloud.com',
																  emailSubject="6FigureJobs Registration - Invoice ###ioc_trans_id#",
																  emailBody=emailMessage) />
				
				<cfset application.emailManager.erRegConfirmation(emailTo='vnalla@calliduscloud.com',
																  emailSubject="LIVE 6FigureJobs Registration - Invoice ###ioc_trans_id#",
																  emailBody=emailMessage) />
																  
			<cfelse>
				<cfset application.emailManager.erRegConfirmation(emailTo='vnalla@calliduscloud.com',
																  emailSubject="UAT/DEV 6FigureJobs Registration - Invoice ###ioc_trans_id#",
																  emailBody=emailMessage) />
			</cfif>																

			<!----------------------------------------------------------------------------------------->
			<!------------------------------cc transaction was rejected ------------------------------->
			<!----------------------------------------------------------------------------------------->
		<cfelse>

			

			<cftransaction action="rollback" />
				
			<!--- ER Sign-Up redirection --->
			<cflock scope="session" timeout="10" type="Exclusive">
				<cfset session.ER.shoppingCart.Status = 4 />
				<cfset session.ER.shoppingCart.IOC_TransID = ioc_merchant_order_id />
			</cflock>
			
		</cfif>


	</cftransaction>
	
	<!--- had to do this outside the cftransaction --->
	<cfif session.ER.shoppingCart.Status EQ 3>
		<cflocation url="#application.secureURL#/package.confirm?pid=#request.pid#" addtoken="false">
	</cfif>

</cfif>