#include	"c:\hcs12.inc"
	
		ORG			$1000				; 7seg data stored 

MYCACHE	EQU		$2000
SEG7	DC.B	$5B, $0E, $3F, $0D		;20
		DC.B	$06, $0E, $6F, $0D		;19
		DC.B	$06, $0E, $7F, $0D		;18
		DC.B	$06, $0E, $07, $0D		;17
		DC.B	$06, $0E, $7D, $0D		;16
		DC.B	$06, $0E, $6D, $0D		;15
		DC.B	$06, $0E, $66, $0D		;14
		DC.B	$06, $0E, $4F, $0D		;13
		DC.B	$06, $0E, $5B, $0D		;12
		DC.B	$06, $0E, $06, $0D		;11
		DC.B	$06, $0E, $3F, $0D		;10
		DC.B	$3F, $0E, $6F, $0D		;09
		DC.B	$3F, $0E, $7F, $0D		;08
		DC.B	$3F, $0E, $07, $0D		;07
		DC.B	$3F, $0E, $7D, $0D		;06
		DC.B	$3F, $0E, $6D, $0D		;05
		DC.B	$3F, $0E, $66, $0D		;04
		DC.B	$3F, $0E, $4F, $0D		;03
		DC.B	$3F, $0E, $5B, $0D		;02
		DC.B	$3F, $0E, $06, $0D		;01
		DC.B	$3F, $0E, $3F, $0D		;00

		ORG		$1500
		MOVB	#$00, DDRH				;declare Port H as input
		MOVB	#$FF, DDRB				;declare Port B as output (Segment)
		MOVB	#$0F, DDRP				;declare Port P as output (Common)

LOOP	LDAA	PTH						;enter desired input (Switch)
		ANDA	#$01					;masking 
		CMPA	#$01					;compare input with masking 
		BEQ		START
		JSR 	DELAY
		BRA		LOOP

START	LDAB	#42						;total of dc.b (42)
		LDX		#SEG7	
MORE	MOVB	1, X+, PORTB			;increasing value of segment
		MOVB	1, X+, PTP				;increasing value of common
		JSR		DELAY
		DECB
		CMPB	#0						;compare with output desired
		BEQ		START1
		BNE		MORE
	
START1	MOVB	#$00, PORTB				;turn off 7 Segment when all process done 

		SWI

		ORG		$1900
DELAY	MOVB	#500, MYCACHE			;500ms= 0.5s
DEL		LDY		#6000					;6000x4= 24000 cycles = 1ms
LOOP2	DEY								;1 cycle
		BNE		LOOP2					;3 cycles
		DEC		MYCACHE
		BNE		DEL
		RTS

		END
