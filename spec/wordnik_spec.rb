require 'spec_helper'

describe Wordnik do

  before(:each) do
    configure_wordnik
  end

  context "initialization" do

    context "resources" do
      it "instantiates resources from cached JSON" do
        Wordnik.resources.class.should == Hash
        Wordnik.resources[:word].class.should == Wordnik::Resource
      end
      
      it "has as many resources as there are resource names" do
        Wordnik.resources.size.should == Wordnik.resource_names.size
      end

      it "assigns resource keys that match the resource names" do
        Wordnik.resources[:word].name.should == :word
      end

    end
    
    context "authentication" do
      
      before(:each) do
      end
      
      it "succeeds if a username and password are present in the configuration" do
        Wordnik.authenticate
        Wordnik.authenticated?.should == true
      end
      
      it "de_authenticates" do
        Wordnik.authenticate
        Wordnik.authenticated?.should == true
        Wordnik.de_authenticate
        Wordnik.authenticated?.should == false
      end
      
      it "fails if credentials are invalid" do
        Wordnik.de_authenticate
        Wordnik.configure do |config|
          config.api_key = CREDENTIALS[:api_key]
          config.username = CREDENTIALS[:username]
          config.password = 'wrong!'
          config.base_uri = "beta.wordnik.com/v4"
        end
        Wordnik.authenticated?.should == false
      end
      
      it "fails if username and/or password are absent"
      
    end
    
  end
  
  context "dynamic method_missing magic" do
    
    it "maps shorthand Wordnik.resource calls to their resources" do
      Wordnik.word.class.should == Wordnik::Resource
      Wordnik.word.name.should == :word
    end

    it "builds requests but doesn't run them if method name begins with 'build_'" do
      @request = Wordnik.word.build_get('dynamo')
      @request.class.should == Wordnik::Request
    end

    it "runs requests and returns their body if method name doesn't begin with 'build_'" do
      @response_body = Wordnik.word.get('dynamo')
      @response_body.class.should == Hash
      @response_body.keys.sort.should == %w(canonicalForm word)
    end
    
    context "argument handling" do

      before(:each) do
         @request = Wordnik.word.build_get_examples('dynamo', :skip => 2, :limit => 10)
       end
       
       it "injects required arguments into the path" do
         @request.path.should == "/word/dynamo/examples"
       end

       it "passes optional key-value arguments to the query string" do
         @request.query_string.should == "?limit=10&skip=2"
       end
       
    end
    
    context "wordlists" do
      
      it "creates a wordlist" do
        
      end
      
      it "adds words"
      
      it "updates words"
      
      it "get all the words"
      
      it "deletes a wordlist"
      
    end
        
  end
  
end