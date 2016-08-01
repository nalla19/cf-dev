<cfcomponent output="false" accessors="true">

	<cfproperty name="intCorpID" type="numeric" getter="true" setter="true">
	
	<cfproperty name="imgLogo" type="string" getter="true" setter="true">
	<cfproperty name="strCoName" type="string" getter="true" setter="true">
	<cfproperty name="strDescription" type="string" getter="true" setter="false">
	<cfproperty name="strFeaturedURL" type="string" getter="true" setter="true">
	
	<cfproperty name="seoStrCompany" type="string" getter="true" setter="true">
	<cfproperty name="strCity" type="string" getter="true" setter="true">
	<cfproperty name="strState" type="string" getter="true" setter="true">
	
	<cfproperty name="employerIds" type="string" getter="true" setter="true">
	
	
	<cfproperty name="strProfilePgLogo" type="string" getter="true" setter="true">
	<cfproperty name="strProfilePgLogoAltTag" type="string" getter="true" setter="true">
	
	<cfproperty name="strMasterLogo" type="string" getter="true" setter="true">
	<cfproperty name="strMasterLogoAltTag" type="string" getter="true" setter="true">
	
	<cfproperty name="strHomePgFeatureLogo" type="string" getter="true" setter="true">
	<cfproperty name="strHomePgFeatureLogoAltTag" type="string" getter="true" setter="true">
	
	<cfproperty name="strHomePgSliderLogo" type="string" getter="true" setter="true">
	<cfproperty name="strHomePgSliderLogoAltTag" type="string" getter="true" setter="true">
	
	<cfproperty name="strCorporateVideo" type="string" getter="true" setter="true">
	<cfproperty name="strCorporateVideoSmall" type="string" getter="false" setter="true">
	
	<cfproperty name="strTwitterLink" type="string" getter="true" setter="true">
	<cfproperty name="strFacebookLink" type="string" getter="true" setter="true">
	<cfproperty name="strLinkedInLink" type="string" getter="true" setter="true">
	<cfproperty name="strGooglePlusLink" type="string" getter="true" setter="true">
	<cfproperty name="strYoutubeLink" type="string" getter="true" setter="true">
	<cfproperty name="strPinterestLink" type="string" getter="true" setter="true">
	<cfproperty name="strOpportunities" type="string" getter="true" setter="true">
	<cfproperty name="strPerks" type="string" getter="true" setter="true">
	<cfproperty name="strBenfGrowthPros" type="string" getter="true" setter="true">
    <cfproperty name="strSummary" type="string" getter="true" setter="true">
    <cfproperty name="strSummaryShort" type="string" getter="true" setter="false">
    	
	<cfproperty name="strProfilePgTrackURL" type="string" getter="true" setter="true">
	<cfproperty name="strJobDetPgTrackURL" type="string" getter="true" setter="true">
	<cfproperty name="strHomePgTrackURL" type="string" getter="true" setter="true">

	<cfscript>
		this.setIntCorpId(0);
		
		this.setImgLogo("");
		this.setStrCoName("");
		this.setStrDescription("");
		this.setStrFeaturedURL("");
		
		//employer table fields
		this.setSeoStrCompany("");
		this.setStrCity("");
		this.setStrState("");
		
		this.setEmployerIds("");
		
		
		this.setStrProfilePgLogo("");
		this.setStrProfilePgLogoAltTag("");
		
		this.setStrMasterLogo("");
		this.setStrMasterLogoAltTag("");
		
		this.setStrHomePgFeatureLogo("");
		this.setStrHomePgFeatureLogoAltTag("");
		
		this.setStrHomePgSliderLogo("");
		this.setStrHomePgSliderLogoAltTag("");
		
		this.setStrCorporateVideo("");
		this.setStrCorporateVideoSmall("");
		
		this.setStrTwitterLink("");
		this.setStrFacebookLink("");
		this.setStrLinkedInLink("");
		this.setStrGooglePlusLink("");
		this.setStrYoutubeLink("");
		this.setStrPinterestLink("");
		this.setStrOpportunities("");
		this.setStrPerks("");
		this.setStrBenfGrowthPros("");
		this.setStrSummary("");
		this.setStrSummaryShort("");
				
		this.setStrProfilePgTrackURL("");
		this.setStrJobDetPgTrackURL("");
		this.setStrHomePgTrackURL("");		
	</cfscript>
	
	
	<cffunction name="setStrDescription" access="public" output="false" returntype="void">
		<cfargument name="strDescription" type="string" required="true" />
		<cfset variables.strDescription = REReplace(arguments.strDescription,'<[^>]*>','','all') />
	</cffunction>
    
    <cffunction name="setStrSummaryShort" access="public" output="false" returntype="void">
		<cfargument name="strSummaryShort" type="string" required="true" />
		<cfset variables.strSummaryShort = REReplace(arguments.strSummaryShort,'<[^>]*>','','all') />
	</cffunction>
    	
	<cffunction name="getStrCorporateVideoSmall" access="public" output="false" returntype="string">
		<cfreturn rereplace(rereplace(variables.strCorporateVideo,'width="([0-9]+)"','width="283"'),'height="([0-9]+)"','height="132"')>
	</cffunction>

</cfcomponent>