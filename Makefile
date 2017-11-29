item = youtube-dl
container = container-$(item)
image = $(item)
version = 0.1

SHELL := /bin/bash

clean:
	rm -f ${HOME}/.containers.d/$(image)
	docker rm $(container) || true
	docker rmi $(image)

define RUN_COMMAND
#!/bin/bash
#$(image)() {
docker run -it --rm         \
-v `pwd`:`pwd` -w `pwd`     \
-h $(image).local  \
$(image) "$$@"
#}
endef

export RUN_COMMAND

install: create-command
	docker build -t "${image}" \
  --squash \
  .

create-command:
	echo "$$RUN_COMMAND" > "/usr/local/bin/${item}"
	chmod u+x "/usr/local/bin/${item}"

uninstall:
	rm -f ${HOME}/.containers.d/$(image)

.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

