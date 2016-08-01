
function loadDashboards(dashboard) {
	if (dashboard === undefined) dashboard = '.dbContent'

	$(dashboard).each(function () {

		var $db = $(this);

		var url = $db.data('url') + "?" + top.jsIDSTR;

		$.ajax({
			type: "GET",
			url: url,
			beforeSend: function () { $db.addClass('loading'); },
			success: function(result) {
				$db.html(result);
				$db.removeClass('loading');
			}
		});
	});
}

$(document).ready(function() {
	loadDashboards();
});
