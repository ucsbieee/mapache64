
DEMO = game
export DEMO

.PHONY: default

default:
	@echo "Building \"${DEMO}\"."
	make -C ..
	cp -r ${DEMO}/. ../template/.
	make -C ../template run
