define([
	'angular',
	'lodash'
],
function(ng, _) {
	require([
		'controllers/__init'
	], function() {
		ng.element(document).ready(function() {
			ng.bootstrap(document, ['iptbot'])
		})
	});
});