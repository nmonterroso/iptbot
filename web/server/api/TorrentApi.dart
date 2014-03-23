part of server;

class TorrentApi extends ApiBase {
	Future<ApiResponse> list({id:0}) {
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