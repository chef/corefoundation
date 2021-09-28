require_relative "os_status"
require_relative "sec_access_ref"
require_relative "sec_external_format"
require_relative "sec_key_import_export_flags"
require_relative "sec_item_import_export_flags"
require_relative "sec_item_import_export_key_parameters"
require_relative "dictionary"
require_relative "boolean"

module CF

    typedef :cftyperef, :secItemOrArray
    typedef :SecExternalFormat, :secExternalFormat
    typedef :SecItemImportExportFlags, :flags
    typedef SecItemImportExportKeyParameters.by_ref, :keyParams
    typedef :cfdataref, :exportedData
    typedef :pointer,:query
    typedef :cftyperef, :itemMatchResult

    attach_variable 'kSecClass', :pointer
    attach_variable 'kSecAttrLabel', :pointer
    attach_variable 'kSecClassIdentity', :pointer
    attach_variable 'kSecReturnRef', :pointer

    attach_function 'SecItemExport' , [:secItemOrArray, :secExternalFormat,
                                         :flags, :keyParams, :exportedData], :OSStatus
    # attach_function 'SecItemImport' ,[], 
    attach_function 'SecItemCopyMatching' , [:query, :itemMatchResult], :OSStatus


    class Security
        def self.export_util(secItemOrArray, secExternalFormat, flags, keyParams, exportedData)
            return CF.SecItemExport(secItemOrArray, secExternalFormat, flags, keyParams, exportedData)
            # return exportedData
        end

        def self.export(attr_label)
            exportedData = FFI::MemoryPointer.new :pointer
            itemMatchResult = search_cert(attr_label)

            # flags = SecItemImportExportFlags.new
            # puts "flags", flags
            keyParams = SecItemImportExportKeyParameters.new
            puts "keyParams", keyParams
            # status = export_util(itemMatchResult, :formatUnknown,:kSecItemPemArmour,keyParams, exportedData)
            status = export_util(itemMatchResult, :formatUnknown,:kSecItemPemArmour,nil, exportedData)
            puts("status:",status)
        end

        def self.search_item(query, itemMatchResult)
            status = CF.SecItemCopyMatching(query, itemMatchResult)
            puts "status:", status
            puts "itemMatchResult:", itemMatchResult
            return itemMatchResult
        end

        def self.search_cert(attr_label)
            result = FFI::MemoryPointer.new :pointer
            query = {}
            query[CF::Base.typecast(CF.kSecClass)] = CF::Base.typecast(CF.kSecClassIdentity)
            query[CF::Base.typecast(CF.kSecAttrLabel)] = attr_label
            query[CF::Base.typecast(CF.kSecReturnRef)] = true
           return search_item(query.to_cf, result)
        end
    end
end

