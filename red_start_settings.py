# This file will contain
# - a description of this project template
# - the list of variables to be substituted
# - the commands to be launched after copying the template files (e.g. git pull)

# Also, this file will NOT be copied
import os
import sys
from random import choice
from string import ascii_lowercase, digits
import stat


def main(no_prompt=False):
    """Steps to run after the templates has been copied in place."""
    os.system("find . -name '*.pyc' -exec rm -rf {} \;")

    # Fix some ignore defaults
    os.system("echo 'collected-static/*' >> .gitignore")
    os.system("echo 'uploads/*' >> .gitignore")

    # 2. Replace boilerplate variables with prompt values or defaults
    placemarks = [
      ['PROJECT_NAME', 'Project Name', 'Django Project'],
      ['ADMIN_EMAIL',  'Administrator email', 'geeks@ff0000.com'],
    ]
    replace = {}
    for var, help, default in placemarks:
        placemark = '__%s__' % var
        replace[placemark] = None
        while not replace[placemark]:
            if no_prompt:
                replace[placemark] = default
            else:
                prompt = '%s [%s]: ' % (help, default)
                replace[placemark] = raw_input(prompt) or default
    key_seed = ''.join([choice(ascii_lowercase + digits) for x in range(50)])
    replace['__SECRET_KEY_SEED__'] = key_seed

    # FIXME: This resets permissions!! Change with shutil
    # TODO: Also replace variables in file names
    for root, dirs, files in os.walk('.'):
        DONT_REPLACE_IN = ['.svn', '.git', '.rbp-temp', '.sass-cache', 'node_modules']
        for folder in DONT_REPLACE_IN:
            if folder in dirs:
                dirs.remove(folder)
        for name in files:
            filepath = os.path.join(root, name)
            with open(filepath, 'r') as f:
                data = f.read()
            for old_val, new_val in replace.items():
                data = data.replace(old_val, new_val)
            with open(filepath, 'w') as f:
                f.write(data)
            if os.path.basename(name).endswith('.sh'):
                st = os.stat(filepath)
                perms = stat.S_IMODE(st.st_mode) | stat.S_IWUSR | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH
                os.chmod(filepath, perms)


if __name__ == "__main__":
    main(sys.argv[1:])
