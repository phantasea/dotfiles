import ranger.api
from ranger.core.linemode import LinemodeBase
from .devicons import *

#add by sim1
#import subprocess
#tmux_sid = subprocess.run(['tmux display-message -p "#S"'], shell=True, capture_output=True, text=True)

@ranger.api.register_linemode
class DevIconsLinemode(LinemodeBase):
  name = "devicons"

  uses_metadata = False

  def filetitle(self, file, metadata):
    #mod by sim1
    #if "3" in tmux_sid.stdout:
    if os.getenv('GUITERM') == 'xterm':
        return file.relative_path
    else:
        return devicon(file) + ' ' + file.relative_path

@ranger.api.register_linemode
class DevIconsLinemodeFile(LinemodeBase):
  name = "filename"

  def filetitle(self, file, metadata):
    #mod by sim1
    #if "3" in tmux_sid.stdout:
    if os.getenv('GUITERM') == 'xterm':
        return file.relative_path
    else:
        return devicon(file) + ' ' + file.relative_path
