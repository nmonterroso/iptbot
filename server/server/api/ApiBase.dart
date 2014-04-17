part of server;

abstract class ApiBase {
	static Config _config;

	InstanceMirror _mirror;

	ApiBase() {
		_mirror = reflect(this);
	}
	
	Future<DataStorage> get storage {
		Future f;
		MysqlStorage storage = new MysqlStorage(_config);
		
		return
			storage.connect()
			.then((_) {
				return new Future.value(storage);
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