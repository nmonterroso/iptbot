part of iptservice;

class Worker {
	Config _config;
	Timer _timer;
	bool _working = false;

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
		new HttpClient()
		.getUrl(Uri.parse(_config.xmlUrl))
		.then((HttpClientRequest request) {
			return request.close();
		})
		.then((HttpClientResponse response) {
			return response.transform(UTF8.decoder).toList();
		})
		.then((List data) {
			String body = data.join("");
			new Parser().parse(body);
		})
		.catchError((error) {
			print(error.toString());
		})
		.whenComplete(() => _working = false);
	}
}
