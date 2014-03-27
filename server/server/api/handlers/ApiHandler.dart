part of server;

abstract class ApiHandler extends Handler {
	Map<String, ApiBase> _handlers = new Map<String, ApiBase>();

	Future handle(HttpRequest req) {
		String path = req.uri.path.substring(1);
		List<String> parts = path.split('/');

		if (parts.length < 2) {
			throw "missing api or method: ${path}";
		}

		parts.removeAt(0);
		String api = parts.removeAt(0), method = parts.removeAt(0);
		req.uri.queryParameters;

		if (!_handlers.containsKey(api)) {
			throw "unknown api: ${api}";
		}

		return
			HttpBodyHandler.processRequest(req)
			.then((HttpBody body) {
				Map<Symbol, dynamic> namedParams = {};

				for (String key in req.uri.queryParameters.keys) {
					namedParams[new Symbol(key)] = req.uri.queryParameters[key];
				}

				if (body.body is Map) {
					for (String key in body.body.keys) {
						namedParams[new Symbol(key)] = body.body[key];
					}
				}

				if (namedParams.isEmpty) {
					namedParams = null;
				}

				return _handlers[api].call(method, parts, namedParams);
			});
	}
}