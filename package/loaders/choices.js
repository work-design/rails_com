module.exports = {
  test: require.resolve('choices.js'),
  use: [
    {
      loader: 'expose-loader',
      options: 'Choices'
    }
  ]
}
