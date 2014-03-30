define(['angular', 'lodash', 'angular-route'], function(ng, _) {
	var modules = {
		'iptbot': ['ngRoute'],
		'iptbot.directives': [],
		'iptbot.services': [],
		'iptbot.controllers': []
	};

	_.each(modules, function(deps, module) {
		ng.module(module, deps);
	});

	require([
		'controllers/__init',
		'services/__init'
	], function() {
		ng.element(document).ready(function() {
			ng.bootstrap(document, _.keys(modules))
		})
	});
});