part of iptservice;

abstract class DataStorage {
	Config _config;

	bool get open;
	Future<bool> connect();
	Future<int> getLastSeen();
	Future<bool>setLastSeen(int lastSeen);
	Future<List<TorrentFilter>> getFilters();
	void close();
}
