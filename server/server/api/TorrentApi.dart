part of server;

class TorrentApi extends ApiBase {
	static final TorrentApi _instance = new TorrentApi._();
	static final String API_NAME = 'torrent';

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
				return storage.dismissTorrent(id);
			})
			.then((dismissed) {
				response._code = dismissed ? 200 : 503;

				return new Future.value(response);
			});
	}

	Future<ApiResponse> download(id) {
		ApiResponse response = new ApiResponse().._code = 200;

		return
			storage.then((DataStorage storage) => storage.getTorrent(id))
			.then((TorrentData torrent) {
				if (torrent == null) {
					response._code = 404;
					throw "unable to download torrent ${id}";
				}

				return new BTC().start(torrent);
			})
			.then((btcData) {
				if (btcData == null) {
					response._code = 500;
					throw "invalid torrent returned";
				}

				response._body = btcData;
				return dismiss(id);
			})
			.then((_) => response)
			.catchError((error) {
				print(error.toString());
				response._body = error.toString();
				return response;
			});
	}
}