#!/usr/bin/env ruby

require_relative '../lib/email_predictor'

if __FILE__ == $PROGRAM_NAME
  while true do
    ep = EmailPredictor.new
    puts "Enter the name you'd like to predict eg: 'David Rozenberg'"
    name = gets.chomp
    until name =~ /^\w+\s\w+$/
      puts "Please enter a first and last name separated by a space like this example: 'David Rozenberg'"
      name = gets.chomp
    end
    puts "Please enter the company the person works for"
    company = gets.chomp.downcase

    puts "Predicted Email: #{ep.predict_email(name, company)}"
    puts
  end
end
