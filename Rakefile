require 'sinatra/activerecord/rake'
require './site_services'

namespace :counter do
  desc 'Create a new counter with NAME, and optionally IPV4_PRELOAD, IPV6_PRELOAD'
  task :create do
    counter = Counter.create(
      :name => ENV['NAME'], 
      :ipv4_preload => ENV['IPV4_PRELOAD'] || 0, 
      :ipv6_preload => ENV['IPV6_PRELOAD'] || 0
    )

    if counter.errors.any?
      counter.errors.messages.each { |field, errors| puts "Error on #{field.upcase}: #{errors.join(', ')}" }
    end
  end

  desc 'Create a new site-wide counter with NAME, and optionally IPV4_PRELOAD, IPV6_PRELOAD'
  task :create_sitewide do
    counter = SitewideCounter.create(
      :name => ENV['NAME'], 
      :ipv4_preload => ENV['IPV4_PRELOAD'] || 0, 
      :ipv6_preload => ENV['IPV6_PRELOAD'] || 0
    )

    if counter.errors.any?
      counter.errors.messages.each { |field, errors| puts "Error: #{field.upcase} #{errors.join(', ')}" }
    end
  end

  desc 'Consolidate hits into counter preloads'
  task :consolidate_hits do
    Counter.all.each do |counter|
      counter.update_preloads!
      counter.hits.destroy_all
    end
  end

  desc 'Remove the counter and associated hits with NAME'
  task :destroy do
    if ENV['NAME']
      Counter.where(:name => ENV['NAME']).each { |counter| counter.destroy }
    else
      puts "You must provide NAME to destroy a counter"
    end
  end

  desc 'Show all current counters'
  task :list do
    counters = Counter.all
    max_name_length = counters.collect(&:name).max_by(&:length).length

    title_line = "#{'name'.ljust(max_name_length, ' ')} | v4 preload | v6 preload | sitewide | v4 hits | v6 hits"
    puts
    puts title_line
    puts "-" * title_line.length

    counters.each do |counter|
      table_line = "#{counter.name.ljust(max_name_length, ' ')} | "
      table_line += "#{counter.ipv4_preload.to_s.rjust(10, ' ')} | "
      table_line += "#{counter.ipv6_preload.to_s.rjust(10, ' ')} | "
      table_line += "#{(counter.is_a?(SitewideCounter) ? 'yes' : 'no').ljust(8, ' ')} | "
      table_line += "#{counter.ipv4_hit_count.to_s.rjust(7, ' ')} |"
      table_line += "#{counter.ipv6_hit_count.to_s.rjust(8, ' ')}"

      puts table_line
    end

    puts
  end
end
