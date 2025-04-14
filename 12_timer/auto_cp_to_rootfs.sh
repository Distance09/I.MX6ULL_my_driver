#!/bin/bash

# 定义源文件和目标目录
KONAME="timer"
EXECUTABLE_FILE_NAME="timerApp.c"
EXECUTABLE_NAME=$(basename "$EXECUTABLE_FILE_NAME" .c)
SOURCE_DIR=$(pwd)
DEST_DIR="/home/zxb/linux/nfs/rootfs/lib/modules/4.1.15/"

# 检查是否存在 .ko 文件，若存在则执行 make clean
KO_FILE_EXIST=$(find "$SOURCE_DIR" -name "*.ko" -type f | head -n 1)
if [ -n "$KO_FILE_EXIST" ]; then
    echo "发现已存在的 .ko 文件，执行 make clean..."
    make clean
    if [ $? -ne 0 ]; then
        echo "make clean 命令执行失败，脚本终止。"
        exit 1
    fi
fi

# 执行 make 命令生成 .ko 文件
echo "开始执行 make 命令生成 .ko 文件..."
make
if [ $? -ne 0 ]; then
    echo "make 命令执行失败，脚本终止。"
    exit 1
fi
# 查找生成的 .ko 文件
KO_FILE=$(find "$SOURCE_DIR" -name "*.ko" -type f | head -n 1)
if [ -z "$KO_FILE" ]; then
    echo "未找到生成的 .ko 文件，脚本终止。"
    exit 1
fi

# 编译 A.c 文件生成可执行文件 A
echo "开始编译 A.c 文件生成可执行文件 A..."
arm-linux-gnueabihf-gcc "$EXECUTABLE_FILE_NAME" -o "$EXECUTABLE_NAME"
if [ $? -ne 0 ]; then
    echo "编译 $EXECUTABLE_FILE_NAME 文件失败，脚本终止。"
    exit 1
fi

# 复制 .ko 文件和可执行文件到目标目录
echo "开始复制文件到 $DEST_DIR..."
sudo cp "$KO_FILE" "$EXECUTABLE_NAME" "$DEST_DIR" -f

# 检查复制是否成功
if [ $? -eq 0 ]; then
    echo "文件复制成功，驱动文件和APP文件 $EXECUTABLE_NAME 已复制到 $DEST_DIR。"
else
    echo "文件复制失败，请检查权限或目标目录是否正确。"
fi