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

.PHONY: gitee
gitee:
	@set -e; \
		if ! git remote | grep -q '^gitee$$'; then \
		  echo "add gitee git remote"; \
			git remote add gitee git@gitee.com:nswebfrog/ToolKit.git; \
	  fi; \
		git push -f gitee master
