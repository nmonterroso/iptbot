part of web;

class Server {
	Config _config;
	
	Server() {
		_config = new Config();
	}
	
	void start() {
		_config.read()
		.then((config) {
			listen();
		});
	}
	
	void listen() {
		HttpServer.bind(_config.httpHost, _config.httpPort)
		.then((HttpServer server) {
			print("server listening on ${_config.httpHost}:${_config.httpPort}");
			server.listen(onRequest);
		});
	}
	
	void onRequest(HttpRequest req) {
		req.response.headers.add('Access-Control-Allow-Origin', '*');
		var handler;
		
		switch (req.method) {
			case 'POST':
				handler = new PostHandler();
				break;
			default:
				handler = new DefaultHandler().._config = _config;
				break;
		}
		
		handler.handle(req)
		.then((response) {
			req.response.statusCode = response['code'];
			req.response.write(response['body']);
			req.response.close();
		})
		.catchError((error) {
			print(error.toString());
		});
	}
}