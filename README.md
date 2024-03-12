# Scanline Interrupt Example

Scanline interrupts on the Apple IIGS are somewhat tricky, but extremely powerful. They are an essential tool for many game and demo writing tasks, yet examples online of how to do it are very few. It took me a while to figure out the ups and downs, so I thought I'd post this here to save someone else the grief.

This little demo alternates between two border colours at 60Hz, just to show you that the interrupt is running and doin' stuff. Insert your sick demo code here.

Note that you can only see this effect on real hardware. As of this writing, no GS emulators are accurate enough to handle high speed border effects properly. All the emulators I tested this demo on show alternating colour-blocking in the border which is neat, but not what the real hardware does.

## Implementation Notes
There are two basic ways to install your interrupt handler- bare metal or via the Toolbox. This sample code shows the bare metal method. The system-friendly Toolbox method uses the toolbox call SetVector, and you can find usage of that in the Apple IIgs toolbox reference manuals. The implementation of the handler is the same, regardless.

The main gotcha with scanline interrupts is that they come very very fast and you have to keep up with them. You cannot leave interrupts disabled for too long or unhandled interrupts will accumulate and murder the system. If you're running on ProDOS 8, as this example does, this will manifest as a System Death error, which is a blank screen with the message **RESTART SYSTEM $1** in the centre. This means ProDOS has hit 255 unhandled interrupts.

The reason this is easy to do by accident on the Apple IIgs is that disabling interrupts for a while is common in high-speed GS rendering. The fast graphics pipeline for this machine involves relocating the stack on to the graphics page so you can push pixels with fast stack operations. However interrupts must be disabled during such shenanigans because the machine is in a very dangerous state that must be reversed when rendering is complete. This makes fast rendering and scanline interrupts a difficult pair of tools to mix. You've been warned.

If you do disable interrupts (such as in your fast rendering goo), you must do so in a re-entrant way. Do not do this:

```
sei
... ; I think I'm safe
cli

```

You must preserve the enivronment before disabling and re-enabling interrupts, in case an interrupt was in progress at the time:

```
php
sei   ; temporarily disable interrupts
...
plp    ; returns the computer to the correct interrupt state
```

This is the kind of rookie interrupt programming mistake that you (read: me) can get away with for years until you try something like scanline interrupts. The odds of blowing up the system are much higher here because of how frequent they are. You (like I was) might be thinking you're okay because you've been rolling the dice until now and always gotten lucky on re-entrancy. With scanline interrupts, the house always wins.

## Acknowledgements

I'd like to send a big thanks to the Apple II Enthusiasts Slack server, without whom I may never have figured all this out. The documentation on this stuff is old, sparse, and sometimes wrong. The people, however, know the way. There are people who have forgotten more about this platform than I will ever know, despite my considerable born-again enthusiasm for it.

`][ Infinitum`