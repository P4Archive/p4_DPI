/* Action */
#define MAX_PORTS 254
#define CPU_PORT 255
#define DROP_PORT 511

action set_egress_port(port) {
    modify_field(standard_metadata.egress_spec, port);
}

action send_to_cpu() {
    modify_field(standard_metadata.egress_spec, CPU_PORT);
}

field_list rule_info {
    learning_metadata._type;
    five_tuple_metadata.srcAddr;
    five_tuple_metadata.dstAddr;
    five_tuple_metadata.srcPort;
    five_tuple_metadata.dstPort;
    label_metadata.label;
    label_metadata.sub_label;
}

action do_set_label_by_guess(label) {
    modify_field(label_metadata.label, label);
    modify_field(label_metadata.label_result, 2); // by guess

    //modify_field(learning_metadata._type, 1);

    //modify_field(standard_metadata.egress_spec, 3);
    clone_ingress_pkt_to_egress(200, copy_to_cpu_fields);
}

action do_set_sub_label_by_guess(sublabel) {
    modify_field(label_metadata.sub_label, sublabel);
    modify_field(label_metadata.sub_label_result, 2); // by guess

    //modify_field(learning_metadata._type, 1);

    //modify_field(standard_metadata.egress_spec, 3);
    clone_ingress_pkt_to_egress(200, copy_to_cpu_fields);
}

action do_set_label_by_detect(label, sublabel) {
    
    modify_field(label_metadata.label, label);
    modify_field(label_metadata.sub_label, sublabel);
    modify_field(label_metadata.label_result, 1); // by detect
    modify_field(label_metadata.sub_label_result, 1); // by detect

    modify_field(learning_metadata._type, 1);
    
    //modify_field(standard_metadata.egress_spec, 3);
    clone_ingress_pkt_to_egress(200, copy_to_cpu_fields);
    //drop();
}

action do_set_label_by_match_rule(label, sublabel) {
    modify_field(label_metadata.label, label);
    modify_field(label_metadata.sub_label, sublabel);
}

action do_label_encap() {
    add_header(label_header);
    modify_field(label_header.label, label_metadata.label );
    modify_field(label_header.sub_label, label_metadata.sub_label );
    modify_field(label_header.label_result, label_metadata.label_result );
    modify_field(label_header.sub_label_result, label_metadata.sub_label_result );
}

action _drop() {
    drop();
}

action _nop() {
    no_op();
}

/*
action do_assemble(){
    modify_field(label_metadata.label, 2);
    //pattern_match(label_metadata.sub_label, one_byte_payload);
    modify_field(label_metadata.label_result, 1); // by detect
    modify_field(label_metadata.sub_label_result, 1); // by detect
    
    modify_field(standard_metadata.egress_spec, 2);

    modify_field(learning_metadata._type, 1);
    
    //clone_ingress_pkt_to_egress(200, copy_to_cpu_fields);
    //drop();
}
*/

action do_set_priority(priority) {
    modify_field(intrinsic_metadata.priority, priority);
}

field_list copy_to_cpu_fields {
    standard_metadata;
    label_metadata;
}

action do_learning() {
    generate_digest( 1, rule_info );
    //clone_ingress_pkt_to_egress( 2, copy_to_cpu_fields );
}
