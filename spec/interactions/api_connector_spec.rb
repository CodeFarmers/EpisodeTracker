require 'spec_helper'
require "zip/zip"

describe ApiConnector do

  before(:all) do
    @xml = %q(<?xml version="1.0" encoding="UTF-8" ?>
          <Data>
          <Series>
          <seriesid>71663</seriesid>
          <language>en</language>
          <SeriesName>The Simpsons</SeriesName>
          <banner>graphical/71663-g13.jpg</banner>
          <Overview>Originally created by cartoonist Matt Groening, "Our Favorite Family," has graced the small screen in one form or another for over 20 years. The Simpson family first appeared on television as the subjects of interstitial "shorts" on The Tracey Ullman Show in April of 1987. The Simpsons remained a staple on The Tracey Ullman Show for three seasons until they premiered in their own half-hour series, on December 17, 1989. With the help of Jim Brooks and Sam Simon, Matt Groening's cartoon family turned into an instant success.
          Set in Springfield, the average American town, the show focuses on the antics and everyday adventures of the Simpson family; Homer, Marge, Bart, Lisa and Maggie, as well as a virtual cast of thousands. Since the beginning, the series has been a pop culture icon, attracting hundreds of celebrities to guest star. The show has also made name for itself in its fearless satirical take on politics, media and American life in general.
          Currently in its 23st season, The Simpsons has piled up close to 500 episodes, 27 Emmy Awards, a handful of music albums, countless endorsements and merchandise, and even made the jump to the silver screen in the summer of 2007 with The Simpsons Movie. And according to Matt Groening, "There is no end in sight."</Overview>
          <FirstAired>1989-12-17</FirstAired>
          <IMDB_ID>tt0096697</IMDB_ID>
          <zap2it_id>EP00018693</zap2it_id>
          <id>71663</id>
          </Series>
          <Series>
          <seriesid>153221</seriesid>
          <language>en</language>
          <SeriesName>Jessica Simpson's The Price of Beauty</SeriesName>
          <banner>graphical/153221-g.jpg</banner>
          <Overview>Jessica Simpson is embarking on a world tour...but this time it has nothing to do with music. Jessica, along with her two best friends, Ken Paves and CaCee Cobb, are traveling the globe to explore how different cultures define beauty and the extraordinary lengths that women will go to in order to achieve it.
          Journeying from Tokyo and Thailand, to Paris and Rio, to Uganda, Morocco and India -- the cast is met in each city by a "beauty ambassador" who helps them tackle topics revolving around fashion, fitness, diet and outlandish spa treatments. In each country, Jessica, Ken and CaCee experience firsthand some of the local beauty rituals, from drinking cow urine in India, to being buried up to their necks in Tokyo, to drinking gourds of ghee in a fattening hut in Uganda. But it's not all fun and games -- Jessica also explores the high price that some women pay to feel beautiful. Imagine the plight of women in Northern Thailand, who wear 20-pound rings around their necks, crushing their clavicles, to a mother in Rio who cannot afford electricity, but is secretly saving for butt implants.
          Each episode ends in a complete transformation of the cast. Imagine Jessica, Ken and CaCee dressed in ornate kaftans, or camel-back riding to a festive Moroccan party complete with belly dancers and live musicians.
          As Jessica learns how beauty is defined across the globe, and how she "measures up," and her own definition of the word, she is challenged to redefine it along the way, allowing the audience to see a personal, vulnerable and oftentimes hilarious side of Jessica Simpson.
          Each episode culminates in a complete transformation of the cast -- Imagine Jessica, Ken and CaCee dressed in ornate kaftans, riding camel-back to a festive Moroccan party, complete with belly dancers and live musicians. They talk to local women and dance the night away Moroccan style.
          As Jessica learns how beauty is defined in far away lands, her own sense of beauty, and how she "measures up" is challenged and redefined along the way, allowing the audience to see a personal, and often times, vulnerable and hilarious side of Jessica Simpson. </Overview>
          <id>153221</id>
          </Series>
          <Series>
          <seriesid>11111</seriesid>
          <language>en</language>
          <SeriesName>The series without overview</SeriesName>
          <banner></banner>
          <Overview></Overview>
          <FirstAired>1989-12-17</FirstAired>
          <IMDB_ID>tt0096697</IMDB_ID>
          <zap2it_id>EP00018693</zap2it_id>
          <id>11111</id>
          </Series>
          <Series>
          <seriesid>11112</seriesid>
          <language>en</language>
          <SeriesName>The Series 4</SeriesName>
          <banner></banner>
          <Overview>This is an overview</Overview>
          <FirstAired>1989-12-17</FirstAired>
          <IMDB_ID>tt0096697</IMDB_ID>
          <zap2it_id>EP00018693</zap2it_id>
          <id>11112</id>
          </Series>
          </Data>
          )
    @empty_xml = %q(<?xml version="1.0" encoding="UTF-8" ?><Error>seriesname is required</Error>)
    @ac = ApiConnector.new
  end
  describe 'initialize' do
    it 'should instantiate an apiconnector' do
      @ac.should_not be_nil
      @ac.should be_instance_of(ApiConnector)
    end
  end

  describe 'set_previous_time' do
    it 'should set the previous time' do
      @ac.should respond_to(:set_previous_time)
      previous_time = @ac.set_previous_time
      previous_time.should_not be_nil
      previous_time.should be_instance_of(String)
    end
  end

  describe 'get series from remote' do

    describe 'when the search returns multiple results' do

      before(:all) do
        @ac.should_receive(:get_response_body_for).with("http://thetvdb.com/api/GetSeries.php?seriesname=the%20simpsons").and_return(@xml)
        @series_list = @ac.get_series_from_remote("the simpsons")
      end

      it 'should return the series as an array' do
        @series_list.should be_instance_of(Array)
      end

      it 'should have all series names' do
        @series_list.length.times do
          @series_list[0][:series_name].should eq("The Simpsons")
          @series_list[1][:series_name].should eq("Jessica Simpson's The Price of Beauty")
        end
      end

      it 'should have all the series remote ids' do
        @series_list.length.times do
          @series_list[0][:series_id].should eq("71663")
          @series_list[1][:series_id].should eq("153221")
        end
      end
    end

    describe 'when the overview is empty' do

      before(:all) do
        @ac.should_receive(:get_response_body_for).with("http://thetvdb.com/api/GetSeries.php?seriesname=the%20simpsons").and_return(@xml)
        @series_list = @ac.get_series_from_remote("the simpsons")
      end

      it 'should not receive the next elements overview' do
        @series_list[3][:overview].should be_nil
      end
    end

    describe 'when the search string is empty' do

      it 'should raise a "RoutingError"' do
        @ac.stub(:get_response_body_for).with("http://thetvdb.com/api/GetSeries.php?seriesname=").and_return(@empty_xml)
        expect { @ac.get_series_from_remote("") }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'when the search string is invalid' do

      it 'should raise a "RoutingError"' do
        @ac.stub(:get_response_body_for).with("http://thetvdb.com/api/GetSeries.php?seriesname=qsdfqsdf").and_return(@empty_xml)
        expect { @ac.get_series_from_remote("qsdfqsdf") }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'create handle for zip' do

    before(:all) { @series = Series.create(name: "SomeSeries", remote_id: "71663") }

    it 'should be of type tempfile' do
      tmpfile = Tempfile.new('tempfile', "tmp")
      @ac.should_receive(:create_handle_for_zip).with(@series.remote_id).and_return(tmpfile)
      ziphandle = @ac.create_handle_for_zip(@series.remote_id)
      ziphandle.should be_instance_of(Tempfile)
    end

    it 'should have the correct url' do
      @ac.should_receive(:open).with("http://thetvdb.com/api/4F5EC797A9F93512/series/71663/all/en.zip")
      @ac.create_handle_for_zip(@series.remote_id)
    end
  end

  describe 'unzip zipfile' do

    before(:all) do
      ziphandle = File.open("spec/data/en.zip")
      @files = @ac.unzip(ziphandle)
    end

    it 'should not be nil' do
      @files.should_not be_nil
    end

    it 'should have a lenght of 3' do
      @files.length.should eq 3
    end

    it 'should be an instance of Array' do
      @files.should be_instance_of(Array)
    end

    it 'should return the unzipped files' do
      @files[0].should be_instance_of(File)
    end
  end

  describe 'get episodes for series' do

    before(:all) do
      series = Series.create(name: "SomeSeries", remote_id: "71663")
      ziphandle = File.open("spec/data/en.zip")
      @ac.should_receive(:create_handle_for_zip).with(series.remote_id).and_return(ziphandle)
      @episodes = @ac.get_episodes(series.remote_id)
    end

    it 'should have the correct name' do
      @episodes.second.elements["EpisodeName"].text.should == "Original Pilot"
    end

    it 'should have the correct overview' do
      @episodes.second.elements["Overview"].text.should include("Steve becomes the school president")
    end

    it 'should have the correct remote id' do
      @episodes.second.elements["id"].text.should == "4321587"
    end

    it 'should be an array of episodes' do
      @episodes.class.should == Array
    end
  end
end
