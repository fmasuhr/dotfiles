DO_NOT_SYMLINK = %w( .gitignore LICENSE Rakefile README.md )

task default: :install

desc 'symlink .files into home directory'
task :install do
  replace_all = false
  (Dir['*'] - DO_NOT_SYMLINK).each do |file|
    symlink = File.join(ENV['HOME'], ".#{file}")
    if File.exist?(symlink)
      if File.identical?(file, symlink)
        puts "Symlink to ~/.#{file} already exists"
      elsif replace_all
        replace_file(file)
      else
        print "Overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipped symlinking ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  `rm -rf "$HOME/.#{file}"`
  link_file(file)
end

def link_file(file)
  `ln -s "$PWD/#{file}" "$HOME/.#{file}"`
  puts "Created symlink ~/.#{file}"
end
