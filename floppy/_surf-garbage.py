# pip install -U pywinauto
from pywinauto.application import Application
import subprocess
import time
subprocess.run('SCHTASKS /DELETE /TN BuildTasks\\Sites /f')
app = Application(backend='uia')
app.start('C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe --force-renderer-accessibility ')
window = app.top_window()
# Allow the registry installed extensions to load...
time.sleep(45)
ch_window = window.child_window(title="Address and search bar", control_type="Edit")
ch_window.type_keys('^a')
ch_window.type_keys('{BACKSPACE}chrome://extensions/{ENTER}')
time.sleep(3)
# Enable Honey (or disable google drive offline)
dlg = window.button6
try:
   dlg.click()
except Exception:
   dlg.close()
# Enable Soccer wallpapers (or Soccer wallpapers)
dlg = window.button9
try:
   dlg.click()
except Exception:
   dlg.close()
# Enable Soccer wallpapers (if it exists)
dlg = window.button12
try:
   dlg.click()
except Exception:
   dlg.close()
time.sleep(5)
ch_window.type_keys('^a')
ch_window.type_keys('{BACKSPACE}https://thepiratebay.org{ENTER}')
time.sleep(10)
# Allow notifications
dlg = window.AllowButton
try:
   dlg.wait_not('visible', timeout=2)
   dlg.click()
except Exception:
   dlg.close()
ch_window.type_keys('^a')
ch_window.type_keys('{BACKSPACE}{BACKSPACE}https://yts.mx{ENTER}')
time.sleep(3)
window.close()
