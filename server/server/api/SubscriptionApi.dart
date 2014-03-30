part of server;

class SubscriptionApi extends ApiBase {
	static final SubscriptionApi _instance = new SubscriptionApi._();
	static final String API_NAME = 'subscription';

	factory SubscriptionApi() {
		return _instance;
	}
	SubscriptionApi._() : super();

	list() {
		ApiResponse response = new ApiResponse();

		return
			storage.then((DataStorage storage) {
				return storage.getSubscriptions();
			})
			.then((subscriptions) {
				response._body = [];
				for (var sub in subscriptions) {
					response._body.add({
						'id': sub['id'],
						'search': sub['search'],
						'location': sub['root_system_location']
					});
				}

				return new Future.value(response);
			});
	}

	remove(id) {
		return
			storage.then((DataStorage storage) {
				return storage.removeSubscription(id);
			})
			.then((removed) {
				return new Future.value(new ApiResponse().._code = removed ? 200 : 503);
			});
	}

	add({search, location}) {
		ApiResponse response = new ApiResponse()
			.._body = {
				'added': true,
			};

		Directory dir = new Directory(location);
		if (!dir.existsSync()) {
			response
				.._body['added'] = false
				.._body['error'] = "directory ${location} does not exist";

			return new Future.value(response);
		}

		return
			storage.then((DataStorage storage) {
				return storage.addSubscription(search, location);
			})
			.then((id) {
				response
					.._body['sub'] = {
						'id': id,
						'search': search,
						'location': location
					};

				return new Future.value(response);
			});
	}
}
