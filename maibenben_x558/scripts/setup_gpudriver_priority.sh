#!/bin/bash

# Проверяем, запущен ли скрипт с правами root
if [ "$EUID" -ne 0 ]; then
  echo "Ошибка: Этот скрипт необходимо запускать с правами sudo (sudo ./set_gpu_priority.sh)"
  exit 1
fi

echo "=== Шаг 1: Настройка ранней загрузки (Early KMS) для AMD ==="
MODULES_FILE="/etc/initramfs-tools/modules"

# Проверяем, добавлен ли уже драйвер amdgpu, чтобы избежать дублирования
if grep -q "^amdgpu" "$MODULES_FILE"; then
    echo "[ИНФО] Драйвер amdgpu уже присутствует в $MODULES_FILE."
else
    echo "amdgpu" >> "$MODULES_FILE"
    echo "[УСПЕХ] Драйвер amdgpu добавлен в $MODULES_FILE для приоритетного старта."
fi


echo -e "\n=== Шаг 2: Создание правил приоритета (softdep) для модулей ядра ==="
NVIDIA_CONF="/etc/modprobe.d/nvidia.conf"

# Создаем конфигурационный файл для модов ядра
cat << 'EOF' > "$NVIDIA_CONF"
# Включение Kernel Mode Setting для корректной работы PRIME-дисплеев
options nvidia-drm modeset=1

# Жесткий приоритет: модуль nvidia загружается строго ПОСЛЕ amdgpu
softdep nvidia pre: amdgpu
EOF

echo "[УСПЕХ] Конфигурация приоритетов записана в $NVIDIA_CONF."


echo -e "\n=== Шаг 3: Обновление загрузочного образа initramfs ==="
echo "Это может занять некоторое время, пожалуйста, подождите..."

if update-initramfs -u; then
    echo -e "\n[ОК] Образ initramfs успешно обновлен!"
    echo "=========================================================="
    echo "Настройка завершена. Теперь AMD будет инициализироваться первой."
    echo "Пожалуйста, перезагрузите ноутбук для применения изменений."
    echo "=========================================================="
else
    echo -e "\n[ОШИБКА] Не удалось обновить initramfs. Проверьте вывод выше."
    exit 1
fi
