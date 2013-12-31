part of web;

class TorrentApi extends ApiBase {
	Future<ApiResponse> list() {
		return new Future.value(new ApiResponse().._body = 'this is a test'.._code = 200);
	}
}