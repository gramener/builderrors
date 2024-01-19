#!/usr/bin/env bash

# Run tests from the same folder as this script
SCRIPT_DIR=`dirname "$(realpath "$0")"`
cd "$SCRIPT_DIR"

# Clone or pull the test repo
# git clone "git@code.gramener.com:s.anand/build-errors-test.git" "build-errors-test" 2> /dev/null || git -C "build-errors-test" pull
cd build-errors-test

# Sort filenames consistently to match test-output. https://serverfault.com/a/95593
export LC_COLLATE=C

# eslint, htmlhint print absolute filenames. That can mess with test output comparisons. So strip directory name.
# On Windows, use cmd /cCD to get the path. Add a backslash to it.
# On Linux, use pwd to get the path. Add a forward slash to it.
IS_WINDOWS="$(which cmd)"
if [ -x "$IS_WINDOWS" ] ; then
  PREFIX_DIR="$(cmd \/cCD | tr -d '\r')\\"
else
  PREFIX_DIR="$(pwd)/"
fi
# Use PREFIX_VAR to remove current directory from output. Makes test cases portable from any directory.
# PREFIX_DIR will be used inside sed. Escape sed special characters. https://unix.stackexchange.com/a/519305
PREFIX_VAR=$(sed -e 's/[&\\/]/\\&/g; s/$/\\/' -e '$s/\\$//' <<<"$PREFIX_DIR")

# By default, we don't have any errors
EXIT_STATUS=0

# Run builderrors on branch $1 and compare with test-output/$1.txt
check() {
  BRANCH="$1"; shift
  echo "Testing $BRANCH..."
  git -c core.longPaths=true clean -fd > /dev/null
  git checkout --quiet "$BRANCH"

  # diff
  #   --ignore-space-change: when running on git bash, the number of spaces changes
  #   --ignore-tab-expansion: same as above
  #   --ignore-trailing-space: duplicate-files awk script has a trailing space
  #   --ignore-matching-lines: ignores bandit's report of the batch run time
  # builderrors
  #   --duplicate-filesize=0: show the empty duplicate filenames we have in our tests
  #   --duplicate-lines=30: test cases are built using this value
  # sed
  #   #1: strips color codes from jscpd: https://stackoverflow.com/a/18000433/100904
  #   #2: strip current directory in output of eslint, htmlhint
  #   #3: replace "BUILD FAILED on builderrors version ..." with a standard "BUILD FAILED."
  #   #4: replace "BUILD PASSED on builderrors version ..." with a standard "BUILD PASSED."
  #   #5: replace .\file.py with ./file.py for bandit
  diff \
    --ignore-space-change \
    --ignore-tab-expansion \
    --ignore-trailing-space \
    --ignore-matching-lines="Run started.*" \
    <(../builderrors $@ --build-env=gitlab-ci --duplicate-filesize=0 --duplicate-lines=30 | \
      sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" |
      sed -E "s/^BUILD FAILED on builderrors v[0-9\.]*\. ([0-9]* min to fix)/BUILD FAILED. \1/" |
      sed "s/^BUILD PASSED on builderrors v[0-9\.]*\./BUILD PASSED./" |
      sed "s/$PREFIX_VAR//g" |
      sed "s~\.\\\\~\./~g") \
    "../test-output/$BRANCH.txt" || EXIT_STATUS=1
}

# Note: Black file order is unpredictable. So --skip=black when there are multiple .py files.
# Note: npm-audit may throw up new errors. So --skip=npm-audit when there are JS files.
check libraries-node
check libraries-bower
check minified
check git-lfs
check useless
check duplicate-files --skip=black --skip=flake8-extra
check duplicate-lines --skip=black --skip=pydoc
check prettier
check black
check python-filenames
check flake8 --skip=black
check bandit
check eslint
check eslint-config --skip=npm-audit
check eslint-package --skip=npm-audit
check stylelint
check htmlhint
check flake8-extra --skip=bandit  # Test --skip=* flags and that build passes
check complexity --skip=npm-audit
check data-blocks --only=data-blocks  # Test --only= option
check url-templates --only=url-templates  # Test --only= option
check js-modules
check npm-audit
check gitleaks
check absolute-urls --skip=gitleaks

# Exit code 1 if ANY of the outputs had an error
exit $EXIT_STATUS
