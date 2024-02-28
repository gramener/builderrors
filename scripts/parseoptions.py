'''Parse command line options and print environment variables to set'''

import os
import argparse
import sys


types = {
    "lib": "ERROR",
    "minified": "ERROR",
    "lfs": "ERROR",
    "useless": "ERROR",
    "duplicate-files": "ERROR",
    "duplicate-lines": "ERROR",
    "prettier": "ERROR",
    "black": "ERROR",
    "py-filenames": "ERROR",
    "flake8": "ERROR",
    "bandit": "ERROR",
    "eslint": "ERROR",
    "data-blocks": "ERROR",
    "stylelint": "ERROR",
    "htmlhint": "ERROR",
    "gitleaks": "ERROR",
    "js-modules": "WARNING",
    "npm-audit": "WARNING",
    "flake8-extra": "WARNING",
    "eslint-extra": "WARNING",
    "complexity": "WARNING",
    "url-templates": "WARNING",
    "pydoc": "WARNING",
    "absolute-urls": "WARNING",
    "folders": "INFO",
    "css-size": "INFO",
    "code-size": "INFO",
}
checks = list(types)
options = [
    'eslint-default',
]
build_envs = {
    'GITLAB_CI': 'gitlab-ci',
    'GITHUB_ACTION': 'github-action',
    'JENKINS_URL': 'jenkins-ci',
}


def main():
    '''Parse command line options and print environment variables to set'''
    parser = argparse.ArgumentParser(prog='builderrors')
    parser.add_argument('target-dir', nargs='?', default='.', help='directory to run in (.)')
    kwargs = {'action': 'append', 'metavar': '{%s,...}' % ','.join(checks[:3])}
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--skip', help="skip this check(s)", choices=checks + options, **kwargs)
    group.add_argument('--only', help='run only this checks(s)', choices=checks, **kwargs)
    parser.add_argument('--error', help="fail on this check(s)", choices=checks, **kwargs)
    parser.add_argument('--warning', help="only warn on this check(s)", choices=checks, **kwargs)
    # Note: Though help mentions a default, DON'T add default=.
    # This overrides user's environment variables. Allow THOSE to be the default.
    parser.add_argument(
        '--lfs-size', metavar='N', help='max file size allowed without LFS (1000000)'
    )
    parser.add_argument(
        '--duplicate-filesize', metavar='N', help='max duplicate file size allowed (100)'
    )
    parser.add_argument(
        '--duplicate-lines', metavar='N', help='max # duplicate lines allowed (25)'
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
    parser.add_argument(
        '--build-env',
        choices=['gitlab-ci', 'github-actions', 'jenkins-ci'],
        default=next((build_envs[key] for key in build_envs if key in os.environ), None),
        help='build environment',
    )
    # Allow legacy arguments but ignore them
    parser.add_argument('--css-chars-error', metavar='N', help=argparse.SUPPRESS)
    parser.add_argument('--code-chars-error', metavar='N', help=argparse.SUPPRESS)

    args = vars(parser.parse_args(sys.argv[1:]))
    envs = {'BUILDERROR_OPTIONS_PARSED': '1'}

    def set_env(prefix, value, vals):
        for check in vals:
            envs[f'{prefix}_{check.upper().replace("-", "_")}'] = value

    for check, type in types.items():
        envs[f'ERROR_{check.upper().replace("-", "_")}'] = type
    for key, vals in args.items():
        if vals is None:
            continue
        elif key == 'skip':
            set_env('SKIP', '1', vals)
        elif key == 'only':
            set_env('SKIP', '1', [check for check in checks if check not in vals])
        elif key in {'warning', 'error'}:
            set_env('ERROR', key.upper(), vals)
        else:
            envs[f'{key.upper().replace("-", "_")}'] = vals

    for key, val in envs.items():
        print(f'{key}={val}')  # noqa: T201 This function exists to print the env vars


if __name__ == '__main__':
    main()
