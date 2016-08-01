<cfparam name="request.thePackageFrm" default="">

<div class="page-pricing" id="page-package">

	<header class="page-header">
		<div class="container">
			<a href="/pricing" class="back">Pricing Packages &raquo;</a>
			<div class="row-fluid">
				<h1 class="span6">Setup your account</h1>
				<ol class="span6 pull-right steps">
					<li class="pull-left step step-1 step-active"><span class="step-label">1</span> Your information <span class="sep">&mdash;</span></li>
					<li class="pull-right step step-2"><span class="step-label">2</span> Payment details</li>
				</ol>
			</div>
		</div>
	</header>

	<article>
		<div class="container">
		
			<div class="modal-body">
				<div class="well well-large">
				<cfoutput>#request.thePackageFrm#</cfoutput>
				</div>
			</div>
			
		</div>
	</article>

</div>