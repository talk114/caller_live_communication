import requests

url = "https://demo.cloudwebrtc.com:8086/api/turn?service=turn&username=flutter-webrtc"

payload = {}
headers = {
  'x-rapidapi-host': 'messagebird-sms-gateway.p.rapidapi.com',
  'x-rapidapi-key': '6c7c707999mshca63542a69c8f4cp19fc7cjsn38435d7d8781',
  'content-type': 'application/x-www-form-urlencoded'
}

response = requests.request("GET", url, headers=headers, data = payload)

print(response.text.encode('utf8'))
