
<cfset intResID =session.EXEC.intResID>
<cfset STRAPPADDTOKEN  = application.STRAPPADDTOKEN >
<cfparam name="tm" default="20"> <!--- Top menu (redesign) --->
<cfparam name="m" default="2"> <!--- main menu --->
<cfparam name="am" default="35"> <!--- active menu --->
<cfparam name="asm" default="0"> <!--- active sub-menu --->
<cfoutput>
<div class="page-dashboard">
	<article class="section">
		<div class="container">
		<h1 class="page-title">Application History</h1>
		<div class="table-responsive"><br>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<cfif (session.EXEC.blnValidLogin neq 1) or (session.EXEC.intResID is "") OR (session.EXEC.blnBigs neq 1)>
							<!---ISR <table border="0" cellpadding="6" cellspacing="0" width="100%">
								<tr><td><cfinclude template="t_PagePasswordText.cfm"></td></tr>
							</table> --->
						<cfelse>
							<!--- delete marked records if form.listDelOneClickIDs is not "" --->
							<cfparam name="form.submitAction" default="">
							<cfparam name="listDelOneClickIDs" default="">
							<cfif (form.submitAction eq "Delete Marked Records") and (listDelOneClickIDs is not "")>
								<cftransaction>
									<cfset number=ListLen(listDelOneClickIDs)>
									<cfloop list="#listDelOneClickIDs#" index="ListElement">
										<cfquery datasource="#application.dsn#">  
											delete from tblOneClickHist where intresid=#intResID# and dteSubmit='#ListElement#'
										</cfquery>
									</cfloop>				
									<cflock scope="session" timeout="10" type="Exclusive">
									 <cfparam name="session.SearchJobs.NbrAppHist" default="">
									 <cfif session.SearchJobs.NbrAppHist neq "">
									  <cfset session.SearchJobs.NbrAppHist=(session.SearchJobs.NbrAppHist - number)>
									 </cfif>
									</cflock>
								</cftransaction>
							</cfif> 
							<!--- get one-click history --->
							<cfquery name="cfqOneClick" datasource="#application.dsn#">
							select tblOneClickHist.*, convert(varchar,tblOneClickHist.dteSubmit,121) as dteCreated, tblJobs.title, tblJobs.jpname, blnActive
							from tblOneClickHist (NOLOCK), tblJobs (NOLOCK)
							where intresid=#intResID# and tblOneClickHist.intJobID=tblJobs.intJobID
							order by dteSubmit DESC
							</cfquery>
					
							<cflock scope="session" timeout="10" type="Exclusive">
								<cfparam name="session.SearchJobs.NbrAppHist" default="">
								<cfif session.SearchJobs.NbrAppHist eq ""> <!--- if not initialized --->
									<cfset session.SearchJobs.NbrAppHist=cfqOneClick.RecordCount>
								</cfif>
							</cflock>
					
							<table class="table table-striped table-bordered">
								<!--- ISR ---><form action="ExecOneClickHistory.cfm?#strAppAddToken#&am=#am#&tm=#tm#" method="post" name="oneClickHistory">
								<cfif cfqOneClick.RecordCount eq 0>
									<tr><td colspan="5" class="exec_lite_gry" align="center" style="padding:10px 0 10px 0;"><strong>You have no applications on record.</strong></td></tr>    
								<cfelse>
									<thead>
									<tr><td colspan="5" style="font-size:13px; font-weight: bold;">Below are the positions that you have applied to.</td></tr>
								
									<tr><td colspan="5">Records <b><cfif cfqOneClick.RecordCount gt 0>1 to #cfqOneClick.RecordCount#<cfelse>0</cfif></b>.</td></tr>
									
									<tr>
										<th style="text-align:left;">Delete</th>
										<th style="text-align:left;">Title</th>
										<th style="text-align:left;">Company</th>
										<th style="text-align:left;">Applied</th>
										<th style="text-align:left;">Active</th>
									</tr>
									</thead>
									<tbody>
									<cfloop query="cfqOneClick">
										<cfif currentRow mod 2 eq 0>
											<cfset td_class="exec_lite_gry">
										<cfelse>
											<cfset td_class="exec_dark_gry">
										</cfif>  
										<tr>
											<td class="span1" style="text-align:left;"><input type="checkbox" name="listDelOneClickIDs" value="#dteCreated#"></td>
											<cfparam name="titledisplay" default="">
											<cfif title neq "">
												<!--- remove the quotes ---> 
												<cfset titledisplay = application.util.getRemoveQuotes(strStrip="#Title#",  blnRemove="0")>
											</cfif>
											<td class="span2" style="text-align:left;">
												<!--- ISR ---><a href="/member-job-detail?#strAppAddToken#&intJobID=#intJobID#&am=#am#&tm=#tm#" title="#titledisplay#">#titledisplay#</a>
											</td>				
											<td class="span2" style="text-align:left;">#jpname#</td>				
											<td class="span1" style="text-align:left;">#DateFormat(dteSubmit, 'dd mmm yyyy')#</td>				
											<td class="span1" style="text-align:left;">#YesNoFormat(blnActive)#</td>
										</tr>
									</cfloop>
									</tbody>
									<tr><td colspan="5"><img src="/img/spacer.gif" border=0 height=5></td></tr>
									<tr>
										<td align="left" colspan="5">
											
											<button class="btn btn-large btn-primary" type="submit" name="submitAction" value="Delete Marked Records" onclick="document.oneClickHistory.submit()">Delete Marked Record(s)</button>
											
										</td>
									</tr>
								</cfif>
								</form>
							</table>
						</cfif>
					</td>
				</tr>
			</table>
			</div>
			</div>
			
	</article>
</div>
</cfoutput>