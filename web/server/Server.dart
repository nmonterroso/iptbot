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
			String body;
			int code;
			
			if (response is ApiResponse) {
				body = response._body;
				code = response._code;
			} else {
				body = response['body'];
				code = response['code'];
			}
			
			req.response.statusCode = code;
			req.response.write(body);
			req.response.close();
		})
		.catchError((error) {
			print(error.toString());
			req.response.write("an unexpected error occurred");
			req.response.close();
		});
	}
}