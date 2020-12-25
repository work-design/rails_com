const { basename, dirname, join, relative, resolve } = require('path')
const { sync } = require('glob')
const extname = require('path-complete-extname')
const { config } = require('@rails/webpacker')

const paths = () => {
  let glob = config.extensions.length === 1 ? `**/*${config.extensions[0]}` : `**/*{${config.extensions.join(',')}}`
  let result = {}

  config.additional_paths.forEach((rootPath) => {
    const ab_paths = sync(join(rootPath, glob), { ignore: config.ignore })

    ab_paths.forEach((path) => {
      const namespace = relative(join(rootPath), dirname(path))
      const name = join(namespace, basename(path, extname(path)))
      result[name] = resolve(path)
    })
  })

  return result
}

module.exports = paths
