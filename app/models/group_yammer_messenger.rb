class GroupYammerMessenger < YammerMessenger
  private

  def request_params
    original_params = super
    original_params.delete(:direct_to_id)
    original_params.merge(group_id: @recipient.yammer_group_id)
  end

  def utm_source(invoking_method)
    original_utm_source = super(invoking_method)
    "group-#{original_utm_source}"
  end
end
