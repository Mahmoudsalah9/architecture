import re


def process_line(line):
    # Remove everything after #
    string = re.sub(r'#.*', '', line)

    # Split by space, comma, or any whitespace character
    result = re.split(r'[,\s]+', string)
    
    return result

def process_line(line):
    #return [word.replace(',', '') for word in line.strip().split()]
    # Remove everything after #
    string = re.sub(r'#.*', '', line)

    # Split by space or comma
    result = re.split(r'[,\s]+', string)
    
    return result

def hex_to_bin(hexdec):
    # Initialize an empty string to store the binary value
    binary = ""
    # Iterate over each character in the hexadecimal string
    for _hex in hexdec:
        # Convert the hexadecimal character to a decimal value
        dec = int(_hex, 16)
        # Convert the decimal value to binary and remove the '0b' prefix
        # Pad the binary value with zeros if needed to reach 4 bits
        binary += bin(dec)[2:].rjust(4,"0")
    # Pad the binary value with zeros if needed to reach 16 bits
    return binary.zfill(16)

def int_to_bin(integer):
    return bin(integer)[2:].zfill(16)


def extract_part(input_string):
     number=input_string.split('(')[0]
     inside_bracket=input_string[input_string.find('(')+1:input_string.find(')')]
     return number,inside_bracket




def line_to_command(line, counter):
    
    opcode = '00000'
    dest = '000'
    src1 = '000'
    src2 = '000'
    imm_Value = '0000000000000000'
    uselessbits = '00' # total size will be 32 + 5 for '_'
       
    opcode_dict = {
    'NOP': '00000',
    'NOT': '00001',
    'NEG': '00010',
    'INC': '00011',
    'DEC': '00100',
    'OUT': '00101',
    'IN': '00110',
    'MOV': '00111',
    'SWAP': '01000',
    'ADD': '01001',
    'SUB': '01010',
    'AND': '01011',
    'OR': '01100',
    'XOR': '01101',
    'CMP': '01110',
    'ADDI': '01111',
    'SUBI': '10000',
    'LDM': '10001',
    'PUSH': '10010',
    'POP': '10011',
    'LDD': '10100',
    'STD': '10101',
    'PROTECT': '10110',
    'FREE': '10111',
    'JZ': '11000',
    'JMP': '11001',
    'CALL': '11010',
    'RET': '11011',
    'RTI': '11100'
                    }
    
    register_dict = {   'R0' : '000',
                        'R1' : '001',
                        'R2' : '010',
                        'R3' : '011',
                        'R4' : '100',
                        'R5' : '101',
                        'R6' : '110',
                        'R7' : '111'
                    }
    
    #out, push have OPCODE AND src1 only 
    if line[0] == 'OUT' or line[0] == 'PUSH' or line[0] == 'POP': 
        opcode = opcode_dict[line[0]] 
        dest = register_dict[line[1]] #there might be error here 
        src1 = register_dict[line[1]] #there might be error here 
    
            
    #CMP has OPCODE SRC1 AND SRC2 
    elif line[0] == 'CMP': 
        opcode = opcode_dict[line[0]] 
        src1 = register_dict[line[1]]
        src2 = register_dict[line[2]]
        
    elif line[0] == 'PROTECT'or line[0] == 'FREE': 
        opcode = opcode_dict[line[0]] 
        src1 = register_dict[line[1]]
      
        
    
       
        
    #ldm has OPCODE AND dest and immediate only 
    elif line[0] == 'LDM': 
        opcode = opcode_dict[line[0]] 
        dest = register_dict[line[1]]
        imm_Value = hex_to_bin(line[2])
     
    #this needs to be implemented correctly    
    #ldd has OPCODE AND dest and immediate only 
    elif line[0] == 'LDD': 
        opcode = opcode_dict[line[0]] 
        dest = register_dict[line[1]]
        number,inside_bracket = extract_part(line[2])
        imm_Value  =  hex_to_bin(number)
        src1= register_dict[inside_bracket]
    
          
    #SWAP has OPCODE SRC1 AND SRC2 AND DEST
    elif line[0] == 'SWAP': 
        opcode = opcode_dict[line[0]] 
        dest = register_dict[line[1]]
        src1 = register_dict[line[1]]
        src2 = register_dict[line[2]]
        
        
       
   
        
    #ldm has OPCODE AND dest and src1 and immediate only 
    elif line[0] == 'ADDI'or line[0] == 'SUBI': 
        opcode = opcode_dict[line[0]] 
        dest = register_dict[line[1]]
        src1 = register_dict[line[2]]
        imm_Value = hex_to_bin(line[3])
        
    #RTI AND RET AND NOP AND SETC AND CLRC HAVE OPCODE ONLY
    elif line[0] == 'RTI' or line[0] == 'RET' or line[0] == 'NOP':
        opcode = opcode_dict[line[0]]
        
    #STD HAS OPCODE AND SRC1 AND SRC2 ONLY
    #same as ldd needs checking
    elif line[0] == 'STD':
        opcode = opcode_dict[line[0]]
        src2 = register_dict[line[1]]
        number,inside_bracket = extract_part(line[2])
        imm_Value  =  hex_to_bin(number)
        src1= register_dict[inside_bracket]
        
        
    #IN 
    elif line[0] == 'IN' :
        opcode = opcode_dict[line[0]]
        dest = register_dict[line[1]]
        
   #JZ 
    elif line[0] == 'JZ'or line[0] == 'JMP'or line[0] == 'CALL' :
        opcode = opcode_dict[line[0]]
        src1 = register_dict[line[1]]      
        
       
    #NOT AND DEC AND MOV AND LDD HAVE OPCODE AND DEST AND SRC1 ONLY
    elif line[0] == 'NOT'or line[0] == 'NEG' or line[0] == 'DEC' or line[0] == 'INC' or line[0] == 'MOV' :
        opcode = opcode_dict[line[0]]
        dest = register_dict[line[1]]
        try: 
            src1 = register_dict[line[2]]
        except: src1 = register_dict[line[1]]
    
    #ADD AND SUB AND AND AND OR HAVE OPCODE AND DEST AND SRC1 AND SRC2 ONLY
    elif line[0] == 'ADD' or line[0] == 'SUB' or line[0] == 'AND' or line[0] == 'OR' or line[0] == 'XOR':
        opcode = opcode_dict[line[0]]
        dest = register_dict[line[1]]
        src1 = register_dict[line[2]]
        src2 = register_dict[line[3]]
      
    else:
        print('instruction transalation error', counter, opcode, src1, src2,dest, imm_Value)
        for x in line:
            print(x)
        
    return  opcode + src1 + src2+ dest + uselessbits +imm_Value
    
    
def work(inputfile, outputfile):
    instruction_write_dict = {}
    
    with open(inputfile) as f, open(outputfile, 'w') as out:
        # out.write('// memory data file (do not edit the following line - required for mem load use)\n')
        # out.write('// instance=/instruction_memory/ram\n')
        # out.write('// format=mti addressradix=h dataradix=s version=1.0 wordsperline=1\n')
        
        counter = 0
        for line in f:
            
            if len(line.strip()) == 0 or line.strip()[0] == '#': continue
            
            result = process_line(line)
            #print('result', result)
            
            if  len(result)<2 and( result[0].isdigit() or all(c in '0123456789abcdefABCDEF' for c in result[0]) ):
                instruction_write_dict[counter] =  '11010' + '000' + '000' + '000' + '00'
                #for Reset opcode is 11010
                counter +=1
                
            elif result[0].lower() == '.org': 
                counter = int(result[1], 16)

            elif result[0]=='ADDI' or result[0]=='SUBI' or result[0]=='STD' or result[0]=='LDD' or result[0]=='LDM'  : 
                result = line_to_command(result, hex(counter)[2:])
                instruction_write_dict[counter] = result[:16]
                counter +=1
                instruction_write_dict[counter] = result[16:32]
                counter +=1
                
            else:    
                result = line_to_command(result, hex(counter)[2:])
                instruction_write_dict[counter] = result[:16]
                counter +=1
                
        
        # print('dict printing')
        # for key,val in instruction_write_dict.items():
        #     print( key,val)
                
        for x in range(2**16):
            if x in instruction_write_dict.keys():
                out.write(''.join(instruction_write_dict[x]) + '\n')
            else: 
                result = process_line('NOP')
                result = line_to_command(result, hex(x)[2:])
                out.write(''.join(result[:16]) + '\n')
                
                    

            
if __name__ == '__main__':
    work('input.txt', 
         'output.txt')
    print('done')
    

