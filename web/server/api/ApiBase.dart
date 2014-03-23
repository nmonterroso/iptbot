part of server;

class ApiBase {
	static Config _config;
	static MysqlStorage _storage;
	
	Future<DataStorage> get storage {
		Future f;
		
		if (_storage == null) {
			_storage = new MysqlStorage();
			f = _storage.isConnected();
		} else {
			f = new Future.value(true);
		}
		
		return 
			f.then((connected) {
				if (!connected) {
					return _storage.connect(_config);
				}
				
				return new Future.value(true);
			})
			.then((_) {
				return new Future.value(_storage);
			});
	}
}