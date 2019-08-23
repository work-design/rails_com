const { basename, dirname, join, relative, resolve } = require('path')
const { readFileSync } = require('fs')
const { sync } = require('glob')
const extname = require('path-complete-extname')
const config = require('@rails/webpacker/package/config')
const roots = JSON.parse(readFileSync('tmp/share_object.json', 'utf8'))

const paths = () => {
  const { extensions } = config
  let glob = extensions.length === 1 ? `**/*${extensions[0]}` : `**/*{${extensions.join(',')}}`
  let result = {}

  roots.forEach((rootPath) => {
    const ab_paths = sync(join(rootPath, glob))

    ab_paths.forEach((path) => {
      const namespace = relative(join(rootPath), dirname(path))
      const name = join(namespace, basename(path, extname(path)))
      result[name] = resolve(path)
    })
  })

  return result
};

const resolved_roots = [resolve('node_modules')].concat(roots)

module.exports = {
  paths,
  resolved_roots
}
