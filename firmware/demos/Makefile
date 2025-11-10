
DEMO = game
export DEMO

.PHONY: default

MAKEFILE_TOP_END = DO\ NOT\ EDIT\ BELOW\ THIS\ LINE

default:
	@echo "Building \"${DEMO}\"."
	make -C ..
	cp -r ${DEMO}/. ../template/.
ifneq ("$(wildcard ${DEMO}/Makefile.top)","")
	@echo "Makefile.top found. Modifying default Makefile"
	@echo "\n" >> ../template/Makefile.top
	@cat ../template/Makefile | sed -n '/${MAKEFILE_TOP_END}/,$$ p' >> ../template/Makefile.top
	@mv ../template/Makefile.top ../template/Makefile
	@echo "Created ${DEMO}'s Makefile"
else
	@echo "Makefile.top not found. Using default Makefile."
endif
	@sleep 1
	make -C ../template
