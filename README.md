# Build Errors

Run automated checks on repositories to improve code quality.

## Setup

- [Install Python 3.x](https://www.python.org/downloads/)
- [Install Node.js](https://nodejs.org/en/)
- [Install git](https://git-scm.com/download)
- [Install git-lfs](https://git-lfs.github.com/)

[Clone this repository](https://code.gramener.com/cto/builderrors) and run this from `bash`:

```shell
git clone git@code.gramener.com:cto/builderrors.git
cd builderrors
npm install
pip install -r requirements.txt
```

## Usage

From a **git repository** with **committed** files, run:

```shell
bash /path/to/builderrors/builderrors
```

Remember: It **WON'T** check untracked or `.gitignore`d files.

To run on [Gitlab's CI/CD pipeline](https://docs.gitlab.com/ee/ci/pipelines/) on code.gramener.com,
add a `.gitlab-ci.yml` file with this configuration:

```yaml
validate:
  script: builderrors
```

# How to fix

The [builderrors](builderrors) script reports these errors:

## ERROR: don't commit libraries

`node_modules` (or `bower_components`) should be installed via `npm install` in each environment

- Run `git rm -rf node_modules/ bower_components/` to remove the libraries
- Add `bower_components/` and `node_modules/` to your `.gitignore`
- To skip this check, use `builderrors --skip-libraries` (e.g. to share a git repo for offline installation)

## ERROR: don't commit minified files

Minified files are not source code and shouldn't be version-controlled. They're generated

- Run `git rm jquery.min.js ...other.min.js` to remove the file
- Run `npm install your-package-name` to install the package
- Change URLs to point to the package (e.g. `node_modules/<lib>/dist/<lib>.min.js`)
- To skip this check, use `builderrors --skip-minified` (e.g. if the package is not on npm)

## ERROR: use Git LFS for files over ... chars

Git stores copies of every version. LFS stores pointers instead

- Install [Git LFS](https://git-lfs.github.com/)
- Run `git lfs install` on your repo
- Run `git lfs track <large-file>` on each of these large files
- Commit and push again
- To skip this check, use `builderrors --skip-lfs` (e.g. if you can't use LFS)

## ERROR: don't commit useless or generated files

Thumbnails (`thumbs.db`), backups (`*~`), etc don't need to be committed. Nor logs (`*.log`)

- Run `git rm <useless.file>` to remove it
- Add `<useless.file>` to your `.gitignore`
- To skip this check, use `builderrors --skip-useless` (e.g. if you DO need to commit `.log` files)

## ERROR: don't duplicate files

You can re-use the same file

- Run `git rm <duplicate.file>` to remove it
- Replace `<duplicate.file>` with the retained file in your code
- To allow duplicate files less than 1000 bytes, run `builderrors --duplicate-filesize=1000`
- To skip this check, use `builderrors --skip-duplicate-files` (e.g. if you need duplicate files for test cases)

## ERROR: reduce duplicate lines

You can re-use the same code

- Use **loops** for code repeated one after another
- Use **functions** for code repeated in different places (either in the same file or different files)
- Use **function parameters** to handle minor variations in the repetition
- Use **data structures** for larger variations. For example, create an array or
  dictionary that stores all the parameters that vary. Remember: you can use functions as values.
- Use **function generators** for extreme variations in code. Write a function
  to create and return a new function depending on your variation.
- Refactor the code and test _very carefully_. (Unit test cases help here.)
- To ignore duplicates up to 100 lines, run `builderrors --duplicate-lines=100`
- To skip this check, use `builderrors --skip-duplicate-lines` (e.g. if you need duplicate code for test cases)

## ERROR: reformat with Prettier

It's important to have consistent formatting for readability. We use [prettier](https://prettier.io).

Use the [VS Code Prettier - Code Formatter plugin](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
to auto-format your code.

To format manually:

- Run `npm install -g prettier` to install prettier (one-time)
- Run `prettier --write .` to fix most errors in the current folder (`.`)
- To ignore [specific rules](https://prettier.io/docs/en/options.html), add a [`.prettierrc`](https://prettier.io/docs/en/configuration.html) file
- To skip this check, use `builderrors --skip-prettier` (e.g. if you temporarily need the build to pass)

## ERROR: reformat with Python black

It's important to have consistent formatting for readability. We use [black](https://black.readthedocs.io/) for Python files.

Use the [VS Code Prettier - Black plugin](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)
to auto-format your code.

To format manually:

- Run `pip install black` to install black (one-time)
- Run `black .` to fix most errors in the current folder (`.`)
- To ignore [specific rules](https://prettier.io/docs/en/options.html), add a [`pyproject.toml`](https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file) file
- To skip this check, use `builderrors --skip-prettier` (e.g. if you temporarily need the build to pass)

## ERROR: Python paths must be lower_alphanumeric

Otherwise you can't import the file.

- Rename the Python files using lower case alphanumerics and underscore (`_`)
- To skip this check, use `builderrors --skip-py-filenames` (e.g. if you won't be importing the module)

## ERROR: flake8 errors

[Flake8](https://flake8.pycqa.org//) reports Python errors.

- Run `pip install autopep8` and then `autopep8 -iv --max-line-length 99 *.py` to auto-fix the file
- To ignore a specific line, add [`# noqa`](https://flake8.pycqa.org/en/latest/user/violations.html) at the end
- To ignore specific rules, add a [`.flake8`](https://flake8.pycqa.org/en/latest/user/configuration.html) file based on the [default](.flake8)
- To skip this check, use `builderrors --skip-flake8` (e.g. if you temporarily need the build to pass)

For specific rules:

- **F841**: local variable '...' is assigned to but never used. **Check if you forgot**, else don't assign it
- **F401**: '...' imported but unused. **Check if you forgot** to use the module. Else don't import it
- **F821**: undefined name ... You used an uninitialized variable. That's wrong.
- **F811**: redefinition of unused '...'. You assigned a variable and never used it. Then you're reassigning it. Or re-importing. Look carefully.
- **B901**: blind except: statement. Trap **specific** exceptions. Blind exceptions can trap even syntax errors and confuse you later.
- **F601**: dictionary key '...' repeated with different values. e.g. `{'x': 1, 'x': 2}`. That's wrong.
- **T001** or **T003**: print found -- just remove `print` in production code.
- **N806**: variable in function should be lowercase -- rename your variable.
- **N802** or **N803**: function and argument names should be lowercase.

## ERROR: bandit security errors

[Bandit](https://bandit.readthedocs.io/) reports security errors in Python.

- Re-write the code based on advice from bandit.
- To ignore a specific line, add a [`# nosec`](https://bandit.readthedocs.io/en/latest/config.html#exclusions) at the end
- To ignore specific rules, add a [`.bandit`](https://bandit.readthedocs.io/en/latest/config.html#bandit-settings) file
- To only report errors with high confidence, use `builderrors --bandit-confidence=high` (or `medium`)
- To only report errors with high severity, use `builderrors --bandit-severity=high` (or `medium`)
- To skip this check, use `builderrors --skip-bandit` (e.g. if there are too many false-positives)

## ERROR: eslint errors

[ESLint](https://eslint.org/) reports JavaScript errors in JS and HTML files -- including HTML templates.

- Run `eslint --fix` to automatically fix eslint errors where possible.
- To ignore a specific line, add a [`// eslint-disable-line`](https://eslint.org/docs/latest/user-guide/configuring/rules#disabling-rules) at the end
- To ignore specific rules, add a [`.eslintrc.js`](http://eslint.org/docs/rules/) file based on the [default](.eslintrc.js)
- To skip this check, use `builderrors --skip-eslint` (e.g. if you temporarily need the build to pass)

For specific errors:

- **[`no-undef`](http://eslint.org/docs/rules/no-undef)**:
  Import globals with `/* globals var1, var2, ... */`.
- **[`no-unused-vars`](http://eslint.org/docs/rules/no-unused-vars)**:
  Export globals with `/* exported var1, fn1, ... */` (or don't assign to the variable)

## ERROR: stylelint errors

[stylelint](https://stylelint.io/) reports CSS and SASS errors.

- Re-write the code based on advice from stylelint
- To ignore a specific line, add a [`/* stylelint-disable-line */`](https://stylelint.io/user-guide/ignore-code) at the end
- To ignore specific rules, add a [`.stylelintrc.js`](https://stylelint.io/user-guide/configure) file based on the [default](.stylelintrc.js)
- To skip this check, use `builderrors --skip-stylelint` (e.g. if you're using third-party provided CSS)

## ERROR: htmlhint errors

[htmlhint](https://htmlhint.com/) checks HTML and reports errors.

- Re-write the code based on advice from htmlhint
- To ignore specific rules, add a [`.htmlhintrc`](https://htmlhint.com/docs/user-guide/getting-started) file based on the [default](.htmlhintrc)
- To skip this check, use `builderrors --skip-htmllint` (e.g. if you're building a Lodash template library)

## ERROR: CSS code is over ... chars

You have too much CSS code, even after minifying with [clean-css](https://www.npmjs.com/package/clean-css-cli).

- Reduce CSS code using libraries.
- To allow 20,000 characters, use `builderrors --css-chars-error=10000`
- To skip this check, use `builderrors --skip-css-chars`

## ERROR: Python + JS code is over ... chars

You have too much Python / JavaScript code

- Reduce code using libraries.
- To allow 80,000 characters, use `builderrors --code-chars-error=80000`
- To skip this check, use `builderrors --skip-code-chars`

# Options

`builderrors` is controlled via environment variables and command line parameters. Command line parameters override environment variables;

| Environment variable    | Command line               | Meaning                                                                               |
| ----------------------- | -------------------------- | ------------------------------------------------------------------------------------- |
| `$SKIP_CONFIG`          | `--skip-config`            | Skip config at start                                                                  |
| `$SKIP_LIB`             | `--skip-lib`               | Skip [libraries check](#error-dont-commit-libraries)                                  |
| `$SKIP_MINIFIED`        | `--skip-minified`          | Skip [minified file check](#error-dont-commit-minified-files)                         |
| `$SKIP_LFS`             | `--skip-lfs`               | Skip [Git LFS check](#error-use-git-lfs-for-files-over--chars)                        |
| `$SKIP_PRETTIER`        | `--skip-prettier`          | Skip [Prettier check](#error-reformat-with-prettier)                                  |
| `$SKIP_USELESS`         | `--skip-useless`           | Skip [useless files check](#error-dont-commit-useless-or-generated-files)             |
| `$SKIP_DUPLICATE_FILES` | `--skip-duplicate-files`   | Skip [duplicate files check](#error-dont-duplicate-files)                             |
| `$SKIP_DUPLICATE_LINES` | `--skip-duplicate-lines`   | Skip [duplicate lines check](#error-reduce-duplicate-lines)                           |
| `$SKIP_PY_FILENAMES`    | `--skip-py-filenames`      | Skip [Python filename check](#error-python-paths-must-be-lower_alphanumeric)          |
| `$SKIP_BLACK`           | `--skip-black`             | Skip [Python Black check](#error-reformat-with-python-black)                          |
| `$SKIP_FLAKE8`          | `--skip-flake8`            | Skip [flake8 check](#error-flake8-errors)                                             |
| `$SKIP_BANDIT`          | `--skip-bandit`            | Skip [bandit check](#error-bandit-security-errors)                                    |
| `$SKIP_ESLINT`          | `--skip-eslint`            | Skip [eslint check](#error-eslint-errors)                                             |
| `$SKIP_STYLELINT`       | `--skip-stylelint`         | Skip [stylelint check](#error-stylelint-errors)                                       |
| `$SKIP_HTMLHINT`        | `--skip-htmlhint`          | Skip [htmlhint check](#error-htmlhint-errors)                                         |
| `$SKIP_CSS_CHARS`       | `--skip-css-chars`         | Skip [CSS size check](#error-css-code-is-over--chars)                                 |
| `$SKIP_CODE_CHARS`      | `--skip-code-chars`        | Skip [code size check](#error-python--js-code-is-over--chars)                         |
| `$LFS_SIZE`             | `--lfs-size=num`           | Files over `num` bytes should use Git LFS (default: 1,000,000)                        |
| `$DUPLICATE_FILESIZE`   | `--duplicate-filesize=num` | Files over `num` bytes should not be duplicated (default: 100)                        |
| `$DUPLICATE_LINES`      | `--duplicate-lines=num`    | Duplicate code over `num` lines are not allowed (default: 50)                         |
| `$BANDIT_CONFIDENCE`    | `--bandit-confidence=low`  | Show bandit errors with `low` or more confidence. `medium`, `high`, `all` are allowed |
| `$BANDIT_SEVERITY`      | `--bandit-severity=low`    | Show bandit errors with `low` or more severity. `medium`, `high`, `all` are allowed   |
| `$PY_LINE_LENGTH`       | `--py-line-length=num`     | Max line length of Python code (default: 99)                                          |
| `$CSS_CHARS_ERROR`      | `--css-chars-error=num`    | Minified CSS should be less than `num` bytes (default: 10,000)                        |
| `$CODE_CHARS_ERROR`     | `--code-chars-error=num`   | Minified Python + JS code should be less than `num` bytes (default: 50,000)           |

On Gitlab, you can set project [environment variables](https://docs.gitlab.com/ce/ci/variables/)
under Settings > CI / CD > Variables.

# Alternatives

Comprehensive multi-linting tools are available at:

- [Super-Linter](https://github.com/github/super-linter)
- [MegaLinter Runner](https://github.com/oxsecurity/megalinter)
