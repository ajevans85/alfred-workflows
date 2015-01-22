#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require_relative "bundle/bundler/setup"
require "alfred"
require 'json'

account     = ENV['BB_USER_NAME']
cache = "/tmp/bb-repositories.json"

Alfred.with_friendly_error do |alfred|
  alfred.with_rescue_feedback = true
  fb = alfred.feedback

  if File.exists?(cache) and File.stat(cache).mtime > Time.now - 60*60*2
    j = File.read(cache)
  else
    password = `security -p Alfred find-internet-password -w -a #{account} -s bitbucket.org`.strip!

    if $?.exitstatus > 0
      raise Alfred::ObjCError, "Error getting Bitbucket password from keychain, does this exist for #{account}"
    end
    
    j = `curl --silent --user #{account}:#{password} https://bitbucket.org/api/1.0/user/repositories`
    File.write(cache, j)
  end
  
  
  JSON.load(j).sort_by{|o| o['name']}.each do |o|
    name = o['name']
    owner = o['owner']
    url = "https://bitbucket.org/#{owner}/#{name}"
    fb.add_item({
      :uid      => "",
      :title    => "#{name}",
      :subtitle => "#{o['description']} #{url}",
      :arg      => url.gsub(" ", "-").downcase,
      :valid    => "yes",
    })
  end

  if ARGV[0].eql? "failed"
    raise Alfred::NoBundleIDError, "Wrong Bundle ID Test!"
  end

  puts fb.to_xml(ARGV)
end
