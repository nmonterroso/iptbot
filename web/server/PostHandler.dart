part of web;

class PostHandler {
	static final _instance = new PostHandler._();
	
	Map<String, ApiHandler> _handlers = new Map<String, ApiHandler>();
	
	factory PostHandler() {
		return _instance;
	}
	PostHandler._() {
		_handlers.addAll({
			'torrent': new ApiHandler(new TorrentApi())
		});
	}
	
	Future handle(HttpRequest req) {
		String path = req.uri.path.substring(1);
		List<String> parts = path.split('/');
		
		if (parts.length < 2) {
			throw "missing api or method: ${path}";
		}
		
		String api = parts.removeAt(0), method = parts.removeAt(0);
		
		if (!_handlers.containsKey(api)) {
			throw "unknown api: ${api}";
		}
		
		return 
			HttpBodyHandler.processRequest(req)
			.then((HttpBody body) {
				if (body.body is Map) {
					Map<Symbol, dynamic> namedParams = {};
					for (String key in body.body.keys) {
						namedParams[new Symbol(key)] = body.body[key];
					}
					
					return _handlers[api].call(method, parts, namedParams);
				} else {
					return _handlers[api].call(method, parts, null);
				}
			});
	}
}