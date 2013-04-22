class SecondarySuggestion < ActiveRecord::Base
  include Votable

  belongs_to :primary_suggestion

  def event
    primary_suggestion.event
  end

  def full_description
    "#{primary_suggestion.try(:description)} #{description}".strip
  end
end
