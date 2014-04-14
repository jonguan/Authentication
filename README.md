Authentication
==============

SSL Pinning for iOS.  Tested on Xcode 5.1 with OSX Mavericks 10.9.2

Setup:

1. Setup apache server (installed by default on mac osx 10.9 mavericks)

2. Setup apache server for ssl (http://webdevstudios.com/2013/05/24/how-to-set-up-ssl-with-osx-mountain-lions-built-in-apache/) (works for mavericks too)

3. Generate public/private keys and certificates (http://www.akadia.com/services/ssh_test_certificate.html)

4. Make a copy of the certificate in a der X509 format that iOS understands. (https://stackoverflow.com/questions/16694280/ssl-pinning-on-ios)


Usage:

1. Start apache server

      sudo apachectl configtest 

      sudo apachectl start

2. Run xcode project in simulator
3. Hit button 'Use Certificate 1'
4. See that everything passes
5. Restart apache server

      sudo apachectl restart

6. Hit button 'Use certificate 2'
7. See that certificate does not match and request fails


