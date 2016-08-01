<cfcomponent output="false" accessors="true">

	<cfproperty name="intJobId" type="numeric" getter="true" setter="true">
	
	<cfproperty name="jpname" type="string" getter="true" setter="true">
	<cfproperty name="title" type="string" getter="true" setter="true">
	<cfproperty name="location" type="string" getter="true" setter="false">
	<cfproperty name="description" type="string" getter="true" setter="true">
	
	<cfproperty name="intEmployerId" type="numeric" getter="true" setter="true">
	
	<cfproperty name="state" type="string" getter="true" setter="true">
	
	<cfproperty name="strOpportunity" type="string" getter="true" setter="true">
	<cfproperty name="date_submitted" type="date" getter="true" setter="true">
	<cfproperty name="seoJobURL" type="string" getter="true" setter="true">
	
	<cfproperty name="fltSalary_desiredlow" type="numeric" getter="true" setter="true">
	
	<cfproperty name="jobIndustries" type="query" getter="true" setter="true">
	<cfproperty name="jobFunctions" type="query" getter="true" setter="true">
	
	<cfproperty name="strAboutCompany" type="string" getter="true" setter="true">
	<cfproperty name="strCompanyPerks" type="string" getter="true" setter="true">
	<cfproperty name="strMasterLogo" type="string" getter="true" setter="true">
	<cfproperty name="strMasterLogoAltTag" type="string" getter="true" setter="true">
	
	<cfscript>
		this.setIntJobId(0);
		
		this.setJpname("");
		this.setTitle("");
		this.setLocation("");
		this.setDescription("");
		
		this.setintEmployerId(0);
		
		this.setState("");
		
		this.setStrOpportunity("");
		this.setDate_Submitted("1/1/1900");
		this.setSeoJobURL("");
		
		this.setFltSalary_desiredlow("100");
		
		this.setStrAboutCompany("");
		this.setStrCompanyPerks("");
		this.setStrMasterLogo("");
		this.setStrMasterLogoAltTag("");
	</cfscript>
	
    <cffunction name="setLocation" access="public" output="false" returntype="void">
		<cfargument name="location" type="string" required="true" />
		<cfset variables.location = REReplace(arguments.location, "\b(\S)(\S*)\b" , "\u\1\L\2", 'all') />
	</cffunction>
        
</cfcomponent>