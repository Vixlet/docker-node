v0.10:
	./build.sh all --latest=0.10.41 0.10.41

v0.12:
	./build.sh all 0.12.9

v4.2:
	./build.sh all 4.2.4

v5.3:
	./build.sh all 5.3.0

push-v0.10:
	./build.sh push --latest=0.10.41 0.10.41

push-v0.12:
	./build.sh push 0.12.9

push-v4.2:
	./build.sh push 4.2.4

push-v5.3:
	./build.sh push 5.3.0
