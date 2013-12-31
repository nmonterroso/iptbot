part of core;

class MysqlStorage extends DataStorage {
	ConnectionPool _pool;

	Future<bool> connect(Config config) {
		_pool = new ConnectionPool(host: config.mysqlHost, port: config.mysqlPort, user: config.mysqlUser, password: config.mysqlPass, db: config.mysqlDb);
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

	Future<bool> setLastSeen(int lastSeen) {
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
			})
			.catchError((error) {
				print(error.toString());
				return new Future.value(false);
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
			})
			.catchError((error) {
				print(error.toString());
			});
	}
	
	Future _save(List<TorrentData> torrents) {
		String sql = ""
			"REPLACE INTO `torrents`"
			"SET `sub_id`=?, `torrent_id`=?, `season`=?, `episode`=?, "
				"`title`=?, `link`=?, `date`=?, `size`=?";
		
		List<List<dynamic>> params = [];
		for (TorrentData t in torrents) {
			params.add([t._subId, t._torrentId, t._season, t._episode, t._title, t._link, t._date, t._size]);
		}
		
		return 
			_pool.prepare(sql)
			.then((query) {
				return query.executeMulti(params);
			})
			.then((results) {
				return new Future.value(true);
			})
			.catchError((error) {
				print(error.toString());
				return new Future.value(false);
			});
	}

	bool get open => _pool != null;
	void close() {
		// noop. sqljocky _pool.close() says it will probably break things.
	}
}