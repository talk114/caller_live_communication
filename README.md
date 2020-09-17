# Monjo Live Communication
## by John Melody
---
<br />

<b>$Servers</b> <br/>
I will be using [Janus - Gateway](https://github.com/meetecho/janus-gateway). For quick installation of ```Janus Gateway``` into your designed server do run :

```
sh install.sh
```

<br/>
<b>$Setup TURN Server with coturn</b> <br/>
Go to the {dir}/usr/local/coturn/etc and configure. 


```
cd /usr/local/cotrurn/etc && sudo vim turnserver.conf
```

uncomment the line ```listening-port=3478``` make sure it is port 3478 and ```external-ip=xx.xx.xx.xx```, ```user=[username_youdesired]:[key_you_wanted]```,



<b>$Libraries</b><br/>
[flutter-webrtc](https://github.com/flutter-webrtc/flutter-webrtc) <br/>
[coturn](https://github.com/coturn/coturn)<br/>


<b>$Support</b><br/>
Email: [johnmelodyme@yandex.com](mailto:johnmelodyme@yandex.com )