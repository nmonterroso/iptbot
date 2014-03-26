define([
	'angular',
	'lodash'
],
function(ng, _) {
	var modules = [
		'iptbot',
		'iptbot.directives',
		'iptbot.services',
		'iptbot.controllers'
	];

	_.each(modules, function(module) {
		ng.module(module, []);
	});

	require([
		'controllers/__init',
		'services/__init'
	], function() {
		ng.element(document).ready(function() {
			ng.bootstrap(document, modules)
		})
	});
});