# (Dead) simple installation / configuration of Powerline (powerline-status)
> #Linux #bash #git [#Powerline](https://github.com/powerline/powerline)
>

If you ever have to reinstall Powerline on another machine this are the easy steps to follow to give you a nice looking prompt with git status and branch name in your bash terminal. Steps where done on Deepin Linux 15.7 but should also work on Debian / Ubuntu.

![image - Deepin Linux Bash Powerline Git Status](https://user-images.githubusercontent.com/5635462/51083961-abca4e80-1722-11e9-825b-e3767c780cb6.png)

## TL;DR
```bash
pip install powerline-status

wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf

# NOTE: adjust fonts paths properly!
mv PowerlineSymbols.otf /usr/share/fonts/

fc-cache -vf /usr/share/fonts/

mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# add this to your .bashrc
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. {powerline-installation-dir}/bindings/bash/powerline.sh
# NOTE: use `pip show powerline-status` to find your **{powerline-installation-dir}**

mkdir -p ~/.config/powerline
# NOTE: adjust your {powerline-installation-dir} properly!
cp /{powerline-installation-dir}/config_files/config.json ~/.config/powerline

# edit ~/.config/powerline/config.json to see git branch name in prompt
# --> "theme": "default_leftonly",

# edit /{powerline-installation-dir}/segments/common/vcs.py to color highlight git status (sudo?)
# --> def __call__(self, pl, segment_info, create_watcher, status_colors=True, ignore_statuses=()):
# optionally set "ignore_statuses=()" to "ignore_statuses=(["U"])" to ignore untracked files

powerline-daemon --replace

# close all terminal windows
# FINISH

NOTE: If you run into issues scroll down and check my latest comments - hope it helps ♥

```



## DETAILED INSTRUCTIONS (10 STEPS)
How to install Powerline in 10 steps on Linux and configure it for bash terminal with git status.

1. 	```bash
	pip install powerline-status
	```

## Fonts installation
Download fonts file and fontconfig file.

2.	```bash
	wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
	wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
	```


Move the symbol font to a valid X fonts path. Valid fonts paths can be listed with `xset q` (--> `Font Path: ...`).

3.	```bash
	# NOTE: adjust fonts path properly!
	mv PowerlineSymbols.otf /usr/share/fonts/
	```

Update fonts cache.

4.	```bash
	# NOTE: adjust fonts path properly!
	fc-cache -vf /usr/share/fonts/
	```

Install fontconfig.

5.	```bash
	mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
	```

## Edit your `.bashrc`
Add this lines to your .bashrc

6.	```bash
	powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1
	. {powerline-installation-dir}/bindings/bash/powerline.sh
	```

> NOTE: use `pip show powerline-status` to determine your **{powerline-installation-dir}** (e.g. `Location: /usr/local/...`)


## Customization (show git status and branch name)

7.	```bash
	mkdir -p ~/.config/powerline
	```

Copy `config.json` from `{powerline-installation-dir}/config_files/` to `~/.config/powerline`

8.	```bash
	# NOTE: adjust your {powerline-installation-dir} properly!
	cp /usr/lib/python3.6/site-packages/powerline/config_files/config.json ~/.config/powerline
	```

To see git branch name and color highlighted git status in prompt you have to 
  - change shell/theme property from `default` to `default_left_only` in `~/.config/powerline/config.json` (see 9.)
  - copy `default_leftonly.json` to your user config directory (`~/.config/powerline`) and modify it (see 10.).


9.	```bash
	# edit ~/.config/powerline/config.json
	{
	  ...
		"ext": {
	    ...
			"shell": {
				"colorscheme": "default",
				"theme": "default_leftonly",
				"local_themes": {
					"continuation": "continuation",
					"select": "select"
				}
			},
	    ...
		}
	}
	```
10.	```bash
	# copy default_leftonly.json from powerline installation dir to user config dir
	cp {powerline-installation-dir}/config_files/themes/shell/default_leftonly.json ~/.config/powerline
	
	# modify default_leftonly.json in user config dir
	nano ~/.config/powerline/default_leftonly.json
	```
	```json
	{
           "function": "powerline.segments.common.vcs.branch",
           "priority": 40,
           "args": {
                       "status_colors": true,
                       "ignore_statuses": ["U"]
                   }
    },
	```
	
## FINISH! APPLY CHANGES!
Your changes will not apply until you restart the daemon

```bash
powerline-daemon --replace
```

---
Need even more details? --> [Official Documentation](https://powerline.readthedocs.io/en/master/installation.html)