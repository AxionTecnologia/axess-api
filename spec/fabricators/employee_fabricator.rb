#!/bin/env ruby
# encoding: utf-8

Fabricator(:employee) do
  id  { sequence }
  rut 16056807
  cv  '0'
  name  'Andrés'
  last_name 'Otárola Alvarado'
  active true
end
