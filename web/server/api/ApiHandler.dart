part of server;

class ApiHandler {
	ApiBase _api;
	InstanceMirror _mirror;
	
	ApiHandler(this._api) {
		_mirror = reflect(this._api);
	}
	
	Future<ApiResponse> call(method, params, namedParams) {
		InstanceMirror im;
		try {
			im = _mirror.invoke(new Symbol(method), params, namedParams);
		} catch(error) {
			throw "unable to invoke ${method}: ${error.toString()}";
		}
		
		return im.reflectee;
	}
}