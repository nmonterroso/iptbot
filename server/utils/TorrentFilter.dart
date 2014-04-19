part of core;

class TorrentFilter {
	int _subId;
	String _rootSystemLocation;
	List<String> _require = [];

	TorrentFilter.fromStorage(storageData) {
		_subId = storageData.id;
		_rootSystemLocation = (storageData.root_system_location as Blob).toString();
		_require.add(storageData.search);
	}

	Future<TorrentData> allow(TorrentData torrent) {
		String title = torrent.title.toLowerCase();

		for (String r in _require) {
			if (!title.contains(r.toLowerCase())) {
				return new Future.value(null);
			}
		}

		return new DirectoryWatcher(_rootSystemLocation).contains(torrent.season, torrent.episode)
		.then((contains) {
			TorrentData result = null;

			if (!contains) {
				torrent.subId = _subId;
				result = torrent;
			}
			
			return new Future.value(result);
		});
	}
}