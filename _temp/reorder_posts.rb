#!/usr/bin/env ruby

require 'date'
require 'yaml'

# Read all post files
post_files = Dir.glob('_posts/*.md')

# Group posts by base name (e.g., "purple", "blue", etc.)
post_groups = {}

post_files.each do |file|
  basename = File.basename(file, '.md')
  
  # Extract date and slug from filename (YYYY-MM-DD-slug.md)
  match = basename.match(/(\d{4}-\d{2}-\d{2})-(.+)/)
  next unless match
  
  date_str = match[1]
  slug = match[2]
  
  # Extract base name and sequence number
  # Examples: "purple01" -> ["purple", "01"], "dot-bag02" -> ["dot-bag", "02"]
  if slug =~ /^(.+?)(\d+)$/
    base = $1
    sequence = $2.to_i
    
    # Handle special cases like "3d"
    next if base == "3"  # Skip special cases like "3d"
    
    # Handle hyphenated names
    base = base.chomp('-')
    
    post_groups[base] ||= []
    post_groups[base] << {
      file: file,
      date: Date.parse(date_str),
      sequence: sequence,
      slug: slug
    }
  end
end

# Sort each group by sequence number
post_groups.each do |base, posts|
  posts.sort_by! { |post| post[:sequence] }
end

# For each group, update the dates to be sequential
post_groups.each do |base, posts|
  next if posts.empty?
  
  # Find the earliest date in the group to use as starting point
  start_date = posts.map { |post| post[:date] }.min
  
  # Update post dates
  posts.each_with_index do |post, index|
    # Calculate new date (start_date + index days)
    new_date = start_date + index
    
    # Skip if the date is already correct
    next if post[:date] == new_date
    
    # Read the post file
    content = File.read(post[:file])
    
    # Parse the YAML front matter
    if content =~ /\A---\s*\n(.*?\n?)^---\s*$\n?(.*)\z/m
      front_matter = YAML.load($1)
      post_content = $2
      
      # Update the date
      front_matter['date'] = new_date.strftime('%Y-%m-%d')
      
      # Write the updated content back to the file
      new_content = "---\n#{front_matter.to_yaml.sub(/---\n/, '')}---\n#{post_content}"
      File.write(post[:file], new_content)
      
      # Create a new filename with the updated date
      new_filename = "_posts/#{new_date.strftime('%Y-%m-%d')}-#{post[:slug]}.md"
      
      # Rename the file if the date has changed
      if post[:file] != new_filename
        File.rename(post[:file], new_filename)
        puts "Renamed #{post[:file]} to #{new_filename}"
      end
      
      puts "Updated date for #{base} #{post[:sequence]} to #{new_date}"
    end
  end
end

puts "All posts with sequential numbering now have sequential dates!" 