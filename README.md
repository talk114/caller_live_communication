# Caller Live Communication
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

add to ```/etc/services```

```
stun-turn       3478/tcp                        # Coturn
stun-turn       3478/udp                        # Coturn
stun-turn-tls   5349/tcp                        # Coturn
stun-turn-tls   5349/udp                        # Coturn
turnserver-cli  5766/tcp                        # Coturn
```



<b>$Libraries</b><br/>
[flutter-webrtc](https://github.com/flutter-webrtc/flutter-webrtc), Version: flutter_webrtc: ^0.2.8 <br/>
[coturn](https://github.com/coturn/coturn)<br/>


<b>$Support</b><br/>
Email: [johnmelodyme@yandex.com](mailto:johnmelodyme@yandex.com )

<b>Donate</b>
[](https://github.com/johnmelodyme/ShortestPathAlgorithm/blob/master/assets/wechat.png?raw=true)

