part of server;

class PostHandler extends ApiHandler {
	static final _instance = new PostHandler._();
	
	factory PostHandler() {
		return _instance;
	}
	PostHandler._() {
		_handlers.addAll({
			'torrent': new TorrentApi()
		});
	}
}