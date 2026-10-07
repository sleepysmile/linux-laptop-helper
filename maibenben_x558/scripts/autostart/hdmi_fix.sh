#!/bin/bash
# Получаем текущую версию установленного драйвера NVIDIA
CURRENT_VERSION=$(modinfo -F version nvidia 2>/dev/null)

# Укажите версию, для которой должен работать конфиг (например, 550.120)
TARGET_VERSION="580.159.03"

if [ "$CURRENT_VERSION" == "$TARGET_VERSION" ]; then
    # Если версия совпала, выполняем транзит на HDMI
    sleep 3
    xrandr --setprovideroutputsource "NVIDIA-0" "AMD Radeon Graphics @ pci:0000:05:00.0"
else
    echo "Версия драйвера изменилась ($CURRENT_VERSION). Команда не выполнена."
fi
