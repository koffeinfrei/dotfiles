require 'rake'
require 'fileutils'

desc "install the dotfiles into the current user's home"
task :install do
  overwrite_all = false
  backup_all = false
  skip_all = false

  home = Dir.home

  # Create ~/bin (if does not exist)
  files.map { |f| File.dirname(f) }.each do |directory|
    FileUtils.mkdir_p(File.join(home, directory))
  end

  files.each do |f|
    overwrite = false
    backup = false
    skip = false

    target = File.join(home, f)

    if File.exist?(target) || File.symlink?(target)
      unless overwrite_all || backup_all || skip_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then skip = true
        end
      end

      next if skip || skip_all

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
    FileUtils.mv(backup, target) if File.exist? backup
  end
end

desc "sets up vim plugins"
task :vim do
  `sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'`
  `vim +PlugInstall +qall`
end

desc "creates a symlink for neovim"
task :neovim do
  config_dir = File.join(Dir.home, '.config/nvim')
  source = File.join(Dir.home, '.vimrc')
  target = File.join(config_dir, 'init.vim')

  FileUtils.mkdir(config_dir) unless File.exist?(config_dir)
  FileUtils.ln_s(source, target) unless File.exist?(target)

  puts "linked #{target} -> #{source}."
end

desc "installs the dependent ubuntu packages"
task :packages do
  system("
    sudo apt install -y \
    trash-cli \
    exuberant-ctags \
    autojump \
    net-tools \
    thefuck \
    silversearcher-ag \
    tmux \
    fzf
   ")
end

task default: [:packages, :install, :vim, :neovim]

def files
  `git ls-files -z`.split("\x0").select do |file|
    file.start_with?('.') ||
      file.start_with?('bin/')
  end
end
