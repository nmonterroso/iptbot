part of iptservice;

class IptBot {
	Config _config;
	Worker _worker;

	IptBot() {
		_config = new Config();
		_worker = new Worker(_config);
	}

	void start() {
		_config.read()
		.then((config) {
			_worker
				.._config = _config
				..start();
		});
	}
}