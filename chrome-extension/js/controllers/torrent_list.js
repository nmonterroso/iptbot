define(['angular', 'lodash'], function(ng, _) {
	ng.module('iptbot.controlers')
		.controller('TorrentListController', ['$scope', 'ApiService', function($scope, api) {
			$scope.torrents = [];
			$scope.loaded = false;

			var lastLoad = 0,
				init = function() {
					getData();
				},
				getData = function() {
					api.get('torrent', 'list', {'since': lastLoad}, function(list) {
						_.each()
					});
				};
		}]);
});