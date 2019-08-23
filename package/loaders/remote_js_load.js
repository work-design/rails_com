module.exports = {
  test: require.resolve('rails_com/package/remote_js_load'),
  use: [
    {
      loader: 'expose-loader',
      options: 'remote_js_load'
    }
  ]
}
