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

# Various functions for compiling one or more files
module Util
  def self.render_file(filename)
    puts "Rendering #{filename}"

    result = Page.new(filename).render

    File.write(File.join(DIST_DIR, filename.delete_suffix('.erb')), result)
  end

  def self.render_all
    Dir
      .entries(PAGE_DIR)
      .select { |f| File.file? File.join(PAGE_DIR, f) }
      .each(&method(:render_file))
  end
end

Util.render_all
