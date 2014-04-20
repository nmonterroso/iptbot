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

			$scope.download = function(id) {
				var torrentIndex = null;

				_.each($scope.torrents, function(torrent, i) {
					if (torrent.id == id) {
						torrentIndex = i;
						return false;
					}
				});

				if (torrentIndex == null) {
					console.log("unable to find torrent index for "+id);
					return;
				}

				$scope.torrents[torrentIndex].status = 'downloading';
				api.get(apiName, 'download', id,
					function(torrentData) {
						$scope.torrents[torrentIndex].status = 'completed';
					},
					function() {
						$scope.torrents[torrentIndex].status = 'failed';
					}
				);
			};

			$scope.getStatus = function(id) {
				var status = 'unknown';

				_.each($scope.torrents, function(torrent) {
					if (torrent.id == id) {
						status = torrent.status;
						return false;
					}
				});

				return status;
			};

			var apiName = 'torrent',
				getData = function() {
					$scope.loading = true;
					api.get(apiName, 'list', { limit: 0 }, function(list) {
						$scope.torrents = list;

						_.each($scope.torrents, function(torrent, i) {
							$scope.torrents[i].date = $.timeago(torrent.date);
							$scope.torrents[i].status = 'init';
						});

						$scope.loading = false;
					});
				};

			getData();
		}]);
});