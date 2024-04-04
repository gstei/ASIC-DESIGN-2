proc findFiles { dir pattern } {
set dir [string trimright [file join [file normalize $dir] { }]]
set fileList {}
array set myArray {}

    foreach fileName [glob -nocomplain -type {f r} -path $dir $pattern] {
        lappend fileList $fileName
    }

    foreach dirName [glob -nocomplain -type {d r} -path $dir *] {
        set subDirList [findFiles $dirName $pattern]
        if { [llength $subDirList] > 0 } {
            foreach subDirFile $subDirList {
                lappend fileList $subDirFile
            }
        }
    }
    return $fileList
}
proc touch filename {
    close [open $filename a]
};
proc setupFolders {top} {
global script_path
global PartDev
global VivDir
global OutputDir

puts "Clsoing any designs that are currently open..."
puts ""
close_project -quiet
puts "Continuing..."
set script_path [ file join [pwd] [ file dirname [file normalize [info script ] ] ] ]
set script_path [ file dirname [ file normalize $script_path ] ]
set script_path $script_path/controller
set PartDev "xc7s50csga324-1"
set VivDir vivado
set OutputDir output
puts "Stage 2: Setup folder Structure"
file delete -force -- $script_path/$VivDir
file delete -force -- $script_path/$OutputDir

file mkdir $script_path/$VivDir
file mkdir $script_path/$OutputDir

puts "Stage 3: Create project"
create_project -force $top $VivDir -part $PartDev
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]
set_property default_lib work [current_project]

create_fileset -simset simset

current_fileset -simset [ get_filesets simset ]
delete_fileset [get_filesets sim_1]
file delete -force $script_path/$VivDir/$top.sim/sim_1

set sourcesVHD [findFiles $script_path/sources "*.vhd"]
set simulationVHD [findFiles $script_path/simulation "*.vhd"]
set sourcesVer [findFiles $script_path/sources "*.v"]
set constraintsXDC [findFiles $script_path/constraints "*.xdc"]
set SrcXCI [findFiles $script_path/ip "*.xci"]

if {[llength $SrcXCI]} {
    add_files -norecurse $SrcXCI
}
export_ip_user_files -of_objects [get_files $SrcXCI] -force -quiet
if {[llength $sourcesVHD]} {
    add_files $sourcesVHD
}
if {[llength $sourcesVer]} {
    add_files $sourcesVer
}
if {[llength $simulationVHD]} {
    add_files -fileset simset $simulationVHD
}
if {[llength $constraintsXDC]} {
    add_files -fileset constrs_1 -noresource $constraintsXDC
}

}