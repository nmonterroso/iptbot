part of server;

abstract class Handler {
	Future handle(HttpRequest req);
}