# Movie List App


## Usage
Add the following pod in your pod file
`pod 'NetworkCustomSDK','1.0.2'`

## Setup

### Call the Network endpoint.
```
let customEndpoint = NetworkEndpoint.custom(url: customURL, method: "GET", headers: customHeaders, queryItems: customQueryItems, body: nil)
```
###Create the object of the class and call the Request

```
  let networkCustomCalling = NetworkCustomCalling()
  networkCustomCalling.request(endpoint: customEndpoint) { result in
      switch result {
      case .success(let data):
          print("Custom API request passed: \(data)")
      case .failure(let error):
          print("Custom API request failed: \(error)")
      }
  }
```
