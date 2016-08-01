<!--- This function's purpose is to transform structs/arrays into a serialized format, so it can be passed through a URL String. ---->
<cffunction name="SerializeURLData" access="public" returntype="string" output="false" hint="Serializes the given data using WDDX. Optionally encodes for URL.">
	<!--- Define arguments. --->
	<cfargument name="Data"	type="any" required="true"	hint="ColdFusion struct or array data."	/>
	<cfargument	name="Encode" type="boolean" required="false" default="true" hint="Flag for URL encoded format."/>
	
	<!--- Create local scope. --->
	<cfset var LOCAL = StructNew() />
	
	<!--- Serialize the data using WDDX. This will convert the ColdFusion data into WDDX standards XML data. --->
	<cfwddx	action="CFML2WDDX"	input="#ARGUMENTS.Data#" output="LOCAL.WDDXData" usetimezoneinfo="false"/>
	
	<!--- Check to see if we are encoding the data for URL. If do this here, then the user has to be carful NOT to run URLEncodedFormat() on the returned data (that would be like double-escaping it). --->
	<cfif ARGUMENTS.Encode>
		<!--- Return the encoded data. --->
		<cfreturn URLEncodedFormat(LOCAL.WDDXData) />
	<cfelse>
		<!--- Return the data as-is. --->
		<cfreturn LOCAL.WDDXData />
	</cfif>
</cffunction>

<cffunction name="DeserializeURLData" access="public" returntype="any" output="false" hint="Converts the URL WDDX data back into ColdFusion data objects.">
	<!--- Define arguments. --->
	<cfargument name="Data" type="string" required="true" hint="WDDX data (can be URL encoded)." />
 	<!--- Define the local scope. --->
	<cfset var LOCAL = StructNew() />
 	<!--- 
	When it comes to converting the data from WDDX back into ColdFusion, we have to make sure that it is not URL encoded. If it is NOT URL encoded, then our first
	character will be "<". If not, then the data is URL encoded and we must first decode it.
	--->
	<cfif (Left( ARGUMENTS.Data, 1 ) NEQ "<")>
 		<!--- Decode the data. --->
		<cfset ARGUMENTS.Data = URLDecode(ARGUMENTS.Data) />
 	</cfif>
 
	<!--- ASSERT: At this point, no matter how the data was passed to us, it is not in true WDDX format. --->
    <!--- Convert the WDDX back to ColdFusion. --->
	<cfwddx action="WDDX2CFML" input="#ARGUMENTS.Data#" output="LOCAL.Data" />
	
	<!--- Return the ColdFusion data. --->
	<cfreturn LOCAL.Data />
</cffunction>