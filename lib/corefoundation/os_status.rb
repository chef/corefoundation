module CF
    enum :OSStatus, [
        :errSecSuccess,0,
        :errSecUnimplemented,-4,
        :errSecDiskFull, -34,
        :errSecIO, -36,
        :errSecOpWr, -49
    ]
end