#include <octave/oct.h>
#include <octave/octave.h>
#include <octave/parse.h>
#include <octave/toplev.h>

SC_MODULE(refmod_oct) {
  sc_port<tlm_get_peek_if<tr> > in;
  sc_port<tlm_put_if<tr> > out;

  void p() {
    string_vector oct_argv (2);
    oct_argv(0) = "embedded";
    oct_argv(1) = "-q";
    octave_function *oct_fcn;
    octave_value_list oct_in, oct_out;
    oct_fcn = load_fcn_from_file("reffunc.m");
    if(oct_fcn) cout << "Info: SystemC: Octave function loaded." << endl;
    else sc_stop();
   
    tr tr;
    while(1){
      tr = in->get();
      octave_idx_type i = 0;
      oct_in(i) = octave_value (tr.message);
      oct_out = feval(oct_fcn, oct_in);
      tr.message = oct_out(0).string_value ();
      cout <<"refmod_oct: " <<tr.message <<"\n";
      out->put(tr);
    }
  }
  SC_CTOR(refmod_oct): in("in"), out("out") { SC_THREAD(p); }
};


