module CF 
  
    enum :SecKeyImportExportFlags, [
      :kSecKeyImportOnlyOne,0x00000001,
      :kSecKeySecurePassphrase, 0x00000002,
      :kSecKeyNoAccessControl, 0x00000004,
    ]
  end