#!/bin/env ruby
# encoding: utf-8

Fabricator(:clock) do
  id  { sequence }
  employee
  clock_in  DateTime.now
end
