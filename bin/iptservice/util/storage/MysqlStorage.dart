part of iptservice;

class MysqlStorage extends DataStorage {
	Config _config;
	ConnectionPool _pool;

	MysqlStorage(this._config);
  
	Future<bool> connect() {
		_pool = new ConnectionPool(host: _config.mysqlHost, port: _config.mysqlPort, user: _config.mysqlUser, password: _config.mysqlPass, db: _config.mysqlDb);
		return new Future.value(true);
	}

	Future<int> getLastSeen() {
		String sql = ""
			"SELECT `value`"
			"FROM `vars`"
			"WHERE `key`='last_seen_torrent_id'";

		return
			_pool.query(sql)
			.then((result) {
				return result.first;
			})
			.then((row) {
				return new Future.value(int.parse(row[0]));	
			})
			.catchError((error) {
				print(error.toString());
				return new Future.value(0);
			});
	}

	Future<bool>setLastSeen(int lastSeen) {
		if (lastSeen == null) {
			return new Future.value(false);
		}
		
		String sql = ""
			"REPLACE INTO `vars`"
			"SET `key`='last_seen_torrent_id', `value`=?";
		
		return
			_pool.prepareExecute(sql, [lastSeen])
			.then((result) {
				return new Future.value(true);
			});
	}
	
	Future<List<TorrentFilter>> getFilters() {
		List<TorrentFilter> filters = [];
		String sql = ""
			"SELECT `id`, `search`, `root_system_location`"
			"FROM `subs`";
		
		return
			_pool.query(sql)
			.then((results) {
				return results.forEach((row) {
					filters.add(new TorrentFilter.fromStorage(row));
				});
			})
			.then((result) {
				return new Future.value(filters);
			});
	}

	bool get open => _pool != null;
	void close() {
		// noop. sqljocky _pool.close() says it will probably break things.
	}
}