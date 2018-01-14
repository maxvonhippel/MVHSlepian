Information on screen can be found [here](https://askubuntu.com/a/8657)
My current screen session is `bufferGreenland`
To list current screens, run `screen -ls`
To resume a specific screen, run `screen -r bufferGreenland`, or whatever the 
screen is named in place of `bufferGreenland`
To detatch from a screen type `Ctrl-A` then `Ctrl-D`.

Other issue to talk about:
````
>> XY=greenland(0,1);
// etc etc etc etc for many many lines
Buffering the coastlines... this may take a while
Buffering the coastlines... this may take a while
Buffering the coastlines... this may take a while
Buffering the coastlines... this may take a while
Buffering the coastlines... this may take a while
Buffering the coastlines... this may take a while
Out of memory. The likely cause is an infinite recursion within the program.

Error in fullfile (line 90)
        locHandleError(theInputs(1,:));
````