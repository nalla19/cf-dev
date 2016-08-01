<cfset reinitVar=0>
<cfif isDefined("url.reinit")>
	<cfif  url.reinit gt "0">
		<cfset reinitVar=url.reinit>
    </cfif>
</cfif>

<cflock scope="Application" timeout="10" type="readonly">
	<cfscript>
	//Multiple If for Code Readability
	if (isDefined("Application.sixfj.query.Industries") or isDefined("Application.sixfj.query.Functions") or isDefined("Application.sixfj.query.States")){
		tempSetApp = 0;
	}else{
		tempSetApp = 1;
	}
	
	strSixFigData="6Figs";
	Attributes="Exec";
	
	//Set Array Variables
	if (not(tempSetApp)){
		//Categories
		arrInds=Application.sixfj.query.Industries;
		intIndsArrLen=ArrayLen(arrInds);
		
		//Functions
		arrFuncs=Application.sixfj.query.Functions;
		intFuncsArrLen=ArrayLen(arrFuncs);
		
		//States
		arrStates=Application.sixfj.query.States;
		intStatesArrLen=ArrayLen(arrStates);
	}
	</cfscript>
</cflock>

<cfif reinitVar gt 0>
	<cfset tempSetApp = 1>
</cfif>

<!--- Check Wheather To Process Arrays --->
<cfif tempSetApp>
	<cflock scope="Application" timeout="10" type="exclusive">
		<!--- CATEGORIES --->
        <cfset arrInds=ArrayNew(2)>
        <cfquery name="cfqGetIndustries" datasource="#application.dsn#"><!--- cachedwithin="#CreateTimeSpan(0,1,0,0)#">--->
        select intOldIndId,strIndName,intSHKeywordID from tblIndustries order by intindid
        </cfquery>
        <cfloop from="1" to="#cfqGetIndustries.RecordCount#" index="i">
			<cfset arrInds[i][1] = cfqGetIndustries.intOldIndId[i]>
            <cfset arrInds[i][2] = cfqGetIndustries.strIndName[i]>
            <cfset arrInds[i][3] = cfqGetIndustries.intSHKeywordID[i]>
       	</cfloop>
        <cfset intIndsArrLen=ArrayLen(arrInds)> 
        
        <!--- FUNCTIONS --->
		<cfset arrFuncs=ArrayNew(2)> 
        <!---Do not pull the All Functions option--->
        <cfquery name="cfqGetFunctions" datasource="#application.dsn#"><!--- cachedwithin="#CreateTimeSpan(0,1,0,0)#">--->
        select intOldFunctionId,strFunctionName,intSHKeywordID from tblFunctions (nolock) where 1=1 and intOldFunctionId != 800 order by strFunctionName
        </cfquery>
		
        <!---Set the All Functions to be the first in the array--->                
        <cfset arrFuncs[1][1] = 800>
    	<cfset arrFuncs[1][2] = "All Functions">
        <cfset arrFuncs[1][3] = "">
        
        <cfloop from="1" to="#cfqGetFunctions.RecordCount#" index="f">
            <cfset k=f+1>
	        <cfset arrFuncs[k][1] = cfqGetFunctions.intOldFunctionId[f]>
    	    <cfset arrFuncs[k][2] = cfqGetFunctions.strFunctionName[f]>
        	<cfset arrFuncs[k][3] = cfqGetFunctions.intSHKeywordID[f]>
        </cfloop>
        <cfset intFuncsArrLen=ArrayLen(arrFuncs)> 
        
        <!--- STATES ---> 
        <cfset arrStates=ArrayNew(2)> 
       	<cfquery name="cfqGetStates" datasource="#application.dsn#"><!---  cachedwithin="#CreateTimeSpan(0,1,0,0)#" --->
        select strName,strshortname, intOldId,strAbbrev,strCountry from tblstates(nolock) order by intStateID
       	</cfquery>
        <cfloop from="1" to="#cfqGetStates.RecordCount#" index="s">
			<cfset arrStates[s][1] = cfqGetStates.intOldId[s]>
            <cfset arrStates[s][2] = cfqGetStates.strName[s]>
            <cfset arrStates[s][3] = cfqGetStates.strAbbrev[s]>
            <cfset arrStates[s][4] = cfqGetStates.strCountry[s]>
            <cfset arrStates[s][5] = cfqGetStates.strShortName[s]>
        </cfloop>
        <cfset intStatesArrLen=ArrayLen(arrStates)>
        
		<cfscript>
        Application.sixfj.query.Industries = arrInds; 
        Application.sixfj.query.Functions =  arrFuncs;
        Application.sixfj.query.States = arrStates;
        </cfscript>
	</cflock>
</cfif>