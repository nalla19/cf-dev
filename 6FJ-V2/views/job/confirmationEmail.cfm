<cfoutput>

<cfset emailSubject = "Job Application Confirmation">
<cfif application.sourceapp EQ "6FigureJobs">
	<cfset emailSubject = "6FigureJobs Job Application Confirmation">
<cfelseif application.sourceapp EQ "SalesStars">
	<cfset emailSubject = "SalesStars Job Application Confirmation">
</cfif>

<cfset title = replace(title, "&", chr(38), "ALL")>
<cfset jcode = replace(jcode, "&", chr(38), "ALL")>

<cfif application.sourceapp eq "6FigureJobs">
	<cfset theURL = "http://www.6figurejobs.com">
<cfelseif application.sourceapp eq "SalesStars">
	<cfset theURL = "http://www.salesstars.com">
</cfif>

<cfsavecontent variable = "emailMessage">
<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
	<tr>
        <!--- MASTHEAD BEGIN --->
        <td width="350">
            <a href="#theURL#">
                <cfif application.sourceapp EQ "6FigureJobs">
                    <img src="#theURL#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.sourceapp#"><br><br>
                <cfelseif application.sourceapp EQ "SalesStars">
                    <img src="#theURL#/_includes/templates/assets/img/salesstars-logo-black-beta.png" border="0" alt="#application.sourceapp#">
                </cfif>
            </a>
        </td>
        <td width="250" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333;"><strong>Job Application Confirmation</strong></td>
        <!--- MASTHEAD END --->
	</tr>
</table>

<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
	<tr>
    	<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">

        <!--- COMMUNICATION MESSAGE BEGIN --->
		<span style="color:##333333;font-weight:bold;"><i>This is an automated response. Please do NOT reply.</i></span><br><br>
        <span style="font-size:18px; color:##9f58a2; font-weight:bold;">You have successfully applied to the following job.</span><br><br>

        <strong>#title#</strong><br>
        #jpname#<br>
        <cfif len(location)>
        	<cfif location neq "National">
            	#location#, #strState#<br><br>
            <cfelse>
            	#location#<br><br>
            </cfif>
        </cfif>
		
        
        This company will contact you directly if you meet their qualifications.<br><br>

        <!--- COMMUNICATION MESSAGE END --->
     	</td>
	</tr>
</table>

<br>

<table width="650" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
            <cfif application.sourceapp EQ "SalesStars">
                &copy; #year(now())# SalesStars.com | <a href="#theURL#/SalesStars_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/SalesStars_TOS.cfm">Terms of Use</a> | <a href="#theURL#/SalesStars_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
                <br />
                SalesStars.com | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
                <br /><br>
                You are receiving this job application confirmation because you applied to a job listing on SalesStars.com.
                <br /><br />
            <cfelse>
                &copy; #year(now())# 6FigureJobs.com | <a href="#theURL#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#theURL#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
                <br />
                6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
                <br /><br>
                You are receiving this job application confirmation because you applied to a job listing on 6FigureJobs.com
                <br /><br />
            </cfif>
        </td>
    </tr>
</table>
</cfsavecontent>

<!--- //Call the component to send the email// --->
<cfset application.emailManager.sendJobApplConfirmation(emailTo=ExecConfEmail, emailSubject=emailSubject, emailBody=emailMessage)>
    
</cfoutput>