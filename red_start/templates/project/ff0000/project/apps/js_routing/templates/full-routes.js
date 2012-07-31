define(

	function () {

		"use strict";

		return [
			{
				"config" : {
					"selector" : "#main",
					"useHistory" : true,
					"transition" : "async"
				},
				"routes" : {% include json_template %}
			}
		]
	}
);
