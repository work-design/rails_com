# frozen_string_literal: true

module CompressUtil
  extend self

  def involve(path)
    variation = ActiveStorage::Variation.new(resize_to_limit: [1000, 1000], saver: { quality: 90 })
    path.each_child do |entry|
      if entry.file?
        output = variation.send(:transformer).send(:process, entry, format: :jpg)
        FileUtils.copy_file(output, path.dirname.join('copy' ,entry.basename))
      end
    end
  end

end