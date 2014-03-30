define(['angular', 'lodash', 'jquery'], function(ng, _, $) {
	ng.module('iptbot.controllers')
		.controller('SubscriptionController', ['$scope', 'ApiService', function($scope, api) {
			$scope.subs = [];
			$scope.loading = false;
			$scope.sub = {
				search: '',
				location: ''
			};

			$scope.validate = function() {
				return $scope.sub.search != '' && $scope.sub.location != '';
			};

			$scope.subscribe = function() {
				api.post(apiName, 'add', {
					search: $scope.sub.search,
					location: $scope.sub.location
				}, function(response) {
					if (!response.added) {
						alert(response.error);
						return;
					}

					$scope.subs.unshift({
						id: response.sub.id,
						search: response.sub.search,
						location: response.sub.location
					});
				});
			};

			$scope.unsubscribe = function(id) {
				api.del(apiName, 'remove', id);

				$scope.subs = _.filter($scope.subs, function(sub) {
					return sub.id != id;
				});
			};

			var apiName = 'subscription',
				getData = function() {
					$scope.loading = true;
					api.get(apiName, 'list', function(list) {
						$scope.subs = list;
						$scope.loading = false;
					});
				};

			getData();
		}]);
});