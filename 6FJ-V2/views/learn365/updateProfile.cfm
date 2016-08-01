<cfsilent><!--- <cfsetting showdebugoutput="no">
We saved the world!

<cfoutput>
#url.type#
</cfoutput> --->
 <cfsetting showdebugoutput="yes">
<cfparam name="intResID" default="">
<cfparam name="form.bln6FJAccount" default="0">

<cfset intResID = session.exec.intResID>

<cfswitch expression="#form.type#">
	<cfcase value="account">
		<cfset firstName=form.firstName>
		<cfset lastName=form.lastName>
		<cfset email=form.stremail>
		<cfset password=form.strPasswd>
		<cfset bln6FJAccount=form.bln6FJAccount>
		
		<cfif bln6FJAccount>
			<cfset blnHide6FJ = 0>
		<cfelse>
			<cfset blnHide6FJ = 1>
		</cfif>
		
		<cfset session.EXEC.hide6FJBtn = blnHide6FJ>
		
		<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
			update tblResumes  set
				dteEdited= getdate(),
				fname=<cfqueryparam value="#firstName#" cfsqltype="cf_sql_varchar" />,
				lname=<cfqueryparam value="#lastName#" cfsqltype="cf_sql_varchar" />,
				email= <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar" />,
				password= <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar" />,
				blnHide6FJBtn  = #blnHide6FJ#
				where intResid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfset getResponse.RESULT = 0>
		<cfset getResponse.RESPMSG = "Approved">
		<cfset RESPTYPEMSG = "account">
		
		
		<!--- update Litmos if userid is available & they are an active litmos user --->
		<cfif isDefined("session.EXEC.isLearn365Active") and session.EXEC.isLearn365Active>
			<cfset learn365Username = email>
			<cfset learn365FirstName = firstName>
			<cfset learn365LastName = lastName>
			<cfset learn365UserId = session.EXEC.learn365UserID>
			<cfset learn365Active = session.EXEC.isLearn365Active>
			
			<cfinclude template="api/updateUser.cfm">
		</cfif>
	</cfcase>
	
	<cfcase value="billing">
		<cfset phonenumber = form.phonenumber>
		<cfset strAddress1=form.strAddress1>
		<cfset strAddress2=form.strAddress2>
		<cfset strCity=form.strCity>
		<cfset strState=form.strState>
		<cfset strZipCode=form.strZipCode>
		<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
			update tblResumes  set
				dteEdited= getdate(),
				address = '#strAddress1# #strAddress2#',
				city=<cfqueryparam value="#strCity#" cfsqltype="cf_sql_varchar" />,
				state=<cfqueryparam value="#strState#" cfsqltype="cf_sql_varchar" />,
				zip=<cfqueryparam value="#strZipCode#" cfsqltype="cf_sql_varchar" />,
				home_phone= <cfqueryparam value="#phonenumber#" cfsqltype="cf_sql_varchar" />
				where intResid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfscript>
			payPalObj 	= application.payflowpro;
			getResponse = payPalObj.setUpdatedBillingDetails(intresid,strAddress1,strZipCode);
		</cfscript>
		<cfset RESPTYPEMSG = "billing">
	</cfcase>
	
	<cfcase value="creditcard">
		<!--- get components ready --->
			<cfscript>
			payPalObj 	= application.payflowpro;
			resObj 		= application.resume;
			qProfile 	= resObj.getResumeDetail(intResID); 
			premiumObj 	= application.premium;
			
			</cfscript>
				
			 <cfset expDate = "#form.cardmonth##form.cardyear#">
			
			 <cfstoredproc procedure="spU_ExecUpdateCC" datasource="#application.dsn#" returncode="no">
				<cfprocparam type="IN" dbvarname="@intresid" value="#intresid#" cfsqltype="cf_sql_integer" />
				<cfprocparam type="IN" dbvarname="@blnCCCharged" value="1" cfsqltype="cf_sql_integer" />
				<cfprocparam type="IN" dbvarname="@name" value="#form.cardname#" cfsqltype="cf_sql_varchar" />
				<cfprocparam type="IN" dbvarname="@cardType" value="#form.strcardType#" cfsqltype="cf_sql_varchar" />
				<cfprocparam type="IN" dbvarname="@cardnumber" value="#form.cardnumber#" cfsqltype="cf_sql_varchar" />
				<cfprocparam type="IN" dbvarname="@expDate" value="#expDate#" cfsqltype="cf_sql_varchar" />
				<cfprocparam type="IN" dbvarname="@cscCode" value="#form.securityCode#" cfsqltype="cf_sql_varchar" />
				<cfprocparam type="IN" dbvarname="@ipaddress" value="#cgi.REMOTE_ADDR#" cfsqltype="cf_sql_varchar" />
			</cfstoredproc>
			 <cfscript>
	        cardnumber  = form.cardnumber;
	        expDate = trim(expDate);
	        profileid =  application.executive.getProfileidByResumeid(intresid).profileid;
	      getResponse = payPalObj.setUpdatedBillingCC(intresid,0,cardnumber,expdate);
        </cfscript>
		<cfset RESPTYPEMSG = "credit card">
	</cfcase>
	
	<cfdefaultcase>
			
	</cfdefaultcase>
</cfswitch>
</cfsilent>
