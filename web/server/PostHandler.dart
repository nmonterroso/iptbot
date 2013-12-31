part of web;

class PostHandler {
	static final _instance = new PostHandler._();
	
	factory PostHandler() {
		return _instance;
	}
	PostHandler._();
	
	Future handle(HttpRequest req) {
	
	}
}