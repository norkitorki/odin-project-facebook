require 'rails_helper'

RSpec.describe TagList, type: :model do
  fixtures :tag_lists

  before do
    @tag_list = tag_lists(:one)
  end

  it "should instantiate with an empty list" do
    expect(subject.list).to eq('')
  end

  it "should be valid with list and tagable" do
    expect(@tag_list).to be_valid
  end

  it "should be valid when list is empty" do
    @tag_list.list = ''
    expect(@tag_list).to be_valid
  end

  it "should be valid without list" do
    @tag_list.list = nil
    expect(@tag_list).to be_valid
  end

  it "should be invalid without tagable" do
    @tag_list.tagable = nil
    expect(@tag_list).to_not be_valid
  end

  it "should be invalid when list contains banned characters" do
    @tag_list.list = 'hello,#?world!'
    expect(@tag_list).to_not be_valid
  end

  it "should be invalid when tag count > 10" do
    @tag_list.list = 'hello,world,web,design,course,css,html,javascript,frontend,backend,learning'
    expect(@tag_list).to_not be_valid
  end

  it "should downcase list" do
    @tag_list.list = 'NATURE,BeaUtiFul'
    expect { @tag_list.save! }.to change { @tag_list.list }.to('beautiful,nature')
  end

  it "should remove whitespace from list" do
    @tag_list.list = 'hello,        world'
    expect { @tag_list.save! }.to change { @tag_list.list }.to('hello,world')
  end

  it "should remove duplicate tags from list" do
    @tag_list.list = 'world,WORLD,hello'
    expect { @tag_list.save! }.to change { @tag_list.list }.to('hello,world')
  end

  it "should sort the list" do
    @tag_list.list = 'zebra,lion,mouse,ape,eagle'
    expect { @tag_list.save! }.to change { @tag_list.list }.to('ape,eagle,lion,mouse,zebra')
  end

  describe '#find_by_tag' do
    fixtures :posts

    it "should find single tagable" do
      expect(subject.class.find_by_tag('programming').to_a).to eq([posts(:one)])
    end

    it "should find multiple tagables" do
      expect(subject.class.find_by_tag('web').to_a).to eq(posts)
    end

    it "should return an empty array when no tagable was found" do
      expect(subject.class.find_by_tag('test').to_a).to eq([])
    end
  end

  describe '#to_a' do
    it "should return list as an array" do
      expect(@tag_list.to_a).to eq(%w[ css design programming technology web ])
    end
  end
end
