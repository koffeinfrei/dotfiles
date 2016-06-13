require 'rake'

desc "install the dotfiles into the current user's home"
task :install do
  overwrite_all = false
  backup_all = false

  home = Dir.home
  files.each do |f|
    overwrite = false
    backup = false

    target = File.join(home, f)

    if File.exists?(target) || File.symlink?(target)
      unless overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then break
        when 's' then next
        end
      end

      FileUtils.rm_rf(target) if overwrite || overwrite_all
      FileUtils.mv(target, "#{target}.dotfiles~") if backup || backup_all
    end

    FileUtils.ln_s(File.join(Dir.getwd, f), target)
    puts "linked #{target}"
  end

  puts "done."
end

desc "uninstalls the dotfiles from the current user's home"
task :uninstall do
  home = Dir.home

  files.each do |f|
    target = File.join(home, f)

    FileUtils.rm(target) if File.symlink?(target)

    backup = File.join(home, "#{f}.dotfiles~")
    FileUtils.mv(backup, target) if File.exists? backup
  end
end

desc "sets up vim plugins"
task :vim do
  `git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`
  `vim +BundleInstall +qall`
end

task :default => :install

def files
  Dir['.[!.]*'].delete_if{|x| x == '.git'} << 'bin'
end
