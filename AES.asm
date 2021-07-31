;Yousef Ashraf 46-16443
;Mina Romany   46-16867
;Ahmed Mesameh 46-18225
   



org 100h    
.data       
encryptCounter db 0
; counters for the nested loop 
tmpWord db   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0           
RoundString db 'Round : $'
EnterWord db 'E','n','t','e','r',' ','Y','o','u','r',' ','W','o','r','d',':'  
EnterKey db 'E','n','t','e','r',' ','Y','o','u','r',' ','K','e','y',' ',':'  
AsciToHexa db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
Cipher db 'C','I','P','H','E' ,'R',' ',':'
i db 0
j db 0     
;counter for some loop
ii dw 0

 
word db '1','2','3','4','5','6','7','8','9'  ,'1','2','3','4','5','6','7'
key db '1','2','3','4','5','6','7','8','9'  ,'1','2','3','4','5','6','7'



mixField db 0x02,0x03,0x01,0x01,0x01,0x02,0x03,0x01,0x01,0x01,0x02,0x03,0x03,0x01,0x01,0x02

mixColumnsMatrix db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
mixrow db 0x00,0x00,0x00,0x00
col  db 0x00,0x00,0x00,0x00

testarray1  db 0x00,0x00,0x00,0x00
elementOfMixColumn db 0x00
count DW 0x04


c db 0h
Rcon db 01h ,02h,04h,08h,10h,20h,40h,80h,1bh,36h 
RconV db 00h
RKCount db 00h
t db 0h   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
col1 db 0,0,0,0
col2 db 0,0,0,0   
nthColForAProc db 0



tmp db 00h          

;; sbox for AES
	sbox db 0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76
	db 0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0
	db 0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15
	db 0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75
	db 0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84
	db 0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF
	db 0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8
	db 0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2
	db 0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73
	db 0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB
	db 0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79
	db 0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08
	db 0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A
	db 0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E
	db 0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF
	db 0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16



;; Galois field GF(2^8) multiplication tables for mixcolumns

MixCol db 0x0, 0x00, 0x00, 0x1, 0x02, 0x03, 0x2, 0x04, 0x06, 0x3, 0x06, 0x05, 0x4, 0x08, 0x0C, 0x5, 0x0A, 0x0F, 0x6, 0x0C, 0x0A
db 0x7,  0x0E, 0x09, 0x8,  0x10, 0x18, 0x9,  0x12, 0x1B, 0xa,  0x14, 0x1E, 0xb,  0x16, 0x1D, 0xc,  0x18, 0x14, 0xd, 0x1A, 0x17
db 0xe,  0x1C, 0x12, 0xf,  0x1E, 0x11, 0x10, 0x20, 0x30, 0x11, 0x22, 0x33, 0x12, 0x24, 0x36, 0x13, 0x26, 0x35, 0x14
db 0x28, 0x3C, 0x15, 0x2A, 0x3F, 0x16, 0x2C, 0x3A, 0x17, 0x2E, 0x39, 0x18, 0x30, 0x28, 0x19, 0x32, 0x2B, 0x1a, 0x34, 0x2E
db 0x1b, 0x36, 0x2D, 0x1c, 0x38, 0x24, 0x1d, 0x3A, 0x27, 0x1e, 0x3C, 0x22, 0x1f, 0x3E, 0x21, 0x20, 0x40, 0x60, 0x21
db 0x42, 0x63, 0x22, 0x44, 0x66, 0x23, 0x46, 0x65, 0x24, 0x48, 0x6C, 0x25, 0x4A, 0x6F, 0x26, 0x4C, 0x6A, 0x27, 0x4E, 0x69 
db 0x28, 0x50, 0x78, 0x29, 0x52, 0x7B, 0x2a, 0x54, 0x7E, 0x2b, 0x56, 0x7D, 0x2c, 0x58, 0x74, 0x2d, 0x5A, 0x77, 0x2e, 0x5C, 0x72
db 0x2f, 0x5E, 0x71, 0x30, 0x60, 0x50, 0x31, 0x62, 0x53, 0x32, 0x64, 0x56, 0x33, 0x66, 0x55, 0x34, 0x68, 0x5C, 0x35, 0x6A
db 0x5F, 0x36, 0x6C, 0x5A, 0x37, 0x6E, 0x59, 0x38, 0x70, 0x48, 0x39, 0x72, 0x4B, 0x3a, 0x74, 0x4E, 0x3b, 0x76, 0x4D, 0x3c, 0x78
db 0x44, 0x3d, 0x7A, 0x47, 0x3e, 0x7C, 0x42, 0x3f, 0x7E, 0x41, 0x40, 0x80, 0xC0, 0x41, 0x82, 0xC3, 0x42, 0x84, 0xC6, 0x43
db 0x86, 0xC5, 0x44, 0x88, 0xCC, 0x45, 0x8A, 0xCF, 0x46, 0x8C, 0xCA, 0x47, 0x8E, 0xC9, 0x48, 0x90, 0xD8, 0x49, 0x92, 0xdb, 0x4a, 0x94
db 0xDE, 0x4b, 0x96, 0xDD, 0x4c, 0x98, 0xD4, 0x4d, 0x9A, 0xD7, 0x4e, 0x9C, 0xD2, 0x4f, 0x9E, 0xD1, 0x50, 0xA0, 0xF0, 0x51, 0xA2
db 0xF3, 0x52, 0xA4, 0xF6, 0x53, 0xA6, 0xF5, 0x54, 0xA8, 0xFC, 0x55, 0xAA, 0xFF, 0x56, 0xAC, 0xFA, 0x57, 0xAE, 0xF9, 0x58, 0xB0, 0xE8, 0x59
db 0xB2, 0xEB, 0x5a, 0xB4, 0xEE, 0x5b, 0xB6, 0xED, 0x5c, 0xB8, 0xE4, 0x5d, 0xBA, 0xE7, 0x5e, 0xBC, 0xE2, 0x5f, 0xBE, 0xE1, 0x60, 0xC0
db 0xA0, 0x61, 0xC2, 0xA3, 0x62, 0xC4, 0xA6, 0x63, 0xC6, 0xA5, 0x64, 0xC8, 0xAC, 0x65, 0xCA, 0xAF, 0x66, 0xCC, 0xAA, 0x67, 0xCE, 0xA9
db 0x68, 0xD0, 0xB8, 0x69, 0xD2, 0xBB, 0x6a, 0xD4, 0xBE, 0x6b, 0xD6, 0xBD, 0x6c, 0xD8, 0xB4, 0x6d, 0xDA, 0xB7, 0x6e, 0xDC, 0xB2, 0x6f, 0xDE, 0xB1, 0x70
db 0xE0, 0x90, 0x71, 0xE2, 0x93, 0x72, 0xE4, 0x96, 0x73, 0xE6, 0x95, 0x74, 0xE8, 0x9C, 0x75, 0xEA, 0x9F, 0x76, 0xEC, 0x9A, 0x77, 0xEE, 0x99
db 0x78, 0xF0, 0x88, 0x79, 0xF2, 0x8B, 0x7a, 0xF4, 0x8E, 0x7b, 0xF6, 0x8D, 0x7c, 0xF8, 0x84, 0x7d, 0xFA, 0x87, 0x7e, 0xFC, 0x82, 0x7f, 0xFE, 0x81, 0x80
db 0x1B, 0x9B, 0x81, 0x19, 0x98, 0x82, 0x1F, 0x9D, 0x83, 0x1D, 0x9E, 0x84, 0x13, 0x97, 0x85, 0x11, 0x94, 0x86, 0x17, 0x91, 0x87, 0x15, 0x92, 0x88
db 0x0B, 0x83, 0x89, 0x09, 0x80, 0x8a, 0x0F, 0x85, 0x8b, 0x0D, 0x86, 0x8c, 0x03, 0x8F, 0x8d, 0x01, 0x8C, 0x8e, 0x07, 0x89, 0x8f, 0x05, 0x8A, 0x90, 	0x3B
db 0xAB, 0x91, 0x39, 0xA8, 0x92, 0x3F, 0xAD, 0x93, 0x3D, 0xAE, 0x94, 0x33, 0xA7, 0x95, 0x31, 0xA4, 0x96, 0x37, 0xA1, 0x97, 0x35, 0xA2, 0x98, 0x2B, 0xB3
db 0x99, 0x29, 0xB0, 0x9a, 0x2F, 0xB5, 0x9b, 0x2D, 0xB6, 0x9c, 0x23, 0xBF, 0x9d, 0x21, 0xBC, 0x9e, 0x27, 0xB9, 0x9f, 0x25, 0xBA, 0xa0, 0x5B, 0xFB, 0xa1
db 0x59, 0xF8, 0xa2, 0x5F, 0xFD, 0xa3, 0x5D, 0xFE, 0xa4, 0x53, 0xF7, 0xa5, 0x51, 0xF4, 0xa6, 0x57, 0xF1, 0xa7, 0x55, 0xF2, 0xa8, 0x4B, 0xE3, 0xa9, 0x49, 0xE0
db 0xaa, 0x4F, 0xE5, 0xab, 0x4D, 0xE6, 0xac, 0x43, 0xEF, 0xad, 0x41, 0xEC, 0xae, 0x47, 0xE9, 0xaf, 0x45, 0xEA, 0xb0, 0x7B, 0xCB, 0xb1, 0x79, 0xC8, 0xb2
db 0x7F, 0xCD, 0xb3, 0x7D, 0xCE, 0xb4, 0x73, 0xC7, 0xb5, 0x71, 0xC4, 0xb6, 0x77, 0xC1, 0xb7, 0x75, 0xC2, 0xb8, 0x6B, 0xD3, 0xb9, 0x69, 0xD0, 0xba, 0x6F, 0xD5
db 0xbb, 0x6D, 0xD6, 0xbc, 0x63, 0xDF, 0xbd, 0x61, 0xDC, 0xbe, 0x67, 0xD9, 0xbf, 0x65, 0xDA, 0xc0, 0x9B, 0x5B, 0xc1, 0x99, 0x58, 0xc2, 0x9F, 0x5D, 0xc3
db 0x9D, 0x5E, 0xc4, 0x93, 0x57, 0xc5, 0x91, 0x54, 0xc6, 0x97, 0x51, 0xc7, 0x95, 0x52, 0xc8, 0x8B, 0x43, 0xc9, 0x89, 0x40, 0xca, 0x8F, 0x45, 0xcb, 0x8D, 0x46
db 0xcc, 0x83, 0x4F, 0xcd, 0x81, 0x4C, 0xce, 0x87, 0x49, 0xcf, 0x85, 0x4A, 0xd0, 0xBB, 0x6B, 0xd1, 0xB9, 0x68, 0xd2, 0xBF, 0x6D, 0xd3, 0xBD, 0x6E
db 0xd4, 0xB3, 0x67, 0xd5, 0xB1, 0x64, 0xd6, 0xB7, 0x61, 0xd7, 0xB5, 0x62, 0xd8, 0xAB, 0x73, 0xd9, 0xA9, 0x70, 0xda, 0xAF, 0x75, 0xdb, 0xAD, 0x76, 0xdc, 0xA3
db 0x7F, 0xdd, 0xA1, 0x7C, 0xde, 0xA7, 0x79, 0xdf, 0xA5, 0x7A, 0xe0, 0xdb, 0x3B, 0xe1, 0xD9, 0x38, 0xe2, 0xDF, 0x3D, 0xe3, 0xDD, 0x3E, 0xe4, 0xD3, 0x37
db 0xe5, 0xD1, 0x34, 0xe6, 0xD7, 0x31, 0xe7, 0xD5, 0x32, 0xe8, 0xCB, 0x23, 0xe9, 0xC9, 0x20, 0xea, 0xCF, 0x25, 0xeb, 0xCD, 0x26, 0xec, 0xC3, 0x2F, 0xed, 0xC1
db 0x2C, 0xee, 0xC7, 0x29, 0xef, 0xC5, 0x2A, 0xf0, 0xFB, 0x0B, 0xf1, 0xF9, 0x08, 0xf2, 0xFF, 0x0D, 0xf3, 0xFD, 0x0E, 0xf4, 0xF3, 0x07, 0xf5, 0xF1, 0x04
db 0xf6, 0xF7, 0x01, 0xf7, 0xF5, 0x02, 0xf8, 0xEB, 0x13, 0xf9, 0xE9, 0x10, 0xfa, 0xEF, 0x15, 0xfb, 0xED, 0x16, 0xfc, 0xE3, 0x1F, 0xfd, 0xE1, 0x1C, 0xfe, 0xE7
db 0x19, 0xff, 0xE5, 0x1A, 

wordCounter dw 0
.code

;*********************************************************************************************************************************

;this macro gets the nth column from word array and stores it in col array 
getCol macro  n 
    mov ax,0    
    mov bx,0
    mov cx,0
    mov bl ,n     
    
    mov al,[word+bx]
    mov col,al 
    add bx,04h   
    mov al,[word+bx]
    mov col+01,al
    add bx,04h
    mov al,[word+bx]
    mov col+02,al
    add bx,04h
    mov al,[word+bx]
    mov col+03,al 
    
       
endm 

;*********************************************************************************************************************************

;this macro gets the nth column from key array and stores it in col array        
getColKey macro  n    
    mov bx ,n
    mov al,[key+bx]
    mov col,al 
    add bx,04h   
    mov al,[key+bx]
    mov col+01,al 
    add bx,04h
    mov al,[key+bx]
    mov col+02,al 
    add bx,04h
    mov al,[key+bx]
    mov col+03,al 
    
       
endm 

;*********************************************************************************************************************************
     
;helper method for round key 
;this macro gets the nth column from key array and stores it in col1 array 
getCol1 macro  n    
    mov bx ,n
    mov al,[key+bx]
    mov col1,al 
    add bx,04h   
    mov al,[key+bx]
    mov col1+01,al 
    add bx,04h
    mov al,[key+bx]
    mov col1+02,al 
    add bx,04h
    mov al,[key+bx]
    mov col1+03,al 
    
   
    
endm 

;*********************************************************************************************************************************
    
; helper method for roundkey          
;macro to get the subBytes for a column(used in Round Key Generator part)
subBytesOfCol macro     
    mov bh,00h
    mov bl,col
    mov al,sbox[bx]  
    mov col,al
    mov bh,00h
    mov bl,col+01
    mov al,sbox[bx]  
    mov col+01,al
    mov bh,00h
    mov bl,col+02
    mov al,sbox[bx]  
    mov col+02,al
    mov bh,00h
    mov bl,col+03
    mov al,sbox[bx]  
    mov col+03,al

        
endm 

;*********************************************************************************************************************************

;macro to get the nth row of the (1,2,3) matrix used in the mixColumns operation
;note that the mult process here is unique for the mixColumns cycle and not just an ordianry matrix Mult.  
getMixRow macro  n       
    mov ax,0
    mov bx,0
    mov cx,0
    mov bl ,n 
    mov ax,4
    mul bx
    mov bx,ax 
    mov al,[mixField+bx]
    mov mixrow,al
    add bx,01h   
    mov al,[mixField+bx]
    mov mixrow+01,al
    add bx,01h
    mov al,[mixField+bx]
    mov mixrow+02,al 
    add bx,01h
    mov al,[mixField+bx]
    mov mixrow+03,al 
    
   
    
endm  

;*********************************************************************************************************************************

;macro to get the values of mult. of(word column element)*(mixfield col element) from the mult. table we generated at start of code 
;note that the mult process here is unique for the mixColumns cycle and not just an ordianry matrix Mult.
mixcolumnsValues  macro m  

mov di ,0
add di , m
mov bx, 0
mov ax,0    
mov cx,0
mov al,[di+col]
mov dx,0003h
mul dx
mov cl,[di+mixrow]
dec cx
add ax,cx
mov bx,ax
mov al,MixCol[bx]
mov [di+testarray1],al

endm

;*********************************************************************************************************************************

;macro to get the subBytes values from the sbox 
subBytes macro looper
    mov di,0
    mov bx,0
    looper:    
    mov bl,[di+word]
    mov al,sbox[bx]
    mov [di+word],al
    inc di
    cmp di,16
    jnz looper  
    mov di,0 
    
    
endm       

;*********************************************************************************************************************************

;macro to make shiftRows cycle using the idea of swapping of elements in each row 

shiftRows macro looper2
    mov al,word[04]
    mov tmpWord[07],al 
    mov al,word[05]
    mov tmpWord[04],al 
    mov al,word[06]
    mov tmpWord[05],al 
    mov al,word[07]
    mov tmpWord[06],al 
    
    mov al,word[08]
    mov tmpWord[10],al 
    mov al,word[09]
    mov tmpWord[011],al 
    mov al,word[010]
    mov tmpWord[08],al 
    mov al,word[011]
    mov tmpWord[09],al    
    
    
    mov al,word[012]
    mov tmpWord[013],al 
    mov al,word[013]
    mov tmpWord[014],al 
    mov al,word[014]
    mov tmpWord[015],al 
    mov al,word[015]
    mov tmpWord[012],al
    
    
    
    mov bx,04h
    looper2: 
    mov al,tmpWord[bx]
    mov [word+bx],al
    inc bx
    cmp bx,16
    jnz looper2
    
    endm  
   
   
;********************************************************************************************************************************* 
   
;macro to addRound key 
addRkey macro looper3   
    mov bx,0
    looper3:
    mov al,[word+bx]
    xor al,[key+bx]
    mov [word+bx],al
    inc bx
    cmp bx,16
    jnz looper3
    
    
    
endm       

;*********************************************************************************************************************************  
  
  
;this is a nested loop operation to make the whole mixColumns logic by using the help of (multiplyColumnByRow)procedure
;and store the values in a temp array called mixColumnsMatrix to preserve our original word array 
;then after finishing we put the mixColumnsMatrix elements in our word array
mixColumns macro  
    mov wordCounter,0 
    mov i,0
    mov j,0
    mov ax,0 
    mov bx,0
    mov di ,0       ;outer loop incrementer
    mov si,0        ;inner loop incrementer
    mov cx, count   ;outer loop counter
   L3:
        ;set inner loop count 
   getMixRow i     
   mov j,0
     L4:
     mov ax,00
     getCol j                             ;we now have col=wordColumn[i]
;                                        ;we now have mixrow=mixFieldRow[i]
     call multiplyColumnByRow 
     mov  al , elementOfMixColumn    
     mov di, wordCounter     
     mov [di+mixColumnsMatrix],al                  
     inc wordCounter
     inc j
     cmp j,4
     jnz L4
   inc i
   cmp i,4
   jnz L3
         
         
   mov i,0   
   mov bx,0
   Transfer:
   mov al,[mixColumnsMatrix+bx] 
   mov [word+bx],al
   inc bx
   inc i
   cmp i,16
   jnz Transfer
     
     
 
   
endm 

;*********************************************************************************************************************************   


;here starts the main code to be run

;take input from user
call InputWord  
;take key from user
call InputKey

 
  
addRkey  0
call RoundNumber 

ENCRYPT:      

subBytes  1
shiftRows  2
mixColumns  3
call   roundKey
addRkey      4
inc encryptCounter  
call RoundNumber
cmp encryptCounter,9   
 
;loop 9 rounds 
jnz ENCRYPT 
inc encryptCounter



              
subBytes      5
shiftRows      6
call   roundKey
addRkey         7
call RoundNumber       

;output the cypherText to the user                                          
call outputWord 
call outputWordASCI 

ret  

   
            
            
            
            
; here ends the main code to be run





;*********************************************************************************************************************************


;this procedure prints the current round number the compiler is working on
RoundNumber   proc
    mov dl,0Ah
    mov ah,02
    int 21h
    mov dl,0dh
    mov ah,02
    int 21h    
    mov bx,0                        
    mov bl,encryptCounter
    lea dx,RoundString
    mov ah,9h
    int 21h
     mov dl,[AsciToHexa+bx]
    mov ah,02
    int 21h
    ret
        
endp  



;********************************************************************************************************************************* 
 
;procedure to multiply the "word" array column with the "mixField" array row by using help of mixcolumnsValues macro
;note that the mult process here is unique for the mixColumns cycle and not just an ordianry matrix Mult.
 
multiplyColumnByRow proc
    mov si, 00	
	;mov cx, 04	
    mov ii,0
	L1:                       ;makes a testarray1 by mult. col of "word"  by row of "mixField"
	mixcolumnsValues ii
	inc ii
	cmp ii,4
	jnz L1
	    
	mov si,00
	mov cx,04	
	mov ax,0
	L2:
	xor al,testarray1[si]         ;adds elements of testarray1 which are considered the new elements to be
	inc si                        ;put in the mixColumns array
	loop L2  
	mov elementOfMixColumn ,al
	ret
 endp





;*********************************************************************************************************************************
;procdure of making the roundKey of each round
roundKey proc   
    mov bx, 0
    mov bl,RKCount
    mov al,Rcon[bx]
    mov RconV,al  
    inc RKCount
    getColKey 3
    getCol1 0
    mov al,col
    mov tmp,al
    mov al,col+01 
    mov col,al
    mov al,col+02
    mov col+01,al
    mov al,col+03
    mov col+02,al
    mov al,tmp  
    mov col+03,al 
    subBytesOfCol 
    mov al,col
    xor al,RconV
    mov col,al
    mov bx,0
    call AddColAndCol1
    mov nthColForAProc,0
    call PutColInKey 
    
    getColKey 0  
    getCol1 1
    call AddColAndCol1
    mov nthColForAProc,1
    call PutColInKey
    getColKey 1
    getCol1 2
    call AddColAndCol1
    mov nthColForAProc,2
    call PutColInKey 
    getColKey 2
    getCol1 3
    call AddColAndCol1       
    mov nthColForAProc,3
    call PutColInKey

ret   
endp   
 
;*********************************************************************************************************************************
;helper proc for round key  that adds col and col1
AddColAndCol1 proc 
    mov bx,0
    mov ax,0
    LoopOfAdding:
    mov al,col[bx]
    xor al,col1[bx]
    mov col[bx],al
    inc bx
    cmp bx, 4
    jnz LoopOfAdding 
    ret
endp        

;*********************************************************************************************************************************
  
;helper method for round key to place col in key (its position is nthColForAProc)
PutColInKey proc 
    mov bx,0 
    mov ax,0
    mov al,nthColForAProc
    mov di,ax
    mov ax,0
    LoopToPutCol:
    mov al,col[bx]  
    mov ah,bl
    mov bx,di
    mov key[bx],al 
    mov bx,0
    mov bl,ah 
    mov ah,key
    inc bx 
    add di,04h 
    cmp bx,4
    jnz LoopToPutCol
   
   ret
    
endp


ret              

;*********************************************************************************************************************************

;procedure to get word from user          
InputWord proc 
mov bx,0

EnterAWord:
mov dl,[EnterWord+bx]
mov ah,02
int 21h
inc bx
cmp bx,16
jnz EnterAWord 
    mov bx,0      
    mov i,0
OuterLooooooop: mov bl,i 
    loopToGetWord:mov ah , 01h
    int 21h
    mov [bx+word],al  
    add bx,4
    cmp bx,16
    jl loopToGetWord   
    inc i
    cmp i,4
jnz OuterLooooooop
 
mov dl,0Ah
mov ah,02
int 21h
mov dl,0dh
mov ah,02
int 21h
    ret
endp         
  
;*********************************************************************************************************************************
  
;procedure to get key from user   
InputKey proc   
mov bx,0 

EnterAKey:
mov dl,[EnterKey+bx]
mov ah,02
int 21h
inc bx
cmp bx,16
jnz EnterAKey 
    mov bx,0 
    mov i,0   
    
OuterLooooop:
    mov bl,i    
    loopToGetkey:
    mov ah , 01h
    int 21h
    mov [bx+key],al  
    add bx,4
    cmp bx,16
    jl loopToGetkey  
    inc i
    cmp i,4
jnz OuterLooooop

                 
mov dl,0Ah
mov ah,02
int 21h
ret         

endp          


;*********************************************************************************************************************************

;procdure to output cypherWord to user in Hexa 
outputWord proc   
mov dl,0Ah
mov ah,02
int 21h
    mov dl,0dh
    mov ah,02
    int 21h                            
    
mov bx,0
  
           
LOLOL: 

mov dl,[Cipher+bx]
mov ah,02
int 21h
inc bx
cmp bx,8
jnz LOLOL  
       mov bx,0

mov i,0
    
OuterL00007:  mov bl,i         
L00007:    
mov ah,0
mov al,[word+bx] 
mov cl,16
div cl
mov cl,al
mov ch,0
mov si,cx
mov cl,ah
mov ch,0
mov di,cx
mov dl,[AsciToHexa+si]

mov ah,02
int 21h  
mov dl,[AsciToHexa+di]

mov ah,02
int 21h  
mov dl,'h'

mov ah,02
int 21h 
mov dl,' '

mov ah,02
int 21h
add bx,4
cmp bx,16
jl L00007
inc i
cmp i,4
jnz OuterL00007  
  
ret 
endp  
;procdure to output cypherWord to user in ASCI 
outputWordASCI proc   
mov dl,0Ah
mov ah,02
int 21h
    mov dl,0dh
    mov ah,02
    int 21h                            
    
mov bx,0
  
           
LoopOfAsci: 

mov dl,[Cipher+bx]
mov ah,02
int 21h
inc bx
cmp bx,8
jnz LoopOfAsci  
       mov bx,0

mov i,0
    
LoopOfAsci1:  mov bl,i         
LoopOfAsci2:    
mov ah,0
mov dl,[word+bx] 
mov ah,02
int 21h
add bx,4
cmp bx,16
jl LoopOfAsci2
inc i
cmp i,4
jnz LoopOfAsci1  
  
ret 
endp