/* eslint-env node */

// To override these rules, create a .eslintrc.js file in your app.
// See https://eslint.org/docs/user-guide/configuring
module.exports = {
  parserOptions: {
    ecmaVersion: "latest",
  },
  // These default plugins are installed in the root gramex director via package.json
  plugins: ["html", "template"],
  // Styles are based on recommended eslint fields, but with specific overrides
  extends: "eslint:recommended",
  rules: {
    indent: ["error", 2, { VariableDeclarator: 2 }], // 2-space indentation
    "linebreak-style": ["error", "unix"], // Force UNIX style line
    quotes: ["warn", "double"], // Prefer double-quotes style
    semi: ["warn", "never"], // Prefer no-semicolon style
  },
}
