#include "systemc.h"
#include "tlm.h"
#include <string>

using namespace std;

using namespace tlm;

struct tr {
  string message;
};

#include "uvmc.h"
using namespace uvmc;
UVMC_UTILS_1(tr, message)


SC_MODULE(refmod) {
  sc_port<tlm_get_peek_if<tr> > in;
  sc_port<tlm_put_if<tr> > out;

  void p() {
    
    tr tr;
    while(1){
      tr = in->get();
      cout <<"refmod: " <<tr.message <<"\n";
      out->put(tr);
    }
  }
  SC_CTOR(refmod): in("in"), out("out") { SC_THREAD(p); }
};


