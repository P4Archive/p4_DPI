control process_libprotoident {
    // update data
    apply(calculate_index);
    apply(read_counter);
    if( five_tuple_metadata.srcPort < five_tuple_metadata.dstPort ) {
        if( direction_metadata.counter_A == 0 ){ apply(updateA_1); }
        elif( direction_metadata.counter_A == 1 ){ apply(updateA_2); }
        else{ apply(updateA_3); }
    }
    else {
        if( direction_metadata.counter_B == 0 ){ apply(updateB_1); }
        elif( direction_metadata.counter_B == 1 ){ apply(updateB_2); }
        else{ apply(updateB_3); }
    }
    apply(update_all);

    // Start to detect
    if( direction_metadata.counter_A == 1 and direction_metadata.counter_B > 0 ) { apply(detect_A_two_direction); }
    else if( direction_metadata.counter_B == 1 and direction_metadata.counter_A > 0 ) { apply(detect_B_two_direction); }
    else if( direction_metadata.counter_A == 3 ){ apply(detect_A_one_direction); }
    else if( direction_metadata.counter_B == 3 ){ apply(detect_B_one_direction); }
}
