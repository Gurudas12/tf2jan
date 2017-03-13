USAGE_TEXT = '''\
Usage: %prog [options] "command"

Monitors paths and upon detecting changes runs the specified command.

Ensure the command is quoted to avoid %prog processing options that
are intended for the command.

Full help displayed with %prog --help'''

VERSION_NUMBER = '1.1'

VERSION_TEXT = '%%prog version %s' % VERSION_NUMBER

BUILTIN_BLACK_LIST = ['.hg', '.git', '.bzr', '.svn', 'CVS', '*~', '#*', '.#*', '*.swp', '*.pyc', '*.pyo']

WIDTH = 80
