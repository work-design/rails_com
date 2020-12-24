module.exports = {
  test: require.resolve('@hotwired/turbo'),
  use: [
    {
      loader: 'expose-loader',
      options: 'Turbo'
    }
  ]
}
