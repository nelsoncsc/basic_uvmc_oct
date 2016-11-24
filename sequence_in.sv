import "DPI-C" context function string read_message(string msg);

class sequence_in extends uvm_sequence #(packet_in);
    `uvm_object_utils(sequence_in)

    function new(string name="sequence_in");
        super.new(name);
    endfunction: new
    
    int data_file, scan_file;
    string filename;
    
    function void open_file();
      data_file = $fopen("myfile.txt", "r");
      if(data_file == 0)begin
         $display("file could not be open!!!");
      end
     endfunction: open_file
  
    task body();
        packet_in tr;
        open_file();
        while(1)begin
            scan_file = $fscanf(data_file, "%s", filename);
            tr = packet_in::type_id::create("tr");
            start_item(tr);
            tr.message = read_message(filename);
            finish_item(tr);
            if($feof(data_file))
                break;
        end
        $finish();
    endtask: body
endclass: sequence_in

