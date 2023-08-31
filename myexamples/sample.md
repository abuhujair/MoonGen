1. 

POST /nausf-auth/v1/ue-authentications HTTP/1.1
Host: 127.0.0.1:3333
Content-Length:143
Content-Type:application/json
User-Agent:cpprestsdk/2.10.15
Connection: Keep-Alive

{"amfInstanceId":"f38441e6-7f5f-4de0-8d3c-02eb6aa2617e","servingNetworkName":"5G:mnc000.mcc404.3gppnetwork.org","supiOrSuci":"404000000000000"}

POST /nausf-auth/v1/ue-authentications HTTP/1.1
Host: 127.0.0.1:3333
Content-Length:143
Content-Type:application/json
User-Agent:cpprestsdk/2.10.15
Connection: Keep-Alive

{"amfInstanceId": "hex(8)-hex(4)-hex(4)-hex(4)-hex(12)","servingNetworkName":"5G:mnc000.mcc404.3gppnetwork.org","supiOrSuci":string(15)[Numeric]}


2.
PUT /nausf-auth/v1/ue-authentications/b306f363-4b3a-4f09-a7d7-61ac5b1cb5c4/5g-aka-confirmation HTTP/1.1
Host: 127.0.0.1:3333
Content-Length:77
Content-Type:application/json
User-Agent:cpprestsdk/2.10.15
Connection: Keep-Alive

{"resStar":"10676CD279AC701722F481FDD544E21D","supiOrSuci":"404000000000000"}

PUT /nausf-auth/v1/ue-authentications/hex(8)-hex(4)-hex(4)-hex(4)-hex(12)/5g-aka-confirmation HTTP/1.1
Host: 127.0.0.1:3333
Content-Length:77
Content-Type:application/json
User-Agent:cpprestsdk/2.10.15
Connection: Keep-Alive

{"resStar":string(32),"supiOrSuci":"404000000000000"}

3.
Types of URL (AUSF) for ue-authenications

[TYPE] [SERVICE]
POST /nausf-auth/v1/ue-authentications
POST /nausf-auth/v1/ue-authentications/deregister
PUT /nausf-auth/v1/ue-authentications/hex(8)-hex(4)-hex(4)-hex(4)-hex(12)/5g-aka-confirmation
DELETE /nausf-auth/v1/ue-authentications/hex(8)-hex(4)-hex(4)-hex(4)-hex(12)/5g-aka-confirmation
POST /nausf-auth/v1/ue-authentications/hex(8)-hex(4)-hex(4)-hex(4)-hex(12)/eap-session
DELETE /nausf-auth/v1/ue-authentications/hex(8)-hex(4)-hex(4)-hex(4)-hex(12)/eap-session
POST /nausf-auth/v1/rg-authentications


