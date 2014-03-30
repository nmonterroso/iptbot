part of server;

class TorrentApi extends ApiBase {
	static final TorrentApi _instance = new TorrentApi._();

	factory TorrentApi() {
		return _instance;
	}
	TorrentApi._() : super();

	Future<ApiResponse> list({until: 0, limit: 10}) {
		if (until is! int) {
			until = int.parse(until);
		}

		if (limit is! int) {
			limit = int.parse(limit);
		}

		ApiResponse response = new ApiResponse();
		
		return
			storage.then((DataStorage storage) {
				return storage.getTorrents(until:until, limit:limit);
			})
			.then((List<TorrentData> torrents) {
				List responseData = [];
				for (TorrentData t in torrents) {
					responseData.add({
						"id": t.torrentId,
						"title": t.title,
						"link": t.link,
						"detailLink": t.detailLink,
						"season": t.season,
						"episode": t.episode,
						"size": t.friendlySize,
						"date": t.date
					});
				}
				
				response._body = responseData;
				return new Future.value(response);
			});
	}

	Future<ApiResponse> dismiss(id) {
		ApiResponse response = new ApiResponse();

		return
			storage.then((DataStorage storage) {
				return storage.dismiss(id);
			})
			.then((dismissed) {
				response._code = dismissed ? 200 : 503;

				return new Future.value(response);
			});
	}
}