part of iptservice;

class IptBot {
	Config _config;
	Couch _couch;
	Worker _worker;

	IptBot() {
		_config = new Config();
		_worker = new Worker();
		_couch = new Couch();
	}

	void start() {
		_config.read()
		.then((config) {
			return _couch
				.._config = config
				..connect();
		})
		.then((couch) {
			_worker
				.._config = _config
				..start();
		});
	}
}