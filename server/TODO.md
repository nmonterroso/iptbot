* fork https://github.com/bittorrent/btc to make btcclient add &path="pathname" to the add_torrent_url command
	** for now i just installed and hacked locally with changes to
	*** btc_add.py arg parsing (and passing to client)
	*** btcclient.py build out string with &path=path if present
* find out how to run as windows service - probably don't need to edit code for this
* make episode regex match #x##
* at least try to always get a torrent id when parsing, to save parsing again on next pass