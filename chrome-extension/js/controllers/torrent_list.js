define(['angular', 'lodash'], function(ng, _) {
	ng.module('iptbot.controlers')
		.controller('TorrentListController', ['$scope', 'ApiService', function($scope, api) {
			$scope.torrents = [];
			$scope.loaded = false;
		}]);
});