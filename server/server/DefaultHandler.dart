part of server;

class DefaultHandler extends Handler {
	static final _instance = new DefaultHandler._();
	static final PUBLIC_DIR = Directory.current.path+'/../public';
	
	Map <String, String> _cache = new Map<String, String>();
	Config _config;
	
	factory DefaultHandler() {
		return _instance;
	}
	DefaultHandler._();
	
	Future<Object> handle(HttpRequest req) {
		Future f;
		String path = req.uri.path;
		
		if (path == '/') {
			path = '/index.html';
		}
		
		path = path.substring(1);
		if (!_config.httpCache || !_cache.containsKey(path)) {
			f = getPage(path);
		} else {
			f = new Future.value(_cache[path]);
		}
		
		return f.then((body) {
			return new Future.value({"body": body, "code": 200 });
		})
		.catchError((error) {
			return new Future.value({"body": error.toString(), "code": 500 });
		});
	}
	
	Future getPage(String path) {
		File page = new File('${PUBLIC_DIR}/${path}');
		
		return
			page.exists()
			.then((exists) {
				if (!exists) {
					throw "${path} does not exist";
				}
				
				return page.readAsString();
			})
			.then((body) {
				_cache[path] = body;
				return new Future.value(body);
			});
	}
}