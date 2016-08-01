<!--Slide Up the Non Education CPLs-->
<cfoutput><cfloop query="cfqGetNonEduCPLs">
<script>
$("##bln#intMemberID#No").click(function() {
	$("###intMemberID#Row").slideUp(1000);
	hiddenNonEduCPLs +=1;
	$("##showNonEduToggle").show();
});  	
</script>
</cfloop>

<!--Slide down the Non Education CPL's-->
<cfloop query="cfqGetNonEduCPLs">
<script>
$("##showNonEduCPLs").click(function() {
	$("###intMemberID#Row").slideDown(1000);
	if (hiddenNonEduCPLs > 0){
		hiddenNonEduCPLs = 0;
		$("##showNonEduToggle").hide();
	}
});  	
</script>
</cfloop>


<!--Slide Up the Education CPLs-->
<cfloop query="cfqGetEduCPLs">
<script>
$("##bln#intMemberID#No").click(function() {
	$("###intMemberID#Row").slideUp(1000);
	hiddenEduCPLs += 1;
	$("##showEduToggle").show();
});  	
</script>
</cfloop>

<!--Slide down the Education CPL's-->
<cfloop query="cfqGetEduCPLs">
<script>
$("##showEduCPLs").click(function() {
	$("###intMemberID#Row").slideDown(1000);
	if (hiddenEduCPLs > 0){
		hiddenEduCPLs = 0;
		$("##showEduToggle").hide();
	}
});  	
</script>
</cfloop></cfoutput>