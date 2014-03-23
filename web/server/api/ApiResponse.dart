part of server;

class ApiResponse {
	int _code;
	dynamic _body;
	
	String get body {
		if (!(_body is String)) {
			return JSON.encode(_body);
		}
		
		return _body;
	}
}