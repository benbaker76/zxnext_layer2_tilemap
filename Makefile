################################################################################
# Ben Baker 2020
# zxnext_layer2_tilemap
################################################################################

M4 := m4

MKDIR := mkdir -p

RM := rm -rf

CP := cp

ZIP := zip -r -q

BINDIR := bin

CFG := src/zconfig.h src/zconfig.def src/zpragma.inc src/zconfig.m4 zproject.lst

DEBUGFLAGS := --list --c-code-in-asm

BUILD_OPT := false

ifeq ($(BUILD_OPT), true)
CFLAGS_OPT := -SO3 --max-allocs-per-node200000
endif

# sdcc_ix, sdcc_iy, new

CFLAGS := +zxn -subtype=nex -vn -startup=31 -clib=sdcc_iy -m $(CFLAGS_OPT)

all: CFG
	$(MKDIR) $(BINDIR)
	zcc $(CFLAGS) $(DEBUG) -pragma-include:src/zpragma.inc @zproject.lst -o $(BINDIR)/zxnext_layer2_tilemap -Cz"--main-fence 0xBE80" -create-app

debug: DEBUG = $(DEBUGFLAGS)

debug: all

CFG: $(CFG)

src/zconfig.h: configure.m4
	$(M4) -DTARGET=1 $(CONFIG) $< > $@

src/zconfig.def: configure.m4
	$(M4) -DTARGET=2 $(CONFIG) $< > $@

src/zconfig.m4: configure.m4
	$(M4) -DTARGET=3 $(CONFIG) $< > $@

src/zpragma.inc: configure.m4
	$(M4) -DTARGET=4 $(CONFIG) $< > $@

zproject.lst: configure.m4
	$(M4) -DTARGET=5 $(CONFIG) $< > $@

clean:
	$(RM) bin tmp zcc_opt.def zcc_proj.lst src/*.lis
