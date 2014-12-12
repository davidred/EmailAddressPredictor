require_relative 'format_generator'

class EmailPredictor

  attr_reader :company_formats

  def initialize
    fg = FormatGenerator.new
    @company_formats = fg.company_formats
  end

  def predict_email(name, company)
    if company_formats[company].nil?
      return "We don't have any information about that company's email structure"
    else
      send company_formats[company].to_sym, name, company
    end
  end

  private

  def first_name_dot_last_name(name, company)
    name_arr = name.downcase.split()
    "#{name_arr[0]}.#{name_arr[1]}@#{company}.com"
  end

  def first_name_dot_last_initial(name, company)
    name_arr = name.downcase.split()
    "#{name_arr[0]}.#{name_arr[1][0]}@#{company}.com"
  end

  def first_initial_dot_last_initial(name, company)
    name_arr = name.downcase.split()
    "#{name_arr[0][0]}.#{name_arr[1][0]}@#{company}.com"
  end

  def first_initial_dot_last_name(name, company)
    name_arr = name.downcase.split()
    "#{name_arr[0][0]}.#{name_arr[1]}@#{company}.com"
  end

end
