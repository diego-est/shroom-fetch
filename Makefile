.POSIX:

HAREC=hare
SRC=src/*.ha
BUILD=build

build: src/main.ha
	$(HAREC) build -F -o $(BUILD)/a.out $(SRC)

run:
	$(HAREC) run $(SRC)

test:
	$(HAREC) test $(SRC)

.PHONY: run build
