part of server;

abstract class ApiBase {
	static Config _config;
	static MysqlStorage _storage;

	InstanceMirror _mirror;

	ApiBase() {
		_mirror = reflect(this);
	}
	
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

	Future<ApiResponse> call(method, params, namedParams) {
		InstanceMirror im;
		try {
			im = _mirror.invoke(new Symbol(method), params, namedParams);
		} catch(error) {
			throw "unable to invoke ${method}: ${error.toString()}";
		}

		return im.reflectee;
	}
}