module.exports = {
  extends: [
    'plugin:toml/standard'
  ],
  rules: {
    'toml/indent': 'off',
    'toml/padding-line-between-tables': 'off',
    'toml/spaced-comment': 'off',
    'toml/tables-order': 'off',
    'toml/no-mixed-type-in-array': 'error',
    'eol-last': ['error', 'always'],
    'no-mixed-spaces-and-tabs': 'error',
    'no-multi-spaces': ['error', { ignoreEOLComments: true }],
    'no-multiple-empty-lines': ['error', { max: 1, maxBOF: 0, maxEOF: 0}],
    'no-tabs': 'error',
    'no-trailing-spaces': 'error',
    'unicode-bom': 'error'
  }
}
