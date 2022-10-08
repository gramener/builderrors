# Contributing to builderrors

## More tests

If you have more tests to suggest, please raise an [issue](https://code.gramener.com/cto/builderrors/-/issues). Here are some we're considering:

- [`pyright`](https://github.com/microsoft/pyright) or
  [`mypy`](https://github.com/python/mypy) for Python static type checking
- [`curlylint`](https://github.com/thibaudcolas/curlylint) or
  [`djlint`](https://github.com/Riverside-Healthcare/djLint) for HTML templates
- [`markdownlint`](https://www.npmjs.com/package/markdownlint). But Prettier does most of this
- [`yamllint`](https://yamllint.readthedocs.io/). But Prettier handles most of this, except `empty-values`, `key-duplicates`
- [`sqlfluff`](https://github.com/sqlfluff/sqlfluff) for SQL
- Documentation linters for Python, JavaScript and README (e.g. overview, setup instructions, contact)
- Security & containers
  - [`snyk`](https://snyk.io/). It's [paid](https://snyk.io/plans/) but has a free tier
  - [`hadolint`](https://github.com/hadolint/hadolint) for Dockerfile
  - [`gitleaks`](https://github.com/zricethezav/gitleaks) for secrets / keys leakage
  - [`checkov`](https://github.com/bridgecrewio/checkov) for containers & secrets
  - devskim, dustilock, git_diff, goodcheck, secretlint, semgrep, syft, trivy
- Spelling: textllint, misspell, cspell, proselint

Here are some we don't plan to add:

- [`npm audit`](https://docs.npmjs.com/cli/v8/commands/npm-audit) because it reports un-fixable problems,
  and may be [broken by design](https://overreacted.io/npm-audit-broken-by-design/)
- [`eslint-plugin-json`](https://www.npmjs.com/package/eslint-plugin-json) or
  [`eslint-plugin-jsonc`](https://www.npmjs.com/package/eslint-plugin-jsonc). Prettier formats JSON.
  These are not the best tools for linting JSON, though
- [`standardjs`](https://standardjs.com/). It's a set of standard eslint rules. But we customize
  eslint with [`eslint-plugin-html`](https://github.com/BenoitZugmeyer/eslint-plugin-html)

## Release

1. Update `VERSION=` in [builderrors](builderrors)

2. Upgrade npm packages. Ensure there are no `npm audit` issues

   ```bash
   npm upgrade
   ```

3. Test for errors

   ```bash
   bash test-builderrors.sh
   ```

4. Build and push Docker container

   ```bash
   export VERSION=1.x.x
   docker build --tag gramener/builderrors:$VERSION --tag gramener/builderrors:latest .
   docker run --rm -v `pwd`:/src gramener/builderrors:latest
   docker push gramener/builderrors --all-tags
   ```

5. Commit and push git repo

   ```bash
   export VERSION=1.x.x
   git commit . -m"DOC: Release $VERSION"
   git tag -a v$VERSION -m"Release $VERSION"
   git push --follow-tags
   ```
