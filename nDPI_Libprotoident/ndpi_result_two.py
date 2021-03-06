
from subprocess import call
from os import devnull
import os
import warnings
import json
import sys
import csv

# Convert ndpi json output to a [flow: app] dictionary
def json2dict(appjson, fo_writer):
    table = {}
    for flow in appjson['known.flows']:
        label = str(flow['detected.protocol.name'])
        src_ip = str(flow['host_a.name'])
        dst_ip = str(flow['host_b.name'])
        print("%s" % src_ip )
        if src_ip.find(':') > 0 :
            print("exchange")
            src_port = str(flow['host_b.port'])
            dst_port = str(flow['host_a.port'])
        else :
            src_port = str(flow['host_a.port'])
            dst_port = str(flow['host_b.port']) 

        src = "%s:%s" % ( src_ip, src_port )
        dst = "%s:%s" % ( dst_ip, dst_port )
        protocol = str(flow['protocol'])
        key = frozenset({src, dst, protocol})
        table.update({key:label})
        print key, label
        dict2csv( fo_writer, src, dst, protocol, label)


    '''    
    for flow in appjson['unknown.flows']:
        if flow['protocol'] != 'TCP': continue

        name = mpkt.FiveTuple(flow['host_a.name'], flow['host_b.name'],
            flow['host_a.port'], flow['host_n.port'], 'TCP').toString()

        if name in dict:
            warnings.warn(name.toString()+' has appeared twice.')
            # if name appeared twice, then we cannot distinguish those flows

        dict[name] = flow['detected.protocol.name']
    '''
    return dict

def dict2csv( fo_writer, src, dst, protocol, label ):
    result = []
    result.append(src)
    result.append(dst)
    result.append(protocol)
    result.append(label)
    fo_writer.writerow(result)

def main():
    # Check for arguments
    if len(sys.argv) == 3:
        file_in_tcp = sys.argv[1]
        file_in_udp = sys.argv[2]
        file_out = 'essence.csv'
    elif len(sys.argv) == 4:
        file_in_tcp = sys.argv[1]
        file_in_udp = sys.argv[2]
        file_out = sys.argv[3]
    else:
        print "Usage: ", sys.argv[0], "[input_tcp.json]", "[input_udp.json]", "[output.csv]"
        return

    # Open files for input and output
    try:
        FNULL = open(devnull, 'w')   # File of nowhere
        fi_tcp = open(file_in_tcp, 'r')
        fi_udp = open(file_in_udp, 'r')
        fo = open(file_out, 'w')
        fo_writer = csv.writer(fo)
    except IOError as (errno, strerror):
        print "I/O error({0}): {1}".format(errno, strerror)
        return

    json2dict(json.load(fi_tcp, encoding='latin-1'), fo_writer)
    json2dict(json.load(fi_udp, encoding='latin-1'), fo_writer)


    fi_tcp.close()
    fi_udp.close()
    fo.close()


if __name__ == "__main__":
    main()
