part of core;

class MysqlStorage extends DataStorage {
	ConnectionPool _pool;
	Config _config;

	MysqlStorage(this._config);

	Future<bool> connect() {
		_pool = new ConnectionPool(host: _config.mysqlHost, port: _config.mysqlPort, user: _config.mysqlUser, password: _config.mysqlPass, db: _config.mysqlDb);
		return new Future.value(true);
	}
	
	Future<bool> isConnected() {
		return new Future.value(_pool != null);
	}

	Future<int> getLastSeen() {
		String sql =
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
		
		String sql =
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
		String sql =
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
		String sql =
			"REPLACE INTO `torrents`"
			"SET `sub_id`=?, `torrent_id`=?, `season`=?, `episode`=?, "
				"`title`=?, `link`=?, `date`=?, `size`=?";
		
		List<List<dynamic>> params = [];
		for (TorrentData t in torrents) {
			params.add([t.subId, t.torrentId, t.season, t.episode, t.title, t.link, t.date, t.size]);
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
	
	Future<List<TorrentData>> getTorrents({until: 0, limit: 20}) {
		List<TorrentData> torrents = [];
		List<dynamic> params = [];

		String sql =
			"SELECT *, unix_timestamp(str_to_date(`date`, '%a, %d %b %Y %T')) AS date_read "
			"FROM `torrents` "
			"WHERE `dismissed` = 0 ";

		if (until > 0) {
			sql += "AND date_read < FROM_UNIXTIME(?)";
			params.add(until);
		}

		sql += "ORDER BY date_read DESC ";

		if (limit > 0) {
			sql += "LIMIT ?";
			params.add(limit);
		}


		return
			_pool.prepareExecute(sql, params)
			.then((results) {
				return results.forEach((row) {
					torrents.add(new TorrentData.fromStorage(row));
				});
			})
			.then((_) {
				return new Future.value(torrents);
			})
			.catchError((error) {
				print(error.toString());
				return new Future.value([]);
			});
	}

	Future<bool> dismissTorrent(torrentId) {
		String sql =
			"UPDATE `torrents` "
			"SET `dismissed`=1 "
			"WHERE `torrent_id`=?";

		return _pool.prepareExecute(sql, [torrentId])
			.then((_) {
				return new Future.value(true);
			})
			.catchError((error) {
				print(error.toString());
				return new Future.value(false);
			});
	}

	Future<List> getSubscriptions() {
		String sql =
			"SELECT * "
			"FROM `subs` "
			"ORDER BY `search` ASC";
		List subs = [];

		return _pool.query(sql)
			.then((results) {
				return results.forEach((row) {
					subs.add({
						'id': row.id,
						'search': row.search,
						'root_system_location': (row.root_system_location as Blob).toString()
					});
				});
			})
			.then((_) {
				return new Future.value(subs);
			});
	}

	Future<bool> removeSubscription(subId) {
		String sql =
			"DELETE FROM `subs` "
			"WHERE `id`=?";

		return _pool.prepareExecute(sql, [subId])
			.then((_) {
				return new Future.value(true);
			});
	}

	Future<int> addSubscription(search, location) {
		String sql =
			"INSERT INTO "
			"`subs` SET `search`=?, `root_system_location`=?";

		return _pool.prepareExecute(sql, [search, location])
			.then((result) {
				return new Future.value(result.insertId);
			});
	}


	bool get open => _pool != null;
	void close() {
		_pool.close();
		// noop. sqljocky _pool.close() says it will probably break things.
	}
}