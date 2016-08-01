<cfcomponent output="false">

	<cfparam name="variables.dsn" default="6figs">

	<cffunction name="init" access="public" output="false" returntype="premium">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="executive" required="true" />
		<cfargument name="payflowpro" required="true" />
		<cfargument name="resume" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			variables.executive = arguments.executive;
			variables.payflowpro = arguments.payflowpro;
			variables.resume = arguments.resume;

			return this;
		</cfscript>
	</cffunction>


    <cffunction name="setPremiumTransaction" access="public" returntype="any" hint="Inserts Transaction">
        <cfargument type="string" name="authCode" required="yes"  hint="Authorization Code From Versiign" />
        <cfargument type="numeric" name="intresid" required="yes"  hint="Resume ID ##" />
        <cfargument type="string" name="name" required="yes"  hint="Name " />
        <cfargument type="string" name="email" required="yes"  hint="Email" />
        <cfargument type="string" name="cardType" required="yes"  hint="Card Type? Visa, Mastercard, etc." />
        <cfargument type="string" name="cardnumber" required="yes"  hint="Card Number (Encrypted)" />
        <cfargument type="string" name="cscCode" required="yes"  hint="CSC Code (Encrypted)" />
        <cfargument type="string" name="expDate" required="yes"  hint="Expiration Date" />
        <cfargument type="string" name="responseCode" required="yes"  hint="Verisign Response Code" />
        <cfargument type="string" name="responseDesc" required="yes"  hint="Verisign Response Descr" />
        <cfargument type="string" name="transid" required="yes"  hint="Transaction ID" />
        <cfargument type="string" name="TransactionID" required="yes"  hint="Recurring TransactionID" />
        <cfargument type="string" name="TransactionMsg" required="yes"  hint="Recurring Transaction Message" />
        <cfargument type="string" name="cost" required="yes"  hint="Cost of Package" />
        <cfargument type="numeric" name="months" required="yes"  hint="Number of months signed up for" />
        <cfargument type="string" name="ipaddress" required="yes"  hint="IP Address of Client" />
        <cfargument type="string" name="avsAddrResp" required="yes"  hint="Security Address Response" />
        <cfargument type="string" name="AvsZipResp" required="yes"  hint="Security Zip Response" />
        <cfargument type="string" name="profileid" required="yes"  hint="Profile ID" />

  		<cfstoredproc procedure="spI_Learn365Transaction" datasource="#variables.dsn#" returncode="Yes">
            <cfprocparam type="IN" dbvarname="@authCode" value="#trim(arguments.authCode)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="cf_sql_integer" />
            <cfprocparam type="IN" dbvarname="@name" value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@email" value="#trim(arguments.email)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cardType" value="#trim(arguments.cardType)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cardnumber" value="#trim(arguments.cardnumber)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cscCode" value="#trim(arguments.cscCode)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@expDate" value="#trim(arguments.expDate)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@responseCode" value="#trim(arguments.responseCode)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@responseDesc" value="#trim(arguments.responseDesc)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@transid" value="#trim(arguments.transid)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@TransactionID" value="#trim(arguments.TransactionID)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@TransactionMsg" value="#trim(arguments.TransactionMsg)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cost" value="#trim(arguments.cost)#" cfsqltype="cf_sql_money" />
            <cfprocparam type="IN" dbvarname="@months" value="#trim(arguments.months)#" cfsqltype="cf_sql_tinyint" />
            <cfprocparam type="IN" dbvarname="@ipaddress" value="#arguments.ipaddress#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@avsAddrResp" value="#trim(arguments.avsAddrResp)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@AvsZipResp" value="#trim(arguments.AvsZipResp)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@profileid" value="#trim(arguments.profileid)#" cfsqltype="cf_sql_varchar" />
			<cfprocresult resultset="1" name="qtransaction">
	  	</cfstoredproc>
		<cfreturn qtransaction />
	</cffunction>

	<!---New Premium Memebership Registration for the execs coming to the site for the first time---->
    <cffunction name="newPremiumRegistration" access="public" returntype="query" hint="Record the CC Information for the New Premium Registration">
        <cfargument type="numeric" name="premiumid" required="yes"  hint="Premium ID ##" />
        <cfargument type="string" name="urlToken" required="yes"  hint="URL Token" />
        <cfargument type="numeric" name="intresid" default="0"  required="yes"  hint="Executive ID ##" />
        <cfargument type="string" name="transType" required="yes"  hint="Transaction Type of Premium Membership" />
        <cfargument type="string" name="name" required="yes"  hint="Name " />
        <cfargument type="string" name="cardType" required="yes"  hint="Card Type? Visa, Mastercard, etc." />
        <cfargument type="string" name="cardnumber" required="yes"  hint="Card Number (Encrypted)" />
        <cfargument type="string" name="expDate" required="yes"  hint="Expiration Date" />
        <cfargument type="string" name="cscCode" required="yes"  hint="CSC Security code (Encrypted)" />
        <cfargument type="numeric" name="months" required="yes"  hint="Number of months signed up for" />
        <cfargument type="string" name="cost" required="yes"  hint="Cost of Package" />
        <cfargument type="string" name="ipaddress" required="yes"  hint="IP Address of the Executive" />
        <cfargument type="string" name="premiumStatus" required="yes"  hint="Premium Status - Active, Inactive" />

        <cfstoredproc procedure="spI_ExecPremiumRegistration" datasource="#variables.dsn#" returncode="Yes">
            <cfprocparam type="IN" dbvarname="@premiumid" value="#trim(arguments.premiumid)#" cfsqltype="cf_sql_tinyint" />
            <cfprocparam type="IN" dbvarname="@urltoken" value="#trim(arguments.urlToken)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@intresid" value="#arguments.intresid#" cfsqltype="cf_sql_integer" />
            <cfprocparam type="IN" dbvarname="@transtype" value="#trim(arguments.transType)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@name" value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cardType" value="#trim(arguments.cardType)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cardnumber" value="#trim(arguments.cardnumber)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@expDate" value="#trim(arguments.expDate)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cscCode" value="#trim(arguments.cscCode)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cost" value="#trim(arguments.cost)#" cfsqltype="cf_sql_money" />
            <cfprocparam type="IN" dbvarname="@months" value="#trim(arguments.months)#" cfsqltype="cf_sql_tinyint" />
            <cfprocparam type="IN" dbvarname="@ipaddress" value="#trim(arguments.ipaddress)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@premiumStatus" value="#trim(arguments.premiumStatus)#" cfsqltype="cf_sql_varchar" />
            <cfprocresult resultset="1" name="qtransaction">
        </cfstoredproc>
	    <cfreturn qtransaction />
    </cffunction>

	<!---Update the credit card information for the execs who are premium members and execs wanting to become premium members---->
    <cffunction name="updateExecCreditCard" access="public" hint="Update Credit Card Information">
        <cfargument type="numeric" name="intresid" default="0"  required="yes"  hint="Executive ID ##" />
        <cfargument type="numeric" name="intEmployerid" default="0" required="yes"    hint="Employer ID ##" />
        <cfargument type="numeric" name="blnCCCharged" required="yes"  hint="If Credit Card already charged once" />
        <cfargument type="string" name="name" required="yes"  hint="Name " />
        <cfargument type="string" name="cardType" required="yes"  hint="Card Type? Visa, Mastercard, etc." />
        <cfargument type="string" name="cardnumber" required="yes"  hint="Card Number (Encrypted)" />
        <cfargument type="string" name="expDate" required="yes"  hint="Expiration Date" />
        <cfargument type="string" name="cscCode" required="yes"  hint="CSC Security code (Encrypted)" />
        <cfargument type="string" name="ipaddress" required="yes"  hint="IP Address of the Executive" />
		<cfset var profileid = "" />
		<cfset var qPayPal = "" />
		   
        <cfstoredproc procedure="spU_ExecUpdateCC" datasource="#variables.dsn#" returncode="no">
            <cfprocparam type="IN" dbvarname="@intresid" value="#arguments.intresid#" cfsqltype="cf_sql_integer" />
            <cfprocparam type="IN" dbvarname="@blnCCCharged" value="#val(arguments.blnCCCharged)#" cfsqltype="cf_sql_integer" />
            <cfprocparam type="IN" dbvarname="@name" value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cardType" value="#trim(arguments.cardType)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cardnumber" value="#right(arguments.cardnumber,4)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@expDate" value="#trim(arguments.expDate)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@cscCode" value="000" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@ipaddress" value="#trim(arguments.ipaddress)#" cfsqltype="cf_sql_varchar" />
        </cfstoredproc>

      <cfscript>
	        cardnumber  = variables.payflowpro.setDecryptedCC(trim(arguments.cardnumber));
	        expDate = trim(arguments.expDate);
	        profileid =  variables.executive.getProfileidByResumeid(arguments.intresid).profileid;
	        qPayPal = variables.payflowpro.Obj.getPremiumStatus(profileid);
	        //if (len(profileid) and qPayPal.status eq 'Active'){}
	        //Send Credit Card info to Versign
	        getResponse = variables.payflowpro.setUpdatedBillingCC(arguments.intresid,arguments.intEmployerid,cardnumber,expdate);
        </cfscript>
		
		<!---<cfreturn getResponse /> --->
    </cffunction>

	<!---Update the credit card information for the execs who are premium members and execs wanting to become premium members---->
    <cffunction name="getPremiumPackageDetails" access="public" returntype="query" hint="Update Credit Card Information">
	    <cfargument name="profileid" type="string" required="yes" hint="Premium ID"  />
		<cfset var q = "" />
		
    	<cfstoredproc procedure="spS_getPremiumPackage" datasource="#variables.dsn#" returncode="no">
    		<cfprocparam type="IN" dbvarname="@profileid" value="#trim(arguments.profileid)#" cfsqltype="cf_sql_varchar" />
    		<cfprocresult resultset="1" name="q">
    	</cfstoredproc>
	
    	<cfreturn q />
    </cffunction>

	<!--- Set Premium Account --->
    <cffunction name="setPremiumAccount" access="public" returntype="void" hint="Update Account to Premium Status">
        <cfargument type="string" name="intresid" required="yes"  hint="Resume ID" />
        <cfargument type="string" name="profileid" required="yes"  hint="Profile ID" />

        <cfstoredproc procedure="spU_ExecPremiumUpgrade" datasource="#variables.dsn#" returncode="Yes">
            <cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="cf_sql_integer" />
            <cfprocparam type="IN" dbvarname="@profileid" value="#trim(arguments.profileid)#" cfsqltype="cf_sql_varchar" />
        </cfstoredproc>
    </cffunction>

    <cffunction name="setPremiumCancel" access="public" returntype="void" hint="Cancel Premium Membership">
        <cfargument type="string" name="intresid" required="yes"  hint="Resume ID" />
        <cfargument type="string" name="profileid" required="yes"  hint="Profile ID" />

        <cfstoredproc procedure="spU_ExecPremiumCancel" datasource="#variables.dsn#" returncode="Yes">
	        <cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="cf_sql_integer" />
    	    <cfprocparam type="IN" dbvarname="@profileid" value="#trim(arguments.profileid)#" cfsqltype="cf_sql_varchar" />
        </cfstoredproc>
    </cffunction>

    <cffunction name="getCCDetail" access="public" returntype="query" hint="Get Credit Card Info">
	    <cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />
		<cfset var q = "" />
		
        <cfstoredproc procedure="sp_readResume" datasource="#variables.dsn#" returncode="Yes">
    		<cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="CF_SQL_INTEGER">
    		<cfprocresult resultset="3" name="q">
    	</cfstoredproc>
	
    	<cfreturn q />
    </cffunction>

    <cffunction name="getPendingCCDetail" access="public" returntype="query" hint="Get Pending Credit Card Information">
	    <cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />
		<cfset var q = "" />
		
        <cfstoredproc procedure="spS_ExecPendingCC" datasource="#variables.dsn#" returncode="Yes">
    		<cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="CF_SQL_INTEGER">
    		<cfprocresult resultset="1" name="q">
    	</cfstoredproc>
	
    	<cfreturn q />
    </cffunction>

    <cffunction name="isExecRenewable" access="public" returntype="boolean" hint="Cancel Premium Membership">
	    <cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />
		<cfset var q = "" />
		
    	<cfstoredproc procedure="spS_ExecPremiumRenewable" datasource="#variables.dsn#" returncode="Yes">
    		<cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="cf_sql_varchar" />
    		<cfprocresult resultset="1" name="q">
    	</cfstoredproc>

    	<cfscript>
    		return iif(q.numOfCancels gt 0, false, true);
    	</cfscript>
    </cffunction>

    <cffunction name="getPremiumStruct" access="public" returntype="struct" hint="Returns True or False Based on Profile ID">
    	<cfargument type="string" name="profileid" required="yes"  hint="Profile ID" />
    	<cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />

		<cfscript>
        var myStruct = structnew();
	        //Set Defaults to False
	        var premiumExists = false;
	        var premiumActive = false;
	        var isRenewable = true;
	        var qStatus = "";
	
	        if (len(arguments.profileid) gt 10){
	    	    isRenewable = isExecRenewable(arguments.intresid);
	        	qStatus = variables.payflowpro.getPremiumStatus(arguments.profileid);
	
				if (isdefined("qStatus") and qstatus.result eq 0){
	            	premiumExists = true;
	            	//Active
	            	if (qStatus.STATUS eq "ACTIVE"){
	                	premiumActive = true;
	            	}
	        	}
	        }
	
			myStruct.isRenewable = isRenewable;
	        myStruct.premiumExists = premiumExists;
	        myStruct.premiumActive = premiumActive;
	        return myStruct;
        </cfscript>
    </cffunction>


	<!--- 6FJ Admin Changes --->
	<cffunction name="getPendingBOAInfo" access="public" returntype="query" hint="Get Pending Transactions from Database">
  		<cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />
		<cfset var q = "" />
		
        <cfstoredproc procedure="spS_ExecPendingBoaByResid" datasource="#variables.dsn#" returncode="Yes">
    	    <cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="cf_sql_varchar" />
	        <cfprocresult resultset="1" name="q">
        </cfstoredproc>
		
        <cfreturn q />
   	</cffunction>

    <cffunction name="setPendingComplete" access="public" returntype="void" hint="Get Pending Transactions from Database">
	    <cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />

        <cfstoredproc procedure="spU_ExecPendingComplete" datasource="#variables.dsn#" returncode="Yes">
    		<cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="cf_sql_varchar" />
    	</cfstoredproc>
    </cffunction>

    <cffunction name="setPendingBatch" access="public" returntype="void" hint="Get Pending Transactions from Database">
        <cfargument type="numeric" name="paymentnum" required="yes" default="" hint="Payment Number" />
        <cfargument type="string" name="profileid" required="yes" default="" hint="Profile ID" />
        <cfargument type="string" name="transactionid" required="yes" default="" hint="Transaction ID" />
        <cfargument type="date"  name="transactionDate" required="yes" default="" hint="Transaction Date" />
        <cfargument type="date" name="dteExpires" required="yes" default="" hint="Date Account Expires" />

        <cfstoredproc procedure="spU_ExecPremiumBatch" datasource="#variables.dsn#" returncode="Yes">
            <cfprocparam type="IN" dbvarname="@paymentnum" value="#val(arguments.paymentnum)#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@profileid" value="#arguments.profileid#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@transactionid" value="#arguments.transactionid#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@transactionDate" value="#arguments.transactionDate#" cfsqltype="cf_sql_varchar" />
            <cfprocparam type="IN" dbvarname="@dteExpires" value="#arguments.dteExpires#" cfsqltype="cf_sql_varchar" />
        </cfstoredproc>
	</cffunction>

	<cffunction name="setPremium6FJAdminTransaction" access="public" returntype="void" hint="Inserts Transaction from 6FJ Backend">
  		<cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />

  		<cftry>
			<cfset qBoa = getPendingBOAInfo(arguments.intresid) />

		    <cfif qboa.recordcount>
				<cfscript>
					qProfile 	= variables.resume.getResumeDetail(intresid);
					unEncryptedCC  = variables.payflowpro.setDecryptedCC(qBoa.CARDNUMBER);
					unEncryptedCSC = variables.payflowpro.setDecryptedCC(qBoa.CSCCODE);
	
					qTransaction = variables.payflowpro.setPremiumSubscription(
															intresid=arguments.intresid,
															premiumid=qBoa.premiumid,
															isRenewable=true,
															acct=unEncryptedCC,
															expdate=qboa.dteExp,
															cvv2=unEncryptedCSC,
															firstname=qprofile.fname,
															lastname=qprofile.lname,
															email=qprofile.email,
															address1=qprofile.address,
															phone=iif(len(qprofile.home_phone),de(qprofile.home_phone),de(qprofile.mobile_phone)),
															city=qprofile.city,
															state=qprofile.state,
															zip=qprofile.zip,
															country=qprofile.countryCode,
															ipaddress=qBoa.ipaddress);
				</cfscript>

				<cfscript>
	                if (isdefined("qTransaction.authcode")){  authcode = qTransaction.authcode; } else{ authcode = ""; }
	                if (isdefined("qTransaction.profileid")){ profileid = qTransaction.profileid; } else{ profileid = ""; }
	                if (isdefined("qTransaction.RPREF")){ RPREF = qTransaction.RPREF; }else{ RPREF = "";}
	                //Address
	                if (isdefined("qTransaction.AVSADDR")){ avsAddr = qTransaction.AVSADDR; } else{ avsAddr =  "";}
	                if (isdefined("qTransaction.AVSZIP")){ avsZip = qTransaction.AVSZIP; } else{ AVSZIP = "";	 }
	                //Recurring Model
	                if (isdefined("qTransaction.TRXPNREF")){ TRXPNREF = qTransaction.TRXPNREF; } else{ TRXPNREF = "";	 }
	                if (isdefined("qTransaction.TRXRESPMSG")){ TRXRESPMSG = qTransaction.TRXRESPMSG; } else{ TRXRESPMSG = "";	 }
                </cfscript>

  				<!--- Log Transaction --->
  				<cfinvoke method="setPremiumTransaction">
                    <cfinvokeargument name="authCode" value="#authcode#"/>
                    <cfinvokeargument name="intresid" value="#arguments.intresid#"/>
                    <cfinvokeargument name="name" value="#qprofile.fname# #qprofile.lname#"/>
                    <cfinvokeargument name="email" value="#qprofile.email#"/>
                    <cfinvokeargument name="cardtype" value="#qboa.cardType#"/>
                    <cfinvokeargument name="cardnumber" value="#variables.payflowpro.setEncryptedCC(unEncryptedCC)#"/>
                    <cfinvokeargument name="cscCode" value="#variables.payflowpro.setEncryptedCC(unEncryptedCSC)#"/>
                    <cfinvokeargument name="expDate" value="#qboa.dteExp#"/>
                    <cfinvokeargument name="responseCode" value="#ucase(qTransaction.result)#"/>
                    <cfinvokeargument name="responseDesc" value="#qTransaction.RESPMSG#"/>
                    <cfinvokeargument name="transid" value="#qTransaction.RPREF#"/>
                    <cfinvokeargument name="TransactionID" value="#TRXPNREF#"/>
                    <cfinvokeargument name="TransactionMsg" value="#iif(TRXRESPMSG eq 'Approved',de('Active'),de(TRXRESPMSG))#"/>
                    <cfinvokeargument name="cost" value="#qBoa.cost#"/>
                    <cfinvokeargument name="months" value="#qBoa.months#"/>
                    <cfinvokeargument name="ipaddress" value="#qBoa.ipaddress#"/>
                    <cfinvokeargument name="avsAddrResp" value="#AVSADDR#"/>
                    <cfinvokeargument name="AvsZipResp" value="#AVSZIP#"/>
                    <cfinvokeargument name="profileid" value="#profileid#"/>
  				</cfinvoke>

				<cfscript>
	                //Update Account
	                if (qTransaction.RESULT eq 0 and qTransaction.RESPMSG eq "Approved"){
		                setPremiumAccount(arguments.intresid,qTransaction.profileid);
	    	            setPendingComplete(arguments.intresid);
	        	        setPremiumCPLOff(arguments.intresid);
	                }
                </cfscript>

                <!--- Update Transactions from Unprocessed to processed --->
    			<cfif (qTransaction.RESULT eq 0 and qTransaction.RESPMSG eq "Approved")>
					<cfset intresid = arguments.intresid />
                    <cfset email = qprofile.email />
                    <cfset RPREF =  qTransaction.RPREF />
                    <!--- Include Email Page --->
                    <cfinclude template="/6fj/execs/premium/_includes/emailconfirmation.cfm" />
    				<!--- Trigger CPL's Here --->
  				</cfif>
   			</cfif>

			<cfcatch type="Any">
				<cfmail to="webmaster@6figurejobs.com" from="noreply@6figurejobs.com" subject="Credit Card Processing Error on Premium.cfc (#intresid#)" type="html">
					<cfdump var="#cfcatch#" />
				</cfmail>
			</cfcatch>
      	</cftry>
	</cffunction>

	<cffunction name="setPremiumCPLOff" access="private" returntype="void" hint="Sets Premium Members CPL Info To 0">
  		<cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />

  		<cftry>
			<cfscript>
	            session.exec.intresid = arguments.intresid ;
	            STRSIXFIGDATA = variables.dsn ;
	            STRLOCKTIMEOUT = 10;
            </cfscript>

			<cfinclude template="/6fj/execs/resbuilder/_includes/defineRegVariables.cfm" />

			<cfif cplInfo.recordcount>
				<cfscript>
                cplDeleteList = 12;	//Auto Deletion List
                new_resID=arguments.intresid;
                cplDeleteList = valuelist(cplInfo.intMemberid);
                CPLMemberIDList = cplDeleteList;
                </cfscript>
  				<cfinclude template="/6fj/t_CPartnerConfirmWrapper.cfm">
			</cfif>

			<cfcatch type="Any">
				<cfmail to="webmaster@6figurejobs.com" from="noreply@6figurejobs.com" subject="CPL Error on Premium.cfc (#intresid#)" type="html">
					<cfdump var="#cfcatch#" />
				</cfmail>
			</cfcatch>
       	</cftry>
	</cffunction>

</cfcomponent>