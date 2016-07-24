tclmode
set current_module [ get_root_module ]

if { [ get_unmap_points -not -count ] > 0 } {
    //file mkdir "$work_dir/reports/un.map"
    //vpx remodel -seq_constant
    //vpx map key points
    //vpx report message -modeling -verbose

    vpx report unmapped points > $work_dir/reports/$current_module.unmapped
    vpx report mapped points   > $work_dir/reports/$current_module.mapped
    vpx report floating signals -all -undriven > $work_dir/reports/$current_module.undrive
    vpx report unmapped points -not -golden > $work_dir/reports/$current_module.notmapped_golden
    vpx report unmapped points -not -revised > $work_dir/reports/$current_module.notmapped_revised
    vpx report unmapped points -extra -type pi -golden
    vpx report unmapped points -extra -type po -golden
}

if { $current_module ne "S3VDV_hevc_desdec_0" } {
    vpx analyze datapath -verbose -threads 10
    vpx usage
}
vpxmode

