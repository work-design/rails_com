module RailsCom::SvgHelper

  def svg_data_url(path = 'placeholder.svg')
    svg_content = Rails.application.assets.resolver.read path
    base64_svg = Base64.strict_encode64(svg_content)
    "data:image/svg+xml;base64,#{base64_svg}"
  end

end