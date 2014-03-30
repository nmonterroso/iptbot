part of server;

class PostHandler extends ApiHandler {
	static final _instance = new PostHandler._();
	
	factory PostHandler() {
		return _instance;
	}

	PostHandler._() {
		_handlers.addAll({
				TorrentApi.API_NAME: new TorrentApi(),
				SubscriptionApi.API_NAME: new SubscriptionApi()
		});
	}
}