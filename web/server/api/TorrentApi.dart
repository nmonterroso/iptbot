part of server;

class TorrentApi extends ApiBase {
	static final TorrentApi _instance = new TorrentApi._();

	factory TorrentApi() {
		return _instance;
	}
	TorrentApi._() : super();

	Future<ApiResponse> list() {
		ApiResponse response = new ApiResponse();
		
		return
			storage.then((DataStorage storage) {
				return storage.getTorrents();
			})
			.then((List<TorrentData> torrents) {
				List responseData = [];
				for (TorrentData t in torrents) {
					responseData.add({
						"id": t.torrentId,
						"title": t.title
					});
				}
				
				response._body = responseData;
				return new Future.value(response);
			});
	}
}