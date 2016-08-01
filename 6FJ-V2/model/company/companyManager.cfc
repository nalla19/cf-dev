<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="companyManager">
		<cfargument name="dsn" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			variables.companyGateway = createObject('component', 'companyGateway').init(dsn=variables.dsn);
						
			return this;
		</cfscript>
	</cffunction>


	<!--- start CRUD methods --->
	<cffunction name="getCompany" access="public" output="false" returntype="company">
		<cfargument name="intEmployerId" type="numeric" required="false" default="0" />
		<cfargument name="seoStrCompany" type="string" required="false" default="" />
		<cfargument name="includeEmployers" type="boolean" required="false" default="false" />
		<cfset var company = createObject('component', 'company') />
		
		<cfif len(arguments.seoStrCompany) OR intEmployerId GT 0>
			<cfset company = setCompany(qry_company=variables.companyGateway.qry_company(
											intEmployerId=arguments.intEmployerId,
											seoStrCompany=arguments.seoStrCompany),
										queryRow=1,
										includeEmployers=arguments.includeEmployers) />
		</cfif>
		
		<cfreturn company>
	</cffunction>

	<cffunction name="setCompany" access="private" output="false" returntype="company">
		<cfargument name="qry_company" type="query" required="true" />
		<cfargument name="queryRow" type="numeric" required="true" />
		<cfargument name="company" type="company" required="false" />
		<cfargument name="includeEmployers" type="boolean" required="false" default="false" />
		<cfset var qry_employers = "" />
		
		<cfif NOT isDefined("arguments.company")>
			<cfset arguments.company = createObject('component', 'company') />
		</cfif>
		
		<cfif arguments.qry_company.recordcount GTE arguments.queryRow>
			<cfscript>
				arguments.company.setIntCorpId(qry_company.intCorpId[arguments.queryRow]);

				arguments.company.setStrCoName(qry_company.strCoName[arguments.queryRow]);
				
				if (isDefined("qry_company.strDescription")) {
					arguments.company.setStrDescription(qry_company.strDescription[arguments.queryRow]);
				}
				
				arguments.company.setStrFeaturedURL(qry_company.strFeaturedURL[arguments.queryRow]);
				
				arguments.company.setSeoStrCompany(qry_company.seoStrCompany[arguments.queryRow]);
				arguments.company.setStrCity(qry_company.strCity[arguments.queryRow]);
				arguments.company.setStrState(qry_company.strState[arguments.queryRow]);
				
				arguments.company.setStrProfilePgLogo(qry_company.strProfilePgLogo[arguments.queryRow]);
				arguments.company.setStrProfilePgLogoAltTag(qry_company.strProfilePgLogoAltTag[arguments.queryRow]);
				arguments.company.setStrMasterLogo(qry_company.strMasterLogo[arguments.queryRow]);
				arguments.company.setStrMasterLogoAltTag(qry_company.strMasterLogoAltTag[arguments.queryRow]);
				arguments.company.setStrHomePgFeatureLogo(qry_company.strHomePgFeatureLogo[arguments.queryRow]);
				arguments.company.setStrHomePgFeatureLogoAltTag(qry_company.strHomePgFeatureLogoAltTag[arguments.queryRow]);
				arguments.company.setStrHomePgSliderLogo(qry_company.strHomePgSliderLogo[arguments.queryRow]);
				arguments.company.setStrHomePgSliderLogoAltTag(qry_company.strHomePgSliderLogoAltTag[arguments.queryRow]);
				
				arguments.company.setStrCorporateVideo(qry_company.strCorporateVideo[arguments.queryRow]);
				arguments.company.setStrTwitterLink(qry_company.strTwitterLink[arguments.queryRow]);
				arguments.company.setStrFacebookLink(qry_company.strFacebookLink[arguments.queryRow]);
				arguments.company.setStrLinkedInLink(qry_company.strLinkedInLink[arguments.queryRow]);
				arguments.company.setStrGooglePlusLink(qry_company.strGooglePlusLink[arguments.queryRow]);
				arguments.company.setStrYoutubeLink(qry_company.strYoutubeLink[arguments.queryRow]);
				arguments.company.setStrPinterestLink(qry_company.strPinterestLink[arguments.queryRow]);
				
				if (isDefined("qry_company.strOpportunities")) {
					arguments.company.setStrOpportunities(qry_company.strOpportunities[arguments.queryRow]);
				}
				if (isDefined("qry_company.strPerks")) {
					arguments.company.setStrPerks(qry_company.strPerks[arguments.queryRow]);
				}
				if (isDefined("qry_company.strBenfGrowthPros")) {
					arguments.company.setStrBenfGrowthPros(qry_company.strBenfGrowthPros[arguments.queryRow]);
				}
				if (isDefined("qry_company.strSummary")) {
					arguments.company.setStrSummary(qry_company.strSummary[arguments.queryRow]);
					arguments.company.setStrSummaryShort(qry_company.strSummary[arguments.queryRow]);
				}
				
				if (arguments.includeEmployers) {
					qry_employers = variables.companyGateway.qry_companyEmployers(intCorpId=arguments.company.getintCorpId());
					arguments.company.setEmployerIds(ValueList(qry_employers.intEmployerID));
				}
			
				arguments.company.setStrProfilePgTrackURL(qry_company.strProfilePgTrackURL[arguments.queryRow]);
				arguments.company.setStrJobDetPgTrackURL(qry_company.strJobDetPgTrackURL[arguments.queryRow]);
				arguments.company.setStrHomePgTrackURL(qry_company.strHomePgTrackURL[arguments.queryRow]);
			</cfscript>
		</cfif>
		
		<cfreturn arguments.company>
	</cffunction>
	<!--- end CRUD methods --->



	<!--- start query/data methods --->
	<cffunction name="getFeaturedCompanies" access="public" output="false" returntype="array">
		<cfset var ary_companies = ArrayNew(1) />
		<cfset var qry_companies = variables.companyGateway.qry_featuredCompanies() />
		
		<cfloop query="qry_companies">
			<cfset ary_companies[qry_companies.currentrow] = setCompany(
															qry_company 		= qry_companies,
															queryRow 			= qry_companies.currentrow) />
		</cfloop>
		
		<cfreturn ary_companies>
	</cffunction>
	
	<cffunction name="getBestInClassCompanies" access="public" output="false" returntype="array">
		<cfset var ary_companies = ArrayNew(1) />
		<cfset var qry_companies = variables.companyGateway.qry_bestInClassCompanies() />
		
		<cfloop query="qry_companies">
			<cfset ary_companies[qry_companies.currentrow] = setCompany(
															qry_company 		= qry_companies,
															queryRow 			= qry_companies.currentrow) />
		</cfloop>
		
		<cfreturn ary_companies>
	</cffunction>
	
	<cffunction name="getCompanyOfTheWeek" access="public" output="false" returntype="company">
		<cfset var company = createObject('component', 'company') />
		
		<cfset company = setCompany(qry_company=variables.companyGateway.qry_companyOfTheWeek(),
										queryRow=1) />
		
		<cfreturn company>
	</cffunction>
	
	<cffunction name="getCompanyPostingIndustries" access="public" output="false" returntype="query">
		<cfreturn variables.companyGateway.qry_companyPostingIndustries()>
	</cffunction>
	
	<cffunction name="getHiringCompanies" access="public" output="false" returntype="array">
		<cfset var ary_companies = ArrayNew(1) />
		<cfset var qry_companies = variables.companyGateway.qry_hiringCompanies() />
		
		<cfloop query="qry_companies">
			<cfset ary_companies[qry_companies.currentrow] = setCompany(
															qry_company 		= qry_companies,
															queryRow 			= qry_companies.currentrow) />
		</cfloop>
		
		<cfreturn ary_companies>
	</cffunction>
	<!--- end query/data methods --->



	
	<!--- start misc methods --->
		
	<!--- end misc methods --->

</cfcomponent>