require_relative "sec_key_import_export_flags"

module CF 

  class SecItemImportExportKeyParameters < FFI::Struct
      layout  :version, :uint32,
              :flags, :SecKeyImportExportFlags,
              :passphrase, :cftyperef,
              :alertTitle, :cfstringref,
              :alertPrompt, :cfstringref,
              :accessRef, :pointer,
              :keyUsage, :cfarrayref,
              :keyAttributes, :cfarrayref
  end
end