# encoding: UTF-8

require 'spec_helper'

describe Article do
  before :each do 
    @article = Article.new
    @article.stub(:grab_original_url_content).and_return("")  
  end
  
  it "should validate Wiki links" do
    @article.url = "http://fr.wikipedia.org/wiki/France"
    
    @article.should have(:no).errors_on(:url)
  end

  it "should reject non-Wiki links" do
    @article.url = "http://www.google.com"
    
    @article.should have(1).errors_on(:url)
  end
  
  context "URI validity" do 
    it "should prefix URI with protocol" do
      @article.send(:prefix_url_if_necessary, "fr.wikipedia.org/wiki/France").should eq("http://fr.wikipedia.org/wiki/France")
    end
    
    it "should not prefix while not necessary" do
      @article.send(:prefix_url_if_necessary, "http://fr.wikipedia.org/wiki/France").should_not eq("http://http://fr.wikipedia.org/wiki/France")
    end
    
    it "should encode URI if necessary" do
      @article.send(:encode_url_if_necessary, "http://fr.wikipedia.org/wiki/Algérie").should eq("http://fr.wikipedia.org/wiki/Alg%C3%A9rie")
    end

    it "should encode really messy complexe URI" do
      @article.send(:encode_url_if_necessary, "http://ar.wikipedia.org/wiki/الحديث_النبوي").should eq("http://ar.wikipedia.org/wiki/%D8%A7%D9%84%D8%AD%D8%AF%D9%8A%D8%AB_%D8%A7%D9%84%D9%86%D8%A8%D9%88%D9%8A")
    end

    it "should not encode valid correctly encoded strings" do
      @article.send(:encode_url_if_necessary, "http://fr.wikipedia.org/wiki/Alg%C3%A9rie").should eq("http://fr.wikipedia.org/wiki/Alg%C3%A9rie")
    end
  end
  
  context "with valid Wiki path" do
    before(:each) do
      @original_url = "http://fr.wikipedia.org/wiki/Alg%C3%A9rie"
      
      @article = Article.new
      @article.stub(:grab_original_url_content).and_return("")
      @article.url = @original_url
    end
    
    it "should extract correctly the title" do
      @article.title.should eq("Algérie")
    end
    
    it "should extract correctl the code of the language" do
      @article.lang_code.should eq("fr")
    end
    
    it "should reconstitute the original URL correctly" do
      @article.url_original.should eq(@original_url)
    end

    it "should generate a correct slug" do
      @article.slug.should eq("Alg%C3%A9rie")
    end
    
    context "image extractions with nokogiri" do
      pending "should get images"
      
      pending "should avoid images smaller than X pixels height"
    end
  end
  
  context "Edit informations" do
    before(:each) do 
      # Create the user 
      @author = Author.create(
        :username               => "Toto", 
        :email                  => "toto@tata.lu", 
        :password               => "1234", 
        :password_confirmation  => "1234"
      );
      
      # Create the article
      @article = Article.new
      @article.stub(:grab_original_url_content).and_return("")
      @article.url = "http://en.wikipedia.org/wiki/Algeria"
      
      @article.creator = @author
      
      @article.save
    end
    
    it "should create correctly the user and article" do
      @author.should_not be :new_record
      @article.should_not be :new_record
    end
    
    it "should correcty surcharge the reading accessor of last_modifier" do 
      @article.last_modifier = @author
      @article.last_modifier.should eq(@author)
    end
    
    context "transfert user to informations" do 
      before(:each) do 
        @article.attributes = {
          :main_information_attributes => {:content => "Is a north african country"},
          :informations_attributes => {
            "0" => {
              :content => "Is a north african country"
            }
          }
        }
      
        @article.last_modifier = @author  
      end
      
      it "should transfert to main_information" do
        @article.main_information.last_revision_author.should eq(@author)
      end

      it "should transfert to other informations created" do
        @article.should have(1).informations
        @article.informations.first.last_revision_author.should == @author  
      end
    end
  end
end