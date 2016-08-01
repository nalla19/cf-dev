<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="companyGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="qry_company" access="public" output="false" returntype="query">
		<cfargument name="intEmployerId" type="numeric" required="true" />
		<cfargument name="seoStrCompany" type="string" required="true" />
		<cfset var qry_comp = "" />
		
		<cfquery name="qry_comp" datasource="#variables.dsn#">
			SELECT ercp.intCorpID, 
					
					ercp.strCoName,
					ercp.strDescription,
					ercp.strFeaturedURL,
					
					emp.seoStrCompany,
					emp.strCity,
					emp.strState,
					
					era.strProfilePgLogo,
					era.strProfilePgLogoAltTag,
					era.strMasterLogo,
					era.strMasterLogoAltTag,
					era.strHomePgFeatureLogo,
					era.strHomePgFeatureLogoAltTag,
					era.strHomePgSliderLogo,
					era.strHomePgSliderLogoAltTag,
					
					era.strCorporateVideo,
					era.strTwitterLink,
					era.strFacebookLink,
					era.strLinkedInLink,
					era.strGooglePlusLink,
					era.strYoutubeLink,
					era.strPinterestLink,
					era.strOpportunites as strOpportunities,
					era.strPerks,
					era.strBenfGrowthPros,
                    era.strSummary,
					
					era.strProfilePgTrackURL,
					era.strJobDetPgTrackURL,
					era.strHomePgTrackURL
				
			FROM tblERCorpPage ercp (nolock)
				INNER JOIN tblCorpID corp (nolock) ON (ercp.intCorpID=corp.intCorpID)
				INNER JOIN tblEmployers emp (nolock) ON (corp.intEmployerID=emp.intEmployerID and emp.blnCorpPage=1)
				LEFT OUTER JOIN tblErAssets era (nolock) ON (emp.intEmployerID = era.intEmployerID)
			WHERE bln6Figure=1
			AND blnFeatured=1
			<cfif len(arguments.seoStrCompany)>
				AND seoStrCompany = <cfqueryparam value="#arguments.seoStrCompany#" cfsqltype="cf_sql_varchar" />
			<cfelse>
				AND emp.intEmployerId = <cfqueryparam value="#arguments.intEmployerId#" cfsqltype="cf_sql_integer" />
			</cfif>
            AND emp.dteAcctExp >= '#DateFormat(now(),"mm/dd/yyyy")#'
			ORDER BY strCoName
		</cfquery>
				
		<cfreturn qry_comp>
	</cffunction>
	
	<cffunction name="qry_companyEmployers" access="public" output="false" returntype="query">
		<cfargument name="intCorpId" type="numeric" required="true">
		<cfset var qry_ce = "" />
		
		<cfquery name="qry_ce" datasource="#variables.dsn#">
			SELECT intEmployerID
			FROM tblCorpID (NOLOCK)
			WHERE intCorpID = <cfqueryparam value="#arguments.intCorpId#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn qry_ce>
	</cffunction>
	
    
	<cffunction name="qry_featuredCompanies" access="public" output="false" returntype="query">
		<cfset var qry_c = "" />
		
		<cfquery name="qry_c" datasource="#variables.dsn#">
			SELECT ercp.intCorpID,
					
					ercp.strCoName,
					ercp.strDescription,
					ercp.strFeaturedURL,
					
					emp.seoStrCompany,
					emp.strCity,
					emp.strState,
					
					era.strProfilePgLogo,
					era.strProfilePgLogoAltTag,
					era.strMasterLogo,
					era.strMasterLogoAltTag,
					era.strHomePgFeatureLogo,
					era.strHomePgFeatureLogoAltTag,
					era.strHomePgSliderLogo,
					era.strHomePgSliderLogoAltTag,
					
					era.strCorporateVideo,
					era.strTwitterLink,
					era.strFacebookLink,
					era.strLinkedInLink,
					era.strGooglePlusLink,
					era.strYoutubeLink,
					era.strPinterestLink,
					era.strOpportunites as strOpportunities,
					era.strPerks,
					era.strBenfGrowthPros,
                    era.strSummary,
					
					era.strProfilePgTrackURL,
					era.strJobDetPgTrackURL,
					era.strHomePgTrackURL
					
			FROM tblERCorpPage ercp,
					tblCorpID corp,
					tblEmployers emp
					LEFT OUTER JOIN tblErAssets era ON (emp.intEmployerID = era.intEmployerID)
			WHERE ercp.intCorpID=corp.intCorpID
			AND corp.intEmployerID=emp.intEmployerID
			AND emp.blnCorpPage = 1
			AND emp.dteAcctExp >= '#DateFormat(now(),"mm/dd/yyyy")#'
			AND bln6Figure = 1
			AND blnFeatured = 1
			ORDER BY strCoName
		</cfquery>
		
		<cfreturn qry_c>
	</cffunction>
	
	<cffunction name="qry_companyOfTheWeek" access="public" output="false" returntype="query">
		<cfset var qry_c = "" />
		
		<cfquery name="qry_c" datasource="#variables.dsn#">
			SELECT ercp.intCorpID,
					
					ercp.strCoName,
					ercp.strDescription,
					ercp.strFeaturedURL,
					
					emp.seoStrCompany,
					emp.strCity,
					emp.strState,
					
					era.strProfilePgLogo,
					era.strProfilePgLogoAltTag,
					era.strMasterLogo,
					era.strMasterLogoAltTag,
					era.strHomePgFeatureLogo,
					era.strHomePgFeatureLogoAltTag,
					era.strHomePgSliderLogo,
					era.strHomePgSliderLogoAltTag,
					
					era.strCorporateVideo,
					era.strTwitterLink,
					era.strFacebookLink,
					era.strLinkedInLink,
					era.strGooglePlusLink,
					era.strYoutubeLink,
					era.strPinterestLink,
					era.strOpportunites as strOpportunities,
					era.strPerks,
					era.strBenfGrowthPros,
                    era.strSummary,
					
					era.strProfilePgTrackURL,
					era.strJobDetPgTrackURL,
					era.strHomePgTrackURL

			FROM tblERCorpPage ercp,
					tblCorpID corp,
					tblEmployers emp
					LEFT OUTER JOIN tblErAssets era ON (emp.intEmployerID = era.intEmployerID)
			WHERE ercp.intCorpID=corp.intCorpID
			AND corp.intEmployerID=emp.intEmployerID
			AND emp.blnFeaturedHomePage = 1 
			and emp.dteAcctExp >= '#DateFormat(now(),"mm/dd/yyyy")#'
		</cfquery>
		
		<cfreturn qry_c>
	</cffunction>
	
	<cffunction name="qry_bestInClassCompanies" access="public" output="false" returntype="query">
		<cfset var qry_c = "" />
		
		<cfquery name="qry_c" datasource="#variables.dsn#">
			SELECT ercp.intCorpID,
					
					ercp.strCoName,
					ercp.strDescription,
					ercp.strFeaturedURL,
					
					emp.seoStrCompany,
					emp.strCity,
					emp.strState,
					
					era.strProfilePgLogo,
					era.strProfilePgLogoAltTag,
					era.strMasterLogo,
					era.strMasterLogoAltTag,
					era.strHomePgFeatureLogo,
					era.strHomePgFeatureLogoAltTag,
					era.strHomePgSliderLogo,
					era.strHomePgSliderLogoAltTag,
					
					era.strCorporateVideo,
					era.strTwitterLink,
					era.strFacebookLink,
					era.strLinkedInLink,
					era.strGooglePlusLink,
					era.strYoutubeLink,
					era.strPinterestLink,
					era.strOpportunites as strOpportunities,
					era.strPerks,
					era.strBenfGrowthPros,
                    era.strSummary,

					era.strProfilePgTrackURL,
					era.strJobDetPgTrackURL,
					era.strHomePgTrackURL

			FROM tblERCorpPage ercp,
					tblCorpID corp,
					tblEmployers emp,
					tblErAssets era
			WHERE ercp.intCorpID=corp.intCorpID
			AND emp.intEmployerID = era.intEmployerID
			AND corp.intEmployerID=emp.intEmployerID
			AND ercp.blnFeatured = 1 
			AND era.strHomePgSliderLogo is not null
			AND emp.dteAcctExp >= '#DateFormat(now(),"mm/dd/yyyy")#'
			ORDER BY newid()
		</cfquery>
		
		<cfreturn qry_c>
	</cffunction>
	
	
	<cffunction name="qry_hiringCompanies" access="public" output="false" returntype="query">
		<cfset var qry_i = "" />
		<!---
		<cfquery name="qry_i" datasource="#variables.dsn#">
			SELECT DISTINCT ercp.intCorpID,
					
					ercp.strCoName,
					ercp.strFeaturedURL,
								
					emp.seoStrCompany,
					emp.strCity,
					emp.strState,
								
					era.strProfilePgLogo,
					era.strProfilePgLogoAltTag,
					era.strMasterLogo,
					era.strMasterLogoAltTag,
					era.strHomePgFeatureLogo,
					era.strHomePgFeatureLogoAltTag,
					era.strHomePgSliderLogo,
					era.strHomePgSliderLogoAltTag,
								
					era.strCorporateVideo,
					era.strTwitterLink,
					era.strFacebookLink,
					era.strLinkedInLink,
					era.strGooglePlusLink,
					era.strYoutubeLink,
					era.strPinterestLink
			FROM tblJobs jobs (nolock),
					tblERCorpPage ercp,
					tblCorpID corp,
					tblEmployers emp
					LEFT OUTER JOIN tblErAssets era ON (emp.intEmployerID = era.intEmployerID)
			WHERE ercp.intCorpID=corp.intCorpID
			AND corp.intEmployerID=emp.intEmployerID
			AND emp.intEmployerID = jobs.intEmployerID
			AND jobs.blnActive = 1 
			and jobs.blnArchived = 0 
			and emp.intPackageType in (1, 2)
			and emp.dteAcctExp >= '#DateFormat(now(),"mm/dd/yyyy")#'
		</cfquery>
		--->
		
		<cfquery name="qry_i" datasource="#variables.dsn#">
			SELECT DISTINCT 0 intCorpID,
					
					emp.strcompany strCoName,
					'dummyURL' strFeaturedURL,
								
					emp.seoStrCompany,
					emp.strCity,
					emp.strState,
								
					era.strProfilePgLogo,
					era.strProfilePgLogoAltTag,
					era.strMasterLogo,
					era.strMasterLogoAltTag,
					era.strHomePgFeatureLogo,
					era.strHomePgFeatureLogoAltTag,
					era.strHomePgSliderLogo,
					era.strHomePgSliderLogoAltTag,
								
					era.strCorporateVideo,
					era.strTwitterLink,
					era.strFacebookLink,
					era.strLinkedInLink,
					era.strGooglePlusLink,
					era.strYoutubeLink,
					era.strPinterestLink,
					era.strProfilePgTrackURL,
					era.strJobDetPgTrackURL,
					era.strHomePgTrackURL
			FROM tblJobs jobs (nolock)
			LEFT OUTER JOIN tblCorpID corp
			ON jobs.intEmployerID = corp.intEmployerID
			LEFT OUTER JOIN tblERCorpPage ercp
			ON corp.intCorpID = ercp.intCorpID
			LEFT OUTER JOIN tblEmployers emp
			ON emp.intEmployerID = jobs.intEmployerID
			LEFT OUTER JOIN tblErAssets era 
			ON emp.intEmployerID = era.intEmployerID
			WHERE 1=1
			AND jobs.blnActive = 1 
			and jobs.blnArchived = 0 
			and emp.intPackageType in (1, 2)
			and emp.seoStrCompany is not null
			and emp.blnHiringCompany = 1
			and emp.dteAcctExp >= '#DateFormat(now(),"mm/dd/yyyy")#'
		</cfquery>
		
		<cfreturn qry_i>
	</cffunction>
	
	<cffunction name="qry_companyPostingIndustries" access="public" output="false" returntype="query">
		<cfset var qry_i = "" />
		
		<cfquery name="qry_i" datasource="#variables.dsn#">
			SELECT distinct jobAtt.intAttID, ind.strIndName, ind.seoIndName from tblJobs jobs (nolock) 
				inner join tblEmployers emp (nolock) on emp.intEmployerID = jobs.intEmployerID 
				inner join tblJobAtt jobAtt (nolock) on jobAtt.intJobID = jobs.intJobID 
				inner join tblIndustries ind (nolock) on jobAtt.intAttID = ind.intOldIndID 
			WHERE jobs.blnActive = 1 
			AND jobs.blnArchived = 0 
			AND emp.dteAcctExp >= '#DateFormat(now(),"mm/dd/yyyy")#' 
			ORDER BY ind.strIndName
		</cfquery>
		
		<cfreturn qry_i>
	</cffunction>
	
</cfcomponent>