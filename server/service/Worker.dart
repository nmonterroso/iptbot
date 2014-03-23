part of service;

class Worker {
	Config _config;
	Timer _timer;
	DataStorage _storage;
	bool _working = false;

	Worker(this._config) {
		_storage = new MysqlStorage(); // TODO: init storage type from config?
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

		Future.wait([_storage.connect(_config), new HttpClient().getUrl(Uri.parse(_config.xmlUrl))])
		.then((responses) {
			bool connected = responses[0];
			HttpClientRequest request = responses[1];
			
			if (!connected) {
				throw "unable to connect to data storage";
			}
			
			return request.close();
		})
		.then((HttpClientResponse response) {
			return response.transform(UTF8.decoder).toList();
		})
		.then((List data) {
			String body = data.join("");
			return new Parser().parse(body, _storage);
		})
		.then((torrents) {
			return _storage.save(torrents);
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
