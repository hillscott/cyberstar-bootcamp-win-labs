# pip install -U pyautogui
import pywinauto.application
import os
import time
import subprocess
import sys
# Remove the GUI work-around schedule item
subprocess.run('SCHTASKS /DELETE /TN BuildTasks\\uTorrent /f')
os.startfile('C:\\Windows\\Temp\\uTorrent.exe')
time.sleep(10)

app = pywinauto.application.Application(backend="uia").connect(path="GenericSetup.exe")
ch_window = app.top_window()
dlg = ch_window.window(title_re="Next", control_type="Button")
try:
    dlg.click()
except Exception:
    dlg.close()
try:
    dlg.click()
except Exception:
    dlg.close()
dlg = ch_window.window(title_re="Agree", control_type="Button")
dlg.click()
time.sleep(3)
# Decline Avast
ch_window.Button5.click()
# Install Opera
ch_window.Button5.click()
# Install SodaPDF
ch_window.Button6.click() 
dlg = ch_window.window(title_re="Next", control_type="Button")
dlg.click()
dlg = ch_window.window(title_re="Next", control_type="Button")
dlg.click()
dlg = ch_window.window(title_re="Next", control_type="Button")
dlg.click()
time.sleep(20)
dlg = ch_window.window(title_re="Finish", control_type="Button")
dlg.click()
