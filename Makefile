VERSION := 21.1.3
CTRL01 := $(shell cat playbook/variables/credential01.yaml | grep controller | awk '{print $$NF}' | sed 's/"//g')
OVA_DIR := /host/pkgs/21.1.3-9051-20211219.182134


build:
	docker build -t hichtakk/ansible-nsx-alb:$(VERSION) .

run:
	docker run -itd -v $(PWD)/playbook:/playbook --name alb-ansible hichtakk/ansible-nsx-alb:$(VERSION) /bin/sh 

03-sysconfig:
	@for ctrl in 1 2 3; do \
	    docker exec -it alb-ansible ansible-playbook -v -e @playbook/variables/credential0$${ctrl}.yaml -e @playbook/variables/03-system-configuration.yaml playbook/03-system-configuration.yaml; \
	done

04-controller-cluster:
	docker exec -it alb-ansible ansible-playbook -v -e @playbook/variables/credential01.yaml -e @playbook/variables/04-controller-cluster.yaml playbook/04-controller-cluster.yaml

05-cloud:
	docker exec -it alb-ansible ansible-playbook -v -e @playbook/variables/credential01.yaml -e @playbook/variables/05-cloud.yaml playbook/05-cloud.yaml
	scp admin@$(CTRL01):${OVA_DIR}/se.ova ./playbook/

06-se:
	#generate authtoken for each SE
	#playbook/06-deploy-se.sh
	docker exec -it alb-ansible ansible-playbook -v -e @playbook/variables/credential01.yaml -e @playbook/variables/06-se.yaml playbook/06-segroup.yaml
