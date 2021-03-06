/*
   Forward and Mirror
 */

/* Table */

table table0 {
    reads {
        standard_metadata.ingress_port : ternary;
        ethernet_header.dstAddr : ternary;
        ethernet_header.srcAddr : ternary;
        ethernet_header.etherType : ternary;
    }
    actions {
        set_egress_port;
        send_to_cpu;
        _drop;
    }
    support_timeout: true;
}

table forward {
    reads {
        ethernet_header.dstAddr: exact;
    }

    actions { 
        do_forward;
        _nop;
    }
}

table label_encup {
    reads { 
        standard_metadata.instance_type : exact ;
        //learning_metadata._type : exact ;
    }
    actions { 
        _drop; 
        do_label_encap; 
    }
    size : 16;
}

table set_queue {
    reads {
        label_metadata.sub_label : exact ;
        //ethernet_header.srcAddr : exact ;
    }

    actions {
        do_set_priority ;
    }
} 

table rule_match {
    reads {
        five_tuple_metadata.srcAddr: exact;
        five_tuple_metadata.dstAddr: exact;
        five_tuple_metadata.srcPort: exact;
        five_tuple_metadata.dstPort: exact;
    }

    actions {
        do_set_label_by_match_rule;
    }
}

table detect_four_byte_payload {
    reads {
        four_byte_payload.data : ternary ;
        intrinsic_metadata.payload_len : ternary ;
    }

    actions {
        do_set_label_by_detect ;
    }

}

table detect_dns {
    actions {
        do_assemble ;
    }
}

table detect_ssl {
    actions {
        do_detect_ssl;
    }
}

table detect_quic {
    reads {
        quic_flags.reset : exact;
        quic_flags.reserved: exact ;
    }
    actions {
        _nop ;
    }
}

table set_quic {
    actions {
        do_set_label_by_detect ;
    }
}

table detect_whatsapp {
    reads {
        whatsapp_three_byte_payload.payload_1 : ternary;
        whatsapp_three_byte_payload.payload_2 : ternary;
        whatsapp_three_byte_payload.payload_3 : exact;
    }

    actions { 
        do_set_label_by_detect ;
    }
}

table guess_by_tcp_port {
    reads {
        tcp_header.srcPort : ternary;
        tcp_header.dstPort : ternary;
    }

    actions {
        do_set_label_by_guess ;
    }
}

table guess_by_udp_port {
    reads {
        udp_header.srcPort : ternary;
        udp_header.dstPort : ternary;
    }

    actions {
        do_set_label_by_guess ;
    }
}

table guess_by_src_address {
    reads {
        ipv4_header.srcAddr: lpm;
    }

    actions {
        do_set_sub_label_by_guess ;
    }
}

table guess_by_dst_address {
    reads {
        ipv4_header.dstAddr: lpm;
    }

    actions {
        do_set_sub_label_by_guess ;
    }
}

table learning {
    reads {
        learning_metadata._type : range ;
    }

    actions {
        do_learning ;
    }
}

table calculate_index {
    actions { do_calculate_index; }
    size: 1;
}

table read_counter {
    actions { do_read_counter; }
    size: 1;
}

table update_A {
    actions { do_updateA; }
    size: 1;
}

table update_counter_A {
    reads { 
        direction_metadata.counter_A : exact;
    }
    actions {
        do_update_counter_A;
    }

    size: 2;
}

table update_B {
    actions { do_updateB; }
    size: 1;
}

table update_counter_B {
    reads { 
        direction_metadata.counter_B : exact;
    }
    actions {
        do_update_counter_B;
    }

    size: 2;
}

table read_all {
    actions { do_read_all; }
    size: 1;
}

table detect_two_direction {
    reads {
        direction_metadata.payload_A : ternary;
        direction_metadata.length_A : ternary;
        direction_metadata.payload_B : ternary;
        direction_metadata.length_B : ternary;
        five_tuple_metadata.srcPort : ternary;
        five_tuple_metadata.dstPort : ternary;
    }

    actions { do_set_label_by_detect; }
}

table detect_one_direction {
    reads {
        direction_metadata._payload : ternary;
        direction_metadata._length : ternary;
        five_tuple_metadata.srcPort : ternary;
        five_tuple_metadata.dstPort : ternary;
    }

    actions { do_set_label_by_detect; }
}

table copy_A_fields {
    actions { do_copy_A_fields; }
    size : 1;
}

table copy_B_fields {
    actions { do_copy_B_fields; }
    size : 1;
}

table reset_direction{
    actions { do_reset_direction; }
    size : 1;
}

table threshold{
    reads {
        label_metadata.label : exact;
        label_metadata.sub_label : exact ;
    }
    actions { do_set_unknown; do_set_label_when_threshold; }
}
