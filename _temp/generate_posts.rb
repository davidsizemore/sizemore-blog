#!/usr/bin/env ruby

require 'date'
require 'fileutils'

# Starting date - July 1, 2024
date = Date.new(2024, 7, 1)

# Get list of image files, ignoring common system files
image_files = Dir.glob('assets/images/*.jpg').reject { |file| file.include?('.DS_Store') }

# Function to create a readable title from filename
def format_title(filename)
  # Extract basename without extension and path
  base = File.basename(filename, File.extname(filename))
  
  # Special cases
  return "3D Artwork" if base == "3D"
  
  # Replace hyphens with spaces
  base = base.gsub('-', ' ')
  
  # Split by numbers (e.g., "yellow01" becomes "yellow 01")
  parts = base.scan(/[a-zA-Z]+|\d+/)
  
  # Capitalize each part
  parts.map! { |part| part =~ /^\d+$/ ? part : part.capitalize }
  
  # Join back together with spaces
  parts.join(' ')
end

# Process each image file
image_files.each do |image_file|
  # Format title from filename
  title = format_title(image_file)
  
  # Determine post filename (yyyy-mm-dd-slug.md)
  slug = File.basename(image_file, File.extname(image_file)).downcase.gsub(/\s+/, '-')
  post_filename = "_posts/#{date.strftime('%Y-%m-%d')}-#{slug}.md"
  
  # Create post content
  post_content = <<~CONTENT
  ---
  layout: post
  title: "#{title}"
  date: #{date.strftime('%Y-%m-%d')}
  categories: art
  feature_image: /#{image_file}
  ---
  CONTENT
  
  # Write the post file
  File.write(post_filename, post_content)
  
  puts "Created post for #{title} on #{date.strftime('%Y-%m-%d')}"
  
  # Increment date by 1 day
  date = date + 1
end

puts "All posts created successfully!" 