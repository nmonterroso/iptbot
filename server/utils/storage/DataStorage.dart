part of core;

abstract class DataStorage {
	bool get open;
	Future<bool> connect(Config config);
	Future<int> getLastSeen();
	Future<bool> setLastSeen(int lastSeen);
	Future<List<TorrentFilter>> getFilters();
	Future<List<TorrentData>> getTorrents({until: 0, limit: 20});
	Future<bool> dismiss(torrentId);
	Future<bool> isConnected();
	void close();
	
	Future _save(List<TorrentData> torrents);
	
	Future save(List<TorrentData> torrents) {
		if (torrents.length == 0) {
			return new Future.value(true);
		}
		
		return _save(torrents);
	}
}
