import eslintPluginToml from 'eslint-plugin-toml'
import stylistic from '@stylistic/eslint-plugin'
export default [
  ...eslintPluginToml.configs['flat/recommended'],
  {
    plugins: {
      '@stylistic': stylistic
    },
    rules: {
      '@stylistic/eol-last': 'error',
      '@stylistic/indent': 'error',
      '@stylistic/linebreak-style': 'error',
      '@stylistic/no-mixed-spaces-and-tabs': 'error',
      '@stylistic/no-multi-spaces': [
        'error',
        {
          'ignoreEOLComments': true
        }
      ],
      '@stylistic/no-multiple-empty-lines': [
        'error',
        {
          'max': 1,
          'maxBOF': 0,
          'maxEOF': 0
        }
      ],
      '@stylistic/no-tabs': 'error',
      '@stylistic/no-trailing-spaces': 'error',
      'toml/indent': [
        'error',
        4,
        {
          'subTables': 1,
          'keyValuePairs': 1
        }
      ],
      'toml/padding-line-between-tables': 'off',
      'toml/spaced-comment': 'off',
      'toml/tables-order': 'off',
      'toml/no-mixed-type-in-array': 'error',
      'unicode-bom': 'error'
    },
    ignores: [
      '/*.toml',
      '**/*.config.toml'
    ],
  }
];
