part of server;

class TorrentApi extends ApiBase {
	static final TorrentApi _instance = new TorrentApi._();

	factory TorrentApi() {
		return _instance;
	}
	TorrentApi._() : super();

	Future<ApiResponse> list({from: 0, limit: 10}) {
		if (from is! int) {
			from = int.parse(from);
		}

		if (limit is! int) {
			limit = int.parse(limit);
		}

		ApiResponse response = new ApiResponse();
		
		return
			storage.then((DataStorage storage) {
				return storage.getTorrents(from:from, limit:limit);
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