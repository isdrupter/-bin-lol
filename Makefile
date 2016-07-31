CC := gcc
OBJCOPY ?= objcopy

CFLAGS ?= -ggdb -Wall -Werror -Wextra

SCRIPT := script.sh
SCRIPT_OBJECTS := $(SCRIPT:.sh=.o)

SOURCES := suidsh.c
SOURCES_OBJECTS := $(SOURCES:.c=.o)

OBJECTS := $(SCRIPT_OBJECTS) $(SOURCES_OBJECTS)

BINARY := suidsh

SCRIPT_NAME_SYM := $(subst .,_,$(SCRIPT))

.PHONY: all clean

all: $(BINARY)

clean:
	$(RM) $(OBJECTS) $(BINARY)

$(BINARY): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

$(SOURCES_OBJECTS): %.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -DSCRIPT_NAME=$(SCRIPT_NAME_SYM) -o $@ $<

$(SCRIPT_OBJECTS): %.o: %.sh
	$(OBJCOPY) -I binary -O elf64-x86-64 -B i386 --rename-section .data=.rodata,readonly,data,load,contents,alloc $< $@
