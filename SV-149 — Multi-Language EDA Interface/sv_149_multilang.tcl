puts "========================================"
puts "SV-149 MULTI-LANGUAGE EDA DEMONSTRATION"
puts "========================================"

puts "\n\[TCL\] Tcl execution started"

puts "\n\[TCL\] Running Python..."
puts [exec python sv_149_multilang.py]

puts "\n\[TCL\] Running Perl..."
puts [exec perl sv_149_multilang.pl]

puts "\n\[TCL\] Compiling C DPI code..."
exec xsc sv_149_multilang.c 2>@1

puts "\n\[TCL\] Compiling SystemVerilog..."
exec xvlog -sv sv_149_multilang_tb.sv

puts "\n\[TCL\] Elaborating and linking DPI library..."
exec xelab sv_149_multilang_tb -sv_lib dpi

puts "\n\[TCL\] Running SystemVerilog simulation..."
puts [exec xsim sv_149_multilang_tb -runall]

puts "\n========================================"
puts "ALL LANGUAGE TESTS COMPLETED"
puts "========================================"