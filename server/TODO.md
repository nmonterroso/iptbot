* refactor dart code to not use Future.value. just retrun the value.
* automatic downloading based on minimum file download size
* work notifications into the chrome extension.
* fork https://github.com/bittorrent/btc to make btcclient add &path="pathname" to the add_torrent_url command
	** for now i just installed and hacked locally with changes to
	*** btc_add.py arg parsing (and passing to client)
	*** btcclient.py build out string with &path=path if present
	*** btc.py:41
			if env_config_file:
					config_file = env_config_file
			else:
					config_file = os.path.join(os.getenv(env_varname), '.btc')
* make episode regex match #x##
* at least try to always get a torrent id when parsing, to save parsing again on next pass