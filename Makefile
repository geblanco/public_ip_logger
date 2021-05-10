#
# Global Settings
#

INSTALL = install
DESTDIR ?= /
PREFIX  ?= $(DESTDIR)/usr
SYSTEMD_DIR = $(HOME)/.config/systemd/user

BIN_PATH = $(PREFIX)/bin
PATH_EXEC = ${BIN_PATH}/pub_ip_logger
CONFIG_NAME = pub_ip.config
CONFIG_PATH = $(HOME)/.config/$(CONFIG_NAME)

ifneq ("$(wildcard $(CONFIG_NAME))","")
	LOCAL_CONFIG = $(CONFIG_NAME)
else
	LOCAL_CONFIG = "default.config"
endif

#
# Targets
#

all:
	@echo "Nothing to do"

install:
	@echo "sudo ${INSTALL} -m0755 -D pub_ip_logger.sh ${PATH_EXEC}"
	$(shell sudo ${INSTALL} -m0755 -D pub_ip_logger.sh ${PATH_EXEC})
	$(INSTALL) -m0644 -D pub_ip_logger.service $(SYSTEMD_DIR)/pub_ip_logger.service
	$(INSTALL) -m0644 -D pub_ip_logger.timer $(SYSTEMD_DIR)/pub_ip_logger.timer
	$(INSTALL) -m0644 -D $(CONFIG_NAME) $(CONFIG_PATH)
	systemctl --user enable pub_ip_logger.service
	systemctl --user enable pub_ip_logger.timer
	systemctl --user start pub_ip_logger.timer

uninstall:
	@echo "sudo rm ${PATH_EXEC}"
	$(shell sudo rm ${PATH_EXEC})
	systemctl --user disable pub_ip_logger.service
	systemctl --user stop pub_ip_logger.timer
	systemctl --user disable pub_ip_logger.timer
	rm $(SYSTEMD_DIR)/pub_ip_logger.service
	rm $(SYSTEMD_DIR)/pub_ip_logger.timer
	rm $(CONFIG_PATH)

.PHONY: all install uninstall
