#
#  Makefile
#
#  Created by Quinn Dunki on 7/14/15.
#  One Girl, One Laptop Productions
#  http://www.quinndunki.com
#  http://www.quinndunki.com/blondihacks
#


CL65=cl65
CAD=./cadius
ADDR=0800
VOLNAME=GSSHR
PGM=gsshr
IMG=DiskImageParts
EXEC=$(PGM)\#06$(ADDR)

all: clean diskimage $(PGM) emulate

emulate:
	-/Applications/GSplus.app/Contents/MacOS/gsplus
	
$(PGM):
	@PATH=$(PATH):/usr/local/bin; $(CL65) -t apple2enh --cpu 65816 --start-addr $(ADDR) -l$(PGM).lst $(PGM).s -o $(EXEC)
	$(CAD) ADDFILE $(PGM).2mg /$(VOLNAME) $(EXEC)
	rm -f $(PGM).o
		
diskimage:
	$(CAD) CREATEVOLUME $(PGM).2mg $(VOLNAME) 800KB
	$(CAD) ADDFILE $(PGM).2mg /$(VOLNAME) $(IMG)/BITSY.BOOT/BITSY.BOOT#FF2000
	$(CAD) ADDFILE $(PGM).2mg /$(VOLNAME) $(IMG)/QUIT.SYSTEM/QUIT.SYSTEM#FF2000
	$(CAD) ADDFILE $(PGM).2mg /$(VOLNAME) $(IMG)/PRODOS/PRODOS#FF0000
	$(CAD) ADDFILE $(PGM).2mg /$(VOLNAME) $(IMG)/BASIC.SYSTEM/BASIC.SYSTEM#FF2000

clean:
	rm -f $(PGM)
	rm -f $(PGM).o
	
