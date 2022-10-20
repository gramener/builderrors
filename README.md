# Build Errors

Run automated checks on repositories to improve code quality.

- You can install and run it in
  - [Gitlab CI](#gitlab-ci-usage)
  - [BitBucket Pipelines](#bitbucket-pipelines-usage)
  - [Docker](#docker-usage)
  - [Local](#local-usage)
- Here are instructions on how to fix each error:
  - [ERROR: don't commit libraries](#error-dont-commit-libraries)
  - [ERROR: don't commit minified files](#error-dont-commit-minified-files)
  - [ERROR: use Git LFS for files over ... chars](#error-use-git-lfs-for-files-over--chars)
  - [ERROR: don't commit useless or generated files](#error-dont-commit-useless-or-generated-files)
  - [ERROR: don't duplicate files](#error-dont-duplicate-files)
  - [ERROR: reduce duplicate lines](#error-reduce-duplicate-lines)
  - [ERROR: format with Prettier](#error-format-with-prettier)
  - [ERROR: format with Python black](#error-format-with-python-black)
  - [ERROR: use lower_alphanumeric Python paths](#error-use-lower_alphanumeric-python-paths)
  - [ERROR: fix flake8 errors](#error-fix-flake8-errors)
  - [ERROR: fix bandit security errors](#error-fix-bandit-security-errors)
  - [ERROR: fix eslint errors](#error-fix-eslint-errors)
  - [ERROR: fix stylelint errors](#error-fix-stylelint-errors)
  - [ERROR: fix htmlhint errors](#error-fix-htmlhint-errors)
  - [ERROR: CSS code is over ... chars](#error-css-code-is-over--chars)
  - [ERROR: Python + JS code is over ... chars](#error-python--js-code-is-over--chars)

## Gitlab CI usage

To run checks on every push with [Gitlab](https://docs.gitlab.com/ee/ci/pipelines/),
add this on top of your [`.gitlab-ci.yml`](https://docs.gitlab.com/ee/ci/yaml/) file:

```yaml
validate:
  image: gramener/builderrors
  script: builderrors
```

## Migrate from Gramex < 1.84

If you used `gramex init` from [gramex](https://github.com/gramener/gramex) before version 1.84, change the following:

- Delete `.editorconfig`, `.htmllintrc` and `.stylelintrc.js`
- If you have an `.eslintrc.*`, remove rules for `indent`, `linebreak-style`, `quotes` and `semi`.
  [`prettier`](#error-format-with-prettier) handles formatting
- If you have a `.flake8` or [equivalent](https://flake8.pycqa.org/en/latest/user/configuration.html), add `extend-ignore = E203,E501`.
  [`black`](#error-format-with-python-black) handles formatting

## BitBucket Pipelines usage

To run checks on every push with [BitBucket](https://bitbucket.org/product/features/pipelines),
add this on top of your [`bitbucket-pipelines.yml`](https://support.atlassian.com/bitbucket-cloud/docs/configure-bitbucket-pipelinesyml/):

```yaml
clone:
  lfs: true

pipelines:
  default:
    - step:
        name: validate
        image: gramener/builderrors
        script: builderrors
```

## Docker usage

From the folder you want check, run this command on Linux:

<!--
  Why use "--rm"? To delete the container after it runs
  Why use "-it"? Some tools (e.g. jscpd) print colorized output only on interactive terminals.
  Why use "-v $(pwd):/src"? For container to access current host directory at /src (the workdir)
-->

```bash
docker run --rm -it -v $(pwd):/src gramener/builderrors
```

On Windows Command Prompt:

```bat
docker run --rm -it -v %cd%:/src gramener/builderrors
```

On Windows PowerShell:

```powershell
docker run --rm -it -v ${PWD}:/src gramener/builderrors
```

## Local usage

- [Install Python 3.x](https://www.python.org/downloads/)
- [Install Node.js](https://nodejs.org/en/)
- [Install git](https://git-scm.com/download)
- [Install git-lfs](https://git-lfs.github.com/)

In `bash` or Git Bash, from any folder (e.g. `C:/projects/`) run this:

```bash
git clone https://code.gramener.com/cto/builderrors.git
cd builderrors
npm install
pip install -r requirements.txt
```

From the folder _you want to test_, run this in `bash` or Git Bash:

```bash
bash /wherever-you-installed/builderrors
```

How to fix errors:

- `Cannot uninstall 'PyYAML'. It is a distutils installed project ...`: Run [`pip install --ignore-installed PyYAML`](https://stackoverflow.com/a/53534728/100904) first.
- `'bash' is not recognized as an internal or external command`: Run in bash or Git bash, not the Command Prompt or PowerShell
- `flake8: No such file or directory` or `pyminify: command not found`: Ensure you can run `python`, `node` and `git` in the same `bash` shell, and re-install

## It checks only committed files

`builderrors` only runs on a **git repository** with **committed** files.

It **WON'T** check untracked or `.gitignore`d files.

## Options

You can pass options as command-line parameters. For example:

```bash
# Skip flake8. Report errors only if minified code characters > 100,000
docker run --rm -it -v $(pwd):/src gramener/builderrors \
  builderrors --skip-flake8 --code-chars-error=100000

# Skip Git LFS, eslint and stylelint
bash /path/to/builderrors --skip-lfs --skip-eslint --skip-stylelint
```

You can also pass options as environment variables. (Command line overrides environment variables.) For example:

```bash
# Skip flake8. Report errors only if minified code characters > 100,000
docker run --rm -it -v $(pwd):/src \
  -e SKIP_FLAKE8=1 -e CODE_CHARS_ERROR=100000 \
  builderrors gramener/builderrors

# Skip Git LFS, eslint and stylelint
SKIP_LFS=1 SKIP_ESLINT=1 SKIP_STYLELINT=1 bash /path/to/builderrors
```

On Gitlab, set [environment variables](https://docs.gitlab.com/ce/ci/variables/)
under Settings > CI / CD > Variables.

| Environment variable   | Command line               | Meaning                                                                               |
| ---------------------- | -------------------------- | ------------------------------------------------------------------------------------- |
| `VERBOSE`              | `--verbose`                | Show config used and progress                                                         |
| `SKIP_LIB`             | `--skip-lib`               | Skip [libraries check](#error-dont-commit-libraries)                                  |
| `SKIP_MINIFIED`        | `--skip-minified`          | Skip [minified file check](#error-dont-commit-minified-files)                         |
| `SKIP_LFS`             | `--skip-lfs`               | Skip [Git LFS check](#error-use-git-lfs-for-files-over--chars)                        |
| `SKIP_PRETTIER`        | `--skip-prettier`          | Skip [Prettier check](#error-format-with-prettier)                                    |
| `SKIP_USELESS`         | `--skip-useless`           | Skip [useless files check](#error-dont-commit-useless-or-generated-files)             |
| `SKIP_DUPLICATE_FILES` | `--skip-duplicate-files`   | Skip [duplicate files check](#error-dont-duplicate-files)                             |
| `SKIP_DUPLICATE_LINES` | `--skip-duplicate-lines`   | Skip [duplicate lines check](#error-reduce-duplicate-lines)                           |
| `SKIP_PY_FILENAMES`    | `--skip-py-filenames`      | Skip [Python filename check](#error-use-lower_alphanumeric-python-paths)              |
| `SKIP_BLACK`           | `--skip-black`             | Skip [Python Black check](#error-format-with-python-black)                            |
| `SKIP_FLAKE8`          | `--skip-flake8`            | Skip [flake8 check](#error-fix-flake8-errors)                                         |
| `SKIP_BANDIT`          | `--skip-bandit`            | Skip [bandit check](#error-fix-bandit-security-errors)                                |
| `SKIP_ESLINT`          | `--skip-eslint`            | Skip [eslint check](#error-fix-eslint-errors)                                         |
| `SKIP_ESLINT_DEFAULT`  | `--skip-eslint-default`    | Skip [default eslint checks](#error-fix-eslint-errors) (HTML & template plugins)      |
| `SKIP_STYLELINT`       | `--skip-stylelint`         | Skip [stylelint check](#error-fix-stylelint-errors)                                   |
| `SKIP_HTMLHINT`        | `--skip-htmlhint`          | Skip [htmlhint check](#error-fix-htmlhint-errors)                                     |
| `SKIP_CSS_CHARS`       | `--skip-css-chars`         | Skip [CSS size check](#error-css-code-is-over--chars)                                 |
| `SKIP_CODE_CHARS`      | `--skip-code-chars`        | Skip [code size check](#error-python--js-code-is-over--chars)                         |
| `LFS_SIZE`             | `--lfs-size=num`           | Files over `num` bytes should use Git LFS (default: 1,000,000)                        |
| `DUPLICATE_FILESIZE`   | `--duplicate-filesize=num` | Files over `num` bytes should not be duplicated (default: 100)                        |
| `DUPLICATE_LINES`      | `--duplicate-lines=num`    | Duplicate code over `num` lines are not allowed (default: 50)                         |
| `PY_LINE_LENGTH`       | `--py-line-length=num`     | Approx line length of Python code used by Black (default: 99)                         |
| `BANDIT_CONFIDENCE`    | `--bandit-confidence=low`  | Show bandit errors with `low` or more confidence. `medium`, `high`, `all` are allowed |
| `BANDIT_SEVERITY`      | `--bandit-severity=low`    | Show bandit errors with `low` or more severity. `medium`, `high`, `all` are allowed   |
| `CSS_CHARS_ERROR`      | `--css-chars-error=num`    | Minified CSS should be less than `num` bytes (default: 10,000)                        |
| `CODE_CHARS_ERROR`     | `--code-chars-error=num`   | Minified Python + JS code should be less than `num` bytes (default: 50,000)           |

# How to fix errors

[`builderrors`](builderrors) reports these errors:

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
- For each large file(s), run these commands on `bash` or Git bash: [see help](https://git-lfs.github.com/)
  ```bash
  git rm your-large-file.ext          # Remove and commit
  git commit -m"Remove your-large-file.txt"
  git lfs track your-large-file.ext   # Use Git LFS for your file(s)
  # Copy your-large-file.ext back
  git add your-large-file.ext         # Add and commit
  git commit -m"Use LFS for your-large-file.txt`
  ```
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

## ERROR: format with Prettier

It's important to have consistent formatting for readability. We use [prettier](https://prettier.io).

Use the [VS Code Prettier - Code Formatter plugin](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
to auto-format your code.

**Don't format HTML templates** like Tornado / Lodash. [Prettier does not support templates](https://github.com/prettier/prettier/issues/5581)

<!--
- Go templates have a plugin: https://github.com/NiklasPor/prettier-plugin-go-template
- Django plugin is incomplete: https://github.com/robertquitt/prettier-plugin-djangohtml
- Jinja plugin for VS Code: https://github.com/samuelcolvin/jinjahtml-vscode
- Django plugin for VS Code: https://github.com/vscode-django/vscode-django
- Unibeautify supports templates: https://github.com/unibeautify/unibeautify
-->

To format manually:

- To auto-fix required files, run `npx prettier --write "**/*.{js,jsx,vue,ts,css,scss,sass,yaml,md}"`
- To ignore specific files, add a [`.prettierignore`](https://prettier.io/docs/en/ignore.html) file (e.g. add `*.html`)
- To ignore [specific rules](https://prettier.io/docs/en/options.html), add a [`.prettierrc`](https://prettier.io/docs/en/configuration.html) file
- To skip this check, use `builderrors --skip-prettier` (e.g. if you temporarily need the build to pass)

## ERROR: format with Python black

It's important to have consistent formatting for readability. We use [black](https://black.readthedocs.io/) for Python files.

Use the [VS Code Prettier - Black plugin](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)
to auto-format your code.

To format manually:

- Run `pip install black` (one-time)
- To auto-fix required files, run `black --skip-string-normalization --line-length=99 .`
- To ignore [specific rules](https://prettier.io/docs/en/options.html), add a [`pyproject.toml`](https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file) file
- To skip this check, use `builderrors --skip-prettier` (e.g. if you temporarily need the build to pass)

## ERROR: use lower_alphanumeric Python paths

Otherwise you can't import the file.

- Rename the Python files using lower case alphanumerics and underscore (`_`)
- To skip this check, use `builderrors --skip-py-filenames` (e.g. if you won't be importing the module)

## ERROR: fix flake8 errors

[Flake8](https://flake8.pycqa.org//) reports Python errors.

- Run `pip install autopep8` (one-time)
- To auto-fix required files, run `autopep8 -iv --max-line-length 99 *.py`. Then [reformat with `black`](#error-format-with-python-black)
- To ignore a specific line, add [`# noqa`](https://flake8.pycqa.org/en/latest/user/violations.html) at the end
- To ignore specific rules, add a [`.flake8`](https://flake8.pycqa.org/en/latest/user/configuration.html) file
  - Make sure to use `extend-ignore = E203,E501` for consistency with [black](https://black.readthedocs.io/en/stable/guides/using_black_with_other_tools.html#flake8)
- To skip this check, use `builderrors --skip-flake8` (e.g. if you temporarily need the build to pass)

Common errors:

- **F841**: local variable 'x' is assigned to but never used. **Check if you forgot**, else don't assign it
- **F401**: 'x' imported but unused. **Check if you forgot** to use the module. Else don't import it
- **F821**: undefined name 'x' You used an uninitialized variable. That's wrong.
- **F811**: redefinition of unused 'x'. You assigned a variable and never used it. Then you're reassigning it. Or re-importing. Look carefully.
- **B901** or **B902**: blind except: statement. Trap **specific** exceptions. Blind exceptions can trap even syntax errors and confuse you later.
- **F601**: dictionary key 'x' repeated with different values. e.g. `{'x': 1, 'x': 2}`. That's wrong.
- **T001** or **T003**: print found -- just remove `print` in production code.
- **N806**: variable in function should be lowercase -- rename your variable.
- **N802** or **N803**: function and argument names should be lowercase.

## ERROR: fix bandit security errors

[Bandit](https://bandit.readthedocs.io/) reports security errors in Python.

- Re-write the code based on advice from bandit.
- To ignore a specific line, add a [`# nosec`](https://bandit.readthedocs.io/en/latest/config.html#exclusions) at the end
- To ignore specific rules, add a [`.bandit`](https://bandit.readthedocs.io/en/latest/config.html#bandit-settings) file
- To only report errors with high confidence, use `builderrors --bandit-confidence=high` (or `medium`)
- To only report errors with high severity, use `builderrors --bandit-severity=high` (or `medium`)
- To skip this check, use `builderrors --skip-bandit` (e.g. if there are too many false-positives)

## ERROR: fix eslint errors

[ESLint](https://eslint.org/) reports JavaScript errors in JS and HTML files -- including HTML templates.

- To auto-fix required files, run `eslint --fix`.
- To ignore a specific line, add a [`// eslint-disable-line`](https://eslint.org/docs/latest/user-guide/configuring/rules#disabling-rules) at the end
- To ignore specific rules, add a [`.eslintrc.js`](http://eslint.org/docs/rules/) file based on the [default](.eslintrc.js)
- To skip this check, use `builderrors --skip-eslint` (e.g. if you temporarily need the build to pass)

Common errors:

- **[`'x' is not defined. [Error/no-undef]`](http://eslint.org/docs/rules/no-undef)**
  - [Add in your `.js`](https://eslint.org/docs/latest/user-guide/configuring/language-options#using-configuration-comments-1): `/* globals x, ... */`.
  - [Add in `.eslintrc.js`](https://eslint.org/docs/latest/user-guide/configuring/language-options#using-configuration-files-1) for libraries like `d3`, `$`, `_`, etc.: `"globals": {"d3": "readonly", ...}`
- **[`'x' is assigned a value but never used. [Error/no-unused-vars]`](http://eslint.org/docs/rules/no-unused-vars)**
  - [Add in your `.js`](https://eslint.org/docs/latest/rules/no-unused-vars#exported): `/* exported x, ... */` (or don't assign to the variable)

## ERROR: fix stylelint errors

[stylelint](https://stylelint.io/) reports CSS and SASS errors.

- Re-write the code based on advice from stylelint
- To ignore a specific line, add a [`/* stylelint-disable-line */`](https://stylelint.io/user-guide/ignore-code) at the end
- To ignore specific rules, add a [`.stylelintrc.js`](https://stylelint.io/user-guide/configure) file based on the [default](.stylelintrc.js)
- To skip this check, use `builderrors --skip-stylelint` (e.g. if you're using third-party provided CSS)

## ERROR: fix htmlhint errors

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

# Alternatives

Comprehensive multi-linting tools are available at:

- [Super-Linter](https://github.com/github/super-linter)
- [MegaLinter Runner](https://github.com/oxsecurity/megalinter)
