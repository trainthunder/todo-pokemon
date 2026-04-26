module TasksHelper
  # Returns CSS class for filter tabs based on current filter
  def filter_class(current_filter)
    active_filter = params[:filter]
    if active_filter == current_filter
      'filter-tab active'
    elsif active_filter.nil? && current_filter.nil?
      'filter-tab active'
    else
      'filter-tab'
    end
  end
end
