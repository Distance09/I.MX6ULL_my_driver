# linux内核路径
KERNELDIR := /home/zxb/linux/IMX6ULL/linux/linux-imx-rel_imx_4.1.15_2.1.0_ga_alientek
# 当前路径
CURRENT_PATH := $(shell pwd)
obj-m := chrdevbase.o

# 表示编译的是模块
build: kernel_modules

kernel_modules:
	$(MAKE) -C $(KERNELDIR) M=$(CURRENT_PATH) modules
clean:
	$(MAKE) -C $(KERNELDIR) M=$(CURRENT_PATH) clean