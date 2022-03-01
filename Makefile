VERSION := 21.1.3


build:
	docker build -t hichtakk/ansible-nsx-alb:$(VERSION) .

run:
	docker run --rm -it -v $(PWD)/playbook:/playbook hichtakk/ansible-nsx-alb:$(VERSION) bash
