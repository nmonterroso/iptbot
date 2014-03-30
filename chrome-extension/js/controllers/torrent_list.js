define(['angular', 'lodash', 'jquery', 'jquery.timeago'], function(ng, _, $) {
	ng.module('iptbot.controllers')
		.controller('TorrentListController', ['$scope', 'ApiService', function($scope, api) {
			$scope.torrents = [];
			$scope.loading = true;
			$scope.dismiss = function(id) {
				api.del(apiName, 'dismiss', id);

				$scope.torrents = _.filter($scope.torrents, function(torrent) {
					return torrent.id != id;
				});
			};

			var apiName = 'torrent',
				getData = function() {
					$scope.loading = true;
					api.get(apiName, 'list', { limit: 0 }, function(list) {
						$scope.torrents = list;

						_.each($scope.torrents, function(torrent, i) {
							$scope.torrents[i].date = $.timeago(torrent.date);
						});

						$scope.loading = false;
					});
				};

			getData();
		}]);
});