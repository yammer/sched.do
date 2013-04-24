class PrimarySuggestion < ActiveRecord::Base
  include Votable

  belongs_to :event
  has_many :secondary_suggestions, order: 'created_at', dependent: :destroy

  accepts_nested_attributes_for :secondary_suggestions,
    reject_if: :all_blank,
    allow_destroy: true

  def full_description
    "#{description} #{secondary_descriptions}".strip
  end

  def suggestions
    @suggestions ||= Sorter.new(secondary_suggestions).sort
  end

  def time_based?
    begin
      DateTime.parse(description)
      true
    rescue ArgumentError
      false
    end
  end

  private

  def secondary_descriptions
    suggestions.map(&:description).join(' ')
  end
end
