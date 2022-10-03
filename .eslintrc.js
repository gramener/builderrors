/* eslint-env node */

// These rules override the configurations in the app. Use --skip-eslint-extra to ignore this
// See https://eslint.org/docs/user-guide/configuring
module.exports = {
  parserOptions: {
    ecmaVersion: "latest",
  },
  plugins: ["html", "template"],
  extends: "eslint:recommended",
  rules: {
    complexity: ["warn", { max: 10 }],
  },
};
