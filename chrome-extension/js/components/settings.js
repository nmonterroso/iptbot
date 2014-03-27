define(['lodash'], function(_) {
	return function Settings(config) {
		var accept = {
			server: {
				required: true
			}
		};

		var settings = {};
		_.each(accept, function(definition, key) {
			var required = definition.required || false;
			var value = config[key] || definition.default || null;

			if (required && !value) {
				throw 'Settings: required config '+key+' is missing';
			}

			settings[key] = value;
		});

		return settings;
	};
});