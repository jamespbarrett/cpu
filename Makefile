WORKDIR?=work
STD?=08

GHDL?=ghdl
GHDL_FLAGS?=--workdir=${WORKDIR} --std=${STD}
GHDL_IFLAGS?=
GHDL_MFLAGS?=
GHDL_AFLAGS?=

VHDL_SOURCES=$(wildcard *.vhd) $(wildcard rtl/*.vhd)
TB_SOURCES=$(wildcard rtl/*_tb.vhd)

all: list_tb

.DUMMY: all clean list_tb

${WORKDIR}:
	mkdir -p $<

${WORKDIR}/work-obj${STD}.cf: ${VHDL_SOURCES}
	${GHDL} -i ${GHDL_FLAGS} ${GHDL_IFLAGS} ${VHDL_SOURCES}

make-%: ${WORKDIR}/work-obj${STD}.cf
	${GHDL} -m ${GHDL_FLAGS} ${GHDL_MFLAGS} $*

%.ghw: make-%
	${GHDL} -r ${GHDL_FLAGS} ${GHDL_RFLAGS} $* --wave=$@

list_tb: ${WORKDIR}/work-obj${STD}.cf
	@echo "Valid test bench targets:"
	@sed -n '/architecture test/{s/.*architecture test of \([a-zA-Z0-9_]*\).*/    \1.ghw/;p;}' $<

clean:
	-rm -rf ${WORKDIR}/*
	-rm -rf *.ghw

