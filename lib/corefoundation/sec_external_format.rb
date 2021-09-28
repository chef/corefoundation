module CF
    enum :SecExternalFormat, [
      :formatUnknown,0,
      :formatOpenSSL,1,
      :formatSSH,2,
      :formatBSAFE,3,
      :formatSSHv2,14,
      :formatRawKey,4,
      :formatWrappedPKCS8,5,
      :formatWrappedOpenSSL,6,
      :formatWrappedSSH,7,
      :formatWrappedLSH,8,
      :formatX509Cert,9,
      :formatPEMSequence,10,
      :formatPKCS7,11,
      :formatPKCS12,12,
      :formatNetscapeCertSequence,13,
    ]
end