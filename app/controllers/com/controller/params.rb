module Com
  module Controller::Params

    def xx
      method("#{controller_name.singularize}_params").source.slice(/permit\((.*)\)/m, 1).split("\n")
    end

  end
end
