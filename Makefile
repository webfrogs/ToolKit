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
	@set -e; set -o pipefail; \
		git fetch origin; \
		latestHash=$(shell git rev-parse origin/master); \
		if test -f ".pre_git_hash" -a "$(shell cat .pre_git_hash)" = "$${latestHash}"; then \
		  echo "no need to update"; \
		else \
		  echo "prepare to update git repo"; \
			git reset --hard origin/master; \
			echo "$(shell git rev-parse HEAD)" > .pre_git_hash; \
		fi; 

.PHONY: gitee
gitee:
	@set -e; \
		if ! git remote | grep -q '^gitee$$'; then \
		  echo "add gitee git remote"; \
			git remote add gitee git@gitee.com:nswebfrog/ToolKit.git; \
	  fi; \
		git push -f gitee master
