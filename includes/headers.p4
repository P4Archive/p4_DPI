/*
Forward and Mirror
*/

/* Metedata Type */
header_type intrinsic_metadata_t {
    fields {
        ingress_global_timestamp : 32;
        lf_field_list : 32;
        mcast_grp : 16;
        egress_rid : 16;
	    priority : 8;
        payload_len : 16;
        //dns_payload_len : 16;
        // Info I need
        version_len : 8;
        cid_len : 8;
        seq_len : 8;
        quic_header_len : 8;
        tcp_hdr_len : 8;
        ssl_host_name : 16;
    }
}

header_type five_tuple_metadata_t {
    fields {
        srcAddr: 128;
        dstAddr: 128;
        srcPort: 16;
        dstPort: 16;
        protocol: 8;
    }
}
 
header_type label_metadata_t {
    fields {
        label : 8 ;
        sub_label : 8 ;       
        label_result : 8 ;
        sub_label_result : 8 ;
    }
}

header_type learning_metadata_t {
    fields {
        _type: 8;
    }
}

header_type direction_metadata_t {
    fields {
        hash_index : 16;

        _payload : 32;
        _length: 16 ;

        payload_A : 32;
        payload_B : 32;

        length_A : 16;
        length_B : 16;

        counter_A : 16;
        counter_B : 16;
    }
}

/*
header_type dns_metadata_t {
    fields {
        data : 256 ;
        _length: 16;
    }
}
*/

/* Metedata */
metadata intrinsic_metadata_t intrinsic_metadata;
metadata five_tuple_metadata_t five_tuple_metadata;
metadata label_metadata_t label_metadata;
//metadata dns_metadata_t dns_metadata;
metadata learning_metadata_t learning_metadata;
metadata direction_metadata_t direction_metadata;

/* Header_type */
header_type ethernet_header_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

header_type ipv4_header_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}

header_type ipv6_header_t {
    fields {
        version : 4;
        trafficClass : 8;
        flowLabel : 20;
        payloadLen : 16;
        nextHdr : 8;
        hopLimit : 8;
        srcAddr : 128;
        dstAddr : 128;
    }
}

header_type tcp_header_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        seqNo : 32;
        ackNo : 32;
        dataOffset : 4;
        res : 3;
        ecn : 3;
        ctrl : 6;
        window : 16;
        checksum : 16;
        urgentPtr : 16;
        options: *;
    }

    length : 4 * dataOffset ;
    max_length : 512;
}

header_type udp_header_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        length_ : 16;
        checksum : 16;
    }
}

header_type dns_header_t {
   fields {
        tr_id : 16;
        flags : 16;
        num_queries : 16;
        num_answers : 16;
        authority_rrs : 16;
        additional_rrs : 16;
   }
}

header_type label_header_t {
    fields {
        label: 8;
        sub_label: 8;
        label_result : 8;
        sub_label_result : 8;
    }
}

header_type four_byte_payload_t {
    fields {
        data : 32 ; 
    }
}

/*
header_type dns_payload_t {
    fields {
        data : * ; 
    }
    length : intrinsic_metadata.dns_payload_len ;
    max_length : 48;
}
*/

header_type one_byte_payload_t {
    fields {
        data : 8;
    }
}

header_type whatsapp_three_byte_payload_t {
    fields {
        payload_1 : 8;
        payload_2 : 8;
        payload_3 : 8; 
    }
}

header_type quic_flags_t {
    fields {
        version : 1;
        reset : 1;
        cid_len : 2;
        seq_len : 2;
        reserved : 2; 
    }
}

header_type tls_records_header_t {
    fields {
        _type : 8;
        version : 16;
        _length : 16;
    }
}

header_type handshake_protocol_t {
    fields {
        _type : 8;
        _length : 24;
    }
}

header_type client_hello_t {
    fields {
        version : 16;
        random : 256;
        session_id_length : 8;
        session_id : *;
    }
    length : session_id_length + 35 ;
    max_length : 72;
}

header_type cipher_suites_t {
    fields {
        _length : 16;
        values : * ;
    }
    length : _length + 2 ;
    max_length : 128;
}

header_type compression_methods_t {
    fields {
        _length : 8;
        values : * ;
        extenstions_length : 16;
    }
    length : _length + 3 ;
    max_length : 64;
}

header_type server_extension_t {
    fields {
        _type : 16;
        _length : 16;
    }
}

header_type server_name_indication_t{
    fields {
        list_length : 16;
        _type : 8;
        name_length: 16;
    }
}

header_type other_extension_t {
    fields {
        _type : 16;
        _length: 16;
        values : *;
    }
    length : _length + 4 ;
    max_length : 1024;
}

/* Header */
header ethernet_header_t ethernet_header;
header ipv4_header_t ipv4_header;
header ipv6_header_t ipv6_header;
header tcp_header_t tcp_header;
header udp_header_t udp_header;
header dns_header_t dns_header;
header one_byte_payload_t one_byte_payload[64];
header four_byte_payload_t four_byte_payload;
//header dns_payload_t dns_payload ;
header label_header_t label_header;
header quic_flags_t quic_flags ;
header whatsapp_three_byte_payload_t whatsapp_three_byte_payload ; 
header tls_records_header_t tls_records_header;
header handshake_protocol_t handshake_protocol;
header client_hello_t client_hello;
header cipher_suites_t cipher_suites;
header compression_methods_t compression_methods;
header server_extension_t server_extension;
header server_name_indication_t server_name_indication;
header other_extension_t other_extension[64];
