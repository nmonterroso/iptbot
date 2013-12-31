part of public;

@NgController(
	selector: 'index',
	publishAs: 'index'
)
class IndexController {
	List<TorrentData> torrents;
	Http _http;
	
	IndexController(Http this._http) {
		_loadData();
	}
	
	void _loadData() {
		// should be a GET for a proper REST call, but meh, this is easier.
		_http.post('/torrent/list', "dummy data")
		.then((HttpResponse response) {
			
		});
	}
}