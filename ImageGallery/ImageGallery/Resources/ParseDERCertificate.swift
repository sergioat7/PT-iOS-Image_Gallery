//
//  ParseDERCertificate.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 24/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import Alamofire

class ParseDERCertificate {
    
    /*
     We extract and bake the certificate data in code as base64 string
     to avoid someone replace the certificate file with another public key
     and makes the app vulnerable to Man in the Middle attacks
     */
    
    let base64Certificate = """
                            MIIFdTCCBF2gAwIBAgIQBeqhnLHxD+qTterJyI2HZTANBgkqhkiG9w0BAQsFADBGMQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRUwEwYDVQQLEwxTZXJ2ZXIgQ0EgMUIxDzANBgNVBAMTBkFtYXpvbjAeFw0yMDA2MDQwMDAwMDBaFw0yMTA3MDQxMjAwMDBaMBUxEzARBgNVBAMTCmZsaWNrci5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCbkIyOayvlN+gj3XAGC9nxncPvZtcq90hzlyyeVB6bG32cKP9szYD000I28bl4dsD91O4IM0o5uBveBNSBsWU3Y/LAtli49gFlzZO+fdm1w8cUgKCUhkX8SKFZJd6EDlYLHlLBvrxOhuXZmfP2Mnj2SVFPNOJ59Pl82182M+F9yTbYZu8bX/R19zcMYC4gP77FtaMDPikjPlk3yzgCdBZ9Q5O1iznKqcFUOFDqik34IotzOUSvXi/GOUevwpv5GiKFjveh3Gv7rccO7tp5cs/4JgYgvXE3xc8g199x1uUzZaV6XI+KX7qX/UmvRPoEdmtN5XVgXBJBJXTFPE76+2GpAgMBAAGjggKOMIICijAfBgNVHSMEGDAWgBRZpGYGUqB7lZI8o5QHJ5Z0W/k90DAdBgNVHQ4EFgQU3UkbQFYoWtYkKuKw1Nm8fJ8TRB0wLAYDVR0RBCUwI4IKZmxpY2tyLmNvbYIHZmxpYy5rcoIMKi5mbGlja3IuY29tMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybC5zY2ExYi5hbWF6b250cnVzdC5jb20vc2NhMWIuY3JsMCAGA1UdIAQZMBcwCwYJYIZIAYb9bAECMAgGBmeBDAECATB1BggrBgEFBQcBAQRpMGcwLQYIKwYBBQUHMAGGIWh0dHA6Ly9vY3NwLnNjYTFiLmFtYXpvbnRydXN0LmNvbTA2BggrBgEFBQcwAoYqaHR0cDovL2NydC5zY2ExYi5hbWF6b250cnVzdC5jb20vc2NhMWIuY3J0MAwGA1UdEwEB/wQCMAAwggEFBgorBgEEAdZ5AgQCBIH2BIHzAPEAdwD2XJQv0XcwIhRUGAgwlFaO400TGTO/3wwvIAvMTvFk4wAAAXJ8/+1dAAAEAwBIMEYCIQDQ2wdxjYxLL8nHLomKfuxre3T++hxQm56rVKI1t1AZFQIhAJuRFIkUBCXFGCjvm0t6yqrIb5xbKKlHq+5pIAUiwWWsAHYAXNxDkv7mq0VEsV6a1FbmEDf71fpH3KFzlLJe5vbHDsoAAAFyfP/tfAAABAMARzBFAiBpAWr4a5xIi0bBVqls4hibfhl9OkFpHKsH5CFKiCOetwIhANy1Vn0YUFi5HgwgVPrjg0fqYwWNOkH3V03PMJutK71MMA0GCSqGSIb3DQEBCwUAA4IBAQBsjS6isjHCuBna878JEuWKZ15UhEbUvPIcThjVG5BE7o7ONpKJllSWjrxLoHTxFAtzkE8GIJodE3NIQXywN2gJpHVjTrOsBlCs2lI1fi8+eaapaXr6/fOJXlu/+PvEOEfaKMhksLeRvAJAYMyqi6MFic8pRTArtcTodLGpev4/3pwXrlpDMp1lc8Pki64VYBX5pYwFUiEr6nKcqxjQeABXzXQyifpJDOI1WuTscX/1bOmpTSE17XdOH1LgvRpwC0odf8mjZQrzl2641fY+VqVkhTV1sGZ1pBYCtu4K5bgG4+MDttdokwS49ctZW6C7w8WWwkIyosv8T24VUuHIJDi5
                            """

    public func getCertificates() -> [SecCertificate] {
        
        if let certificateData = Data(base64Encoded: base64Certificate, options: []),
            let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) {
            return [certificate]
        }
        return Bundle.main.af.certificates
    }
}
