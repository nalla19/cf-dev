<cfscript> 
LyrisHQObj =  createObject("component","/6fj/extensions/components/LyrisHQ/LyrisHQ");
globalAPIPasswd = LyrisHQObj.getGlobalAPIPasswd();
WorkstreamSiteID = LyrisHQObj.getSiteID();
</cfscript>

<!---This is the List ID for CPL Optin Email in Lyris HQ--->
<cfset mailingListID = "5659">

<!---Demographic/Attribute ID for Subject--->
<cfset demographicFNameID = "1">

<!---Demographic/Attribute ID for Subject--->
<cfset demographicSubjectID = "37427">

<!---Demographic/Attribute ID for Message-HTML--->
<cfset demographicMessageHTMLID = "37516">

<!---Demographic/Attribute ID for Message--->
<cfset demographicMessageID = "37355">

<!---Mailing List Trigger ID for CPL Optin confirmation Email--->
<cfset cplOptinEmailTriggerID = "2855">


<cfoutput>
<!---HTML Content for the message---->
<cfsavecontent variable="messageHTML">
<table>
	<tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>First Name:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLFname#</td>
    </tr>
	
    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Last Name:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLLname#</td>
    </tr>

    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Email:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLEmail#</td>
    </tr>

    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Address:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLAddr#<cfif len(CPLAddr2)>, #CPLAddr2# </cfif></td>
    </tr>
    
    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>City:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLCity#</td>
    </tr>

    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>State:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#lcl_state#</td>
    </tr>

   	<tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Zip:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLZip#</td>
    </tr>

   	<tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Country:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#lcl_cntry#</td>
    </tr>

    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Phone:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLDPhone#</td>
    </tr>
    
    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Phone 2:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLEPhone#</td>
    </tr>
            
    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Capital:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"></td>
    </tr>
    
    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Net Worth:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"></td>
    </tr>
    
    <tr>
    	<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Timeframe:</strong></td>
        <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"></td>
    </tr>
	
</table>
</cfsavecontent>

<!---Make the content HTMLDecoded--->
<cfset messageHTML = HTMLEditFormat(messageHTML)>

<cfsavecontent variable="messageText">
    First Name: #CPLFname# 
    Last Name: #CPLLname#
    Email: #CPLEmail#
    Address: #CPLAddr#<cfif len(CPLAddr2)>, #CPLAddr2# </cfif>
    City: #CPLCity#
    State: #lcl_state#   
    Zip: #CPLZip#           
    Country: #lcl_cntry#
    Phone: #CPLDPhone#
    Phone 2: #CPLEPhone#
    Capital:
    Net Worth:
    Timeframe:
</cfsavecontent>
</cfoutput>



<!---EmailID where the email needs to be sent out--->
<cfset emailList="">
<cfset emailList=ListAppend(emailList,toEmail)>
<cfset emailList=ListAppend(emailList,toEmailbcc)>

<cfoutput>
<cfloop list="#emailList#" delimiters="," index="emailID">
	<cfsavecontent variable="LyrisDataSet">
        <DATASET>
            <SITE_ID>#WorkstreamSiteID#</SITE_ID>
            <MLID>#mailingListID#</MLID>
            <DATA type="email">#emailID#</DATA>
            <DATA type="demographic" id="#demographicMessageHTMLID#">#messageHTML#</DATA>
            <DATA type="demographic" id="#demographicMessageID#">#messageText#</DATA>
            <DATA type="demographic" id="#demographicSubjectID#">#subject#</DATA>
            <DATA type="extra" id="password">#globalAPIPasswd#</DATA>
        </DATASET>
    </cfsavecontent>
	
	<!---Add the record to the Lyris List--->
	<cfscript>
    addRecordToList = LyrisHQObj.addRecordToList(LyrisDataSet);
    </cfscript>
    <cfset LyrisResponse = addRecordToList>
    
	<!---Check to see if the feed is valid xml file and also to check the if the email address is already exists--->
	<cfif IsXML(LyrisResponse)>
        <!--- Parse the XML --->
        <cfset MyXMLDoc = xmlParse(LyrisResponse) />
        <cfset DnArticles = xmlSearch(MyXMLDoc,'/DATASET')>
    
        <cfloop from="1" to="#arraylen(DnArticles)#" index="i">
            <!--- The array contents need to parsed so you can easily get at the child nodes children and attributes. --->
            <cfset ArticleXML = xmlparse(DnArticles[i]) />
           
            <!---Article Date Created--->
            <cfset type = #ArticleXML.DATASET.TYPE.xmltext#>
            <cfset errmessage = #ArticleXML.DATASET.Data.xmltext#>
        </cfloop>
    </cfif>
    
    <!---If the above process to add the record fails to upload a record, update the record--->
    <cfif isDefined("type") and type eq "Error">
        <cfif isDefined("errmessage") and errmessage eq "Email address already exists">		
            <cfscript>
            updateRecordToList = LyrisHQObj.updateRecordToList(LyrisDataSet);
            </cfscript>
        </cfif>
    </cfif>	
        
    <!---Fire the trigger to send email--->
    <cfsavecontent variable="LyrisDataSet">
        <DATASET>
            <SITE_ID>#WorkstreamSiteID#</SITE_ID>
            <MLID>#mailingListID#</MLID>
            <DATA type="extra" id="trigger_id">#cplOptinEmailTriggerID#</DATA>
            <DATA type="extra" id="recipients">#emailID#</DATA>
            <DATA type="extra" id="password">#globalAPIPasswd#</DATA>
        </DATASET>
    </cfsavecontent>
    
    <cfscript>
    fireTriggerToList = LyrisHQObj.fireTriggerToList(LyrisDataSet);
    </cfscript>    
</cfloop>
</cfoutput>

