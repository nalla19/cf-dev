<cfoutput>
<cfsavecontent variable = "emailMessage">
<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
	<tr>
        <!--- MASTHEAD BEGIN --->
        <td width="350">
            <a href="http://#cgi.HTTP_HOST#">
                <cfif application.applicationName EQ "6FigureJobs">
                    <img src="http://#cgi.HTTP_HOST#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.applicationName#"><br><br>
                <cfelseif application.applicationName EQ "SalesStars">
                    <img src="http://#cgi.HTTP_HOST#/_includes/templates/assets/img/salesstars-logo-black-beta.png" border="0" alt="#application.applicationName#">
                </cfif>
            </a>
        </td>
        <!--- MASTHEAD END --->
	</tr>
</table>

<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
	<tr>
    	<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">

        	<!--- COMMUNICATION MESSAGE BEGIN --->
			<table>
				<tr>	
					<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Full Name:</strong></td>
					<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLFname# #CPLLname#</td>
				</tr>
					
				<tr>
					<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Email:</strong></td>
					<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLEmail#</td>
				</tr>
					
				<tr>
					<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Day Phone:</strong></td>
					<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLDPhone#</td>
				</tr>
					
				<tr>
					<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Evening Phone:</strong></td>
					<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLEPhone#</td>
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
					<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Country:</strong></td>
					<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#lcl_cntry#</td>
				</tr>
				
				<tr>
					<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Zip:</strong></td>
					<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CPLZip#</td>
				</tr>
					
				<tr>
					<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Visitor IPAddress:</strong></td>
					<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">#CGI.REMOTE_ADDR#</td>
				</tr>
				
				<tr>
					<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>How Did You Hear:</strong></td>
					<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">6FigureJobs</td>
				</tr>
					
				<cfif listFind(cpl_AddFieldsList, 1) gt 0>
					<tr>
						<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Education Level:</strong></td>
						<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><cfif len(strEducationLevel)>#strEducationLevel#<cfelse>Information not supplied</cfif></td>
					</tr>
				</cfif>
					
				<cfif listFind(cpl_LoggedInFieldsList, 1) gt 0>
					<tr>
						<td align="right" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><strong>Additional Comment:</strong></td>
						<td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;"><cfif len(strAddtComments)>#strAddtComments#<cfelse>Information not supplied</cfif></td>
					</tr>
				</cfif>
			</table>
	    	<!--- COMMUNICATION MESSAGE END --->
     	</td>
	</tr>
</table>

<br>

<table width="650" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
            <cfif application.applicationName EQ "SalesStars">
                &copy; 2013 SalesStars.com | <a href="http://#cgi.HTTP_HOST#/SalesStars_PrivacyStatement.cfm">Privacy</a> | <a href="http://#cgi.HTTP_HOST#/SalesStars_TOS.cfm">Terms of Use</a> | <a href="http://#cgi.HTTP_HOST#/SalesStars_ContactUs.cfm">Contact</a> | <a href="http://#cgi.HTTP_HOST#/sitemap.cfm">Site Map</a>
                <br />
                SalesStars.com | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
                <br /><br>
                You are receiving this job application confirmation because you applied to a job listing on SalesStars.com.
                <br /><br />
            <cfelse>
                &copy; 2013 6FigureJobs.com | <a href="http://#cgi.HTTP_HOST#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="http://#cgi.HTTP_HOST#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="http://#cgi.HTTP_HOST#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="http://#cgi.HTTP_HOST#/sitemap.cfm">Site Map</a>
                <br />
                6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
                <br /><br>
                You are receiving this email because you recently opted-in to receive information from a 6FigureJobs affiliate.
				<br /><br>
 				This email is a confirmation of your request for information
                <br /><br />
            </cfif>
        </td>
    </tr>
</table>
</cfsavecontent>

<!---EmailID where the email needs to be sent out--->
<cfset emailList="">
<cfset emailList=ListAppend(emailList,toEmail)>
<cfset emailList=ListAppend(emailList,toEmailbcc)>

<cfif cgi.HTTP_HOST EQ "www.6figurejobs.com" OR cgi.HTTP_HOST EQ "6figurejobs.com">
	<cfloop list="#emailList#" delimiters="," index="emailID">
		<!--- Send Email --->
		<cfmail to="#emailID#" from="leadgeneration@6figurejobs.com" subject="#subject#" type="html">
		#emailMessage#
		</cfmail>	   
	</cfloop>
<cfelse>
	#emailMessage#
	<cfabort>
</cfif>



</cfoutput>