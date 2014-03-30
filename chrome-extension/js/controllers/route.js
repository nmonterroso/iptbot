define(['angular', 'lodash'], function(ng, _) {
	ng.module('iptbot')
		.controller('RouteController', function() {

		})
		.config(['$routeProvider', function($routeProvider) {
			$routeProvider
				.when('/torrents', {
					templateUrl: 'templates/torrents.html',
					controller: 'TorrentListController'
				})
				.when('/subscriptions', {
					templateUrl: 'templates/subscriptions.html',
					controller: 'SubscriptionController'
				})
				.otherwise({
					redirectTo: '/torrents'
				})
		}]);
});