import sys
import os
import re
import shutil
from distutils.dir_util import copy_tree
import stat
import fnmatch
from random import choice

def start_project(copy_to=None, copy_from=None, no_prompt=False, no_git=False):
    if not copy_from:
        copy_from = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                    'templates', 'project', 'ff0000'))

    if not copy_to:
        copy_to = os.getcwd()
        copy_tree(copy_from, copy_to)
        matches = []
        for root, dirnames, filenames in os.walk(copy_to):
            for filename in fnmatch.filter(filenames, '*.pyc') + \
                            fnmatch.filter(filenames, 'red_start*'):
                matches.append(os.path.join(root, filename))

        for m in matches:
            if os.path.exists(m):
                os.remove(m)
    else:
        if os.path.exists(copy_to):
            print "%s already exists" % copy_to
            return
        shutil.copytree(copy_from, copy_to, ignore=shutil.ignore_patterns('red_start*','*.pyc'))

    # 2. If template has a settings file, run its after_copy method
    settings_path = os.path.join(copy_from, 'red_start_settings.py')
    if os.path.exists(settings_path):
        sys.path.append(copy_from)
        import red_start_settings
        if callable(getattr(red_start_settings, 'after_copy', None)):
            # First change current directory to copy_to
            os.chdir(copy_to)
            red_start_settings.after_copy(no_prompt=no_prompt, no_git=no_git)
        sys.path.remove(copy_from)
