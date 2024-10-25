# frozen_string_literal: true

require 'zip'

# This is a simple example which uses rubyzip to
# recursively generate a zip file from the contents of
# a specified directory. The directory itself is not
# included in the archive, rather just its contents.
#
# Usage:
#   directory_to_zip = "/tmp/input"
#   output_file = "/tmp/out.zip"
#   zf = ZipFileGenerator.new(directory_to_zip, output_file)
#   zf.write()
class ZipGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir = Rails.root.join('tmp', 'zip'), out_name = 'xx.zip')
    @input_dir = input_dir
    @input_dir.exist? || @input_dir.mkdir
    output_file = @input_dir.join(out_name)

    ::Zip::File.open(output_file, create: true) do |zipfile|
      recursively_write(@input_dir, zipfile)
    end
  end

  def recursively_write(disk_file_path, zipfile)
    if File.directory? disk_file_path
      disk_file_path.children.each do |file_path|
        recursively_write(file_path, zipfile)
      end
    else
      unless disk_file_path.basename.to_s == '.DS_Store'
        zipfile.add(disk_file_path.relative_path_from(@input_dir).to_s, disk_file_path)
      end
    end
  end


end