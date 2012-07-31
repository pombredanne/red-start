import json
import os

from django.conf import settings
from django.template.loader import render_to_string

URL_ATTR = 'urlName'
CONFIG_ATTR = 'config'
ROUTE_ATTR = 'route'

JSON_TEMPLATE = getattr(settings, 'ROUTES_JSON_TEMPLATE', 'routes.js')
JS_TEMPLATE = getattr(settings, 'ROUTES_FULL_TEMPLATE', 'full-routes.js')
STATIC_FILE = getattr(settings, 'ROUTES_STATIC', 'routing.js')

def build_js_route_map():
    """
    Generates a mapping of the declared routes from
    the template 'js_routes.json' with their config
    parameters. Used by js_routing.
    """
    mapping = {}

    data = render_to_string(JSON_TEMPLATE)
    data = json.loads(data.strip())
    for obj in data:
        key = ROUTE_ATTR
        if URL_ATTR in obj:
            key = URL_ATTR
        mapping[obj[key]] = obj[CONFIG_ATTR]

    return mapping

def get_routing_js():
    """
    Renders the full JS template
    """
    return render_to_string(JS_TEMPLATE,
                            { 'json_template' : JSON_TEMPLATE })

def build_js_file():
    """
    Renders the full JS template and then
    writes it output to a static file.
    """
    data = get_routing_js()
    filename = os.path.join(settings.DEV_STATIC_ROOT, 'js',
                             STATIC_FILE)

    with open(filename, 'w') as fp:
        fp.write(data)
