require 'tempfile'

module Babel
  extend self

  def context(file)
    `babel #{file}`
  end

  def transform(code, options = {})
    tmpfile = write_to_tempfile(code)

    begin
      r = context(tmpfile)
    ensure
      File.unlink(tmpfile)
    end

    r
  end

  def write_to_tempfile(contents)
    tmpfile = Tempfile.open(['babel', 'js'])
    tmpfile.write(contents)
    r = tmpfile.path
    tmpfile.close
    r
  end

end
