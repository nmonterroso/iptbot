define(['angular', 'lodash', 'config'], function(ng, _, config) {
	ng.module('iptbot.services')
		.service('ApiService', [, function() {
			var self = this;
			self.methodGet = 'GET';
			self.methodPost = 'POST';

			this.get = function(api, method /**, args..., params, onSuccess, onFailure */) {
				var args = extractApiArgs(self.methodGet, arguments);
				return self.invoke.apply(self, args);
			};

			this.post = function(api, method /**, args..., params, onSuccess, onFailure */) {
				var args = extractApiArgs(self.methodPost, arguments);
				return self.invoke.apply(self, args);
			};

			this.invoke = function(method, url, onSuccess, onFailure, params) {
				console.log(method, url, onSuccess, onFailure, params);
			};

			var extractApiArgs = function(requestMethod, args) {
				var params = {}, onSuccess, onFailure, removeAmount = 0;
				onFailure = onSuccess = noop;

				_.eachRight(args, function(arg) {
					if (_.isFunction(arg)) {
						if (onFailure == null) {
							++removeAmount;
							onFailure = arg;
						} else if (onSuccess == null) {
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
				if (onFailure != null && onSuccess == null) {
					onSuccess = onFailure;
					onFailure = noop;
				}

				var url = buildRequestUrl(_.initial(args, removeAmount));

				return [requestMethod, url, onSuccess, onFailure, params];
			};

			var buildRequestUrl = function() {
				var url = config.server+'api';

				_.each(arguments, function(arg) {
					url += '/'+arg;
				});

				return url;
			};

			var noop = function() {};

			return this;
		}]);
});