SC_MODULE(refmod_low){
  sc_port<tlm_get_peek_if<tr> > in;
  sc_port<tlm_put_if<tr> > out;

  void p() {
    
    tr tr;
    while(1){
      tr = in->get();
      cout <<"refmod_low: " <<tr.message <<"\n";
      out->put(tr);
    }
  }
  SC_CTOR(refmod_low): in("in"), out("out") { SC_THREAD(p); }
};


