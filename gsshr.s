;
;  gsshr
;  A trivial example of a scanline interrupt handler
;
;  Created by Quinn Dunki on Mar 10, 2024
;


.include "macros.s"


NEWVIDEO		= $c029
BORDERCOLOR		= $e0c034


.org $800

main:
	NATIVE

	SHRVIDEO
	jsr initSCBs

	; Install scanline interrupt handler
	sei
	lda #scanLineInterruptHandler
	sta $e10029
	BITS8
	lda #0		; This code bank
	sta $e1002b
	BITS16
	cli

	; Enable a scanline interrupt
	BITS8
	lda $e19d92			; Enable interrupt on scanline 146
	ora #%01000000
	sta $e19d92

	lda $e0c023			; Enable scanline interrupts
	ora #%00000010
	sta $e0c023
	BITS16

deadlock:
	jmp deadlock


; Initialize all scanline control bytes
initSCBs:
	BITS8
	lda #0
	ldx #200	;set all 200 scbs to A

initSCBsLoop:
	dex
	sta $e19d00,x
	cpx #0
	bne initSCBsLoop
	BITS16
	rts


; Minimal possible handler for IRQ.SCAN (vector E1/0028-002B)
scanLineInterruptHandler:
	OP8				; Interrupt firmware calls us in 8-bit native mode so make sure assembler knows that
	BITS8

	lda #$9F				; Clear scanline interrupt source
	sta $e0c032

	lda BORDERCOLOR	; Set border color
	eor #$07
	sta BORDERCOLOR

	clc
	rtl


; Suppress some linker warnings - Must be the last thing in the file
; This is because Quinn doesn't really know how to use ca65 properly
.SEGMENT "ZPSAVE"
.SEGMENT "EXEHDR"
.SEGMENT "STARTUP"
.SEGMENT "INIT"
.SEGMENT "LOWCODE"
