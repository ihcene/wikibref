# encoding: UTF-8

require 'spec_helper'

describe Article do
  before :each do 
    @article = Article.new
    @article.stub(:extract_images).and_return([])  
  end
  
  it "should validate Wiki links" do
    @article.url = "http://fr.wikipedia.org/wiki/France"
    
    @article.should have(:no).errors_on(:url)
  end

  it "should reject non-Wiki links" do
    @article.url = "http://www.google.com"
    
    @article.should have(1).errors_on(:url)
  end
  
  context "with valid Wiki path" do
    before(:each) do
      @original_url = "http://fr.wikipedia.org/wiki/Alg%C3%A9rie"
      
      @article = Article.new
      @article.stub(:extract_images).and_return([])
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
end