#!/usr/bin/python2.7

from logic import *
import re

ASM_FILE = "t.asm"
OUT_FILE = "t.bin"

opcodes_d = {
        "NOP"   : {
                   "opbin" : logic( int( "0000", 2 ) ),
                   "type"   : "NOP"
                  },

        "ADD"   : {
                   "opbin" : logic( int( "0001", 2 ) ),
                   "type"   : "RRR"
                  },
        
        "SUB"   : {
                   "opbin" : logic( int( "0010", 2 ) ),
                   "type"   : "RRR"
                  },

        "AND"   : {
                   "opbin" : logic( int( "0011", 2 ) ),
                   "type"   : "RRR"
                  },

        "OR"    : {
                   "opbin" : logic( int( "0100", 2 ) ),
                   "type"   : "RRR"
                  },
        "XOR"   : {
                   "opbin" : logic( int( "0101", 2 ) ),
                   "type"   : "RRR"
                  },

        "ADDI"  : {
                   "opbin" : logic( int( "1001", 2 ) ),
                   "type"   : "RRI"
                  },

        "LW"    : {
                   "opbin" : logic( int( "1010", 2 ) ),
                   "type"   : "RRI"
                  },
        "SW"    : {
                   "opbin" : logic( int( "1011", 2 ) ),
                   "type"   : "RRI"
                  },
    }

def print_opcode( opcode_str, opcode_d ):
  print "%5s: %4x: %3s" % ( opcode_str, opcode_d["opbin"], opcode_d["type"] )

def print_opcodes( ):
  for i in opcodes_d:
    print_opcode( i, opcodes_d[i] )

def find_opcode( possible_opcode ):
  for i in opcodes_d:
    if possible_opcode == i:
      return opcodes_d[i]
  return None

def regstr_to_int( _str ):
  p = re.compile("R[0-7]$")

  if p.match(_str):
    return int( _str[1] )

  return None

def rrr_parser( sp_line, opcode_d ):

  if len( sp_line ) > 3:
    instr = logic(0)
    r     = [0, 0, 0]
    for i in xrange( 1, 4 ):
      r_ = regstr_to_int( sp_line[i] )
      if r_:
        r[ i - 1 ] = r_
      else:
        return "Wrong reg name"

    instr[15:12] = int( opcode_d["opbin"] )
    instr[11:9]  = r[0]
    instr[8:6]   = r[1]
    instr[2:0]   = r[2]
    return instr
  else:
    return "Too short"

def rrr_parser( sp_line, opcode_d ):

  if len( sp_line ) > 3:
    instr = logic(0)
    r     = [0, 0, 0]
    for i in xrange( 1, 4 ):
      r_ = regstr_to_int( sp_line[i] )
      if r_:
        r[ i - 1 ] = r_
      else:
        return "Wrong reg name"

    instr[15:12] = int( opcode_d["opbin"] )
    instr[11:9]  = r[0]
    instr[8:6]   = r[1]
    instr[2:0]   = r[2]
    return instr
  else:
    return "Too short"

def rri_parser( sp_line, opcode_d ):

  if len( sp_line ) > 3:
    instr = logic(0)
    r     = [0, 0]
    for i in xrange( 1, 3 ):
      r_ = regstr_to_int( sp_line[i] )
      if r_:
        r[ i - 1 ] = r_
      else:
        return "Wrong reg name"
    
    #TODO: check imm values
    imm          = int( sp_line[3] )

    instr[15:12] = int( opcode_d["opbin"] )
    instr[11:9]  = r[0]
    instr[8:6]   = r[1]
    instr[5:0]   = imm
    return instr
  else:
    return "Too short"

def instr_l_to_file( fname, instr_l ):
  f = open( fname, "w" )
  for i in instr_l:
    wstr =  "{:016b}".format( int( i ) )
    print wstr
    f.write("%s\n" % wstr )

def asm_parser( fname ):
  f = open( fname ) 
  lines_raw = f.readlines();
  f.close();
  
  line_num = 0

  instr_l  = []
  for s in lines_raw:
    line_num += 1
    tmp = s.strip().split()
    #print tmp

    opcode = find_opcode( tmp[0] )
    if opcode:
      print tmp
      instr = None
      if opcode["type"] == "RRR":
        instr = rrr_parser( tmp, opcode )
      elif opcode["type"] == "RRI":
        instr = rri_parser( tmp, opcode )

      if ( type( instr ) == str ):
        parse_msg( instr, s, line_num )
      else:
        #print "%s" % bin( int( instr ) )
        instr_l.append( instr )
    else:
      parse_msg("Unknown opcode", s, line_num )

  return instr_l



def parse_msg( msg, line, line_num ):
  # -1 for deleting \n at the end
  print "Error at line %2d: \"%s\": %s" %( line_num, line[:-1], msg )

if __name__ == "__main__":
  print_opcodes( )
  instr_l = asm_parser( ASM_FILE )
  instr_l_to_file( OUT_FILE, instr_l )
