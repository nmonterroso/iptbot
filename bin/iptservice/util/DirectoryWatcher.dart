part of iptservice;

class DirectoryWatcher {
	static Map<String, DirectoryWatcher> _cache = new Map<String, DirectoryWatcher>();
	
	Map<int, List<int>> _episodeList = new Map<int, List<int>>();
	String _directoryPath;
	Stream<FileSystemEvent> _watcher;
	StreamSubscription<FileSystemEvent> _watcherSub;
	
	factory DirectoryWatcher(String directoryPath) {
		if (!_cache.containsKey(directoryPath)) {
			_cache[directoryPath] = new DirectoryWatcher._(directoryPath);
		}
		
		return _cache[directoryPath];
	}
	DirectoryWatcher._(this._directoryPath);
	
	Future<bool> contains(int season, int episode) {
		Future f;
		
		if (_watcher == null) {
			f = watch();
		} else {
			f = new Future.value(true);
		}
		
		return f.then((_) {
			return new Future.value(_episodeList.containsKey(season) && _episodeList[season].contains(episode));
		});
	}
	
	Future watch() {
		Directory dir = new Directory(_directoryPath);
		
		return dir
		.list(recursive: true, followLinks: false)
		.forEach((FileSystemEntity entity) {
			FileSystemEntity.isFile(entity.path)
			.then((isFile) {
				if (isFile) {
					List<int> details = TorrentData.getSeasonAndEpisode(path.split(entity.path).last);
					int season = details[0], episode = details[1];
					_episodeListAdd(season, episode);
				}
			})
			.catchError((error) {
				print(error.toString());
			});
		})
		.whenComplete(() {
			_watcher = dir.watch(events: FileSystemEvent.CREATE, recursive: true);
			_watcherSub = _watcher.listen(_onSubEvent);
		});
	}
	
	void _onSubEvent(FileSystemEvent event) {
		if (event is FileSystemCreateEvent) {
			_onFileCreate(event);
		}
	}
	
	void _onFileCreate(FileSystemCreateEvent event) {
		if (event.isDirectory) {
			return;
		}
		
		try {
			List<int> details = TorrentData.getSeasonAndEpisode(path.split(event.path).last);
			int season = details[0], episode = details[1];
			_episodeListAdd(season, episode);
		} catch (error) {}
		
	}
	
	void _episodeListAdd(season, episode) {
		if (!_episodeList.containsKey(season)) {
			_episodeList[season] = [];
		}
		
		if (!_episodeList[season].contains(episode)) {
			_episodeList[season].add(episode);
		}
	}
}