SHELL = bash

.PHONY: cron_add
cron_add:
	@set -e; \
		set -o pipefail; \
		crontab -l > /tmp/mycron || true; \
		sed -i '#$(shell which make) -C $(shell pwd) git_sync#d' /tmp/mycron; \
		echo "*/5 * * * * $(shell which make) -C $(shell pwd) git_sync" >> /tmp/mycron; \
		crontab /tmp/mycron; \
		rm /tmp/mycron

.PHONY: git_sync
git_sync:
	@set -e; \
		set -o pipefail; \
		git stash; \
		git pull --rebase origin master
