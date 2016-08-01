<cfcomponent hint="Get's the Zip Code Information From Ip2Location">
	<cffunction name="init" access="public" output="false" returntype="ip2location">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="machine" type="string" required="true" />
		<cfargument name="sourceApp" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			variables.machine = arguments.machine;
			variables.sourceApp = arguments.sourceApp;

			return this;
		</cfscript>
	</cffunction>

<cffunction name="getLocationByZip" access="public" output="false" returntype="query"  hint="Returns The City, State, Zip Location Information by Zip Code">
	<cfargument name="zipCode" default="" required="yes" type="string" hint="Zip Code" />
		<cfset var qgetLocation = querynew("City,State,Zip,Country") />
        <cfif len(zipCode) gte 5>    
        	<cfstoredproc procedure="spS_IP_LocationByZip" datasource="#variables.dsn#">
            	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#trim(arguments.zipCode)#" variable="zipCode" null="no">
                <cfprocresult name="qgetLocation">
            </cfstoredproc>   
        </cfif>		
	<cfreturn qgetLocation />
</cffunction>


<!--- Lookup used for auto suggest --->
<cffunction name="getLocationSuggestion" access="remote" returntype="array">
  <cfargument name="search" type="any" required="false" default="">
  <cfscript>
  // Define variables --->
   var data="";
   var result=ArrayNew(1);
  // Do search 
    </cfscript>
    
<cfif len(arguments.search) gt 2>     
  	<cfstoredproc procedure="spS_Location_Suggestion" datasource="#variables.dsn#">
      <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.search#" variable="longnumber" null="no">
      <cfprocresult name="q">
     </cfstoredproc> 

  <!--- Build result array --->
  <cfloop query="q">
  		<!--- Append &nbsp; to Variable because of Issue With CF & Numbers --->
  	 <cfset ArrayAppend(result, location)>
  </cfloop> 
  
</cfif>
  
  <!--- And return it --->
  <cfreturn result>
</cffunction> 



<cffunction name="isZipOK" access="public" output="false" returntype="boolean" hint="Returns whether or not the zip exists">
	  <cfargument name="zipcode" required="yes" type="string" hint="Zip Code" />    
    	<cfset qgetTotal = getLocationByZip(arguments.zipcode) />	      
		<cfreturn iif(qgetTotal.recordcount gt 0,1,0) />         
</cffunction>

<cffunction name="isCPLVerified" access="public" output="false" returntype="boolean"  hint="Verify Whether CPL can be submitted by IP">
	<cfargument name="memberid" default="" required="yes" type="string" hint="Long Number" /> 
        	<cfstoredproc procedure="spS_CPL_VerifyByLongNumber" datasource="#variables.dsn#">
            	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#getIpLongNumber(cgi.REMOTE_ADDR)#" variable="longnumber" null="no">
            	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#trim(arguments.memberid)#" variable="memberid" null="no">
                <cfprocresult name="q">
            </cfstoredproc>   
	<cfreturn iif(q.recordcount,de(1),de(0)) />
</cffunction>


<cffunction name="getLocationByLongNumber" access="public" output="false" returntype="query"  hint="Returns The City, State, Zip Location Information by Zip Code">
	<cfargument name="longnumber" default="" required="yes" type="string" hint="Long Number" /> 
        	<cfstoredproc procedure="spS_IP_LocationByLongNumber" datasource="#variables.dsn#">
            	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#trim(arguments.longnumber)#" variable="longnumber" null="no">
                <cfprocresult name="qgetLocation">
            </cfstoredproc>   
	<cfreturn qgetLocation />
</cffunction>


<cffunction name="getCityListByZip" access="public" output="false" returntype="string" hint="Returns A list of cities by Zip Code">
	<cfargument name="zipCode" default="" required="yes" type="string" hint="Zip Code" />
		<cfset var qgetLocation = querynew("City") />
        <cfif len(zipCode) gte 5>    
        	<cfstoredproc procedure="spS_IP_LocationByZip" datasource="#variables.dsn#">
            	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#trim(arguments.zipCode)#" variable="zipCode" null="no">
                <cfprocresult name="qgetLocation">
            </cfstoredproc>   
        </cfif>	    
	<cfreturn valuelist(qgetLocation.city) />
</cffunction>


<cffunction name="getIpLongNumber" access="public" output="false" returntype="string" hint="Returns the long number based on the Ip address">
	<cfargument name="ipaddress" default="#cgi.REMOTE_ADDR#" required="yes" type="string" hint="Ip Address" />
    
	<cfscript>		
	var longnumber = 0;
	//Error Catching
	if(listlen(trim(arguments.ipaddress),".") neq 4){
		return 0;
		break;
	}	
		longnumber = (256^3*listGetat(trim(arguments.ipaddress),1,".")) + (256^2*listGetat(trim(arguments.ipaddress),2,".")) + (256*listGetat(trim(arguments.ipaddress),3,".")) + listGetat(trim(arguments.ipaddress),4,".");

//if Dev or QA.  Remap IP Address
	if (application.machine NEQ "LIVE"){
		longNumber = 1106558424;
	}
		return longNumber;
	</cfscript>
</cffunction>


<cffunction name="isAreaCodeInList" access="public" output="false" returntype="boolean" hint="Returns true or false whether or not the area code list Zip Code">
	<cfargument name="zipCode" default="" required="yes" type="string" hint="Zip Code" />
    <cfargument name="homephone" default="" required="yes" type="string" hint="City Required" />
		
        <cfif len(trim(arguments.zipCode)) gte 5 and len(trim(arguments.homephone))> 
        	<cfstoredproc procedure="spS_IP_LocationByZip" datasource="#variables.dsn#">
            	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#trim(arguments.zipCode)#" variable="zipCode" null="no">
                <cfprocresult name="qgetLocation">
            </cfstoredproc>  
            
            <cfreturn listfindnocase(trim(qgetLocation.areacode),left(arguments.homephone,3),"/") />
		<cfelse>
        	<cfreturn false />
    	</cfif>
</cffunction>


<cffunction name="isCityInList" access="public" output="false" returntype="boolean" hint="Returns true or false where city is in list Zip Code">
	<cfargument name="zipCode" default="" required="yes" type="string" hint="Zip Code" />
    <cfargument name="city" default="" required="yes" type="string" hint="City Required" />
		
        <cfif len(trim(arguments.zipCode)) gte 5 and len(trim(arguments.city))> 
			<cfset cityList = getCityListByZip(trim(arguments.zipCode)) />
            <cfreturn listfindnocase(citylist,trim(arguments.city)) />
		<cfelse>
        	<cfreturn false />
    	</cfif>
</cffunction>


<cffunction name="isDomesticIp" access="public" output="false" returntype="boolean" hint="Returns true or false where city is in list Zip Code">		
        <cfscript>
		LongNumber = getIpLongNumber();
		qlocation = getLocationByLongNumber(LongNumber);
		country = valuelist(qlocation.country);
		country = listfirst(country);
		 return  listfindnocase('United States,Canada',country);
		</cfscript>
        
</cffunction>

<cffunction name="getStateNamebyID" access="public" output="false" returntype="string" hint="Returns the State Name by State ID">
	<cfargument name="stateid" default="0" required="yes"  hint="Old State ID Number" />    

        	<cfstoredproc procedure="spS_getStateNameByid" datasource="#variables.dsn#">
            	<cfprocparam type="in" cfsqltype="cf_sql_integer" value="#trim(val(arguments.stateid))#" variable="stateid" null="no">
                <cfprocresult name="qgetStateName">
            </cfstoredproc>       
	<cfreturn valuelist(qgetStateName.statename) />         
</cffunction>

<cffunction name="isStateZipMatch" access="public" output="false" returntype="string" hint="Returns the State Name by State ID">
	<cfargument name="state" required="yes" type="string" hint="State Name" />
    <cfargument name="zipcode" required="yes" type="string" hint="Zip Code" />    
        <cfstoredproc procedure="spS_IP_StateZipMatch" datasource="#variables.dsn#">
            <cfprocparam type="In" cfsqltype="cf_sql_varchar" value="#trim(arguments.state)#" variable="state" null=false />
            <cfprocparam type="In" cfsqltype="cf_sql_varchar" value="#trim(arguments.zipcode)#" variable="zipcode" null=false />
            <cfprocresult name="qgetTotal">
        </cfstoredproc>       
	<cfreturn iif(qgetTotal.total gt 0,1,0) />         
</cffunction>

</cfcomponent>