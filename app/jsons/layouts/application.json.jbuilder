json.results JSON.parse(yield)
json.partial! 'pagination', items: @models if defined? @models
