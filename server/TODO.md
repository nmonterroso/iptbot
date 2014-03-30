* refactor so each web request instantiates its own mysql connection, and so does every run of the service, so we don't have to worry about connection timeouts
* find out how to run as windows service - probably don't need to edit code for this
* make episode regex match #x##
* at least try to always get a torrent id when parsing, to save parsing again on next pass