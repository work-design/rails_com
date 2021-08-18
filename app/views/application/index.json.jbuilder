if defined? @models
json.array! @models.map(&:as_full_json)
end
