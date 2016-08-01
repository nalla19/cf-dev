<!---Start Mail--->
<!---
<cfmail from="#strAcctMngrEmail#" to="#jobemail#" subject="6FigureJobs Application: #title# [#jcode#]">
	<cfmailparam name="Reply-To" value="#strAcctMngrEmail#">
This is an automated response. Please do NOT reply.

A candidate on 6FigureJobs.com applied to the following job.

Job Title: #title#
Job Code: #jcode#

Please login to your account to view job applications.

Thanks,
#strAcctMngrFName# #strAcctMngrLName#
#strAcctMngrEmail#
(800) 605-5154 x#strAcctMngrPhoneExt#

<cfinclude template="/t_emailFooter.cfm">
</cfmail>
<!----  End Mail ----->
---->


<cfscript> 
LyrisHQObj =  createObject("component","/v16fj/extensions/components/LyrisHQ/LyrisHQ");
globalAPIPasswd = LyrisHQObj.getGlobalAPIPasswd();
WorkstreamSiteID = LyrisHQObj.getSiteID();
</cfscript>

<!---This is the List ID for JSAs in Lyris HQ--->
<cfset mailingListID = "5505">

<!---Demographic/Attribute ID for Job Title --->
<cfset demographicJobTitleID = "37478">

<!---Demographic/Attribute ID for Job Code --->
<cfset demographicJobCodeID = "37479">

<!---Demographic/Attribute ID for Account Manager First Name --->
<cfset demographicAMFNameID = "37996">

<!---Demographic/Attribute ID for Account Manager Last Name --->
<cfset demographicAMLNameID = "37997">

<!---Demographic/Attribute ID for Account Manager Email --->
<cfset demographicAMEmailID = "37998">

<!---Demographic/Attribute ID for Account Manager Phone Number --->
<cfset demographicAMPhoneNoID = "37999">

<!---Demographic/Attribute ID for Account Manager Phone Extension --->
<cfset demographicAMPhoneExtID = "38000">

<!---Mailing List Trigger ID for Job Application Notification for iCandidate Account--->
<cfset jobApplConfTriggerID = "3072">

<cfparam name="strAcctMngrPhoneNo" default="(800) 605-5154">

<cfoutput>

<cfscript>
recordStatus = LyrisHQObj.getRecordStatus('#jobemail#', '#mailingListID#');
</cfscript>

<cfset title = replace(title, "&", chr(38), "ALL")>
<cfset jcode = replace(jcode, "&", chr(38), "ALL")>

<cftry>
	<!---Do not send the email if the record is unsubscribed or bounced or Admin (trash)---> 
        
    <!---If the record already exists, update the record---->
    <cfif recordStatus eq "active">
		<!---Update the record to the Lyris List--->
        <cfsavecontent variable="LyrisDataSet">
            <DATASET>
                <SITE_ID>#WorkstreamSiteID#</SITE_ID>
                <MLID>#mailingListID#</MLID>
                <DATA type="email">#jobemail#</DATA>
                <DATA type="demographic" id="#demographicJobTitleID#">#title#</DATA>
                <DATA type="demographic" id="#demographicJobCodeID#">#jcode#</DATA>
                <DATA type="demographic" id="#demographicAMFNameID#">#strAcctMngrFName#</DATA>
                <DATA type="demographic" id="#demographicAMLNameID#">#strAcctMngrLName#</DATA>
                <DATA type="demographic" id="#demographicAMEmailID#">#strAcctMngrEmail#</DATA>
                <DATA type="demographic" id="#demographicAMPhoneNoID#">#strAcctMngrPhoneNo#</DATA>
                <DATA type="demographic" id="#demographicAMPhoneExtID#">#strAcctMngrPhoneExt#</DATA>
                <DATA type="extra" id="password">#globalAPIPasswd#</DATA>
            </DATASET>
        </cfsavecontent>
        
        <cfscript>
		updateRecordToList = LyrisHQObj.updateRecordToList(LyrisDataSet);
		</cfscript>
        		
        <!---Fire the trigger to send email--->
        <cfsavecontent variable="LyrisDataSet">
            <DATASET>
                <SITE_ID>#WorkstreamSiteID#</SITE_ID>
                <MLID>#mailingListID#</MLID>
                <DATA type="extra" id="trigger_id">#jobApplConfTriggerID#</DATA>
                <DATA type="extra" id="recipients">#jobemail#</DATA>
                <DATA type="extra" id="password">#globalAPIPasswd#</DATA>
            </DATASET>
        </cfsavecontent>
        
        <cfscript>
        fireTriggerToList = LyrisHQObj.fireTriggerToList(LyrisDataSet);
        </cfscript>
	 <!---If the record does not exist, add the record--->
    <cfelseif recordStatus eq "Can't find email address or unique id">
    	<!---Add the record to the Lyris List--->
        <cfsavecontent variable="LyrisDataSet">
            <DATASET>
                <SITE_ID>#WorkstreamSiteID#</SITE_ID>
                <MLID>#mailingListID#</MLID>
                <DATA type="email">#jobemail#</DATA>
                <DATA type="demographic" id="#demographicJobTitleID#">#title#</DATA>
                <DATA type="demographic" id="#demographicJobCodeID#">#jcode#</DATA>
                <DATA type="demographic" id="#demographicAMFNameID#">#strAcctMngrFName#</DATA>
                <DATA type="demographic" id="#demographicAMLNameID#">#strAcctMngrLName#</DATA>
                <DATA type="demographic" id="#demographicAMEmailID#">#strAcctMngrEmail#</DATA>
                <DATA type="demographic" id="#demographicAMPhoneNoID#">#strAcctMngrPhoneNo#</DATA>
                <DATA type="demographic" id="#demographicAMPhoneExtID#">#strAcctMngrPhoneExt#</DATA>
                <DATA type="extra" id="password">#globalAPIPasswd#</DATA>
            </DATASET>
        </cfsavecontent>
    	
    	<cfscript>
        addRecordToList = LyrisHQObj.addRecordToList(LyrisDataSet);
        </cfscript>
        
        <!---Fire the trigger to send email--->
        <cfsavecontent variable="LyrisDataSet">
            <DATASET>
                <SITE_ID>#WorkstreamSiteID#</SITE_ID>
                <MLID>#mailingListID#</MLID>
                <DATA type="extra" id="trigger_id">#jobApplConfTriggerID#</DATA>
                <DATA type="extra" id="recipients">#jobemail#</DATA>
                <DATA type="extra" id="password">#globalAPIPasswd#</DATA>
            </DATASET>
        </cfsavecontent>
        
        <cfscript>
        fireTriggerToList = LyrisHQObj.fireTriggerToList(LyrisDataSet);
        </cfscript>
	</cfif>
    
	<cfcatch type="any"></cfcatch>
</cftry>

</cfoutput>