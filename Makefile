NAME = incpetion

all: $(NAME)

$(NAME):
	mkdir -p /home/lvodak/data/mariadb
	mkdir -p /home/lvodak/data/wordpress
	cd /home/lvodak/inception/srcs && docker compose up --build -d
clean:
	cd /home/lvodak/inception/srcs && docker compose down
fclean: clean
	docker system prune -af
re: fclean all

eval:
	@if [ -n "$(shell docker ps -qa)" ]; then \
		echo "Stopping and removing containers..."; \
		docker stop $(shell docker ps -qa); \
		docker rm $(shell docker ps -qa); \
	else \
		echo "No containers to stop or remove."; \
	fi
	@if [ -n "$(shell docker images -qa)" ]; then \
		echo "Removing images..."; \
		docker rmi -f $(shell docker images -qa); \
	else \
		echo "No images to remove."; \
	fi
	@if [ -n "$(shell docker volume ls -q)" ]; then \
		echo "Removing volumes..."; \
		docker volume rm $(shell docker volume ls -q); \
	else \
		echo "No volumes to remove."; \
	fi
	@if [ -n "$(shell docker network ls -q | grep -v 'bridge\|host\|none')" ]; then \
		echo "Removing networks..."; \
		docker network rm $(shell docker network ls -q) 2>/dev/null || true; \
	else \
		echo "No custom networks to remove."; \
	fi

.PHONY: all clean fclean re eval