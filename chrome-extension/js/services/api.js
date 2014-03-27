define(['angular', 'lodash', 'config'], function(ng, _, config) {
	ng.module('iptbot.services')
		.factory('ApiService', ['$http', function($http) {
			var self = this;

			this.get = function(api, method /**, args..., params, onSuccess, onFailure */) {
				var args = extractApiArgs(arguments);
				$http.get(args.url, {
					params: args.params
				}).then(
					function(response) {
						args.success(response.data);
					},
					function(e) {
						args.failure(e);
					}
				)
			};

			this.post = function(api, method /**, args..., params, onSuccess, onFailure */) {
				var args = extractApiArgs(arguments);
			};

			var extractApiArgs = function(args) {
				var params = {}, onSuccess, onFailure, removeAmount = 0;
				onFailure = onSuccess = noop;

				_.eachRight(args, function(arg) {
					if (_.isFunction(arg)) {
						if (onFailure == noop) {
							++removeAmount;
							onFailure = arg;
						} else if (onSuccess == noop) {
							onSuccess = arg;
							++removeAmount;
						} else {
							throw "Too many callbacks provided.";
						}
					} else if (_.isPlainObject(arg)) {
						params = arg;
						++removeAmount;
						return false; // params should be the first non url arg
					} else {
						return false;
					}
				});

				// only one cb provided - it's a success cb
				if (onFailure != noop && onSuccess == noop) {
					onSuccess = onFailure;
					onFailure = noop;
				}

				var url = buildRequestUrl(_.initial(args, removeAmount));

				return {
					url: url,
					success: onSuccess,
					failure: onFailure,
					params: params
				};
			};

			var buildRequestUrl = function(pathParts) {
				var url = config.server+'api';

				_.each(pathParts, function(arg) {
					url += '/'+arg;
				});

				return url;
			};

			var noop = function() {};

			return this;
		}]);
});