part of iptservice;

class Couch {
	Config _config;
	CouchClientImpl _client;

	Couch(this._config);
  
	Future<bool> connect() {
		return
			CouchClient.connect([Uri.parse(_config.couchServer)], _config.couchBucket, _config.couchPasswd)
			.then((client) {
				_client = client;
				return new Future.value(true);
			})
			.catchError((error) {
				print(error.toString());
				return new Future.value(false);
			});
	}

	void close() {
		try {
			_client.close();
		} catch (error) {
			print(error.toString());
		}
	}
}