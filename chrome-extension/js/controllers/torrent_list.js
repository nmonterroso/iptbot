define(['angular', 'lodash', 'jquery', 'jquery.timeago'], function(ng, _, $) {
	ng.module('iptbot.controllers')
		.controller('TorrentListController', ['$scope', 'ApiService', function($scope, api) {
			$scope.torrents = [];
			$scope.loading = true;
			$scope.dismiss = function(id) {
				api.del('torrent', 'dismiss', id);

				$scope.torrents = _.filter($scope.torrents, function(torrent) {
					return torrent.id != id;
				});
			};

			var lastLoad = 0,
				limit = 10,
				maxDataReached = false,
				init = function() {
					getData(true);
				},
				getData = function(force) {
					force = force || false;

					if (maxDataReached || ($scope.loading && !force)) {
						return;
					}

					$scope.loading = true;
					api.get('torrent', 'list', {until: lastLoad, limit: limit}, function(list) {
						if (list.length == 0 || list.length < limit) {
							maxDataReached = true;
						}

						$scope.torrents = $scope.torrents.concat(list);

						_.each($scope.torrents, function(torrent, i) {
							$scope.torrents[i].date = $.timeago(torrent.date);
						});

						$scope.loading = false;
					});
				};

			init();
		}]);
});