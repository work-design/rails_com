# frozen_string_literal: true

module CompressUtil
  extend self

  def involve(path, copy: 'copy')
    variation = ActiveStorage::Variation.new(resize_to_limit: [1000, 1000], saver: { quality: 90 })
    copy_dir = path.dirname.join(copy)
    copy_dir.exist? || copy_dir.mkdir
    path.each_child do |entry|
      if entry.file?
        output = variation.send(:transformer).send(:process, entry, format: :jpg)
        FileUtils.copy_file(output, copy_dir(entry.basename))
      end
    end
  end

end