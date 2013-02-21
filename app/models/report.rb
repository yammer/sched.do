module Report
  def get_data_clip
    data = ''
    open("#{@uri}.json") do |file|

      file.each_line do |line|
        data = sanitize_input_data(line)
        data = get_columns(line)
      end

    end
    data
  end

  def sanitize_input_data(json_data)
    json_data.gsub!(/"(?<number>[\d.]+)"/, '\k<number>')
    json_data.gsub!(
      /"(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})[ \d:]+"/,
      @date_format
    )
    json_data.html_safe
  end

  def get_columns(json_data)
    json_data.gsub!(/(?<="fields":)(\[.+?\])(?=.+"values")/) do |fields|

      fields.gsub!(/"(.+?)"/) do |match| 
        components =  match.gsub(/"/,'').split('_')
        type = components.pop
        name = components.join(' ').titleize
        "[\"#{type}\", \"#{name}\"]"
      end

    end
    json_data.html_safe
  end
end
