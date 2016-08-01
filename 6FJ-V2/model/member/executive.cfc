<cfcomponent output="false">
	
	<cfparam name="variables.dsn" default="6figs">
	
	<cffunction name="init" access="public" output="false" returntype="executive">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="dsnAllen" type="string" required="true" />
		<cfargument name="url" type="string" required="true" />
		<cfargument name="sourceApp" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			variables.dsnAllen = arguments.dsnAllen;
			variables.sourceApp = arguments.sourceApp;
			
		
			variables.url = arguments.url;
			

			return this;
		</cfscript>
	</cffunction>


	<cffunction name="getAllenClientData" access="public" returntype="query" hint="Get AAA Client Data Information" >
		<cfargument name="email" type="string" required="Yes" default="00000" hint="Email Address of User">
		<cfstoredproc procedure="ps_rsAllenUser" datasource="#variables.dsnAllen#">
			<cfprocparam type="In" cfsqltype="cf_sql_varchar" dbvarname="@email" value="#arguments.email#" null="no">
			<cfprocresult name="qgetAAA">
		</cfstoredproc>
		<cfreturn qgetAAA />
	</cffunction>

	<cffunction name="setAAAPremium" access="public" returntype="void" hint="Set's AAA Members to Premium" >
		<cfargument name="email" type="string" required="Yes" default="00000" hint="Email Address of User">
	    <cfquery datasource="#variables.dsn#">
		    update tblresumes set
		    	ispremium = 1
		    WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" />
	    </cfquery>
	</cffunction>



	<!--- Check To See Weather Username Is Take --->
	<cffunction name="isUsernameTaken" access="remote" returntype="void" hint="Returns Whether Username Exists or Not">
		<cfargument name="username" type="string" required="Yes" default="00000">
       	<!--- Define variables --->
		<cfset result = structNew()>
   		<cfset result.isvalid = 0>

		<!--- Username Not Default 0--->
		<cfif username neq 00000>
			<cfquery datasource="#variables.dsn#" name="checkUsername">
				 exec dbo.sp_exec_validateUsername '#arguments.username#';
			</cfquery>
			<cfscript>
				if (checkUsername.recordcount){
					result.isvalid = 0;
				}
				else{
					result.isvalid = 1;
				}
			</cfscript>
		</cfif>
		<!--- Parse To JavaScript --->
		<cfwddx action="cfml2js" input="#result#" toplevelvariable="r" />
	</cffunction>

	<cffunction name="isEmailTaken" access="remote" returntype="void" hint="Returns Whether Username Exists or Not">
		<cfargument name="email" type="string" required="Yes" default="00000" hint="email Address of User">
       	<!--- Define variables --->
		<cfset result = structNew()>
   		<cfset result.isvalid = 0>

		<!--- Username Not Default 0--->
		<cfif arguments.email neq 00000 and arguments.email contains "@" and arguments.email contains ".">
			<cfquery datasource="#variables.dsn#" name="checkEmail">
				 exec dbo.sp_exec_validateEmail '#arguments.email#';
			</cfquery>
			<cfscript>
				if (checkEmail.recordcount){
					result.isvalid = 0;
				}
				else{
					result.isvalid = 1;
				}
			</cfscript>
		</cfif>
		<!--- Parse To JavaScript --->
		<cfwddx action="cfml2js" input="#result#" toplevelvariable="r" />
	</cffunction>

	<cffunction name="getCities" access="remote" returntype="string" hint="Returns The List of Cities From A Given Zip">
		<cfargument name="citySearch" hint="City Keyword" type="string" required="yes">
        <cfargument name="zipCode" hint="Zip Code" type="string" required="yes">
       	<!--- Define variables --->
  			<cfset var getList="">
		<cfset var cityList = "">

           	<!--- Don't Send Database Information --->
           <cfif len(citySearch) lte 2>
           	<cfset cityList = "">
           	<!--- Use Database Now --->
           <cfelse>
               <cfquery datasource="#variables.dsn#" name="getList">
                SELECT CITY
                FROM TBL_ZIPCODES (NOLOCK)
                WHERE ZIPCODE = '#ARGUMENTS.zipcode#'
                AND CITY LIKE '#ARGUMENTS.citySearch#%'
               </cfquery>
           	<cfset cityList = ValueList(getList.city)>
           </cfif>


		<!--- And return it --->
 			<cfreturn cityList />
	</cffunction>



	<cffunction name="parseResume" access="public" output="false" returntype="string" hint="Parses Resume For 6FigureJobs Executives">
		<cfargument name="resumeFile" type="string" required="Yes" hint="Text of Actual Resume; Should Be Read By CFFILE if needed" />
		<cfargument name="outputNumber" type="numeric" required="no" default="1" hint="Output Type Of Tile (1,2,3,4)" />
		<cfset var resumeInfo = "" />
		<cfset var binaryFile = "" />
		<cfset var wsResult = "" />
		
		<cfif fileExists(arguments.resumeFile)>
		
			<cffile
				action = "readbinary"
				file = "#resumeFile#"
				variable = "binaryFile">
			
			<!--- Call the web service, asking that it convert the file to plain text. --->
			<cfinvoke 
					webservice="#variables.url#/scap/ConvertAndParse.asmx?WSDL"
					method="DoConversion" 
					returnvariable="wsResult">
				<cfinvokeargument name="DocumentAsByteArray" value="#binaryFile#"/>
				<cfinvokeargument name="OutputType" value="#getOutPutType(arguments.outputNumber)#"/>
			</cfinvoke>
			
			<cfset resumeInfo = wsResult.getString()[2] />
		
		</cfif>
		
		<cfreturn resumeInfo>
	</cffunction>

	<cffunction name="getHRXML" access="private" output="false" returntype="string" hint="Returns HR-XML For Resumes That Are Upload By The Executive">
		<cfargument name="resumeFile" type="string" required="Yes" hint="Text of Actual Resume; Should Be Read By CFFILE if needed" />
		<!---><cfset var parRes = parseResume(arguments.resumeFile) />--->
		<cfset var hrxml = "" />
		<cfset var binaryFile = "" />
		
		
		
		<cfif fileExists(arguments.resumeFile)>
		
			<cffile
				action = "readbinary"
				file = "#resumeFile#"
				variable = "binaryFile">
				
			
		
			<cfinvoke webservice="#variables.url#/scap/ConvertAndParse.asmx?WSDL" method="parse" returnvariable="hrxml">
				<cfinvokeargument name="DocumentAsByteArray" value="#binaryFile#"/>
				<cfinvokeargument name="ResumeOwner" value=""/>
				<cfinvokeargument name="ResumeIdsDelimitedByAmpersand" value=""/>
				<cfinvokeargument name="TimeOutInMs" value="30000"/>
				<cfinvokeargument name="HardTimeoutMultiplier" value="50"/>
				
				<cfinvokeargument name="ParserConfigurationParams" value="110000000000000001011010100100"/>
				<cfinvokeargument name="TaxonomyFilename" value=""/>
				<cfinvokeargument name="SkillsFilename" value=""/>
				<cfinvokeargument name="AlsoUseSovrenTaxonomy" value="true"/>
				<cfinvokeargument name="EmbedConvertedTextInHrXml" value="false"/>
				<cfinvokeargument name="SecurityCodeForSearchHints" value=""/>
				<cfinvokeargument name="RevisionDate" value=""/>

			</cfinvoke>

		</cfif>

		<cfreturn hrxml />
	</cffunction>

	<cffunction name="getStoredResumeID" access="public" output="false" returntype="string" hint="Parses Resume For 6FigureJobs Executives">
		<cfargument name="resumeFile" type="string" required="Yes" hint="Text of Actual Resume; Should Be Read By CFFILE if needed" />
                
		<cfscript>
			var myFile = CreateObject("java","java.io.File").init(arguments.resumeFile);
			var fis = CreateObject("java","java.io.FileInputStream").init(arguments.resumeFile);
			var nbrBytes = myFile.Length();
			var bytesArr = getByteArray(nbrBytes);
			var hrXML = "";
			var resumeTxt = "";
			var resumeid = "";
			
			fis.Read(bytesArr, 0, nbrBytes);

			hrXML = getHRXML(arguments.resumeFile);
			resumeTxt = parseResume(arguments.resumeFile);
		</cfscript>

		<cfinvoke webservice="#variables.url#/ssws/SovrenStorageWS.asmx?WSDL" method="storeFieldedData" returnvariable="resumeid">
			<cfinvokeargument name="ResumeAsByteArray" value="#bytesArr#"/>
			<cfinvokeargument name="ResumeAsPlainText" value=""/>
			<cfinvokeargument name="ResumeAsHrXml" value="#hrXML#"/>
		</cfinvoke>

		<!--- Set Resume Information Up Here --->
		<cfstoredproc procedure="spU_exec_SovernSetResume" datasource="#variables.dsn#">
			<cfprocparam type="In" cfsqltype="cf_sql_varchar" dbvarname="@consultantid" value="#resumeid#" null="no">
			<cfprocparam type="In" cfsqltype="cf_sql_varchar" dbvarname="@resume" value="#resumeTxt#" null="no">
            <cfprocparam type="In" cfsqltype="cf_sql_varchar" dbvarname="@sourceApp" value="#variables.sourceApp#" null="no">
		</cfstoredproc>

		<!--- <cflog text="resumeid - #resumeid#" file="resRedirect"> --->

		<cfreturn resumeid />
	</cffunction>



	<!--- Parsed Information, Rewrite For SP Purposes --->
	<cffunction name="getParsedConsultants" access="public" output="false" returntype="query" hint="Gets The Consultants By ID ##">
		<cfargument name="consultantid" type="string" required="yes" hint="Parsed Resume ID ##" />
		
		<cfstoredproc procedure="spS_exec_SovernGetConsultants" datasource="#variables.dsn#">
			<cfprocparam type="In" cfsqltype="cf_sql_varchar" dbvarname="@consultantid" value="#arguments.consultantid#" null="no">
			<cfprocresult name="getConsultants">
		</cfstoredproc>
		
		<cfreturn getConsultants />
	</cffunction>

	<cffunction name="getParsedPositions" access="public" output="false" returntype="query" hint="Gets The Consultants By ID ##">
		<cfargument name="consultantid" type="string" required="yes" hint="Parsed Resume ID ##" />

		<cfstoredproc procedure="spS_exec_SovernGetPositions" datasource="#variables.dsn#">
			<cfprocparam type="In" cfsqltype="cf_sql_varchar" dbvarname="@consultantid" value="#arguments.consultantid#" null="no">
			<cfprocresult name="getPositions">
		</cfstoredproc>

		<cfreturn getPositions />
	</cffunction>



	<cffunction name="getByteArray" access="private" returnType="binary" output="no" hint="Converts File To Binary Array">
	    <cfargument name="size" type="numeric" required="true"/>
	    <cfset var emptyByteArray = createObject("java", "java.io.ByteArrayOutputStream").init().toByteArray()/>
	    <cfset var byteClass = emptyByteArray.getClass().getComponentType()/>
	    <cfset var byteArray = createObject("java","java.lang.reflect.Array").newInstance(byteClass, arguments.size)/>
	    <cfreturn byteArray/>
	</cffunction>

	<cffunction name="getOutPutType" access="private" returntype="string" hint="Outputs The Various Formats For Parsing Resumes">
		<cfargument name="outputType" type="numeric" required="yes" hint="Number">
		<cfscript>
			var outPutInfo = "";
			switch (arguments.outputType){
				case 1:
					outPutInfo = "plain_text";
					break;
				case 2:
					outPutInfo = "html_formatted";
					break;
				case 3:
					outPutInfo = "html_plain";
					break;
				case 4:
					outPutInfo = "rtf";
					break;
				case 5:
					outPutInfo = "xml";
					break;
				default:
					outPutInfo = "plain_text";
			}
			return outPutInfo;
		</cfscript>
	</cffunction>



	<!--- Check Custom Questions --->
	<cffunction name="isCPLAnswered" returntype="boolean" hint="Check Duplicate CPL">
		<cfargument name="memberid" type="numeric" required="Yes" hint="Member ID Number" />
		<cfargument name="email" type="string" required="Yes" hint="Email Address" />
		<cfset var ValidCPL   =  1 />

		<!--- RecordCount --->
		<cfquery datasource="#variables.dsn#" name="getrequiredfields">
			select blnrequired,intquestionid,intFormFieldType,strFormFieldName
			from tblCplQuestions
			where intmemberid=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.memberid#" />
			and blnActive=1
			and blnInProgress=0
		</cfquery>

		<!--- RecordCount --->
		<cfif getrequiredfields.recordcount>
			<cfstoredproc procedure="sp_cpl_check_for_dup" datasource="#variables.dsn#" returncode="Yes">
				<cfprocparam type="IN" dbvarname="@intMemberID" value="#val(arguments.memberid)#" cfsqltype="CF_SQL_INTEGER">
				<cfprocparam type="IN" dbvarname="@strEmail" value="#arguments.email#" cfsqltype="CF_SQL_VARCHAR">
				<cfprocresult resultset="1" name="cfqCheckCPLDup">
			</cfstoredproc>
			
			<cfif not(cfqCheckCPLDup.recordcount)>
				<cfset ValidCPL = 0 />
			</cfif>
		</cfif>

		<cfreturn ValidCPL />
	</cffunction>

	<cffunction name="getResumeidByProfileid"  access="public" returntype="query" hint="Returns Resume ID From Profile ID">
		<cfargument name="profileid" type="string" required="Yes" hint="Profile ID">
		<!--- Username Not Default 0--->
		<cfquery datasource="#variables.dsn#" name="q">
			exec dbo.spS_ExecResumeidByProfileid '#arguments.profileid#';
		</cfquery>
		<cfreturn q />
	</cffunction>

	<cffunction name="getResumeidByEmail" access="public" returntype="query" hint="Returns Resume ID From Profile ID">
		<cfargument name="email" type="string" required="Yes" hint="Email Address">

		<cfif len(arguments.email) gt 5 and isvalid("email",arguments.email)>
			<!--- Username Not Default 0--->
			<cfquery datasource="#variables.dsn#" name="q">
				exec dbo.spS_ExecResumeidByEmail '#arguments.email#';
			</cfquery>
			<cfreturn q />
		</cfif>
	</cffunction>

	<cffunction name="getProfileidByResumeid"  access="public" returntype="query" hint="Returns Profile ID From Resume ID">
		<cfargument name="intresid" type="numeric" required="Yes" hint="Resume ID">
		<!--- Username Not Default 0--->
		<cfquery datasource="#variables.dsn#" name="q">
			exec dbo.spS_ExecProfileidByResumeid #arguments.intresid#;
		</cfquery>
		<cfreturn q />
	</cffunction>





	<!---Get the candidates first name given the email address--->
	<cffunction name="getFirstName" returntype="string" hint="Get the first Name given the email address">
		<cfargument name="email" type="string" required="yes" hint="Email Address" />
		<cfset var firstName = "">
		<cfset var cfqGetFirstName = "">
	
		<!--- Get the First Name --->
		<cfquery name="cfqGetFirstName" datasource="#variables.dsn#">
			select fname from tblResumes (nolock) where email = '#arguments.email#'
		</cfquery>
	
		<cfif cfqGetFirstName.recordcount gt 0>
			<cfset firstName = cfqGetFirstName.fname>
		</cfif>
	
		<cfreturn firstName />
	</cffunction>


</cfcomponent>