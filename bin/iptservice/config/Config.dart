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
	  List parts = key.split('.');
		if (!_config.containsKey(key)) {
			throw "unknown config: ${key}";
		}

		return _config[key];
	}

	String get xmlUrl => get('xmlUrl');
	int get workerInterval => get('workerInterval');
}
