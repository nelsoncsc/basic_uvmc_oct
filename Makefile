ifeq ("$(UVMC_HOME)","")
$(error ERROR: UVMC_HOME environment variable is not defined)
endif

# definitions only needed for OSCI:
SYSTEMC_HOME=/opt/rede/systemc-2.3.0
SYSC_COPTS=-I$(SYSTEMC_HOME)/include 
SYSC_LOPTS=-L$(SYSTEMC_HOME)/lib-linux64 -Wl,-rpath -Wl,$(SYSTEMC_HOME)/lib-linux64 -lsystemc

# definitions needed for OpenCV:
CV_COPTS=`pkg-config --cflags opencv`
CV_LOPTS=`pkg-config --libs opencv`

# definitions only needed for Octave:
OCT_COPTS=$(shell mkoctfile -p INCFLAGS) -I/usr/include/freetype2
OCT_LOPTS=-L$(shell mkoctfile -p OCTLIBDIR) $(shell mkoctfile -p OCTAVE_LIBS) $(shell mkoctfile -p BLAS_LIBS) $(shell mkoctfile -p FFTW_LIBS) -lreadline -lm
OCT_OPTS=$(OCT_COPTS) $(OCT_LOPTS)

# definitions only needed for VCS:
VCS_UVMC_SC_OPTS=-tlm2 -cflags "-g -I. -I$(VCS_HOME)/etc/systemc/tlm/include/tlm/tlm_utils -I$(UVMC_HOME)/src/connect/sc" $(UVMC_HOME)/src/connect/sc/uvmc.cpp $(UVM_HOME)/src/dpi/uvm_dpi.cc


VCS_UVMC_SV_OPTS=-q -sverilog -ntb_opts uvm -timescale=1ns/1ps +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR +incdir+$(UVM_HOME)/src+$(UVM_HOME)/src/vcs+$(UVMC_HOME)/src/connect/sv +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR $(UVM_HOME)/src/uvm_pkg.sv $(UVM_HOME)/src/vcs/*.sv $(UVMC_HOME)/src/connect/sv/uvmc_pkg.sv

VCS_UVMC_OPTS=-q -sysc=deltasync -lca -sysc -debug_pp -timescale=1ns/1ps uvm_custom_install_recording sc_main $(TOP) 

VCS_SIMV= +UVM_NO_RELNOTES +UVM_TR_RECORD +UVM_TESTNAME=$(TEST)

# definitions for files
TOP = top
REFMOD = top
TEST= test
GCC ?= g++

	
vcs:
	g++ -c $(CV_COPTS) external.cpp
	syscan $(VCS_UVMC_SC_OPTS) -cflags "$(OCT_COPTS) -DREFMOD_OCTAVE" $(REFMOD).cpp 
	vlogan $(VCS_UVMC_SV_OPTS) $(TOP).sv
	vcs    $(VCS_UVMC_OPTS) $(CV_LOPTS) $(TOP) $(CV_LOPTS) $(OCT_LOPTS) external.o
	./simv $(VCS_SIMV) +UVM_VERBOSITY=MEDIUM

clean:
	rm -rf a.out *.o # simulation output file
	rm -rf INCA_libs irun.log ncsc.log # ius
	rm -rf work certe_dump.xml transcript .mgc_simple_ref .mgc_ref_nobuff .mgc_ref_oct # mgc
	rm -rf csrc simv simv.daidir ucli.key .vlogansetup.args .vlogansetup.env .vcs_lib_lock simv.vdb AN.DB vc_hdrs.h *.diag *.vpd *tar.gz # vcs

# Wave form
view_waves:
	dve -vpd vcdplus.vpd &
