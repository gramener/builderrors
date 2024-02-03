# Contributing to builderrors

## More tests

If you have more tests to suggest, please raise an [issue](https://github.com/gramener/builderrors/issues). Here are some we're considering:

- Code approximate similarity
- Git branching structure
- [`nbqa`](https://pypi.org/project/nbqa/) for Jupyter notebooks -- applying flake8 may be too restrictive. Strongly recommend fixing, but it's not a check
- Python checks
  - [`blacken-docs`](https://pypi.org/project/blacken-docs/) for Python docstrings
  - [`pyupgrade`](https://pypi.org/project/pyupgrade/) for safe language-specific upgrades. Strongly recommend running, but it's not a check
  - [`pyright`](https://github.com/microsoft/pyright) or
    [`mypy`](https://github.com/python/mypy) for Python static type checking
  - [`safety`](https://github.com/pyupio/safety) for Python security scanning
- Flake8 plugins
  - [flake8-annotations](https://pypi.org/project/flake8-annotations) ⭐116
  - [flake8-type-checking](https://pypi.org/project/flake8-type-checking) ⭐105. Lets you avoid importing libraries JUST for type-checking
  - [flake8-cognitive-complexity](https://pypi.org/project/flake8-cognitive-complexity) ⭐54. More apt than McCabe complexity
  - [flake8-internal-name-import](https://pypi.org/project/flake8-internal-name-import) ⭐3. Check for imports that clash with internal names
- [Python Typing](https://github.com/typeddjango/awesome-python-typing)
  - [pyre-check](https://pypi.org/project/pyre-check/) ⭐6.6k type checker
  - [MonkeyType](https://pypi.org/project/MonkeyType/) ⭐4.5k automatically adds type annotations
- ESLint plugins / rules
  - [eslint-plugin-etc/no-commented-out-code](https://github.com/cartant/eslint-plugin-etc/blob/main/docs/rules/no-commented-out-code.md)
  - [eslint-plugin-no-jquery/no-ajax](https://github.com/wikimedia/eslint-plugin-no-jquery/blob/master/docs/rules/no-ajax.md): Avoid $.ajax / $.get / $.post. Use fetch instead.
  - [eslint-plugin-promise/prefer-await-to-then](https://github.com/eslint-community/eslint-plugin-promise/blob/main/docs/rules/prefer-await-to-then.md)
  - [no-var](https://eslint.org/docs/latest/rules/no-var): Avoid `var`. Use `let` or `const` instead
  - [@typescript-eslint/eslint-plugin](https://www.npmjs.com/package/@typescript-eslint/eslint-plugin) ⭐12,400
  - [eslint-plugin-unicorn](https://github.com/sindresorhus/eslint-plugin-unicorn) ⭐2,800
  - [eslint-formatter-summary](https://github.com/mhipszki/eslint-formatter-summary) ⭐37
- ESLint rules to evaluate
  - `array-callback-return`
  - `default-param-last`
  - `no-array-constructor`
  - `no-constant-binary-expression`
  - `no-duplicate-imports`
  - `no-invalid-this`
  - `no-lone-blocks`
  - `no-lonely-if`
  - `no-return-assign`
  - `no-self-compare`
  - `no-sequences`
  - `no-template-curly-in-string`
  - `no-unmodified-loop-condition`
  - `no-unneeded-ternary`
  - `no-unreachable-loop`
  - `no-unused-expressions`
  - `no-use-before-define`
  - `no-useless-call`
  - `no-useless-return`
  - `no-var`
  - `prefer-const`
  - `prefer-destructuring`
  - `prefer-exponentiation-operator`
  - `prefer-numeric-literals`
  - `prefer-object-has-own`
  - `prefer-object-spread`
  - `prefer-rest-params`
  - `prefer-spread`
  - `prefer-template`
- [`codeclimate-duplication`](https://github.com/codeclimate/codeclimate-duplication) for fuzzy duplication
- [`curlylint`](https://github.com/thibaudcolas/curlylint) or
  [`djlint`](https://github.com/Riverside-Healthcare/djLint) for HTML templates
- [`commitlint`](https://commitlint.js.org/#/) for Conventional commits
- [`markdownlint`](https://www.npmjs.com/package/markdownlint). But Prettier does most of this
- [`yamllint`](https://yamllint.readthedocs.io/). But Prettier handles most of this, except `empty-values`, `key-duplicates`
- [`sqlfluff`](https://github.com/sqlfluff/sqlfluff) for SQL
- [`webhint`](https://webhint.io/) as an alternative to htmlhint is promising, but has many false positives that need customization for our work (e.g. inline-style warnings, requiring meta viewport, etc.)
- Documentation linters for Python, JavaScript and README (e.g. overview, setup instructions, contact)
- Security & containers
  - `docker scan`, which uses snyk
  - [`tfsec`](https://github.com/aquasecurity/tfsec)
  - [`snyk`](https://snyk.io/). It's [paid](https://snyk.io/plans/) but has a free tier
  - [`hadolint`](https://github.com/hadolint/hadolint) for Dockerfile
  - [`checkov`](https://github.com/bridgecrewio/checkov) for containers & secrets
  - devskim, dustilock, git_diff, goodcheck, secretlint, semgrep, syft, trivy
- Spelling: textllint, misspell, cspell, proselint
- Tools
  - [Sonarqube](https://docs.sonarqube.org/latest/setup-and-upgrade/install-the-server/)
  - [Deepsource](https://deepsource.io/docs/analyzer/python/)
- Testing output (DAST)
  - [Gitlab DAST](https://docs.gitlab.com/ee/user/application_security/dast/)
  - [OWASP ZAP](https://www.zaproxy.org/docs/docker/)
  - [API Fuzzing](https://docs.gitlab.com/ee/user/application_security/api_fuzzing/)
  - [Lighthouse](https://github.com/GoogleChrome/lighthouse): `npm i lighthouse`
  - [Venom](https://github.com/orkestral/venom) `npm i venom-bot`
    - [OSHP-Validator for headers](https://github.com/oshp/oshp-validator)
  - [pa11y](https://github.com/pa11y/pa11y) for accessibility testing
  - [SiteSpeed](https://www.sitespeed.io/) for browser performance testing
  - [K6](https://github.com/grafana/k6) for load performance testing
- Metrics
  - [Maintainability ratings](https://docs.codeclimate.com/docs/maintainability-calculation)

<!--

- Custom [Semgrep](https://semgrep.dev/) rules, or [CodeQL](https://codeql.github.com/)?
- See <https://semgrep.dev/blog/2021/python-static-analysis-comparison-bandit-semgrep>
-->

Here are some we don't plan to add:

- ESLint plugins
  - [`eslint-plugin-json`](https://www.npmjs.com/package/eslint-plugin-json). We treat JSON as data, not code
  - [`eslint-plugin-jsonc`](https://www.npmjs.com/package/eslint-plugin-jsonc). Prettier formats JSONC, if required
  - [`standardjs`](https://standardjs.com/) is a set of standard eslint rules. But we customize eslint with [`eslint-plugin-html`](https://github.com/BenoitZugmeyer/eslint-plugin-html)
- Flake8 plugins:
  - [tryceratops](https://pypi.org/project/tryceratops) ⭐333. Doesn't flag anything by default
  - [flake8-import-order](https://pypi.org/project/flake8-import-order) ⭐266. It's OK to import in any order
  - [pandas-vet](https://pypi.org/project/pandas-vet) ⭐142. [False positives](https://github.com/deppen8/pandas-vet/issues/74), cribs about `inplace=`
  - [flake8-isort](https://pypi.org/project/flake8-isort) ⭐. It's OK to import in any order
  - [flake8-broken-line](https://pypi.org/project/flake8-broken-line) ⭐111. I don't think we use \ to break lines a lot
  - [flake8-logging-format](https://pypi.org/project/flake8-logging-format) ⭐104. OK to use `.format` in logging
  - [flake8-builtins](https://pypi.org/project/flake8-builtins) ⭐92. Too many false positives, e.g. arg type=, gramex.cache.open, id
  - [flake8-pie](https://pypi.org/project/flake8-pie) ⭐48. False positives about len(df), `pass` usage. Cribs about except Exception, `.format` in logging. But has some good checks
  - [flake8-return](https://pypi.org/project/flake8-return) ⭐40. Discourages if: else: with return, which is not a bad idea
  - [flake8-requirements](https://pypi.org/project/flake8-requirements) ⭐33. Good for packages, but not apps in a Gramex environment
  - [flake8-expression-complexity](https://pypi.org/project/flake8-expression-complexity) ⭐32. Complex expressions can be readable. Unclear how to fix
  - [flake8-unused-arguments](https://pypi.org/project/flake8-unused-arguments) ⭐28. False positives. We may need unused args to match signatures
  - [flake8-sql](https://pypi.org/project/flake8-sql) ⭐26. False positives about case, non-SQL and many others
  - [flake8-implicit-str-concat](https://pypi.org/project/flake8-implicit-str-concat) ⭐26. ISC001 (implicit concat on same line) is good, but ISC003 (use implicit, not explicit concat) is bad
  - [flake8-no-implicit-concat](https://pypi.org/project/flake8-no-implicit-concat) ⭐17. PEP3126 says implict concatenation isn't bad
  - [flake8-noqa](https://pypi.org/project/flake8-noqa) ⭐21. **USE LOCALLY**. Has false positives depending on what other plugins are installed
  - [flake8-fixme](https://pypi.org/project/flake8-fixme) ⭐18. We want to ENCOURAGE TODO statements. This discourages them
  - [flake8-todos](https://pypi.org/project/flake8-todos) ⭐18. We want to ENCOURAGE TODO statements. This discourages them
  - [flake8-string-format](https://pypi.org/project/flake8-string-format) ⭐18. It's crazy. Doesn't work. Only false positives
  - [flake8-datetime-utcnow-plugin](https://pypi.org/project/flake8-datetime-utcnow-plugin) ⭐1. Error message is unclear. Very minor impact
  - [flake8-github](https://pypi.org/project/flake8-github) ⭐1. Format for Github. We want to generate our own cross-CI format
- [`synt`](https://github.com/brentlintner/synt) uses [esprima](https://www.npmjs.com/package/esprima) which doesn't parse [`?.`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining) and other modern JS features
- [escomplex](https://github.com/escomplex/escomplex) ⭐257 and [typhonjs-escomplex](https://github.com/typhonjs-node-escomplex/typhonjs-escomplex) ⭐106. Unmaintained

## Release

1. Update `VERSION=` in [builderrors](builderrors)

2. Upgrade npm packages if there are `npm audit` issues. **Test after upgrade!**

   ```bash
   npm audit || npm upgrade
   ```

3. Test for errors.

   ```bash
   # One-time setup
   git clone "https://code.gramener.com/s.anand/build-errors-test" "build-errors-test"`
   ./setup.sh

   # Run tests
   npm run build
   ./builderrors
   ./test-builderrors.sh
   ```

4. Build and push Docker container

   ```bash
   export VERSION=3.x.x
   docker pull nikolaik/python-nodejs:python3.10-nodejs18-bullseye
   docker build --tag gramener/builderrors:$VERSION --tag gramener/builderrors:latest .
   docker run --rm -v `pwd`:/src gramener/builderrors:latest
   # docker login  # log in as any user with push access to gramener/builderrors
   docker push gramener/builderrors:$VERSION
   docker push gramener/builderrors:latest
   ```

5. Commit and push git repo

   ```bash
   export VERSION=3.x.x
   git commit . -m"DOC: Release $VERSION"
   git tag v$VERSION
   git push --follow-tags
   ```

    <!-- git push gitlab main --follow-tags  # For https://code.gramener.com/cto/builderrors -->

6. Deploy image on servers. For example, on Gitlab CI runners, run:

   ```bash
   docker pull gramener/builderrors
   ```
