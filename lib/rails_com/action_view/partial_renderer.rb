# frozen_string_literal: true

module RailsCom::ActionView
  module PartialRenderer

    # 支持在views/:controller 目录下，用 _:action 开头的子目录进一步分组
    def find_template(path, locals)
      if path.include?('/') && !path.start_with?('_')
        prefixes = []
      else
        prefixes = @lookup_context.prefixes
      end

      @lookup_context.find_template(path, prefixes, true, locals, @details)
    end

    def render_collection(collection, view, path, template, layout, block)
      identifier = template&.identifier || path
      ActiveSupport::Notifications.instrument(
        "render_collection.action_view",
        identifier: identifier,
        layout: layout&.virtual_path,
        count: collection.length
      ) do |payload|
        spacer =
          if @options.key?(:spacer_template)
            spacer_template = find_template(@options[:spacer_template], @locals.keys)
            build_rendered_template(spacer_template.render(view, @locals), spacer_template)
          else
            RenderedTemplate::EMPTY_SPACER
          end

        collection_body =
          if template
            cache_collection_render(payload, view, template, collection, layout) do |filtered_collection|
              collection_with_template(view, template, layout, filtered_collection)
            end
          else
            collection_with_template(view, nil, layout, collection)
          end

        return RenderedCollection.empty(@lookup_context.formats.first) if collection_body.empty?

        build_rendered_collection(collection_body, spacer)
      end
    end


    def cache_collection_render(instrumentation_payload, view, template, collection, layout)
      return yield(collection) unless will_cache?(@options, view)

      collection_iterator = collection

      # Result is a hash with the key represents the
      # key used for cache lookup and the value is the item
      # on which the partial is being rendered
      keyed_collection, ordered_keys = collection_by_cache_keys(view, template, collection)
      binding.b

      # Pull all partials from cache
      # Result is a hash, key matches the entry in
      # `keyed_collection` where the cache was retrieved and the
      # value is the value that was present in the cache
      cached_partials = collection_cache.read_multi(*keyed_collection.keys)
      instrumentation_payload[:cache_hits] = cached_partials.size

      # Extract the items for the keys that are not found
      collection = keyed_collection.reject { |key, _| cached_partials.key?(key) }.values

      rendered_partials = collection.empty? ? [] : yield(collection_iterator.from_collection(collection))

      index = 0
      keyed_partials = fetch_or_cache_partial(cached_partials, template, order_by: keyed_collection.each_key) do
        # This block is called once
        # for every cache miss while preserving order.
        rendered_partials[index].tap { index += 1 }
      end

      ordered_keys.map do |key|
        keyed_partials[key]
      end
    end

  end
end

ActiveSupport.on_load :action_view do
  ActionView::PartialRenderer.prepend RailsCom::ActionView::PartialRenderer
end
