images:
	cd cm && ansible-playbook -i inventory -c local playbook/images.yml

nodejs:
	cd cm && ansible-playbook -i inventory -c local playbook/nodejs.yml

registry:
	cd cm && ansible-playbook -i inventory -c local playbook/images.yml --tags 'registry'

template_service:
	cd cm && ansible-playbook -i inventory -c local playbook/template_service.yml

push:
	cd cm && ansible-playbook -i inventory -c local playbook/push.yml -e "docker_image_tag=$(TAG)"

ENV=undefined
#Чтобы явно вызвать ошибку при выполнении ansible-playbook

deploy:
	@echo "Формат команды:"
	@echo "make deploy ENV=<куда деплоить> TAG=<тег docker образа>"
	cd cm && ansible-playbook -i inventory -l $(ENV) -c local playbook/deploy.yml -e "docker_image_tag=$(TAG)"

build-remote:
	cd cm && ansible-playbook \
		playbook/build.yml \
		-i inventory \
		-c local
