WORKDIR?=work
STD?=08

GHDL?=ghdl
GHDL_FLAGS?=--workdir=${WORKDIR} --std=${STD}
GHDL_IFLAGS?=
GHDL_MFLAGS?=
GHDL_AFLAGS?=

VHDL_SOURCES=$(wildcard *.vhd)

all: test_bench.ghw

.DUMMY: clean

${WORKDIR}:
	mkdir -p $<

${WORKDIR}/work-obj${STD}.cf: ${VHDL_SOURCES}
	${GHDL} -i ${GHDL_FLAGS} ${GHDL_IFLAGS} ${VHDL_SOURCES}

make-%: ${WORKDIR}/work-obj${STD}.cf
	${GHDL} -m ${GHDL_FLAGS} ${GHDL_MFLAGS} $*

%.ghw: make-%
	${GHDL} -r ${GHDL_FLAGS} ${GHDL_RFLAGS} $* --wave=$@

clean:
	-rm -rf ${WORKDIR}/*

