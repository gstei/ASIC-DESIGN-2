proc compile {top} {
    global script_path
    global PartDev
    global VivDir
    global OutputDir
    source [ file join [pwd] [ file dirname [file normalize [ info script ] ] ] ]/functions.tcl
    setupFolders $top
    #set topTB as top file.
    set_property top tb_controller [get_filesets simset]
    #set simulation time to 1ms
    set_property -name {xsim.simulate.runtime} -value {5ms} -objects [current_fileset -simset]
    #set waveform config file
    add_files -fileset simset -norecurse [findFiles $script_path/simvectors/waves "tb_controller.wcfg"]
    puts "INFO: Start simulation"
    update_compile_order -fileset [current_fileset -simset]
    set_property target_simulator "XSim" [current_project]
    launch_simulation -mode "behavioral" -simset [get_filesets simset]
}

#Call the compile function and generate the bit file
variable script_path
variable PartDev
variable VivDir
variable OutputDir
compile controller