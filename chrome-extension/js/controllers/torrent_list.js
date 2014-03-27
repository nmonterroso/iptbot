define(['angular', 'lodash'], function(ng, _) {
	ng.module('iptbot.controllers')
		.controller('TorrentListController', ['$scope', 'ApiService', function($scope, api) {
			$scope.torrents = [];
			$scope.loaded = false;

			var lastLoad = 0,
				init = function() {
					getData();
				},
				getData = function() {
					api.get('torrent', 'list', {from: lastLoad}, function(list) {
						console.log(list);
					});
				};

			init();
		}]);
});