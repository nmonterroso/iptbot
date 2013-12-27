part of iptservice;

class Config {
	static final Config _instance = new Config._();
	static const CONFIG_PATH = '/iptservice/config/config.json';

	String _configPath;
	Map _config;

	factory Config() => _instance;
	Config._() {
		_configPath = Directory.current.path+CONFIG_PATH;
	}

	Future<Config> read() {
		File configFile = new File(_configPath);

		return configFile.exists()
			.then((exists) {
				if (exists) {
					return configFile.readAsString();
				} else {
					throw "config file does not exist";
				}
			})
			.then((configData) {
				_config = JSON.decode(configData);
				return new Future.value(this);
			});
	}

	dynamic get(String key) {
		List<String> parts = key.split(".");
		String currentKey;
		var result = _config;

		while (parts.length > 0) {
			currentKey = parts.removeAt(0);
			if (!result.containsKey(currentKey)) {
				throw "unknown config: ${currentKey} in ${key}";
			}

			result = result[currentKey];
		}

		return result;
	}

	String get xmlUrl => get('xmlUrl');
	String get couchServer => get('couchbase.server');
	String get couchBucket => get('couchbase.bucket');
	String get couchPasswd => get('couchbase.password');

	int get workerInterval => get('workerInterval');
}