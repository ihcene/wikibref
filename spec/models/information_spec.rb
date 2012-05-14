# encoding: UTF-8

require 'spec_helper'

describe Information do
  context "Create revisions" do 
    before(:each) do
      @article = Article.new
      @article.stub(:extract_images).and_return([])
      @article.url = "http://en.wikipedia.org/wiki/Algeria"
      
      @article.creator = @author
      
      @article.last_modifier = @author
      
      @information = Information.new(:content => "C'est un pays arabo-berbéro-musulman de l'afrique du nord")
      
      @article.informations << @information
      @article.save
      
      @author = Author.create(
        :username               => "Toto", 
        :email                  => "toto@tata.lu", 
        :password               => "1234", 
        :password_confirmation  => "1234"
      );
    end
    
    it "should not create a version for the same user, before x minutes" do 
      @article.should have(1).informations
      
      lambda{
        @information.update_attributes :content => "Changement de programme"
      }.should_not change(@information.versions, :count)
    end

    it "should did create a version for the same user, after x minutes" do 
      lambda{
        @information.update_attributes :content => "Changement de programme"
      }.should_not change(@information.versions, :count)
    end
    
    it "should create a version for another user, even before x minutes" do 
      @article.informations.first.stub!(:interval_between_versions_passed?).and_return(true)
      
      lambda{
        @article.informations.first.attributes = {:content => "Changement du contenu"} ;
        @article.save
      }.should change(@article.informations.first.versions, :count).from(0).to(1)
    end
  end
end