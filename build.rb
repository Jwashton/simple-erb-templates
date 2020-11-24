#!/usr/bin/env ruby
# frozen_string_literal: true

require 'erb'

LAYOUT = ERB.new(File.read('./templates/layout.html.erb'))
PAGE_DIR = File.join('.', 'pages')
DIST_DIR = File.join('.', 'dist')

# Manages the bindings for a single page.
class Page
  attr_accessor :content

  def initialize(filename)
    @content = File.read(File.join(PAGE_DIR, filename))
  end

  def render
    LAYOUT.result(binding)
  end
end

Dir
  .entries(PAGE_DIR)
  .select { |f| File.file? File.join(PAGE_DIR, f) }
  .each do |file|
    puts "Rendering #{file}"

    result = Page.new(file).render

    File.write(File.join(DIST_DIR, file), result)
  end
