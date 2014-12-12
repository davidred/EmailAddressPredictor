require 'json'

class FormatGenerator

  attr_reader :dataset, :company_formats

  def initialize
    file = File.read("#{Dir.pwd}/lib/sample_data/emails.json")
    @dataset = JSON.parse(file)
    @company_formats = get_formats
  end


  private

  def get_formats(data = @dataset)
    company_formats = {}
    data.each do |name, email|
      company = get_company(email)
      company_format = get_company_format(name.downcase, email)
      company_formats[company] = company_format unless company_format.nil?
    end
    company_formats
  end

  def get_company_format(name, email)
    name_array = name.split()
    first_last = get_first_last(email)
    formats = []
    2.times do |idx|
      formats << get_format(name_array[idx], first_last[idx])
    end
    formats.include?("unknown") ? nil : "first_#{formats[0]}_dot_last_#{formats[1]}"
  end

  def get_company(email) #return company from email
    email.split('@')[1].split('.')[0]
  end

  def get_first_last(email)
    email.split('@')[0].split('.')
  end

  def get_format(name, email_version)
    if name == email_version
      "name"
    elsif name[0] == email_version
      "initial"
    else
      "unknown"
    end
  end


end
