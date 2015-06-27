all:
	docker build -f Dockerfile -t vixlet/node .

clean:
	docker rmi -f vixlet/node

test:
	bash -c 'make example-stop 2>/dev/null; echo "cleaned up from prior tests"'
	make clean
	make
	make example-run
	sleep 2
	make example-status
	make example-stop
	echo "passed test!"

example-status:
	bash -c 'docker ps | grep vixlet-node-example >/dev/null 2>&1'

example-run:
	docker run -d -p 49988:8080 -v $(shell pwd)/example-server:/var/app --name "vixlet-node-example" vixlet/node:latest

example-stop:
	docker stop vixlet-node-example
	docker rm vixlet-node-example

publish:
	docker push vixlet/node
