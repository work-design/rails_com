module.exports = {
  test: require.resolve('@hotwired/turbo-rails'),
  use: [
    {
      loader: 'expose-loader',
      options: 'Turbo'
    }
  ]
}
