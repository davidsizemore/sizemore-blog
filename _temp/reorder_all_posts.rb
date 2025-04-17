#!/usr/bin/env ruby

require 'date'
require 'yaml'

# Read all post files
post_files = Dir.glob('_posts/*.md')

# Initialize groups based on title prefixes
post_groups = {}

post_files.each do |file|
  basename = File.basename(file, '.md')
  
  # Skip files that don't match our pattern (some might be manually created posts)
  match = basename.match(/(\d{4}-\d{2}-\d{2})-(.+)/)
  next unless match
  
  date_str = match[1]
  slug = match[2]
  
  # Read the post file to get the title
  content = File.read(file)
  
  # Extract front matter
  front_matter_match = content.match(/\A---\s*\n(.*?\n?)^---\s*$\n?(.*)\z/m)
  next unless front_matter_match
  
  front_matter = YAML.load(front_matter_match[1])
  title = front_matter['title']
  
  # Skip posts without titles
  next unless title
  
  # Remove quotes from title if present
  title = title.gsub(/["']/, '')
  
  # Determine group key from title (first word or part before a number)
  group_key = nil
  
  if title.include?(' ')
    # First word in multi-word titles
    first_word = title.split(' ').first.downcase
    group_key = first_word
  else
    # For single word titles, use the whole word
    group_key = title.downcase
  end
  
  # Handle special cases or adjust as needed
  if group_key == '3d'
    group_key = 'threeD'  # Avoid numeric group keys
  elsif group_key == 'ring'
    group_key = 'telephone'  # Group with other telephone posts
  end
  
  # Some posts might need manual grouping adjustments
  if slug.start_with?('dot-bag')
    group_key = 'dotbag'
  elsif slug.start_with?('orangetree')
    group_key = 'orangetree'
  end
  
  # Add to appropriate group
  post_groups[group_key] ||= []
  post_groups[group_key] << {
    file: file,
    date: Date.parse(date_str),
    title: title,
    slug: slug,
    content: content,
    front_matter: front_matter
  }
end

# Start date for the first group (July 1, 2024)
current_date = Date.new(2024, 7, 1)

# Process each group, updating dates
post_groups.each do |group_key, posts|
  puts "Processing group: #{group_key} with #{posts.length} posts"
  
  # Sort posts within each group by existing order (filename or any other criteria)
  # This preserves any existing sequence inside each group
  posts.sort_by! { |post| post[:slug] }
  
  # Update dates for all posts in the group
  posts.each_with_index do |post, index|
    # Calculate new date for this post
    new_date = current_date + index
    
    # Skip if date is already correct
    next if post[:date] == new_date
    
    # Update the front matter date
    post[:front_matter]['date'] = new_date.strftime('%Y-%m-%d')
    
    # Create updated content
    new_content = "---\n#{post[:front_matter].to_yaml.sub(/---\n/, '')}---\n#{post[:content].split("---\n", 3)[2]}"
    
    # Create new filename with updated date
    new_filename = "_posts/#{new_date.strftime('%Y-%m-%d')}-#{post[:slug]}.md"
    
    # Write updated content to the file
    File.write(post[:file], new_content)
    
    # Rename the file if the date has changed
    if post[:file] != new_filename
      File.rename(post[:file], new_filename)
      puts "  Renamed #{post[:file]} to #{new_filename}"
    end
    
    puts "  Updated date for '#{post[:title]}' to #{new_date}"
  end
  
  # Move current_date forward for the next group
  # Skip ahead by the number of posts in the group plus 2 days spacing
  current_date = current_date + posts.length + 2
end

puts "All posts have been reordered by title groups with sequential dates!" 