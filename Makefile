all:
	./makehelp.sh all-supported

push:
	./makehelp.sh push-all-supported

v0.10:
	./makehelp.sh all 0.10.41

v0.12:
	./makehelp.sh all 0.12.9

v4.2:
	./makehelp.sh all 4.2.4

v5.3:
	./makehelp.sh all 5.3.0

push-v0.10:
	./makehelp.sh push-all 0.10.41

push-v0.12:
	./makehelp.sh push-all 0.12.9

push-v4.2:
	./makehelp.sh push-all 4.2.4

push-v5.3:
	./makehelp.sh push-all 5.3.0
