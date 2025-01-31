

ospf: ospf-config restart

ospf-config:
	cp ospf.bird.conf bird.conf


restart:
	docker compose kill || echo "ignore"
	docker compose down || echo "ignore"
	docker compose up --build -d