#!/bin/sh

. /opt/muos/script/var/func.sh

C_BRIGHT="$(cat /opt/muos/config/brightness.txt)"
if [ "$C_BRIGHT" -lt 1 ]; then
	/opt/muos/device/"$(GET_VAR "device" "board/name")"/input/combo/bright.sh U
else
	/opt/muos/device/"$(GET_VAR "device" "board/name")"/input/combo/bright.sh "$C_BRIGHT"
fi

GET_VAR "global" "settings/general/colour" >/sys/class/disp/disp/attr/color_temperature

if [ "$(GET_VAR "global" "settings/general/hdmi")" -gt -1 ]; then
	killall hdmi_start.sh
	/opt/muos/device/"$(GET_VAR "device" "board/name")"/script/hdmi_stop.sh
	if [ "$(GET_VAR "device" "board/hdmi")" -eq 1 ]; then
		/opt/muos/device/"$(GET_VAR "device" "board/name")"/script/hdmi_start.sh &
	fi
else
	if pgrep -f "hdmi_start.sh" >/dev/null; then
		killall hdmi_start.sh
		/opt/muos/device/"$(GET_VAR "device" "board/name")"/script/hdmi_stop.sh
	fi
fi

if [ "$(GET_VAR "global" "settings/advanced/android")" -eq 1 ]; then
	/opt/muos/device/"$(GET_VAR "device" "board/name")"/script/adb.sh &
else
	killall -q adbd
fi
