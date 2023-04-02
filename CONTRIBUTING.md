# Contributing to builderrors

## More tests

If you have more tests to suggest, please raise an [issue](https://github.com/gramener/builderrors/issues). Here are some we're considering:

- [`commitlint`](https://commitlint.js.org/#/) for Conventional commits
- [`pyright`](https://github.com/microsoft/pyright) or
  [`mypy`](https://github.com/python/mypy) for Python static type checking
- [`safety`](https://github.com/pyupio/safety) for Python security scanning
- Flake8 plugins
  - [flake8-annotations](https://pypi.org/project/flake8-annotations) ⭐116
  - [flake8-cognitive-complexity](https://pypi.org/project/flake8-cognitive-complexity) ⭐54. More apt than McCabe complexity
- ESLint plugins
  - [@typescript-eslint/eslint-plugin](https://www.npmjs.com/package/@typescript-eslint/eslint-plugin) ⭐12,400
  - [eslint-plugin-unicorn](https://github.com/sindresorhus/eslint-plugin-unicorn) ⭐2,800
  - [eslint-formatter-summary](https://github.com/mhipszki/eslint-formatter-summary) ⭐37
- [`codeclimate-duplication`](https://github.com/codeclimate/codeclimate-duplication) for fuzzy duplication
- [`curlylint`](https://github.com/thibaudcolas/curlylint) or
  [`djlint`](https://github.com/Riverside-Healthcare/djLint) for HTML templates
- [`markdownlint`](https://www.npmjs.com/package/markdownlint). But Prettier does most of this
- [`yamllint`](https://yamllint.readthedocs.io/). But Prettier handles most of this, except `empty-values`, `key-duplicates`
- [`sqlfluff`](https://github.com/sqlfluff/sqlfluff) for SQL
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
- [`synt`](https://github.com/brentlintner/synt) uses [esprima](https://www.npmjs.com/package/esprima) which doesn't parse [`?.`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining) and other modern JS features

## Release

1. Update `VERSION=` in [builderrors](builderrors)

2. Upgrade npm packages if there are `npm audit` issues. **Test after upgrade!**

   ```bash
   npm audit || npm upgrade
   ```

3. Test for errors

   ```bash
   npm run build
   ./builderrors
   ./test-builderrors.sh
   ```

4. Build and push Docker container

   ```bash
   export VERSION=2.x.x
   docker pull nikolaik/python-nodejs:python3.10-nodejs18-bullseye
   docker build --tag gramener/builderrors:$VERSION --tag gramener/builderrors:latest .
   docker run --rm -v `pwd`:/src gramener/builderrors:latest
   docker push gramener/builderrors:$VERSION
   docker push gramener/builderrors:latest
   ```

5. Commit and push git repo

   ```bash
   export VERSION=2.x.x
   git commit . -m"DOC: Release $VERSION"
   git tag -a v$VERSION -m"Release $VERSION"
   git push --follow-tags
   ```

    <!-- git push gitlab main --follow-tags  # For https://code.gramener.com/cto/builderrors -->

6. Deploy image on servers. For example, on Gitlab CI runners, run:

   ```bash
   docker pull gramener/builderrors
   ```
