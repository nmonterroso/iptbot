part of iptservice;

abstract class DataStorage {
	bool get open;
	Future<bool> connect(Config config);
	Future<int> getLastSeen();
	Future<bool>setLastSeen(int lastSeen);
	Future<List<TorrentFilter>> getFilters();
	void close();
	
	Future _save(List<TorrentData> torrents);
	
	Future save(List<TorrentData> torrents) {
		if (torrents.length == 0) {
			return new Future.value(true);
		}
		
		return _save(torrents);
	}
}
