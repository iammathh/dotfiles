# Dotfiles

I've decided to use `stow` to manage my `dotfiles` repository.

It creates `symlinks` based on the directory tree, without needing to specify files and subfolders. It manages everything in a straightforward way, eliminating the need to manually add symlinks.

## How it works
By default, the `stow` command creates symlinks for files in the parent directory, replicating the exact same folder structure of the directory where you execute the command. To simplify the process, you can keep your `.dotfiles` folder at `$HOME` and move all your configuration files into it, maintaining the same folder structure. With that setup, all you need to do is run `stow .` and the magic will happen.

Personally, I decided to keep my dotfiles in `~/Repos/github.com/iammathh/dotfiles`, so all `stow` commands should be executed in that directory and suffixed with `-t ~` to target the home directory. I also keep a folder for each app, where each app folder replicates the `$HOME` directory structure within the app dotfiles. In this case, I need to run `stow */ -t ~`.

I prefer this approach because I can `stow` individual apps as needed using `stow <app_folder> -t ~`. I think it is a cleaner and easier-to-manage approach. It may sound complicated, but it is actually easier to manage the apps.


---

### If you create a `.dotfiles` folder in the `$HOME` directory

From inside `~/.dotfiles`:
```shell
stow */ -v             # stow all app folders 
stow tmux -v           # stow a single app 

stow -D */ -v -n       # unstow/delete all symlinks (dry run)
stow -D */ -v          # unstow/delete all symlinks
```

### If you create a `dotfiles` folder somewhere else

From inside `/<path>/dotfiles`:
```shell
stow */ -v -t ~        # stow all app folders 
stow tmux -v -t ~      # stow a single app 
```

---

### To delete symlinks

From inside the `dotfiles` folder (no need to specify target with `-t ~`):
```shell
stow -D */ -v -n       # unstow/delete all symlinks (dry run)
stow -D */ -v          # unstow/delete all symlinks 
```