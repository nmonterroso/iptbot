part of server;

class GetHandler extends ApiHandler {
	GetHandler() {
		_handlers.addAll({
				TorrentApi.API_NAME: new TorrentApi(),
				SubscriptionApi.API_NAME: new SubscriptionApi()
		});
	}
}
