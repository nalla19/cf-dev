<cfsetting showdebugoutput="no">
<cfparam name="url.intResID" default="0">
<cfparam name="url.step" default="0">
<cfparam name="url.dataField" default="0">
<cfparam name="url.regStepValue" default="0">

<!--- $.post("updateRegistrationSteps.cfm?intResID=" + resID + "&step=" + step + "&dataField=" + dataField); --->

<cfif url.step is 2>
	<cfswitch expression="#dataField#">

		<cfcase value="1">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2ZipCode = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="2">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2City = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		
		<cfcase value="3">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2Country = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>

		<cfcase value="4">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2PhoneNumber = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		
		<cfcase value="5">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2PrivacySetting = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="6">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2JobTitle1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		
		<cfcase value="7">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2JobCompany1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="8">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2JobTitle2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="9">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2JobCompany2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="10">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2HighestSalaryEarned = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
	
		<cfcase value="11">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2HighestSalaryEarnedOpt = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="12">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2DesiredJobTitle = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="13">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2YearsWorkExperience = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="14">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2IndustryExperience = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="15">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2FunctionExperience = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="16">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2Education = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="17">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2InHouseEmails = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
	
		<cfcase value="18">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2NewsLetter = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="19">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2JobAlertEmails = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
		<cfcase value="20">
			<cfquery name="cfqUpdateRegStep" datasource="#application.dsn#">
			update tblResRegStepsTracking 
			   set step2SpecialOffers = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.regStepValue#">
			 where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.intResID#">
			</cfquery>
		</cfcase>
		
	</cfswitch>	
</cfif>