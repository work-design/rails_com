class RailsCom::Engine < ::Rails::Engine #:nodoc:

  config.generators do |g|
    g.stylesheets false
    g.javasricpts false
    g.javascript_engine false
    g.helper false
    g.jbuilder false
    g.templates.unshift File.expand_path('lib/templates', root)
  end

  initializer 'rails_com.assets.precompile' do |app|
    app.config.assets.precompile += ['rails_com_manifest.js']
  end

  initializer 'rails_com.add_generator_templates' do |app|
    app.config.paths['lib/templates'].unshift File.expand_path('lib/templates', root)
  end

  initializer 'rails_com.add_assets_templates' do |app|
    app.config.assets.paths.push(*Dir[File.expand_path('lib/nondigest_assets/*', root)])
  end

  initializer 'rails_com.add_activestorage' do |app|
    ActiveStorage::DiskController.include VideoResponse
    ActiveStorage::Attachment.include AttachmentTransfer

    require 'rails_com/rails_ext/attached_macros'
    ActiveStorage::Attached::One.prepend RailsExt::AttachedOne
    ActiveSupport.on_load(:active_record) do
      self.singleton_class.prepend RailsExt::AttachedMacros
    end
  end

end
