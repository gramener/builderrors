import argparse
import sys


checks = [
    'lib',
    'minified',
    'lfs',
    'prettier',
    'useless',
    'duplicate-files',
    'duplicate-lines',
    'py-filenames',
    'black',
    'flake8',
    'bandit',
    'eslint',
    'eslint-default',
    'stylelint',
    'htmlhint',
    'npm-audit',
    'flake8-extra',
    'complexity',
    'pydoc',
    'absolute-urls',
    'folders',
    'css-size',
    'code-size',
]


def main():
    parser = argparse.ArgumentParser(prog='builderrors')
    parser.add_argument('target-dir', nargs='?', default='.', help='directory to run in (.)')
    kwargs = {
        'choices': checks,
        'action': 'append',
        'metavar': '{%s,...}' % ','.join(checks[:3]),
    }
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--skip', help="don't run specified check(s)", **kwargs)
    group.add_argument('--only', help='run only specified checks(s)', **kwargs)
    # Note: Though help mentions a default, DON'T add default=.
    # This overrides user's environment variables. Allow THOSE to be the default.
    parser.add_argument(
        '--lfs-size', metavar='N', help='max file size allowed without LFS (1000000)'
    )
    parser.add_argument(
        '--duplicate-filesize', metavar='N', help='max duplicate file size allowed (100)'
    )
    parser.add_argument(
        '--duplicate-lines', metavar='N', help='max # duplicate lines allowed (50)'
    )
    parser.add_argument('--py-line-length', metavar='N', help='max Python line length (99)')
    # NOTE: Bandit catches SQL injections only at low confidence.
    # So default confidence to all, not medium/high
    parser.add_argument(
        '--bandit-confidence',
        choices=['high', 'medium', 'low', 'all'],
        help='min bandit confidence level to report (all)',
    )
    parser.add_argument(
        '--bandit-severity',
        choices=['high', 'medium', 'low', 'all'],
        help='min bandit severity to report (all)',
    )
    parser.add_argument('--max-js-complexity', metavar='N', help='max JS complexity (10)')
    parser.add_argument('--max-py-complexity', metavar='N', help='max PY complexity (10)')
    # Allow legacy arguments but ignore them
    parser.add_argument('--css-chars-error', metavar='N', help=argparse.SUPPRESS)
    parser.add_argument('--code-chars-error', metavar='N', help=argparse.SUPPRESS)

    args = vars(parser.parse_args(sys.argv[1:]))
    envs = {'BUILDERROR_OPTIONS_PARSED=1'}
    for key, vals in args.items():
        if vals is None:
            continue
        if key == 'skip':
            for arg in vals:
                envs.add(f'SKIP_{arg.upper().replace("-", "_")}=1')
        elif key == 'only':
            for check in checks:
                if check not in vals:
                    envs.add(f'SKIP_{check.upper().replace("-", "_")}=1')
        else:
            envs.add(f'{key.upper().replace("-", "_")}={vals}')

    for env in envs:
        print(env)  # noqa: T201 This function exists to print the env vars


if __name__ == '__main__':
    main()
