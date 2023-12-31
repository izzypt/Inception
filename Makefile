NAME = inception

all: prune reload

linux:
	@ echo "127.0.0.1 smagalha.42.fr" >> /etc/hosts
	
stop:
	@ docker compose -f srcs/docker-compose.yml down

prune:
	@ docker system prune -f

reload: 
	@ docker compose -f srcs/docker-compose.yml up --build

.PHONY: linux stop prune reload all
