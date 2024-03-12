.macro EMULATION
	sec		; Enable 8-bit mode
	xce
	.i8
	.a8
.endmacro


.macro NATIVE
	clc				; Enable 16-bit mode
	xce
	rep	#$30
	.i16
	.a16
.endmacro

.macro SHRVIDEO
	sep #$30
	.i8
	.a8
	lda NEWVIDEO
	ora	#%11000001
	sta NEWVIDEO
	rep	#$30
	.i16
	.a16
.endmacro

.macro CLASSICVIDEO
	sep #$30
	.i8
	.a8
	lda NEWVIDEO
	and #%00111111
	sta NEWVIDEO
	rep	#$30
	.i16
	.a16
.endmacro

.macro OP8
	.i8
	.a8
.endmacro


.macro OP16
	.i16
	.a16
.endmacro

.macro BITS8
	sep #%00110000
	OP8
.endmacro

.macro BITS16
	rep #%00110000
	OP16
.endmacro
