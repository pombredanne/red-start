RED-start installs a script which allows the easy creation of Django
projects and applications based the layout used at RED Interactive Agency.

How to use
==========

Creating a project
------------------

    pip install red-start
    red-start project

This will use the default project template, which includes
[red-boilerplate](https://github.com/ff0000/red-boilerplate).

Running a project
-----------------

    cd example
    sh scripts/setup.sh
    source env/bin/activate
    cd project
    python manage.py syncdb
    python manage.py runserver


How to contribute
=================

Fork the project, make your changes, then run

    python test.py

This command will:

* create a test project using the `ff0000` template

If everything runs correctly, then submit a pull request via Github.

You can have the tests run automatically before any commit by adding an executable file `.git/hooks/pre-commit` with this code:

    #!/bin/sh
    python test.py || exit 1


How does it work
================

Creating a project from a template
----------------------------------

Running red-start does three simple things:

1. Creates a new folder called `<folder_name>`.
2. Copies in that folder all the files included in the project template folder. This can be specified with the `--template-dir` option; the default is `templates/project/ff0000`.
3. If a file called `red_start_settings.py` is present in that folder, and if it contains a function called `after_copy`, then that file is loaded and that function executed.

As an example, in the case of the ff0000 project template, the [after_copy function](https://github.com/ff0000/red-start/blob/master/red_start/templates/project/ff0000/red_start_settings.py) downloads an HTML5 boilerplate from GitHub, prompts the user for some variables and substitutes them in the template. This is just an example, other project templates can perform any other operation.


Creating a new project template
-----------------------------------

To add a new project template to red-start, simply add it in the `templates` folder, under `project`. If you need to perform extra actions after the files have been copied, add a file called `red_start_settings.py` with an `after_copy` function (take a look at existing templates).

Finally, to use the newly created template, just indicate its path as the `--template-dir` option, for instance:

    red-start.py --template-dir=/your/custom/template new_example
