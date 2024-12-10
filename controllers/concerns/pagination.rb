module Pagination
    extend ActiveSupport::Concern
  
    included do
      before_action :set_pagination_params, only: [:index]
    end
  
    private
  
    def set_pagination_params
      @limit = (params[:limit] || 10).to_i
      @offset = (params[:offset] || 0).to_i
    end
  
    def paginate(collection)
      {
        data: collection.limit(@limit).offset(@offset),
        meta: {
          offset: @offset,
          limit: @limit,
          total_count: collection.count,
          next_offset: (@offset + @limit < collection.count) ? @offset + @limit : nil,
          previous_offset: @offset > 0 ? [@offset - @limit, 0].max : nil
        }
      }
    end
end
