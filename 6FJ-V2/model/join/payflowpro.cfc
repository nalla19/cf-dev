<cfcomponent hint="This CFC is used exclusively to submit transations over to Paypal through the CFX Tag">

	<cfparam name="variables.dsn" default="6figs">

	<cffunction name="init" access="public" output="false" returntype="payflowpro">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="machine" type="string" required="true" />
		<cfargument name="resume" required="true" />
		<cfargument name="profileName" type="string" required="true" />
		<cfscript>
			variables.dsn 			= arguments.dsn;
			variables.machine 		= arguments.machine;
			variables.resume 		= arguments.resume;
			variables.profileName 	= arguments.profileName;
			
			variables.VSPartner		="Verisign";
			variables.VSUserName	="6FigureJobs";
			variables.VSPassword	="!6Fig123";

			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getPayFlowURL" access="private" hint="Get PayFlowPro Production or Development Server" returntype="string">
  		<cfscript>
			var PayFlowURL = "";

			if (variables.machine EQ "LIVE"){
				PayFlowURL="payflowpro.paypal.com";
			} else {
				PayFlowURL="pilot-payflowpro.paypal.com";
			}

			return PayFlowURL;
		</cfscript>
	</cffunction>

    <cffunction name="addJSResumePurchase" access="public" hint="Insert the Resume Purchase into Database Good or Bad" returntype="numeric">
        <cfargument name="purchaseType" type="string" required="yes" hint="" default="ResumeMngr" />
        <cfargument name="purchaseCost" type="string" required="yes" hint="" />
        <cfargument name="purchaseName" type="string" required="yes" hint="" />
        <cfargument name="purchaseEmail" type="string" required="yes" hint="" />
        <cfargument name="purchaseResumeid" type="numeric" required="yes" hint="Resume ID" default="0" />
        <cfargument name="purchaseCCNumber" type="string" required="yes" hint="" />
        <cfargument name="purchaseCCExp" type="string" required="yes" hint="" />
        <cfset var newMaxID = "" />

        <!--- Insert Data --->
        <cfstoredproc procedure="spI_JSPurchaseResume" datasource="#variables.dsn#" returncode="Yes">
           <cfprocparam type="IN" variable="@strPurchaseType" value="#trim(arguments.purchaseType)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@intCost" value="#trim(arguments.purchaseCost)#" cfsqltype="cf_sql_integer">
           <cfprocparam type="IN" variable="@strName" value="#trim(arguments.purchaseEmail)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@stremail" value="#trim(arguments.purchaseEmail)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@intResumeID" value="#trim(arguments.purchaseResumeid)#" cfsqltype="cf_sql_integer" />
           <cfprocparam type="IN" variable="@strIPAddress" value="#trim(cgi.REMOTE_ADDR)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@strCCNumber" value="#trim(setEncryptedCC(arguments.purchaseCCNumber))#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@strExpDate" value="#trim(arguments.purchaseCCExp)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocresult resultset="1" name="newMaxId">
        </cfstoredproc>

        <cfreturn newMaxId.maxid />
    </cffunction>

    <cffunction name="UpdateJSResumePurchase" access="public" hint="Update Resume Purchased Based on PayPal Results" returntype="void">
        <cfargument name="orderNumber" type="string" required="yes" hint="" default="" />
        <cfargument name="PNREF" type="string" required="yes" hint="" default="" />
        <cfargument name="respCode" type="string" required="yes" hint="" default="" />
        <cfargument name="AuthCode" type="string" required="yes" hint="" default="" />
        <cfargument name="AuthDesc" type="string" required="yes" hint="" default="" />
        <cfargument name="VerifyAddress" type="string" required="yes" hint="" default="" />
        <cfargument name="VerifyZip" type="string" required="yes" hint="" default="" />

        <cfstoredproc procedure="spU_JSPurchaseResume" datasource="#variables.dsn#" returncode="Yes">
           <cfprocparam type="IN" variable="@orderNumber" value="#trim(arguments.orderNumber)#" cfsqltype="cf_sql_integer">
           <cfprocparam type="IN" variable="@strPNREF" value="#trim(arguments.PNREF)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@strRespCode" value="#trim(arguments.RespCode)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@strAuthCode" value="#trim(arguments.AuthCode)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@strAuthDesc" value="#trim(arguments.AuthDesc)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@strVerifyAddress" value="#trim(arguments.VerifyAddress)#" cfsqltype="CF_SQL_VARCHAR">
           <cfprocparam type="IN" variable="@strVerifyZip" value="#trim(arguments.VerifyZip)#" cfsqltype="CF_SQL_VARCHAR">
        </cfstoredproc>
    </cffunction>

    <cffunction name="setResumeManagerPurchase" access="public" hint="Update Resume Manager Purchased" returntype="void">
    	<cfargument name="emailaddress" type="string" required="yes" hint="" default="" />
        <cfstoredproc procedure="spU_ConfirmResumeManager" datasource="#variables.dsn#" returncode="Yes">
           <cfprocparam type="IN" variable="@emailaddress" value="#trim(arguments.emailaddress)#" cfsqltype="CF_SQL_VARCHAR">
        </cfstoredproc>
    </cffunction>

    <cffunction name="getWebBasedCC" access="public" returntype="string" hint="Encrypts the Credit Card For 6FJ Members">
        <cfargument name="decryptedCC" type="string" required="yes" hint="Credit Card Number as Shown on Card" />
        <cfscript>
        var returnCard = "";
        for (cardloop = 1; cardloop lte len(arguments.decryptedCC); cardloop = cardloop+1){
            returnCard = returnCard
                & iif(cardloop lt (len(decryptedCC)-3),de('X'),de(mid(decryptedCC,cardloop,1)))
                & iif((cardloop mod 4) eq 0 and cardLoop lt len(arguments.decryptedCC),de('-'),de(''));

        }
        //E.G. xxxx-xxxx-xxxx-4444
        return ucase(returnCard);
        </cfscript>
    </cffunction>


    <cffunction name="setEncryptedCC" access="public" returntype="string" hint="Encrypts the Credit Card For 6FJ Members">
	    <cfargument name="decryptedCC" type="string" required="yes" hint="Credit Card Number as Shown on Card" />
    	<cfreturn CFusion_Encrypt(arguments.decryptedCC, 63)/>
    </cffunction>

    <cffunction name="setDecryptedCC" access="public" returntype="string" hint="Decrypts the Credit Card For 6FJ Members">
	    <cfargument name="encryptedCC" type="string" required="yes" hint="Encrypted CC Number By 6FJ" />
    	<cfreturn CFusion_DeCrypt(arguments.encryptedCC, 63)/>
    </cffunction>

    <cffunction name="setTrxTypeSale" access="public" returntype="query" hint="Returns Response Query Based on a Delayed Capture or Sale Transaction">
        <cfargument name="TrxType" type="string" required="yes" hint="Transaction Type (A or S)" default="A" />
        <cfargument name="Tender" type="string" required="yes" hint="Method of Payment" default="C" />
        <cfargument name="CUSTREF" type="string" required="yes" hint="6figurejobs.com or AAA" default="6FigureJobs.com" />
        <cfargument name="acct" type="string" required="yes" hint="Credit Card Number" />
        <cfargument name="expdate" type="string" required="yes" hint="Expiration Date" />
        <cfargument name="amt" type="string" required="yes" hint="Total Sale Amount w/ Tax" />
        <cfargument name="tax" type="string" required="yes" hint="Tax Amount " />
        <cfargument name="comment1" type="string" required="yes" hint="Order Number" />
        <cfargument name="comment2" type="string" required="yes" hint="Employer ID or Resume ID" />
        <cfargument name="cvv2" type="string" required="yes" hint="Card Security Code" />
        <cfargument name="firstname" type="string" required="yes" hint="First Name" />
        <cfargument name="Lastname" type="string" required="yes" hint="Last Name" />
        <cfargument name="email" type="string" required="yes" hint="Email Address" />
        <cfargument name="address1" type="string" required="yes" hint="Address 1" />
        <cfargument name="address2" type="string" required="no" hint="" default="Address 2" />
        <cfargument name="City" type="string" required="yes" hint="City" />
        <cfargument name="State" type="string" required="yes" hint="State" />
        <cfargument name="ZIP" type="string" required="yes" hint="Zip" />
        <cfargument name="Country" type="string" required="yes" hint="Country" />


        <cftry>
			<!---  Start Error --->
            <cfscript>
            hostingurl = getPayFlowURL();
            arguments.CUSTREF = arguments.comment1;
            arguments.AMT=reReplace(arguments.AMT, "[,$]", "", "ALL");
            arguments.tax=reReplace(arguments.tax, "[,$]", "", "ALL");

            if (listfindnocase("CT,Connecticut",arguments.State)){
	            TaxExempt = "N";
            }else{ //Other States Here...
            	TaxExempt = "Y";
            }
            //Format Accordingly
            arguments.AMT = numberformat(arguments.AMT, "______.__");
            arguments.Tax = numberformat(arguments.Tax, "______.__");
            </cfscript>

    		<cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
              <CFX_PAYFLOWPRO
                  URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
                  PROXYADDRESS	= ""
                  PROXYPASSWORD	= ""
                  PROXYPORT	= ""
                  PROXYLOGON	= ""
                  QUERY			="PNResponse"
                  HOSTADDRESS     = "#hostingurl#"
                  HOSTPORT        = "443"
                  TIMEOUT         = "30"
                  TRXTYPE         = "#arguments.TrxType#"
                  TENDER          = "C"
                  PARTNER         = "#variables.VSPartner#"
                  VENDOR		  = "#variables.VSUserName#"
                  USER            = "#variables.VSUserName#"
                  PWD             = "#variables.VSPassword#"
                  ACCT            = "#arguments.acct#"
                  EXPDATE         = "#arguments.EXPDATE#"
                  AMT             = "#arguments.AMT#"
                  COMMENT1        = "#arguments.COMMENT1#"
                  COMMENT2        = "#arguments.COMMENT2#"
                  CVV2			  = "#arguments.CVV2#"
                  firstname		  = "#arguments.firstname#"
                  Lastname		  = "#arguments.Lastname#"
                  email		 	  = "#arguments.email#"
                  Street		  = "#arguments.address1# #arguments.address2#"
                  City			  = "#arguments.city#"
                  State			  = "#arguments.state#"
                  ZIP			  = "#arguments.zip#"
                  Country		  = "#arguments.country#"
                  TaxExempt		  = "#TaxExempt#"
                  TaxAmt		  = "#Tax#"
                  CUSTREF		  = "#arguments.CUSTREF#"
                  PONum			  = "#arguments.COMMENT1#">
    		</cflock>


            <cfcatch type="any">
				<cfscript>
                PNResponse = querynew("PNResponse,RC,RESULT,RESPMSG");
                void = QueryAddRow (PNResponse,1);
                void = QuerySetCell(PNResponse,"PNResponse","CFERROR");
                void = QuerySetCell(PNResponse,"RC",-1);
                void = QuerySetCell(PNResponse,"RESULT",-1);
                void = QuerySetCell(PNResponse,"RESPMSG","Test w/o locking!");
                </cfscript>
		      	<!--- End Error --->
    		</cfcatch>
  		</cftry>
  		<cfreturn PNResponse>
	</cffunction>

	<cffunction name="getPremiumObj" access="public" returntype="struct" hint="Returns the Cost of Premium Membership and the Duration">
		<cfargument name="premiumid" type="numeric" required="yes">
	 	<cfargument name="state" default="" type="string" required="No">

  		<cfscript>
		var premiumStruct = structnew();
		premiumStruct.TaxAmt = 0;

		if (listfindnocase("CT,Connecticut",arguments.State)){
			premiumStruct.TaxAmt= .06;
		}

		//6 Monts
		if (arguments.premiumid eq 3){
			premiumStruct.intialcost = "79.95";
			premiumStruct.months = 6;
			premiumStruct.cost = "79.95";
			premiumStruct.start = 1;
			premiumStruct.PAYPERIOD = "SMYR";
			premiumStruct.description = "<div id='MembershipPlan'>" & premiumStruct.months & " Month Premium Membership<br>" &
			"<span class='price'> Only $" & premiumStruct.cost & " (Save 33.2%)</span></div>";
		} else if (arguments.premiumid eq 2){
			premiumStruct.intialcost = "49.95";
			premiumStruct.months = 3;
			premiumStruct.cost = "49.95";
			premiumStruct.start = 1;
			premiumStruct.PAYPERIOD = "QTER";
			premiumStruct.description = "<div id='MembershipPlan'>" & premiumStruct.months & " Month Premium Membership<br>" &
			"<span class='price'> Only $" & premiumStruct.cost & " (Save 16.5%)</span></div>";
		} else {
			premiumStruct.intialcost = "19.95";
			premiumStruct.months = 1;
			premiumStruct.cost = "19.95";
			premiumStruct.start = 1;
			premiumStruct.PAYPERIOD = "MONT";
			premiumStruct.description = "<div id='MembershipPlan'>1 Month Premium Membership<br>" &
			"<span class='price'> Only $19.95 for 30 Days</span></div>";
		}

		premiumStruct.cost = premiumStruct.cost + (premiumStruct.cost * premiumStruct.TaxAmt);	//Cost
		premiumStruct.cost = numberformat(premiumStruct.cost, "______.__");
		return premiumStruct;
		</cfscript>
	</cffunction>


    <cffunction name="setPremiumSubscription" access="public" returntype="query" hint="Returns Response Query Based on Recurring Billing for 6FJ Customers">
        <cfargument name="intresid" type="string" required="yes" hint="Resume ID ##"  />
        <cfargument name="premiumid" type="string" required="yes" hint="Premium ID ##"  />
        <cfargument name="profileid" type="string" required="No" default="" hint="Profile ID ##"  />
        <cfargument name="isRenewable" type="boolean" required="no" default="true" hint="Is this profile renewable"  />
        <cfargument name="CUSTREF" type="string" required="yes" hint="6figurejobs.com or AAA" default="6FigureJobs.com" />
        <cfargument name="acct" type="string" required="yes" hint="Credit Card Number" />
        <cfargument name="storedCC" type="string" required="No" default="" hint="Credit Card Number" />
        <cfargument name="expdate" type="string" required="yes" hint="Expiration Date" />
        <cfargument name="cvv2" type="string" required="yes" hint="Card Security Code" />
        <cfargument name="firstname" type="string" required="yes" hint="First Name" />
        <cfargument name="Lastname" type="string" required="yes" hint="Last Name" />
        <cfargument name="email" type="string" required="yes" hint="Email Address" />
        <cfargument name="address1" type="string" required="yes" hint="Address 1" />
        <cfargument name="address2" type="string" required="no" hint="" default="Address 2" />
        <cfargument name="phone" type="string" required="yes" hint="Phone Number" />
        <cfargument name="City" type="string" required="yes" hint="City" />
        <cfargument name="State" type="string" required="yes" hint="State" />
        <cfargument name="ZIP" type="string" required="yes" hint="Zip" />
        <cfargument name="Country" type="string" required="yes" hint="Country" />
        <cfargument name="ipaddress" type="string" required="yes" hint="IP Address" />
		<cfset var PNResponse="" />
		
		<cftry>
     		<!---  Start Error --->
    		<cfscript>
			clientPremiumObj = getPremiumObj(arguments.premiumid);
			totalAmount = clientPremiumObj.intialcost;
			payPeriod = clientPremiumObj.PAYPERIOD;
			TaxAmt= clientPremiumObj.TaxAmt;

			if (arguments.isRenewable){
				//startDate = dateformat(dateadd('d',4,now()),'MMDDYYYY');
				startDate = dateformat(dateadd('d',1,now()),'MMDDYYYY');
			  	//dingAmount = 66.00;
				dingAmount = totalAmount;
			  	dingType = "A";
		 	}else{
		  		//startDate = dateformat(dateadd('d',clientPremiumObj.start,now()),'MMDDYYYY');
				startDate = dateformat(dateadd('d',1,now()),'MMDDYYYY');
		  		//dingAmount = 66.00;
			  	dingAmount =  totalAmount;
			 	dingType = "S";
		 	}

			hostingurl = getPayFlowURL();

		  	if (listfindnocase("CT,Connecticut",arguments.State)){
				TaxExempt = "N";
		 	}else{
		 		TaxExempt = "Y";
		 	}

		 	//Format Accordingly
		 	TaxAmt = numberformat(TaxAmt, "______.__");
		 	totalAmount = numberformat(totalAmount, "______.__");

			if (len(arguments.EXPDATE) gte 4 ){
	 			arguments.EXPDATE = left(arguments.EXPDATE,2) & right(arguments.EXPDATE,2);
		 	}

			actionType = "A";  //By default lets add a new subscription
			premiumExists = false;
			premiumActive = false;

			//Leave AS IS
			if (len(arguments.profileid)){
				qStatus = getPremiumStatus(arguments.profileid);

				if (isdefined("qStatus") and qstatus.result eq 0){
					premiumExists = true;
					//Active
					if (qStatus.STATUS eq "ACTIVE"){
						premiumActive = true;
					}
				}
			}

			if (premiumExists and not(premiumActive)){
				actionType = "R";  //Let's reactivate the account
			}

			//Use Existing CC ##?
			if (len(arguments.acct) gt 14 and left(arguments.acct,14) eq "XXXX-XXXX-XXXX"){
				arguments.acct = arguments.storedCC;
			}

			arguments.acct = trim(arguments.acct);

			if (hostingurl contains "pilot-"){
				arguments.email =  "webmaster@6figurejobs.com";
			}
			</cfscript>

            <cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
                <CFX_PAYFLOWPRO
                  URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
                  PROXYADDRESS	  = ""
                  PROXYPASSWORD	  = ""
                  PROXYPORT		  = ""
                  PROXYLOGON	  = ""
                  QUERY			  ="PNResponse"
                  HOSTADDRESS     = "#hostingurl#"
                  HOSTPORT        = "443"
                  TIMEOUT         = "30"
                  TRXTYPE         = "R"
                  TENDER          = "C"
                  ACTION		  = "A"
                  START			  = "#startDate#"
                  PROFILENAME	  = "#variables.profileName#"
                  PARTNER         = "#variables.VSPartner#"
                  TERM			  = "0"
                  PAYPERIOD		  = "#PAYPERIOD#"
                  VENDOR		  = "#variables.VSUserName#"
                  USER            = "#variables.VSUserName#"
                  PWD             = "#variables.VSPassword#"
                  ACCT            = "#arguments.acct#"
                  EXPDATE         = "#arguments.EXPDATE#"
                  AMT             = "#totalAmount#"
                  OPTIONALTRX     = "#dingType#"
                  OPTIONALTRXAMT  = "#dingAmount#"
                  COMMENT1        = "#arguments.intresid#"
                  CVV2			  = "#arguments.CVV2#"
                  firstname		  = "#arguments.firstname#"
                  Lastname		  = "#arguments.Lastname#"
                  email		 	  = "#arguments.email#"
                  PHONENUM	 	  = "#arguments.phone#"
                  Street		  = "#arguments.address1# #arguments.address2#"
                  City			  = "#arguments.city#"
                  State			  = "#arguments.state#"
                  ZIP			  = "#arguments.zip#"
                  Country		  = "#arguments.country#"
                  IP			  = "#arguments.ipaddress#"
                  COMPANYNAME	  = "#arguments.CUSTREF#"
                  TaxExempt		  = "#TaxExempt#"
                  TaxAmt		  = "#TaxAmt#"
                  CUSTREF		  = "#arguments.CUSTREF#"/>
            </cflock>

   			<cfcatch type="any">
				<cfscript>
                PNResponse = querynew("PNResponse,RC,RESULT,RESPMSG");
                void = QueryAddRow (PNResponse,1);
                void = QuerySetCell(PNResponse,"PNResponse","CFERROR");
                void = QuerySetCell(PNResponse,"RC",-1);
                void = QuerySetCell(PNResponse,"RESULT",-1);
                void = QuerySetCell(PNResponse,"RESPMSG","Test w/o locking! ");
                </cfscript>
		      	<!--- End Error --->
    		</cfcatch>
  		</cftry>
  		<cfreturn PNResponse>
	</cffunction>

	<!--- Get Information On Premium Profile --->

	<cffunction name="getPremiumStatus" access="public" returntype="query" hint="Returns Response Query Based on Recurring Billing for New Customers Only">
  		<cfargument name="profileid" type="string" required="yes" hint="Premium ID"  />
  		<cfargument name="billingHistory" type="string" required="no" default="N" hint="Display Salary History or not (E.G. Y/N)"  />
		<cfset var PNResponse="" />
		<cfset var hostingurl = getPayFlowURL() />
		
        <cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
            <CFX_PAYFLOWPRO
            URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
            PROXYADDRESS	= ""
            PROXYPASSWORD	= ""
            PROXYPORT		= ""
            PROXYLOGON		= ""
            QUERY			="PNResponse"
            HOSTADDRESS     = "#hostingurl#"
            HOSTPORT        = "443"
            TIMEOUT         = "30"
            TRXTYPE         = "R"
            TENDER          = "C"
            PARTNER         = "#variables.VSPartner#"
            VENDOR		  	= "#variables.VSUserName#"
            USER            = "#variables.VSUserName#"
            PWD             = "#variables.VSPassword#"
            ACTION		  	=  "I"
            ORIGPROFILEID	= "#arguments.profileid#"
            PAYMENTHISTORY  = "#arguments.billingHistory#" />
        </cflock>

    	<cftry>
   			<cfcatch type="any">
				<cfscript>
                PNResponse = querynew("PNResponse,RC,RESULT,RESPMSG");
                void = QueryAddRow (PNResponse,1);
                void = QuerySetCell(PNResponse,"PNResponse","CFERROR");
                void = QuerySetCell(PNResponse,"RC",-1);
                void = QuerySetCell(PNResponse,"RESULT",-1);
                void = QuerySetCell(PNResponse,"RESPMSG","Test w/o locking! ");
                </cfscript>
				<!--- End Error --->
    		</cfcatch>
  		</cftry>
  		<cfreturn PNResponse>
	</cffunction>

    <cffunction name="setPremiumOff" access="public" returntype="query" hint="Returns Response Query Based on Recurring Billing for New Customers Only">
        <cfargument name="profileid" type="string" required="yes" hint="Premium ID"  />
		<cfset var PNResponse="" />
        <cfset var hostingurl = getPayFlowURL() />
        <cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
            <CFX_PAYFLOWPRO
            URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
            PROXYADDRESS	= ""
            PROXYPASSWORD	= ""
            PROXYPORT		= ""
            PROXYLOGON		= ""
            QUERY			="PNResponse"
            HOSTADDRESS     = "#hostingurl#"
            HOSTPORT        = "443"
            TIMEOUT         = "30"
            TRXTYPE         = "R"
            TENDER          = "C"
            PARTNER         = "#variables.VSPartner#"
            VENDOR		  	= "#variables.VSUserName#"
            USER            = "#variables.VSUserName#"
            PWD             = "#variables.VSPassword#"
            ACTION		  	=  "C"
            ORIGPROFILEID	= "#arguments.profileid#" />
        </cflock>

    	<cftry>
            <cfcatch type="any">
				<cfscript>
	                PNResponse = querynew("PNResponse,RC,RESULT,RESPMSG");
	                void = QueryAddRow (PNResponse,1);
	                void = QuerySetCell(PNResponse,"PNResponse","CFERROR");
	                void = QuerySetCell(PNResponse,"RC",-1);
	                void = QuerySetCell(PNResponse,"RESULT",-1);
	                void = QuerySetCell(PNResponse,"RESPMSG","Test w/o locking! ");
                </cfscript>
                <!--- End Error --->
            </cfcatch>
  		</cftry>
  		<cfreturn PNResponse>
	</cffunction>

    <cffunction name="setUpdatedBillingCC" access="public" returntype="query" hint="Update the Credit Card on File With Verisign">
        <cfargument type="numeric" name="intresid" default="0" required="yes"  hint="Resume ID ##" />
        <cfargument type="numeric" name="intEmployerid" default="0" required="yes"  hint="Employer ID ##" />
        <cfargument name="acct" type="string" required="yes" hint="Credit Card Number (Decrypted)" />
        <cfargument name="expdate" type="string" required="yes" hint="Expiration Date (Decrypted)" />
		<cfset var PNResponse="" />
		<cfset var profileid = "" />

		<cfscript>
        if(arguments.intresid neq 0){
    	    qProfile = variables.resume.getResumeDetail(arguments.intresid);
        	profileid = qProfile.profileid;
        } else if (arguments.intEmployerid neq 0){

		}

        //Expiration Date
        if (len(arguments.EXPDATE) gte 4 ){
        	arguments.EXPDATE = left(arguments.EXPDATE,2) & right(arguments.EXPDATE,2);
        }
        </cfscript>

		<cfif len(profileid)>
    		<!--- Start Versign Code --->
		    <cfset hostingurl = getPayFlowURL() />
		    <cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
				<CFX_PAYFLOWPRO
                    URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
                    PROXYADDRESS	= ""
                    PROXYPASSWORD	= ""
                    PROXYPORT		= ""
                    PROXYLOGON		= ""
                    QUERY			="PNResponse"
                    HOSTADDRESS     = "#hostingurl#"
                    HOSTPORT        = "443"
                    TIMEOUT         = "30"
                    TRXTYPE         = "R"
                    PARTNER         = "#variables.VSPartner#"
                    VENDOR		  	= "#variables.VSUserName#"
                    USER            = "#variables.VSUserName#"
                    PWD             = "#variables.VSPassword#"
                    ACTION		  	=  "M"
                    ACCT            = "#arguments.acct#"
					OPTIONALTRX		= "A"
                    EXPDATE         = "#arguments.EXPDATE#"
                    ORIGPROFILEID	= "#profileid#"
               	/>
    		</cflock>
			<cftry>
				<cfcatch type="any">
					<cfscript>
						PNResponse = querynew("PNResponse,RC,RESULT,RESPMSG");
						void = QueryAddRow (PNResponse,1);
						void = QuerySetCell(PNResponse,"PNResponse","CFERROR");
						void = QuerySetCell(PNResponse,"RC",-1);
						void = QuerySetCell(PNResponse,"RESULT",-1);
						void = QuerySetCell(PNResponse,"RESPMSG","Test w/o locking! ");
					</cfscript>
					<!--- End Error --->
				</cfcatch>
			</cftry><!---  --->
    		<cfreturn PNResponse>
		</cfif>
	</cffunction>
	
	
	<cffunction name="setUpdatedBillingDetails" access="public" returntype="query" hint="Update the Credit Card on File With Verisign">
        <cfargument type="numeric" name="intresid" default="0" required="yes"  hint="Resume ID ##" />
		<cfargument type="string" name="street" default="" required="yes"  hint="street address" />
		<cfargument type="string" name="zip" default="" required="yes"  hint="address zipcode" />
		
		<cfset var PNResponse="" />
		<cfset var profileid = "" />

		<cfscript>
        if(arguments.intresid neq 0){
    	    qProfile = variables.resume.getResumeDetail(arguments.intresid);
        	profileid = qProfile.profileid;
        } 
        
        </cfscript>

		<cfif len(profileid)>
    		<!--- Start Versign Code --->
		    <cfset hostingurl = getPayFlowURL() />
		    <cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
				<CFX_PAYFLOWPRO
                    URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
                    PROXYADDRESS	= ""
                    PROXYPASSWORD	= ""
                    PROXYPORT		= ""
                    PROXYLOGON		= ""
                    QUERY			="PNResponse"
                    HOSTADDRESS     = "#hostingurl#"
                    HOSTPORT        = "443"
                    TIMEOUT         = "30"
                    TRXTYPE         = "R"
                    PARTNER         = "#variables.VSPartner#"
                    VENDOR		  	= "#variables.VSUserName#"
                    USER            = "#variables.VSUserName#"
                    PWD             = "#variables.VSPassword#"
                    ACTION		  	=  "M"
					STREET			= "#arguments.street#"
					ZIP				= "#arguments.ZIP#"
                    ORIGPROFILEID	= "#profileid#"
               	/>
    		</cflock>
			<cftry>
				<cfcatch type="any">
					<cfscript>
						PNResponse = querynew("PNResponse,RC,RESULT,RESPMSG");
						void = QueryAddRow (PNResponse,1);
						void = QuerySetCell(PNResponse,"PNResponse","CFERROR");
						void = QuerySetCell(PNResponse,"RC",-1);
						void = QuerySetCell(PNResponse,"RESULT",-1);
						void = QuerySetCell(PNResponse,"RESPMSG","Test w/o locking! ");
					</cfscript>
					<!--- End Error --->
				</cfcatch>
			</cftry><!---  --->
    		<cfreturn PNResponse>
		</cfif>
	</cffunction>
	
	

	<cffunction name="setUpdatedRecurringAmt" access="public" returntype="any" hint="Update the Credit Card on File With Verisign">
 		<cfargument type="numeric" name="intresid" default="0" required="yes"  hint="Resume ID ##" />
        <cfargument type="numeric" name="intEmployerid" default="0" required="yes"  hint="Employer ID ##" />
        <cfargument type="numeric" name="amt" default="" required="yes"  hint="Recurring Billing Amount" />

		<cfset var profileid = "" />
		<cfscript>
		if(arguments.intresid neq 0){
			qProfile = variables.resume.getResumeDetail(arguments.intresid);
			profileid = qProfile.profileid;
		}else if (arguments.intEmployerid neq 0){

		}

		arguments.AMT=reReplace(arguments.AMT, "[,$]", "", "ALL");

		//Format Accordingly
		arguments.AMT = numberformat(arguments.AMT, "______.__");
		</cfscript>

		<cfif len(profileid)>
			<!--- Start Versign Code --->
            <cfset hostingurl = getPayFlowURL() />
            <cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
            <CFX_PAYFLOWPRO
            URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
            PROXYADDRESS	= ""
            PROXYPASSWORD	= ""
            PROXYPORT		= ""
            PROXYLOGON		= ""
            QUERY			="PNResponse"
            HOSTADDRESS     = "#hostingurl#"
            HOSTPORT        = "443"
            TIMEOUT         = "30"
            TRXTYPE         = "R"
            PARTNER         = "#variables.VSPartner#"
            VENDOR		  	= "#variables.VSUserName#"
            USER            = "#variables.VSUserName#"
            PWD             = "#variables.VSPassword#"
            ACTION		 	=  "M"
            AMT			 	=  "#arguments.amt#"
            ORIGPROFILEID	= "#profileid#" />
            </cflock>

    		<cfreturn PNResponse>

			<!--- End Verisign Code --->
		</cfif>
	</cffunction>


    <cffunction name="setUpdatedRecurringStartDate" access="public" returntype="any" hint="Update the Credit Card on File With Verisign">
        <cfargument type="numeric" name="intresid" default="0" required="yes"  hint="Resume ID ##" />
        <cfargument type="numeric" name="intEmployerid" default="0" required="yes"  hint="Employer ID ##" />
        <cfargument type="date"   name="startdate" default="" required="yes"  hint="Recurring Starting Date" />

        <cfset var profileid = "" />

		<cfscript>
		if(arguments.intresid neq 0){
			qProfile = variables.resume.getResumeDetail(arguments.intresid);
			profileid = qProfile.profileid;
		}else if (arguments.intEmployerid neq 0){
		}

		arguments.startdate=reReplace(arguments.startdate, "/", "", "ALL");
		arguments.startdate=reReplace(arguments.startdate, "-", "", "ALL");
		</cfscript>

		<cfif len(profileid)>
			<!--- Start Versign Code --->
            <cfset hostingurl = getPayFlowURL() />
            <cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
                <CFX_PAYFLOWPRO
                URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
                PROXYADDRESS	= ""
                PROXYPASSWORD	= ""
                PROXYPORT		= ""
                PROXYLOGON		= ""
                QUERY			="PNResponse"
                HOSTADDRESS     = "#hostingurl#"
                HOSTPORT        = "443"
                TIMEOUT         = "30"
                TRXTYPE         = "R"
                PARTNER         = "#variables.VSPartner#"
                VENDOR		  	= "#variables.VSUserName#"
                USER            = "#variables.VSUserName#"
                PWD             = "#variables.VSPassword#"
                ACTION		  	=  "M"
                START			=  "#arguments.startdate#"
                ORIGPROFILEID	= "#profileid#" />
            </cflock>
		    <cfreturn PNResponse>
			<!--- End Verisign Code --->
		</cfif>
	</cffunction>

    <cffunction name="setRecurringMaxPayments" access="public" returntype="any" hint="Updates total Number of Failed Payments">
	    <cfargument type="numeric" name="intresid" default="0" required="yes"  hint="Resume ID ##" />
    	<cfargument type="numeric" name="intEmployerid" default="0" required="yes"  hint="Employer ID ##" />
	    <cfargument type="numeric" name="MaxPayments" default="6" required="yes"  hint="Max Payments Until Account Deactivated" />

    	<cfset var profileid = "" />

	    <cfscript>
	    if(arguments.intresid neq 0){
		    qProfile = variables.resume.getResumeDetail(arguments.intresid);
		    profileid = qProfile.profileid;
	    }else if (arguments.intEmployerid neq 0){

   		}
    	</cfscript>

		<cfif len(profileid)>
			<!--- Start Versign Code --->
            <cfset hostingurl = getPayFlowURL() />
            <cflock name="PayFlow" timeout="10" throwontimeout="no" type="exclusive">
                <CFX_PAYFLOWPRO
                URLSTREAMHANDLER = "sun.net.www.protocol.https.Handler"
                PROXYADDRESS	= ""
                PROXYPASSWORD	= ""
                PROXYPORT		= ""
                PROXYLOGON		= ""
                QUERY			="PNResponse"
                HOSTADDRESS     = "#hostingurl#"
                HOSTPORT        = "443"
                TIMEOUT         = "30"
                TRXTYPE         = "R"
                PARTNER         = "#variables.VSPartner#"
                VENDOR		  	= "#variables.VSUserName#"
                USER            = "#variables.VSUserName#"
                PWD             = "#variables.VSPassword#"
                ACTION		  	=  "M"
                MAXFAILPAYMENTS =  "#arguments.MaxPayments#"
                ORIGPROFILEID	  = "#profileid#" />
            </cflock>
	    	<cfreturn PNResponse>
			<!--- End Verisign Code --->
		</cfif>
	</cffunction>

 	<!--- Added To Paypal CFC --->
	<cffunction name="QueryToStruct" access="public" returntype="any" output="false" hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">
		<!--- Define arguments. --->
		<cfargument name="Query" type="query" required="true" />
		<cfargument name="Row" type="numeric" required="false" default="0" />

		<cfscript>
		// Define the local scope.
		var LOCAL = StructNew();

		// Determine the indexes that we will need to loop over.
		// To do so, check to see if we are working with a given row,
		// or the whole record set.
		if (ARGUMENTS.Row){
			// We are only looping over one row.
			LOCAL.FromIndex = ARGUMENTS.Row;
			LOCAL.ToIndex = ARGUMENTS.Row;
		}else{
			// We are looping over the entire query.
			LOCAL.FromIndex = 1;
			LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;
		}

		// Get the list of columns as an array and the column count.
		LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
		LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );

		// Create an array to keep all the objects.
		LOCAL.DataArray = ArrayNew( 1 );

		// Loop over the rows to create a structure for each row.
		for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
			// Create a new structure for this row.
			ArrayAppend( LOCAL.DataArray, StructNew() );

			// Get the index of the current data array object.
			LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );

			// Loop over the columns to set the structure values.
			for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
				// Get the column value.
				LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

				// Set column value into the structure.
				LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

			}
		}

		// At this point, we have an array of structure objects that
		// represent the rows in the query over the indexes that we
		// wanted to convert. If we did not want to convert a specific
		// record, return the array. If we wanted to convert a single
		// row, then return the just that STRUCTURE, not the array.
		if (ARGUMENTS.Row){
			// Return the first array item.
			return( LOCAL.DataArray[ 1 ] );
		}else{
			// Return the entire array.
			return( LOCAL.DataArray );
		}
		</cfscript>
	</cffunction>
</cfcomponent>

<!---
S = Sale transaction
C = Credit
A = Authorization
D = Delayed Capture
V = Void
F = Voice Authorization
I = Inquiry
N = Duplicate transaction
--->
