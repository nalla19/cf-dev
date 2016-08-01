<cfparam name="serializedData"  default="">
<cfparam name="request.ikey" default="">
<cfparam name="excludeEmployerList" default="">

<cfif StructKeyExists(session.exec.queryParams, 'exclude') >
	<cfset excludeEmployerList=session.exec.queryParams.exclude />
</cfif>

<cfset queryParams = StructNew()/>

<cfloop collection="#params#" item="key">
	<cfif key neq "fq_njp_ex" OR key neq "hl.fl" OR key neq "facet_fields" OR key neq "qf">
		<cfset queryParams[key] = params[key] />
	</cfif>
</cfloop>

<cfoutput>
<form name="navForm" class="navSearchFilterForm" method="post" action="/jobs/?strKeyWords=#params['Q']#&strTitle=#session.exec.strTitle#&strLocation=#session.exec.strLocation#">
<cfloop from="1" to="#arraylen(nav)#" index="request.theField">
	<cfset request.theDisplay = nav[request.theField].XmlAttributes.name />

	<cfswitch expression="#nav[request.theField].XmlAttributes.name#">
		<cfcase value="nav_strNames">
			<cfset request.theDisplay="State"/>
			<cfset fqvar="nst"/>
		</cfcase>

		<cfcase value="nav_strCats">
			<cfset request.theDisplay="Industries"/>
			<cfset fqvar="nsc"/>
		</cfcase>

		<cfcase value="nav_jpname">
			<cfset request.theDisplay="Employer"/>
			<cfset fqvar="njp"/>
		</cfcase>

		<cfcase value="fltSalary_desiredLow">
			<cfset request.theDisplay="Salary"/>
			<cfset fqvar="fsd"/>
		</cfcase>

		<cfcase value="nav_strFuncs">
			<cfset request.theDisplay="Functions"/>
			<cfset fqvar="nsf"/>
		</cfcase>

		<cfcase value="nav_location">
			<cfset request.theDisplay="City/Town"/>
			<cfset fqvar="nl"/>
		</cfcase>

		<cfdefaultcase>
			<cfset request.theDisplay = nav[request.theField].XmlAttributes.name />
		</cfdefaultcase>
	</cfswitch>

	<cfif arraylen(nav[request.theField].XmlChildren) GT 0>
		<fieldset class="refine-group">
			<h4>#request.theDisplay#</h4>
			<!--- do all others as checkboxes --->
			<cfset request.i = 1 />
			<cfloop index="request.i" from="1" to="#arraylen(nav[request.theField].XmlChildren)#">	
				<cfset fieldquery="#chr(34)##nav[request.theField].XmlChildren[request.i].XmlAttributes['name']##chr(34)#"/>
					<cfset trimmedFieldQuery = replace(fieldquery, chr(34), "", "ALL") />
					<cfset fvar="form_q_#fqvar#">
					<cfset request.checked = "" />
					<cfset request.disabled = "" />

					<cfif NOT isdefined('#fvar#')>
						<cfif request.i EQ "1">
							<label for="all#request.theDisplay##request.ikey#" class="checkbox">
								<input type="checkbox" class="exclude" id="all#request.theDisplay##request.ikey#" name="all#request.theDisplay#" checked="checked" value="all#request.theDisplay#" disabled="disabled"/>
								All #request.theDisplay#
							</label>
						</cfif>

                        <!---Disable the check box--->
						<cfset findVal=excludeEmployerList.indexOf(trimmedFieldQuery) +1 />

						<cfif findVal>
                        	<cfset request.disabled = 'disabled="true"'>
                        </cfif>
					<cfelse>
						<cfif request.i EQ "1">
							<label for="all#request.theDisplay##request.ikey#" class="checkbox">
								<input type="checkbox" class="exclude" id="all#request.theDisplay##request.ikey#" name="all#request.theDisplay#" value="all#request.theDisplay#" disabled="disabled"/>
								All #request.theDisplay#
							</label>
						</cfif>

						<cfswitch expression="#fvar#">
							<cfcase value="form_q_njp">
								<cfset findVal=excludeEmployerList.indexOf(trimmedFieldQuery) +1/>
								<cfif arrayFindCustom(reMatch('\".*?\"',session.exec.fq_njp),#fieldquery#) gt 0 >
									<cfif findVal>
										<cfset request.disabled = 'disabled="true"'>
										<cfset request.checked = 'checked="checked"'>
									<cfelse>
										<cfset request.checked = 'checked="checked"'>
									</cfif>
								<cfelse>
									<!---Disable the check box--->
									<cfif findVal>
										<cfset request.disabled = 'disabled="true"'>
									</cfif>
								</cfif>
							</cfcase>

							<cfcase value="form_q_nsc">
								<cfif arrayFindCustom(reMatch('\".*?\"',session.exec.fq_nsc),#fieldquery#) gt 0 >
									<cfset request.checked = 'checked="checked"'>
								</cfif>
							</cfcase>

							<cfcase value="form_q_nst">
								<cfif arrayFindCustom(reMatch('\".*?\"',session.exec.fq_nst),#fieldquery#) gt 0 >
									<cfset request.checked = 'checked="checked"'>
								</cfif>
							</cfcase>

							<cfcase value="form_q_fsd">
								<cfif arrayFindCustom(reMatch('\".*?\"',session.exec.fq_fsd),#fieldquery#) gt 0 >
									<cfset request.checked = 'checked="checked"'>
								</cfif>
							</cfcase>

							<cfcase value="form_q_nl">
								<cfif arrayFindCustom(reMatch('\".*?\"',session.exec.fq_nl),#fieldquery#) gt 0 >
									<cfset request.checked = 'checked="checked"'>
								</cfif>
							</cfcase>

							<cfcase value="form_q_nsf">
								<cfif arrayFindCustom(reMatch('\".*?\"',session.exec.fq_nsf),#fieldquery#) gt 0 >
									<cfset request.checked = 'checked="checked"'>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfif>

					<cfif request.i EQ 4>
						<button type="button" class="btn-link searchFilterBtn" data-toggle="collapse" data-target="##navFilter#request.theField##request.ikey#" data-collapse-text="Show less">Show more</button>
						<div id="navFilter#request.theField##request.ikey#" class="collapse fade">
					</cfif>


					<label for="fld_#request.theField#_#request.i##request.ikey#" class="checkbox">
						<input type="checkbox" name="form_q_#fqvar#" id="fld_#request.theField#_#request.i##request.ikey#" value='#fieldquery#' #request.checked# #request.disabled# />
						<cfset navValue = nav[request.theField].XmlChildren[request.i].XmlAttributes['name'] />

	                    <!--- queryParams=#queryParams#<br /> --->
						<cfif fvar EQ "form_q_fsd">
							<!---
							$#nav[field].XmlChildren[i].XmlAttributes['name']#K (#nav[field].XmlChildren[i].XmlText#) <br/>
							--->
	                    	$#nav[request.theField].XmlChildren[request.i].XmlAttributes['name']#K (#nav[request.theField].XmlChildren[request.i].XmlText#)<br/>
	                    <cfelse>
							<!--- #nav[request.theField].XmlChildren[request.i].XmlAttributes['name']# (#nav[request.theField].XmlChildren[request.i].XmlText#) --->
							<cfif #nav[request.theField].XmlAttributes.name# is "nav_jpname">
								<cfif StructKeyExists(params, 'exclude')>
									<cfset temp = []/>
									<cfset p = #params.exclude#/>
									<cfloop from=1 to=#arraylen(params['exclude'])# index="x">
										<cfset temp[x] = p[x]/>
									</cfloop>
									<cfset indexVal = (temp.indexof("#navValue#") +1)/>
								
									<cfif indexVal gt 0>
										<cfset serializedData = "">
									<cfset a = #ArrayDeleteAt(temp,indexVal)#/>
									<cfif arraylen(temp) GT "0">
										<!--- cfset queryParams.exclude = temp/ --->
										<cfset serializedData = SerializeURLData(queryParams)>
									<cfelse>
										<cfset a = StructDelete(queryParams, 'exclude')/>
									</cfif>
									
								
									<cfset strURL = (
										"/jobs/" &
										"?start1=#params['start']#&" &
										"pgNo=#pgNo#&" &
										"including=" &
										#navValue#
									) />
									
									<del><a href='#strURL#'/>#nav[request.theField].XmlChildren[request.i].XmlAttributes['name']#</a> (#nav[request.theField].XmlChildren[request.i].XmlText#)</del> <a href='#strURL#'/><img src="/images/include-icon.png" width="9" height="9" border="0" /></a><br /> 						
									<cfelse>
										<cfset a = #ArrayAppend(temp, navValue)#/>
									<cfset queryParams.exclude = temp/>	
									<cfset strURL = (
										"/jobs/" &
										"?start1=#params['start']#&" &
										"pgNo=#pgNo#&" &
										"excluding=" &
										#navValue#
									) />
									<a href='#strURL#'/>#nav[request.theField].XmlChildren[request.i].XmlAttributes['name']#</a> (#nav[request.theField].XmlChildren[request.i].XmlText#) <a href='#strURL#'/><img src="/images/exclude-icon.png" width="9" height="9" border="0"/></a><br />
									</cfif>	
								<cfelse>
									<cfset value = [] />
								<cfset queryParams.exclude = []/>
								<cfset a = #ArrayAppend(value, navValue)#/>
								<cfset queryParams.exclude = #value# />

								<cfset strURL = (
									"/jobs/" &
										"?start1=#params['start']#&" &
										"pgNo=#pgNo#&" &
										"excluding=" &
										#navValue#
								) />
								<a href='#strURL#'/>#nav[request.theField].XmlChildren[request.i].XmlAttributes['name']#</a> (#nav[request.theField].XmlChildren[request.i].XmlText#) <a href='#strURL#'/><img src="/images/exclude-icon.png" width="9" height="9" border="0" /></a><br />
								</cfif>
                        	
                        	<cfelse>                    	
								#nav[request.theField].XmlChildren[request.i].XmlAttributes['name']# (#nav[request.theField].XmlChildren[request.i].XmlText#)
                       		</cfif>
	                    </cfif>
                   	</label>
			</cfloop>

			<!--- close the more options out --->
			<cfif arraylen(nav[request.theField].XmlChildren) GTE 4>
				</div>
			</cfif>

		</fieldset>
	</cfif>
</cfloop>

<input type="hidden" name="start" value="0"/>
</form>
</cfoutput>