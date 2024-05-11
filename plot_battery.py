'''This file is part of Battery Usage Analysis Tool.

Battery Usage Analysis Tool is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Battery Usage Analysis Tool is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Battery Usage Analysis Tool. If not, see <https://www.gnu.org/licenses/>.'
'''


import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


file_path = "data_battery.txt"

data = pd.read_csv(file_path)

print(data.keys())

#include date in calculating time as well (If code runs at 11:59 PM and runs till 12:10 AM)
time_0 = (data['hour'][0]*3600) + (data['minutes'][0]*60) + data['seconds'][0]

time = (data['hour']*3600) + (data['minutes']*60) + data['seconds'] - time_0*np.ones(data['hour'].size)

data['time'] = time

data = data.drop(columns=['hour','minutes','seconds','date'])

fig, axs = plt.subplots(5)

axs[0].plot(time,data['brightness'])
axs[0].set_xlabel('time (s)'); axs[0].set_ylabel('Brightness')

axs[1].plot(time,data['battery_level'])
axs[1].set_xlabel('time (s)'); axs[1].set_ylabel('Battery Level')

axs[2].plot(time,data['charging_status'])
axs[2].set_xlabel('time (s)'); axs[2].set_ylabel('Charging Status')

axs[3].plot(time,data['cpu_usage'])
axs[3].set_xlabel('time (s)'); axs[3].set_ylabel('CPU Usage')

axs[4].plot(time,data['kbd_backlight_brightness'])
axs[4].set_xlabel('time (s)'); axs[4].set_ylabel('Keyboard Backlight')


plt.show()
