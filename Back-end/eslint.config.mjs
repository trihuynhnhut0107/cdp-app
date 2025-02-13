import globals from "globals";
import pluginJs from "@eslint/js";

/** @type {import('eslint').Linter.Config[]} */
export default [
  { files: ["**/*.js"], languageOptions: { sourceType: "commonjs" } },
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
    },
    env: {
      node: true, // ✅ Enables Node.js globals like `process`
      es2021: true,
    },
    globals: {
      process: "readonly", // ✅ Prevents ESLint errors on `process.env`
    },
    extends: ["eslint:recommended"],
    rules: {
      "no-unused-vars": "warn", // ✅ Warns for unused variables instead of erroring
      "no-undef": "off", // ✅ Prevents errors for undefined variables like `process.env`
    },
  },
];
