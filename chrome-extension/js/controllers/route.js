define(['angular', 'lodash', 'jquery', 'angular-route'], function(ng, _, $) {
	ng.module('iptbot')
		.controller('RouteController', ['$scope', function($scope) {

		}])
		.directive('navItem', function() {
			return {
				link: function(scope, e, attrs) {
					$(e).click(function() {
						window.location = window.location.origin + window.location.pathname + '#/'+attrs.location;
						$('#nav li').removeClass('selected');
						$(this).addClass('selected');
					});
				}
			}
		})
		.config(['$routeProvider', function($routeProvider) {
			$routeProvider
				.when('/torrents', {
					templateUrl: 'torrents.html',
					controller: 'TorrentListController'
				})
				.when('/subscriptions', {
					templateUrl: 'subscriptions.html',
					controller: 'SubscriptionController'
				})
				.otherwise({
					redirectTo: '/torrents'
				})
		}]);
});