<cfsetting showdebugoutput="false">
<cfparam name="strPrevKeyWords" default="">
<cfparam name="strKeyWord" default="">
<cfparam name="strKeyWords" default="">
<cfparam name="strSearchKeyword" default="">
<cfparam name="noOfWords" default="0">
<cfparam name="strJobTitle" default="">
<cfparam name="intloopCnt" default="">
<cfparam name="blnZipCodeSearch" default="0">

<cfset strSearchKeyword = #URL.q#>

<cfif len(strSearchKeyword) gte "3">
	
    <cfquery name="getZipCode"  datasource="#application.dsn#">    
    select zipcodes.zipcode
      from tbl_zipcodes_usa zipcodes(nolock) 
     where 1=1
       and zipcodes.zipcode like '#strSearchKeyword#%'
     union
     select zipcodes.PostalCode zipcode
      from tbl_zipcodes_canada zipcodes(nolock) 
     where 1=1
       and zipcodes.PostalCode like '#strSearchKeyword#%'
    </cfquery>
    
    <cfif getZipCode.recordcount gte 1>
    	<cfset blnZipCodeSearch = 1>
    	
        <cfquery name="getCityState"  datasource="#application.dsn#">    
        select distinct zipcodes.city ipCity, zipcodes.state ipRegion, zipcodes.zipcode ipZipCode, 'United States' as ipCountry
          from tbl_zipcodes_usa zipcodes(nolock) 
         where 1=1
           and (zipcodes.city like '#strSearchKeyword#%' or zipcodes.zipcode like '#strSearchKeyword#%')  
         union
         select distinct zipcodes.city ipCity, zipcodes.province ipRegion, zipcodes.postalCode, 'Canada' as ipCountry
          from tbl_zipcodes_canada zipcodes(nolock) 
         where 1=1
           and (zipcodes.city like '#strSearchKeyword#%' or zipcodes.PostalCode like '#strSearchKeyword#%')
        </cfquery>
        
        <cfoutput query="getCityState">
			<cfset strCity = getCityState.ipCity>
            <cfset strtempCity = REReplace(LCase(strCity), "(^[[:alpha:]]|[[:blank:]][[:alpha:]])", "\U\1\E", "ALL")>
            <cfset strCity = strtempCity>        
       
            <cfset strState = getCityState.ipRegion>
            <cfquery name="getStateName" datasource="#application.dsn#">
            select strName from tblStates (nolock) where 1=1 and strAbbrev = '#strState#'
            </cfquery>
            <cfif getStateName.recordcount gt 0>
       			<cfset strState =  getStateName.strName>
            </cfif>
            
	        <cfset strCountry = getCityState.ipCountry>
            <cfset strZipCode =   rtrim(ltrim(getCityState.ipZipCode))>
                   
           <cfset strCityState = "#strZipCode#,#strCity#,#strState#,#strCountry#">
           <!--- <option value="#strCityState#">#strCityState#</option> --->
           #strCityState#;
    	</cfoutput>
	<cfelse>    
    	<cfquery name="getCityState"  datasource="#application.dsn#">    
        select distinct zipcodes.city ipCity, zipcodes.state ipRegion, zipcodes.zipcode ipZipCode, 'United States' as ipCountry
          from tbl_zipcodes_usa zipcodes(nolock) 
         where 1=1
           and (zipcodes.city like '#strSearchKeyword#%' or zipcodes.zipcode like '#strSearchKeyword#%')  
         union
         select distinct zipcodes.city ipCity, zipcodes.province ipRegion, zipcodes.postalCode, 'Canada' as ipCountry
          from tbl_zipcodes_canada zipcodes(nolock) 
         where 1=1
           and (zipcodes.city like '#strSearchKeyword#%' or zipcodes.PostalCode like '#strSearchKeyword#%')
        </cfquery>
        
        <cfoutput query="getCityState">
			<cfset strCity = getCityState.ipCity>
            <cfset strtempCity = REReplace(LCase(strCity), "(^[[:alpha:]]|[[:blank:]][[:alpha:]])", "\U\1\E", "ALL")>
            <cfset strCity = strtempCity>        
            
			<cfset strState = getCityState.ipRegion>
            <cfquery name="getStateName" datasource="#application.dsn#">
            select strName from tblStates (nolock) where 1=1 and strAbbrev = '#strState#'
            </cfquery>
            <cfif getStateName.recordcount gt 0>
       			<cfset strState =  getStateName.strName>
            </cfif>
            
            <cfset strCountry = getCityState.ipCountry>
            <cfset strZipCode =   rtrim(ltrim(getCityState.ipZipCode))>
            
            <cfset strCityState = "#strZipCode#,#strCity#,#strState#,#strCountry#">
            <!--- <option value="#strCityState#">#strCityState#</option> --->
            #strCityState#;
    	</cfoutput>    
	</cfif>
</cfif>