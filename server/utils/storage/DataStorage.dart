part of core;

abstract class DataStorage {
	bool get open;
	Future<bool> connect();
	Future<int> getLastSeen();
	Future<bool> setLastSeen(int lastSeen);
	Future<List<TorrentFilter>> getFilters();
	Future<List<TorrentData>> getTorrents({until: 0, limit: 20});
	Future<bool> dismissTorrent(torrentId);
	Future<bool> isConnected();
	Future<bool> removeSubscription(subId);
	Future<List> getSubscriptions();
	Future<int> addSubscription(search, location);
	void close();
	
	Future _save(List<TorrentData> torrents);
	
	Future save(List<TorrentData> torrents) {
		if (torrents.length == 0) {
			return new Future.value(true);
		}
		
		return _save(torrents);
	}
}
