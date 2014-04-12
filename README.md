Authentication
==============

SSL Pinning for iOS


Steps:
1. Setup apache server (installed by default on mac osx 10.9 mavericks)
2. Setup apache server for ssl (http://webdevstudios.com/2013/05/24/how-to-set-up-ssl-with-osx-mountain-lions-built-in-apache/) (works for mavericks too)
3. Generate public/private keys and certificates (http://www.akadia.com/services/ssh_test_certificate.html)
4. Make a copy of the certificate in a der X509 format that iOS understands. (https://stackoverflow.com/questions/16694280/ssl-pinning-on-ios)


