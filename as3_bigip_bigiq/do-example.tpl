{
    "class": "DO",
    "declaration": {
        "schemaVersion": "1.5.0",
        "class": "Device",
        "async": true,
              "Common": {
                    "class": "Tenant"
              }
    },
    "targetHost": "${TARGET_HOST}",
    "targetUsername": "admin",
    "targetPassphrase": "admin",
    "bigIqSettings": {
        "failImportOnConflict": false,
        "conflictPolicy": "USE_BIGIQ",
        "deviceConflictPolicy": "USE_BIGIP",
        "versionedConflictPolicy": "KEEP_VERSION",
        "statsConfig": {
            "enabled": true,
            "zone": "default"
        },
        "snapshotWorkingConfig": false
    }
}
