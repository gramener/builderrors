#!/usr/bin/env bash

# Run tests from the same folder as this script
SCRIPT_DIR=`dirname "$(realpath "$0")"`
cd $SCRIPT_DIR

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
# PREFIX_DIR will be used inside sed. Escape sed special characters. https://unix.stackexchange.com/a/519305
PREFIX_VAR=$(sed -e 's/[&\\/]/\\&/g; s/$/\\/' -e '$s/\\$//' <<<"$PREFIX_DIR")

# By default, we don't have any errors
EXIT_STATUS=0

# Run builderrors on branch $1 and compare with test-output/$1.txt
check() {
  BRANCH="$1"; shift
  echo "Testing $BRANCH..."
  git checkout --quiet "$BRANCH"

  # In the diff below:
  #   --ignore-space-change: when running on git bash, the number of spaces changes
  #   --ignore-tab-expansion: same as above
  #   --ignore-trailing-space: duplicate-files awk script has a trailing space
  #   --ignore-matching-lines: ignores bandit's report of the batch run time
  #   sed #1: strips color codes from jscpd: https://stackoverflow.com/a/18000433/100904
  #   sed #2: replace current directory in output of eslint, htmlhint
  #   sed #3: replace .\file.py with ./file.py for bandit
  diff \
    --ignore-space-change \
    --ignore-tab-expansion \
    --ignore-trailing-space \
    --ignore-matching-lines="Run started.*" \
    <(../builderrors $@ --duplicate-filesize=0 --duplicate-lines=30 --css-chars-error=10000 --code-chars-error=30000 --lfs-size=1000000 | \
      sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" |
      sed "s/$PREFIX_VAR//g" |
      sed "s~\.\\\\~\./~g") \
    "../test-output/$BRANCH.txt" || EXIT_STATUS=1
}

check libraries-node
check libraries-bower --skip-prettier
check minified
check git-lfs
check useless
check duplicate-files --skip-prettier --skip-black
check duplicate-lines --skip-prettier --skip-black
check prettier
check black
check python-filenames --skip-black
check flake8 --skip-black
check bandit --skip-black
check eslint
check stylelint
check htmlhint

# Exit code 1 if ANY of the outputs had an error
exit $EXIT_STATUS
