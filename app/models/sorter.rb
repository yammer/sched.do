# Chronologically sorts any resources that respond to #full_description
class Sorter
  def initialize(resources)
    @resources = resources
  end

  def sort
    if sortable?
      @resources.sort do |a, b|
        DateTime.parse(a.full_description) <=> DateTime.parse(b.full_description)
      end
    else
      @resources
    end
  end

  private

  def sortable?
    @resources.all? do |resource|
      begin
        DateTime.parse(resource.full_description)
        true
      rescue ArgumentError
        false
      end
    end
  end
end
