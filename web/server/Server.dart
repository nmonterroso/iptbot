part of server;

class Server {
	static final API_URL = new UrlPattern(r'/api/(.*)\/?');

	Config _config;
	Router _router;
	
	Server() {
		_config = new Config();
	}
	
	void start() {
		_config.read()
		.then((config) {
			ApiBase._config = _config;
			listen();
		});
	}
	
	void listen() {
		HttpServer.bind(_config.httpHost, _config.httpPort)
		.then((HttpServer server) {
			_router = new Router(server)
				..serve('/socket').transform(new WebSocketTransformer()).listen(onWebSocket)
				..serve(API_URL).listen((HttpRequest req) {
					Handler handler;

					switch (req.method) {
						case 'POST':
							handler = new PostHandler();
							break;
						case 'GET':
							handler = new GetHandler();
							break;
					}

					respond(req, handler);
				})
				..defaultStream.listen((HttpRequest req) {
					DefaultHandler handler = new DefaultHandler().._config = _config;
					respond(req, handler);
				});

			print("server listening on ${_config.httpHost}:${_config.httpPort}");
		});
	}

	void respond(HttpRequest req, Handler handler) {
		req.response.headers.add('Access-Control-Allow-Origin', '*');

		handler.handle(req)
		.then((response) {
			String body;
			int code;

			if (response is ApiResponse) {
				body = response.body;
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

	void onWebSocket(WebSocket socket) {
		socket
			.map((string) => JSON.decode(string))
			.listen((json) {

			}, onError: (error) {

			});
	}
}