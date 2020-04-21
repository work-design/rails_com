const { basename, dirname, join, relative, resolve } = require('path')
const { sync } = require('glob')
const extname = require('path-complete-extname')
const config = require('@rails/webpacker/package/config')

const paths = () => {
  const { extensions, ignore } = config
  let glob = extensions.length === 1 ? `**/*${extensions[0]}` : `**/*{${extensions.join(',')}}`
  let result = {}

  config.resolved_paths.forEach((rootPath) => {
    const ab_paths = sync(join(rootPath, glob), { ignore: ignore })

    ab_paths.forEach((path) => {
      const namespace = relative(join(rootPath), dirname(path))
      const name = join(namespace, basename(path, extname(path)))
      result[name] = resolve(path)
    })
  })

  return result
}

module.exports = paths
