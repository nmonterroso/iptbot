part of iptservice;

class Worker {
	Config _config;
	Timer _timer;
	DataStorage _storage;
	bool _working = false;

	Worker(this._config) {
		_storage = new MysqlStorage(_config); // TODO: init from config?
	}

	void start() {
		if (_timer == null) {
			_timer = new Timer.periodic(new Duration(seconds: _config.workerInterval), onTick);
		}

		onTick(null);
	}

	void stop() {
		_timer.cancel();
		_timer = null;
	}

	void onTick(Timer t) {
		if (_working) {
			return;
		}

		_working = true;

		_storage.connect()
		.then((connected) {
			if (!connected) {
				throw "unable to connect to data storage";
			}

			return new HttpClient().getUrl(Uri.parse(_config.xmlUrl));
		})
		.then((HttpClientRequest request) {
			return request.close();
		})
		.then((HttpClientResponse response) {
			return response.transform(UTF8.decoder).toList();
		})
		.then((List data) {
			String body = data.join("");
			new Parser().parse(body, _storage);
		})
		.catchError((error) {
			print(error.toString());
		})
		.whenComplete(() {
			_working = false;

			if (_storage.open) {
				_storage.close();
			}
		});
	}
}
