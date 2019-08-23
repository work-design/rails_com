module.exports = {
  test: require.resolve('rails_com/package/remote_js_load'),
  use: [
    {
      loader: 'expose-loader',
      options: {
        expose: 'remote_js_load',
        exportKey: 'default'
      }
    },
    {
      loader: 'babel-loader',
      options: {
        cacheDirectory: 'tmp/cache/webpacker/babel-loader-node-modules',
        cacheCompression: false,
        compact: false
      }
    }
  ]
}
