# Build Errors

Run automated checks on repositories to improve code quality.

- You can install and run it in
  - [Gitlab CI](#gitlab-ci-usage)
  - [BitBucket Pipelines](#bitbucket-pipelines-usage)
  - [Docker](#docker-usage)
  - [Jenkins](#jenkins-usage)
  - [Local](#local-usage)
- Here are instructions on how to fix each error:
  - [ERROR (lib) don't commit libraries](#lib)
  - [ERROR (minified) don't commit minified files](#minified)
  - [ERROR (lfs) use Git LFS for large files](#lfs)
  - [ERROR (useless) don't commit useless/generated files](#useless)
  - [ERROR (duplicate-files) delete duplicate files](#duplicate-files)
  - [ERROR (duplicate-lines) reduce duplicate lines](#duplicate-lines)
  - [ERROR (prettier) re-format JS/CSS with Prettier](#prettier)
  - [ERROR (black) re-format Python with Black](#black)
  - [ERROR (py-filenames) use lower_alpha Python paths](#py-filenames)
  - [ERROR (flake8) fix Python errors](#flake8)
  - [ERROR (bandit) fix Python security errors](#bandit)
  - [ERROR (eslint) fix JavaScript errors](#eslint)
  - [ERROR (stylelint) fix CSS errors](#stylelint)
  - [ERROR (htmlhint) fix HTML errors](#htmlhint)
  - [ERROR (css-chars): reduce CSS code](#css-chars)
  - [ERROR (code-chars) reduce PY/JS code](#code-chars)
  - [WARNING (npm-audit) avoid unsafe npm packages](#npm-audit)
  - [WARNING (flake8-extra) improve Python code](#flake8-extra)
  - [WARNING (absolute-urls) avoid absolute URLs](#absolute-urls)
- [Alternatives](#alternatives)

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
- Copy this [`.eslintrc.js`](.eslintrc.js) and run `npm install --save-dev eslint eslint-plugin-html eslint-plugin-template`
- If you have a `.flake8` or [equivalent](https://flake8.pycqa.org/en/latest/user/configuration.html), add `extend-ignore=E203,E501`.
  [`black`](#formatg

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
  Why use "-it"? Some tools (e.g. jscpd) print colorized output only on interactive terminals
  Why use "-v `pwd`:/src"? For container to access current host directory at /src (the workdir)
-->

```bash
docker run --rm -it -v `pwd`:/src gramener/builderrors
```

On Windows Command Prompt:

```bat
docker run --rm -it -v %cd%:/src gramener/builderrors
```

On Windows PowerShell:

```powershell
docker run --rm -it -v ${PWD}:/src gramener/builderrors
```

## Jenkins usage

To run checks on every push with [Jenkins pipelines](https://www.jenkins.io/doc/book/pipeline/),
add this to your [`Jenkinsfile`](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/) file:

```jenkinsfile
pipeline {
    agent {
        docker { image 'gramener/builderrors' }
    }
    stages {
        stage('Validate') {
            steps {
                sh 'builderrors'
            }
        }
    }
}
```

## Local usage

- [Install Python 3.x](https://www.python.org/downloads/)
- [Install Node.js](https://nodejs.org/en/)
- [Install git](https://git-scm.com/download)
- [Install git-lfs](https://git-lfs.github.com/)

In `bash` or Git Bash, from any folder (e.g. `C:/projects/`) run this:

```bash
git clone https://github.com/gramener/builderrors
cd builderrors
bash setup.sh
```

From the folder _you want to test_, run this in `bash` or Git Bash:

```bash
bash /wherever-you-installed/builderrors
```

How to fix install errors:

- `Cannot uninstall 'PyYAML'. It is a distutils installed project ...`: Run [`pip install --ignore-installed PyYAML`](https://stackoverflow.com/a/53534728/100904) first
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
| `SKIP_LIB`             | `--skip-lib`               | Skip [libraries check](#dont                                                          |
| `SKIP_MINIFIED`        | `--skip-minified`          | Skip [minified file check](#dont                                                      |
| `SKIP_LFS`             | `--skip-lfs`               | Skip [Git LFS check](#use                                                             |
| `SKIP_PRETTIER`        | `--skip-prettier`          | Skip [Prettier check](#format                                                         |
| `SKIP_USELESS`         | `--skip-useless`           | Skip [useless files check](#dont                                                      |
| `SKIP_DUPLICATE_FILES` | `--skip-duplicate-files`   | Skip [duplicate files check](#dont                                                    |
| `SKIP_DUPLICATE_LINES` | `--skip-duplicate-lines`   | Skip [duplicate lines check](#reduce                                                  |
| `SKIP_PY_FILENAMES`    | `--skip-py-filenames`      | Skip [Python filename check](#use                                                     |
| `SKIP_BLACK`           | `--skip-black`             | Skip [Python Black check](#format                                                     |
| `SKIP_FLAKE8`          | `--skip-flake8`            | Skip [flake8 check](#fix                                                              |
| `SKIP_BANDIT`          | `--skip-bandit`            | Skip [bandit check](#fix                                                              |
| `SKIP_ESLINT`          | `--skip-eslint`            | Skip [eslint check](#fix                                                              |
| `SKIP_ESLINT_DEFAULT`  | `--skip-eslint-default`    | Skip [eslint extra checks](#fix                                                       |
| `SKIP_STYLELINT`       | `--skip-stylelint`         | Skip [stylelint check](#fix                                                           |
| `SKIP_HTMLHINT`        | `--skip-htmlhint`          | Skip [htmlhint check](#fix                                                            |
| `SKIP_CSS_CHARS`       | `--skip-css-chars`         | Skip [CSS size check](#css                                                            |
| `SKIP_CODE_CHARS`      | `--skip-code-chars`        | Skip [code size check](#python                                                        |
| `SKIP_NPM_AUDIT`       | `--skip-npm-audit`         | Skip [npm audit check](#warning-fix-npm-audit) warning                                |
| `SKIP_FLAKE8_EXTRA`    | `--skip-flake8-extra`      | Skip [flake8 extra check](#warning-fix-flake8-extra-checks) warning                   |
| `SKIP_ABSOLUTE_URLS`   | `--skip-absolute-urls`     | Skip [absolute URLs check](#warning-avoid-absolute-urls) warning                      |
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

## `lib`

```text
ERROR (lib) don't commit libraries
```

`node_modules` (or `bower_components`) should be installed via `npm install` in each environment

- Run `git rm -rf node_modules/ bower_components/` to remove the libraries
- Add `bower_components/` and `node_modules/` to your `.gitignore`
- To skip this check, use `builderrors --skip-libraries` (e.g. to share a git repo for offline installation)

## `minified`

```text
ERROR (minified) don't commit minified files
```

Minified files are not source code and shouldn't be version-controlled. They're generated

- Run `git rm jquery.min.js ...other.min.js` to remove the file
- Run `npm install your-package-name` to install the package
- Change URLs to point to the package (e.g. `node_modules/<lib>/dist/<lib>.min.js`)
- To skip this check, use `builderrors --skip-minified` (e.g. if the package is not on npm)

## `lfs`

```text
ERROR (lfs) use Git LFS for large files
```

Git stores copies of every version. LFS stores pointers instead

- Install [Git LFS](https://git-lfs.github.com/)
- Run `git lfs install` on your repo
- For each large file(s), run these commands on `bash` or Git bash: [see help](https://git-lfs.github.com/)
  <!-- Dummy comment to avoid MD031/blanks-around-fences -->
  ```bash
  git rm your-large-file.ext          # Remove and commit
  git commit -m"Remove your-large-file.txt"
  git lfs track your-large-file.ext   # Use Git LFS for your file(s)
  # Copy your-large-file.ext back
  git add your-large-file.ext         # Add and commit
  git commit -m"Use LFS for your-large-file.txt`
  ```
  <!-- Dummy comment to avoid MD031/blanks-around-fences -->
- To skip this check, use `builderrors --skip-lfs` (e.g. if you can't use LFS)

## `useless`

```text
ERROR (useless) don't commit useless/generated files
```

Thumbnails (`thumbs.db`), backups (`*~`), etc don't need to be committed. Nor logs (`*.log`)

- Run `git rm <useless.file>` to remove it
- Add `<useless.file>` to your `.gitignore`
- To skip this check, use `builderrors --skip-useless` (e.g. if you DO need to commit `.log` files)

## `duplicate-files`

```text
ERROR (duplicate-files) delete duplicate files
```

You can re-use the same file

- Run `git rm <duplicate.file>` to remove it
- Replace `<duplicate.file>` with the retained file in your code
- To allow duplicate files less than 1000 bytes, run `builderrors --duplicate-filesize=1000`
- To skip this check, use `builderrors --skip-duplicate-files` (e.g. if you need duplicate files for test cases)

## `duplicate-lines`

```text
ERROR (duplicate-lines) reduce duplicate lines
```

You can re-use the same code

- Use **loops** for code repeated one after another
- Use **functions** for code repeated in different places (either in the same file or different files)
- Use **function parameters** to handle minor variations in the repetition
- Use **data structures** for larger variations. For example, create an array or
  dictionary that stores all the parameters that vary. Remember: you can use functions as values
- Use **function generators** for extreme variations in code. Write a function
  to create and return a new function depending on your variation
- Refactor the code and test _very carefully_. (Unit test cases help here)
- To ignore duplicates up to 100 lines, run `builderrors --duplicate-lines=100`
- To skip this check, use `builderrors --skip-duplicate-lines` (e.g. if you need duplicate code for test cases)

## `prettier`

```text
ERROR (prettier) re-format JS/CSS with Prettier
```

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

- To auto-fix, run `npx prettier --write "**/*.{js,jsx,vue,ts,css,scss,sass,yaml,md}"`
- To ignore specific files, add a [`.prettierignore`](https://prettier.io/docs/en/ignore.html) file (e.g. add `*.html`)
- To ignore [specific rules](https://prettier.io/docs/en/options.html), add a [`.prettierrc`](https://prettier.io/docs/en/configuration.html) file
- To skip this check, use `builderrors --skip-prettier` (e.g. if you temporarily need the build to pass)

## `black`

```text
ERROR (black) re-format Python with Black
```

It's important to have consistent formatting for readability. We use [black](https://black.readthedocs.io/) for Python files.

Use the [VS Code Prettier - Black plugin](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)
to auto-format your code.

- To auto-fix, run:
  - `pip install black` (one-time)
  - `black . --skip-string-normalization --line-length=99`
- To ignore [specific rules](https://prettier.io/docs/en/options.html), add a [`pyproject.toml`](https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file) file
- To skip this check, use `builderrors --skip-black` (e.g. if you temporarily need the build to pass)

Troubleshooting:

- `black is not recognized as an internal or external command`
  - **FIX**: `pip install black`
- `pip install black` raises a `PermissionError`
  - **FIX**: `pip install --user black` instead of `pip install black`

## `py-filenames`

```text
ERROR (py-filenames) use lower_alpha Python paths
```

You can't import a Python file unless it has alphanumeric letters. Using lowercase is the convention.

- Rename the Python files using lower case alphanumerics and underscore (`_`)
- To skip this check, use `builderrors --skip-py-filenames` (e.g. if you won't be importing the module)

## `flake8`

```text
ERROR (flake8) fix Python errors
```

[Flake8](https://flake8.pycqa.org//) reports Python errors with the
[flake8-blind-except](https://pypi.org/package/flake8-blind-except),
[flake8-print](https://pypi.org/package/flake8-print),
[flake8-debugger](https://pypi.org/package/flake8-debugger),
[flake8-2020](https://pypi.org/package/flake8-2020), and
[pep8-naming](https://pypi.org/package/pep8-naming) plugins.

- To ignore a specific line, add [`# noqa: <error-number>`](https://flake8.pycqa.org/en/latest/user/violations.html) at the end, e.g. `print("\n") # noqa: T201`
- To ignore specific rules, add a [`.flake8`](https://flake8.pycqa.org/en/latest/user/configuration.html) file
  - Make sure to use `extend-ignore=E203,E501` for consistency with [black](https://black.readthedocs.io/en/stable/guides/using_black_with_other_tools.html#flake8)
- To skip this check, use `builderrors --skip-flake8` (e.g. if you temporarily need the build to pass)

<!-- DO NOT LIST COMMON ERRORS. It wastes space. It's self-explanatory. People can refer it online.

Common errors:

- **F841**: local variable 'x' is assigned to but never used. **Check if you forgot**, else don't assign it
- **F401**: 'x' imported but unused. **Check if you forgot** to use the module. Else don't import it
- **F821**: undefined name 'x' You used an uninitialized variable. That's wrong
- **F811**: redefinition of unused 'x'. You assigned a variable and never used it. Then you're reassigning it. Or re-importing. Look carefully
- **B901** or **B902**: blind except: statement. Trap **specific** exceptions. Blind exceptions can trap even syntax errors and confuse you later
- **F601**: dictionary key 'x' repeated with different values. e.g. `{'x': 1, 'x': 2}`. That's wrong
- **T001** or **T003**: print found -- just remove `print` in production code
- **N806**: variable in function should be lowercase -- rename your variable
- **N802** or **N803**: function and argument names should be lowercase

-->

## `bandit`

```text
ERROR (bandit) fix Python security errors
```

[Bandit](https://bandit.readthedocs.io/) reports security errors in Python.

- Re-write the code based on advice from bandit
- To ignore a specific line, add a [`# nosec`](https://bandit.readthedocs.io/en/latest/config.html#exclusions) at the end
- To ignore specific rules, add a [`.bandit`](https://bandit.readthedocs.io/en/latest/config.html#bandit-settings) file
- To only report errors with high confidence, use `builderrors --bandit-confidence=high` (or `medium`)
- To only report errors with high severity, use `builderrors --bandit-severity=high` (or `medium`)
- To skip this check, use `builderrors --skip-bandit` (e.g. if there are too many false-positives)

## `eslint`

```text
ERROR (eslint) fix JavaScript errors
```

[ESLint](https://eslint.org/) reports JavaScript errors in JS and HTML files -- including HTML templates.

- To auto-fix, run `npx eslint --fix`
- To ignore a specific line, add a [`// eslint-disable-line`](https://eslint.org/docs/latest/user-guide/configuring/rules#disabling-rules) at the end
- To ignore specific rules, add a [`.eslintrc.js`](http://eslint.org/docs/rules/) based on the [default](.eslintrc.js)
- To skip this check, use `builderrors --skip-eslint` (e.g. if you temporarily need the build to pass)

Common errors:

- **[`'x' is not defined. [Error/no-undef]`](http://eslint.org/docs/rules/no-undef)**
  - [Add in your `.js`](https://eslint.org/docs/latest/user-guide/configuring/language-options#using-configuration-comments-1): `/* globals x, ... */`.
  - [Add in `.eslintrc.js`](https://eslint.org/docs/latest/user-guide/configuring/language-options#using-configuration-files-1) for libraries like `d3`, `$`, `_`, etc.: `"globals": {"d3": "readonly", ...}`
- **[`'x' is assigned a value but never used. [Error/no-unused-vars]`](http://eslint.org/docs/rules/no-unused-vars)**
  - [Add in your `.js`](https://eslint.org/docs/latest/rules/no-unused-vars#exported): `/* exported x, ... */` (or don't assign to the variable)

## `stylelint`

```text
ERROR (stylelint) fix CSS errors
```

[stylelint](https://stylelint.io/) reports CSS and SASS errors.

- Re-write the code based on advice from stylelint
- To ignore a specific line, add a [`/* stylelint-disable-line */`](https://stylelint.io/user-guide/ignore-code) at the end
- To ignore specific rules, add a [`.stylelintrc.js`](https://stylelint.io/user-guide/configure) file based on the [default](.stylelintrc.js). For example:
  - `"selector-no-unknown": null` allows styling custom web components
- To skip this check, use `builderrors --skip-stylelint` (e.g. if you're using third-party provided CSS)

## `htmlhint`

```text
ERROR (htmlhint) fix HTML errors
```

[htmlhint](https://htmlhint.com/) checks HTML and reports errors.

- Re-write the code based on advice from htmlhint
- To ignore specific rules, add a [`.htmlhintrc`](https://htmlhint.com/docs/user-guide/getting-started) file based on the [default](.htmlhintrc)
- To skip this check, use `builderrors --skip-htmllint` (e.g. if you're building a Lodash template library)

## `css-chars`

```text
ERROR (css-chars): reduce CSS code
```

You have too much CSS code, even after minifying with [clean-css](https://www.npmjs.com/package/clean-css-cli).

- Reduce CSS code using libraries
- To allow 20,000 characters, use `builderrors --css-chars-error=10000`
- To skip this check, use `builderrors --skip-css-chars`

## `code-chars`

```text
ERROR (code-chars) reduce PY/JS code
```

You have too much Python / JavaScript code

- Reduce code using libraries
- To allow 80,000 characters, use `builderrors --code-chars-error=80000`
- To skip this check, use `builderrors --skip-code-chars`

## `npm-audit`

```text
WARNING (npm-audit) avoid unsafe npm packages
```

[`npm audit`](https://docs.npmjs.com/cli/v8/commands/npm-audit) checks for JavaScript package vulnerabilities.

- To auto-fix, run `npm audit fix`
- To upgrade all packages to the latest compatible version, run `npm upgrade`
- Change package versions manually and retry

## `flake8-extra`

```text
WARNING (flake8-extra) improve Python code
```

[Flake8](https://flake8.pycqa.org//) reports Python warnings based on experimental plugins. These are **OPTIONAL but GOOD** to fix.

- [flake8-bugbear](https://pypi.org/package/flake8-bugbear): catches potential bugs
- [flake8-comprehensions](https://pypi.org/package/flake8-comprehensions): simplifies list comprehensions
- [flake8-eradicate](https://pypi.org/package/flake8-eradicate): reports commented code
- [flake8-simplify](https://pypi.org/package/flake8-simplify): suggests code simplifications

You can fix these exactly like [flake8 errors](#fix.

<!-- DO NOT LIST COMMON ERRORS. It wastes space. It's self-explanatory. People can refer it online.

Common errors:

- **B001**: Do not use bare `except:`, it also catches unexpected events like memory errors, interrupts, system exit, and so on.  Prefer `except Exception:`.  If you're sure what you're doing, be explicit and write `except BaseException:`
- **B006**: Do not use mutable data structures for argument defaults.  They are created during function definition time. All calls to the function reuse this one instance of that data structure, persisting changes between them
- **B007**: Loop control variable 'index' not used within the loop body. If this is intended, start the name with an underscore
- **C401**: Unnecessary generator - rewrite as a set comprehension
- **C402**: Unnecessary generator - rewrite as a dict comprehension
- **C403**: Unnecessary list comprehension - rewrite as a set comprehension
- **C408**: Unnecessary dict call - rewrite as a literal
- **C414**: Unnecessary list call within sorted()
- **C416**: Unnecessary list comprehension - rewrite using list()
- **C417**: Unnecessary use of map - use a list comprehension instead
- **E800**: Found commented out code
- **SIM102**: Use a single if-statement instead of nested if-statements
- **SIM105**: Use 'contextlib.suppress(...)'
- **SIM114**: Use logical or ((a == b) or (c == d)) and a single body
- **SIM118**: Use 'x in dict' instead of 'x in dict.keys()'
- **SIM201**: Use 'i != 0' instead of 'not i == 0'
- **SIM203**: Use 'table not in meta' instead of 'not table in meta'

-->

## `absolute-urls`

```text
WARNING (absolute-urls) avoid absolute URLs
```

Avoid URLs that begin with `/`, e.g. `<a href="/login">` or `<img src="/assets/icon.png">`. If the
application is deployed at a different path (e.g. at `https://example.org/app/` instead of
`https://example.org/`), these links will break.

Change URLs to relative paths,
e.g. `<a href="../login">` or `<a href="login">` or `<img src="../assets/icon.png">`.

# Alternatives

Comprehensive multi-linting tools are available at:

- [Super-Linter](https://github.com/github/super-linter)
- [MegaLinter Runner](https://github.com/oxsecurity/megalinter)
