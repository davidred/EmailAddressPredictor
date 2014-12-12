require 'rspec'
require 'format_generator.rb'
require 'email_predictor.rb'

describe FormatGenerator do
  subject(:fg) { FormatGenerator.new }

  dataset = {
    "John Ferguson" => "john.ferguson@alphasights.com",
    "Damon Aw" => "damon.aw@alphasights.com",
    "Linda Li" => "linda.li@alphasights.com",
    "Larry Page" => "larry.p@google.com",
    "Sergey Brin" => "s.brin@google.com",
    "Steve Jobs" => "s.j@apple.com"
  }

  formats = {
    "alphasights" => "first_name_dot_last_name",
    "google" => "first_initial_dot_last_name",
    "apple" => "first_initial_dot_last_initial"
  }

  context "It creates analyzes data to determine format"
    it "returns a company given an email address" do
      expect(fg.instance_eval { get_company("john.ferguson@alphasights.com") }).to eq("alphasights")
    end

    it "returns an array containing the first and last name as written in email" do
      expect(fg.instance_eval { get_first_last("john.ferguson@alphasights.com") }).to eq(["john","ferguson"])
    end

    context "Returns whether it is a name, initial, or unkown format given a name and email version of the name" do
      it "returns 'name' if the email term matches the name" do
        expect(fg.instance_eval { get_format("john","john") }).to eq('name')
      end
      it "returns 'initial' if the email term matches the first letter of the name" do
        expect(fg.instance_eval { get_format("john","j") }).to eq('initial')
      end
      it "returns 'unknown' if the email term does not match the name or first initial" do
          expect(fg.instance_eval { get_format("john","wat") }).to eq('unknown')
      end
    end

    context "returns the expected company format given an employees name and email address" do
      it "returns first_initial_last_name if given email 'j.ferguson@company.com' and name 'john ferguson'" do
        expect(fg.instance_eval { get_company_format("john ferguson", "j.ferguson@company.com") }).to eq("first_initial_dot_last_name")
      end

      it "returns 'first_name_last_name' if given email 'john.ferguson@company.com' and name 'john ferguson'" do
        expect(fg.instance_eval { get_company_format("john ferguson", "john.ferguson@company.com") }).to eq("first_name_dot_last_name")
      end

      #similar tests
    end

    context "given a hash of known names and email addresses, it learns the companies formats" do
      it "returns the correct formats given one type of format for each company" do
        expect(fg.instance_eval { get_formats({"john ferguson" => "j.ferguson@company.com"}) }).to eq({"company" => "first_initial_dot_last_name"})
      end

      it "returns formats given multiple companies" do
        expect(fg.instance_eval { get_formats(dataset) }).to eq(formats)
      end
    end

end

describe EmailPredictor do

  subject(:ep) { EmailPredictor.new }

  context "It generates an email prediction" do

    it "generates first_name_dot_last_name notation" do
      expect(ep.instance_eval { first_name_dot_last_name("John Ferguson", "company") }).to eq("john.ferguson@company.com")
    end

    it "generates first_name_dot_last_initial notation" do
      expect(ep.instance_eval { first_name_dot_last_initial("John Ferguson", "company") }).to eq("john.f@company.com")
    end

    it "generates first_initial_dot_last_name notation" do
      expect(ep.instance_eval { first_initial_dot_last_name("John Ferguson","company") }).to eq("j.ferguson@company.com")
    end

    it "generates first_intitial_dot_last_initial notation" do
      expect(ep.instance_eval { first_initial_dot_last_initial("John Ferguson","company") }).to eq("j.f@company.com")
    end

  end

end
