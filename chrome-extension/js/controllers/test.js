define(['app', 'angular', 'lodash'], function(app, ng, _) {
	var module = ng.module('iptbot', []);

	module.controller('TestCtrl', function($scope) {
		$scope.phones = [
			{'name': 'phone1'},
			{'name': 'phone2'},
			{'name': 'phone3'}
		]
	});
});