const MediaServer = require("medooze-media-server");
const SemanticSDP = require("semantic-sdp");

//Create UDP server endpoint
const endpoint = MediaServer.createEndpoint(ip);

//Process the sdp
var offer = SemanticSDP.SDPInfo.process(sdp);

//Create an DTLS ICE transport in that enpoint
const transport = endpoint.createTransport({
  dtls: offer.getDTLS(),
  ice: offer.getICE(),
});

//Set RTP remote properties
transport.setRemoteProperties({
	audio : offer.getMedia("audio"),
	video : offer.getMedia("video")
});

//Get local DTLS and ICE info
const dtls = transport.getLocalDTLSInfo();
const ice  = transport.getLocalICEInfo();

//Get local candidates
const candidates = endpoint.getLocalCandidates();

//Get default capabilities
const capabilities = MediaServer.getDefaultCapabilities();
