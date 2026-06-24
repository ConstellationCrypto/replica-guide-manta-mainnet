up:
	@bash ./up.sh
.PHONY: up

down:
	@(docker compose down)
.PHONY: down

clean: down
	docker image ls 'replica*' --format='{{.Repository}}' | xargs -r docker rmi
	docker volume ls --filter name='replica-guide' --format='{{.Name}}' | xargs -r docker volume rm
.PHONY: clean
