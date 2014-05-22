#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe Hashie::Mash do

  let(:my_mashie){
    Hashie::Mash.new({a: 1, b: 2, c:3, d: 4})
  }

  context "#pick" do

    it "returns a new instance with the selected keys" do
      new_mashie = my_mashie.pick :a
      new_mashie.keys.should eq ["a"]
    end

    it "returns an new instance with no data when no key is found" do
      new_mashie = my_mashie.pick :z
      new_mashie.keys.should eq []
    end

  end
end
