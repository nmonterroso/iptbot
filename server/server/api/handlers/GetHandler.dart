part of server;

class GetHandler extends ApiHandler {
	GetHandler() {
		_handlers.addAll({
				'torrent': new TorrentApi()
		});
	}
}
