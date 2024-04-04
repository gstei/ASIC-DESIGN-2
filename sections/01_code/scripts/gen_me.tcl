proc compile (top) {
    global script_path
    global PartDev
    global VivDir
    global OutputDir
    source [ file join [pwd][ file dirname[file normalize [ info script ] ] ] ]/General_functions.tcl
    setupFolders $top
    
    
    puts "Synthestizing design..."
    synth_design -top $top -flatten-hierarchy full
    write_checkpoint -force $script_path/$outputDir/_synthesized
    puts "optimizing design..."
    opt_design
    write_checkpoint -force $script_path/$outputDir/_optimized
    puts "placing design..."
    place_design
    write_checkpoint -force $script_path/$outputDir/_placed
    puts "Routing design..."
    route_design
    write_checkpoint -force $script_path/$outputDir/_routed
    # Generate Reports
    report_timing_summary -file $script_path/$outputDir/post_route_timing_summary.rpt
    puts "Eenerating .bit file"
    write_bitstream -file $script_path/$outputDir/design.bit
    }

#Call the compile function and generate the bit file
variable script path
variable PartDev
variable VivDir
variable OutputDir
compile fpga_OpalKelly_top
